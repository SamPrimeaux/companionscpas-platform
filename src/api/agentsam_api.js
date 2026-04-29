
function json(data, status = 200, headers = {}) {
  return new Response(JSON.stringify(data, null, 2), {
    status,
    headers: { "Content-Type": "application/json", ...headers }
  });
}

function sse(data, event = "message") {
  return `event: ${event}\ndata: ${JSON.stringify(data)}\n\n`;
}

async function readJson(request) {
  try { return await request.json(); } catch { return {}; }
}

function pickModel(mode) {
  if (mode === "debug") return { provider:"openai", model:"gpt-4.1" };
  if (mode === "agent") return { provider:"openai", model:"gpt-4.1-mini" };
  if (mode === "plan") return { provider:"openai", model:"gpt-4.1-mini" };
  return { provider:"workers_ai", model:"@cf/google/gemma-4-26b-a4b-it" };
}

async function getRecentContext(env) {
  const animals = await env.DB.prepare(`
    SELECT name, status, species, breed, bio
    FROM animal_profiles
    WHERE tenant_id='tenant_companionscpas'
    ORDER BY updated_at DESC
    LIMIT 8
  `).all().catch(() => ({ results: [] }));

  const apps = await env.DB.prepare(`
    SELECT first_name, last_name, email, review_status, submitted_at, internal_notes
    FROM cpas_foster_applications
    ORDER BY submitted_at DESC
    LIMIT 5
  `).all().catch(() => ({ results: [] }));

  const fosters = await env.DB.prepare(`
    SELECT f.foster_name, f.status, f.foster_type, a.name AS animal_name
    FROM foster_records f
    LEFT JOIN animal_profiles a ON a.id=f.animal_id
    ORDER BY f.created_at DESC
    LIMIT 5
  `).all().catch(() => ({ results: [] }));

  return { animals: animals.results || [], applications: apps.results || [], fosters: fosters.results || [] };
}

async function runOpenAI(env, prompt, mode, context) {
  if (!env.OPENAI_API_KEY) throw new Error("OPENAI_API_KEY missing");
  const { model } = pickModel(mode);
  const chosen = model.startsWith("gpt-") ? model : "gpt-4.1-mini";

  const res = await fetch("https://api.openai.com/v1/responses", {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${env.OPENAI_API_KEY}`,
      "Content-Type": "application/json"
    },
    body: JSON.stringify({
      model: chosen,
      input: [
        {
          role: "system",
          content: "You are Agent Sam for Companions of CPAS. Be practical, concise, professional, nonprofit-aware, and action-oriented. Help manage foster applications, animals, fundraising, CMS copy, and operational tasks. Never claim you completed external actions unless a tool/API actually did it."
        },
        {
          role: "user",
          content: `Dashboard context:\n${JSON.stringify(context, null, 2)}\n\nUser request:\n${prompt}`
        }
      ]
    })
  });

  if (!res.ok) throw new Error(`OpenAI failed ${res.status}: ${await res.text()}`);
  const data = await res.json();
  return data.output_text || data.output?.map(o => o.content?.map(c => c.text).join("\n")).join("\n") || "I processed that request.";
}

async function runWorkersAI(env, prompt, mode, context) {
  if (!env.AI) throw new Error("Workers AI binding missing");
  const model = "@cf/google/gemma-4-26b-a4b-it";
  const result = await env.AI.run(model, {
    messages: [
      {
        role: "system",
        content: "You are Agent Sam for Companions of CPAS. Be concise, practical, and professional."
      },
      {
        role: "user",
        content: `Context:\n${JSON.stringify(context).slice(0, 7000)}\n\nRequest:\n${prompt}`
      }
    ]
  });
  return result.response || result.text || JSON.stringify(result);
}

export async function agentsamRoutes(request, env, url, sessionUser = null) {
  const path = url.pathname;

  if (path === "/api/agentsam/bootstrap" && request.method === "GET") {
    const commands = await env.DB.prepare(`
      SELECT command_key, command_name, command_category, description, safety_level
      FROM agentsam_commands
      WHERE tenant_id='tenant_companionscpas' AND is_enabled=1
      ORDER BY sort_order ASC
      LIMIT 50
    `).all().catch(() => ({ results: [] }));

    const models = await env.DB.prepare(`
      SELECT provider, model_key, display_name, role, runtime, is_local, is_enabled, priority
      FROM agentsam_ai_models
      WHERE is_enabled=1
      ORDER BY priority ASC
      LIMIT 50
    `).all().catch(() => ({ results: [] }));

    return json({ commands: commands.results || [], models: models.results || [] });
  }

  if (path === "/api/agentsam/chat" && request.method === "POST") {
    const body = await readJson(request);
    const prompt = String(body.prompt || "").trim();
    const mode = String(body.mode || "ask");
    const routePath = String(body.route_path || "/dashboard");

    if (!prompt) return json({ error: "Prompt required" }, 400);

    const runId = crypto.randomUUID();
    const sessionId = body.session_id || crypto.randomUUID();
    const started = Date.now();

    const stream = new ReadableStream({
      async start(controller) {
        const enc = new TextEncoder();
        const send = (payload, event = "message") => controller.enqueue(enc.encode(sse(payload, event)));

        try {
          send({ run_id: runId, status: "started", mode }, "status");
          send({ title: "Reading dashboard context", status: "running" }, "step");

          await env.DB.prepare(`
            INSERT OR IGNORE INTO agentsam_sessions (id, tenant_id, user_id, route_path, mode, updated_at)
            VALUES (?, 'tenant_companionscpas', ?, ?, ?, datetime('now'))
          `).bind(sessionId, sessionUser?.id || sessionUser?.user_id || null, routePath, mode).run().catch(() => {});

          await env.DB.prepare(`
            INSERT INTO agentsam_messages (id, session_id, tenant_id, role, content)
            VALUES (?, ?, 'tenant_companionscpas', 'user', ?)
          `).bind(crypto.randomUUID(), sessionId, prompt).run().catch(() => {});

          const context = await getRecentContext(env);
          send({ title: "Selecting model", status: "running" }, "step");

          let provider = "workers_ai";
          let model_key = "@cf/google/gemma-4-26b-a4b-it";
          let answer = "";

          try {
            if (mode === "ask") {
              answer = await runWorkersAI(env, prompt, mode, context);
            } else {
              provider = "openai";
              model_key = mode === "debug" ? "gpt-4.1" : "gpt-4.1-mini";
              answer = await runOpenAI(env, prompt, mode, context);
            }
          } catch (err) {
            send({ title: "Primary model unavailable, using fallback", status: "running", detail: String(err.message || err) }, "step");
            provider = "openai";
            model_key = "gpt-4.1-mini";
            answer = await runOpenAI(env, prompt, mode, context);
          }

          send({ title: "Writing response", status: "running" }, "step");

          await env.DB.prepare(`
            INSERT INTO agentsam_messages (id, session_id, tenant_id, role, content, metadata_json)
            VALUES (?, ?, 'tenant_companionscpas', 'assistant', ?, ?)
          `).bind(crypto.randomUUID(), sessionId, answer, JSON.stringify({ provider, model_key, run_id: runId })).run().catch(() => {});

          await env.DB.prepare(`
            INSERT INTO agentsam_analytics
            (id, tenant_id, user_id, session_id, run_group_id, provider, model_key, runtime_location, mode, status, latency_ms, input_chars, output_chars, metadata_json, started_at, completed_at)
            VALUES (?, 'tenant_companionscpas', ?, ?, ?, ?, ?, 'cloudflare', ?, 'completed', ?, ?, ?, ?, datetime('now'), datetime('now'))
          `).bind(
            crypto.randomUUID(),
            sessionUser?.id || sessionUser?.user_id || null,
            sessionId,
            runId,
            provider,
            model_key,
            mode,
            Date.now() - started,
            prompt.length,
            answer.length,
            JSON.stringify({ route_path: routePath })
          ).run().catch(() => {});

          send({ content: answer, provider, model_key, session_id: sessionId }, "answer");
          send({ run_id: runId, status: "completed" }, "done");
        } catch (err) {
          await env.DB.prepare(`
            INSERT INTO agentsam_analytics
            (id, tenant_id, user_id, session_id, run_group_id, provider, model_key, mode, status, latency_ms, error_message, started_at, completed_at)
            VALUES (?, 'tenant_companionscpas', ?, ?, ?, 'system', 'none', ?, 'failed', ?, ?, datetime('now'), datetime('now'))
          `).bind(crypto.randomUUID(), sessionUser?.id || null, sessionId, runId, mode, Date.now() - started, String(err.message || err)).run().catch(() => {});
          send({ error: String(err.message || err) }, "error");
        } finally {
          controller.close();
        }
      }
    });

    return new Response(stream, {
      headers: {
        "Content-Type": "text/event-stream",
        "Cache-Control": "no-cache",
        "Connection": "keep-alive"
      }
    });
  }

  return null;
}
