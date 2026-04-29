export default {
  async fetch(request, env) {
    const url = new URL(request.url);

    // API routes
    if (url.pathname.startsWith("/api/")) {
      return handleApi(request, env);
    }

    // Static assets
    return env.ASSETS.fetch(request);
  }
};

async function handleApi(request, env) {
  const url = new URL(request.url);

  if (url.pathname === "/api/health") {
    return new Response(JSON.stringify({ ok: true }), {
      headers: { "Content-Type": "application/json" }
    });
  }

  if (url.pathname === "/api/auth/login" && request.method === "POST") {
    const body = await request.json();

    // TEMP LOGIN (for demo Thursday)
    if (body.email === "meauxbility@gmail.com" && body.password === "admin123") {
      return new Response(JSON.stringify({ success: true }), {
        headers: {
          "Content-Type": "application/json",
          "Set-Cookie": "session=demo; Path=/; HttpOnly"
        }
      });
    }

    return new Response(JSON.stringify({ error: "Invalid login" }), {
      status: 401,
      headers: { "Content-Type": "application/json" }
    });
  }

  return new Response("Not found", { status: 404 });
}
