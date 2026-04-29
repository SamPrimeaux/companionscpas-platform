function json(data, status = 200) {
  return new Response(JSON.stringify(data, null, 2), {
    status,
    headers: { "Content-Type": "application/json" }
  });
}

export async function contactApiRoutes(request, env, url) {
  if (url.pathname === "/api/contact/request" && request.method === "POST") {
    const data = await request.json().catch(() => ({}));
    const name = String(data.name || "").trim();
    const email = String(data.email || "").trim().toLowerCase();
    const message = String(data.message || "").trim();

    if (!name || !email || !message) {
      return json({ error: "Name, email, and message are required." }, 400);
    }

    await env.DB.prepare(`
      INSERT INTO contact_requests_v2
      (id, name, email, phone, request_type, message, source_path, user_agent)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    `).bind(
      crypto.randomUUID(),
      name,
      email,
      String(data.phone || "").trim(),
      String(data.request_type || "general").trim(),
      message,
      request.headers.get("referer") || "",
      request.headers.get("user-agent") || ""
    ).run();

    return json({
      success: true,
      message: "Request saved. Companions of CPAS can follow up from the dashboard."
    });
  }

  if (url.pathname === "/api/admin/contact/requests" && request.method === "GET") {
    const rows = await env.DB.prepare(`
      SELECT * FROM contact_requests_v2
      ORDER BY created_at DESC
      LIMIT 100
    `).all();

    return json({ requests: rows.results || [] });
  }

  return null;
}
