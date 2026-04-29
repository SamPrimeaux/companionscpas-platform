const TENANT_ID = "tenant_companionscpas";

function json(data, status = 200) {
  return new Response(JSON.stringify(data), {
    status,
    headers: { "content-type": "application/json; charset=utf-8" }
  });
}

function id(prefix = "cms") {
  return `${prefix}_${Date.now().toString(36)}_${Math.random().toString(36).slice(2, 8)}`;
}

async function body(request) {
  try { return await request.json(); } catch { return {}; }
}

function safeJson(value, fallback) {
  try { return JSON.parse(value || ""); } catch { return fallback; }
}

export async function cmsRoutes(request, env, url, sessionUser = null) {
  const path = url.pathname;
  const method = request.method;

  if (!env.DB) return json({ error: "DB binding missing" }, 500);

  if (path === "/api/cms/bootstrap" && method === "GET") {
    const [pages, assets, brand, nav, themes] = await Promise.all([
      env.DB.prepare("SELECT * FROM cms_pages WHERE tenant_id = ? ORDER BY sort_order, route_path").bind(TENANT_ID).all().catch(() => ({ results: [] })),
      env.DB.prepare("SELECT * FROM cms_assets WHERE tenant_id = ? AND status != 'archived' ORDER BY updated_at DESC, created_at DESC LIMIT 200").bind(TENANT_ID).all().catch(() => ({ results: [] })),
      env.DB.prepare("SELECT * FROM cms_brand_settings WHERE tenant_id = ? LIMIT 1").bind(TENANT_ID).first().catch(() => null),
      env.DB.prepare("SELECT * FROM cms_navigation_items WHERE tenant_id = ? ORDER BY sort_order, label").bind(TENANT_ID).all().catch(() => ({ results: [] })),
      env.DB.prepare("SELECT * FROM cms_themes WHERE tenant_id = ? ORDER BY is_active DESC, updated_at DESC LIMIT 20").bind(TENANT_ID).all().catch(() => ({ results: [] })),
    ]);

    return json({
      success: true,
      tenant_id: TENANT_ID,
      pages: pages.results || [],
      assets: assets.results || [],
      brand,
      nav: nav.results || [],
      themes: themes.results || []
    });
  }

  if (path === "/api/cms/page" && method === "GET") {
    const route = url.searchParams.get("route") || "/";
    const page = await env.DB.prepare("SELECT * FROM cms_pages WHERE tenant_id = ? AND route_path = ? LIMIT 1")
      .bind(TENANT_ID, route).first();

    if (!page) return json({ error: "Page not found", route }, 404);

    const sections = await env.DB.prepare("SELECT * FROM cms_page_sections WHERE tenant_id = ? AND page_route = ? ORDER BY sort_order, section_key")
      .bind(TENANT_ID, route).all().catch(() => ({ results: [] }));

    const blocks = await env.DB.prepare("SELECT * FROM cms_page_content_blocks WHERE tenant_id = ? AND page_route = ? ORDER BY sort_order, section_key, block_key")
      .bind(TENANT_ID, route).all().catch(() => ({ results: [] }));

    return json({ success: true, page, sections: sections.results || [], blocks: blocks.results || [] });
  }

  if (path === "/api/cms/section/save" && method === "POST") {
    const data = await body(request);
    const section = data.section || data;

    const page_route = section.page_route || data.page_route || "/";
    const section_key = section.section_key || data.section_key || id("section");

    await env.DB.prepare(`
      INSERT INTO cms_page_sections
      (id, tenant_id, page_route, section_key, section_type, eyebrow, heading, subheading, body,
       image_url, cta_label, cta_href, cta_secondary_label, cta_secondary_href, sort_order,
       is_visible, config_json, updated_at)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, datetime('now'))
      ON CONFLICT(tenant_id, page_route, section_key) DO UPDATE SET
        section_type = excluded.section_type,
        eyebrow = excluded.eyebrow,
        heading = excluded.heading,
        subheading = excluded.subheading,
        body = excluded.body,
        image_url = excluded.image_url,
        cta_label = excluded.cta_label,
        cta_href = excluded.cta_href,
        cta_secondary_label = excluded.cta_secondary_label,
        cta_secondary_href = excluded.cta_secondary_href,
        sort_order = excluded.sort_order,
        is_visible = excluded.is_visible,
        config_json = excluded.config_json,
        updated_at = datetime('now')
    `).bind(
      section.id || id("section"),
      TENANT_ID,
      page_route,
      section_key,
      section.section_type || "content",
      section.eyebrow || "",
      section.heading || section.title || "",
      section.subheading || "",
      section.body || "",
      section.image_url || "",
      section.cta_label || "",
      section.cta_href || "",
      section.cta_secondary_label || "",
      section.cta_secondary_href || "",
      Number(section.sort_order || 50),
      section.is_visible === 0 ? 0 : 1,
      typeof section.config_json === "string" ? section.config_json : JSON.stringify(section.config_json || {})
    ).run();

    await env.DB.prepare("UPDATE cms_pages SET status = 'draft', updated_at = datetime('now') WHERE tenant_id = ? AND route_path = ?")
      .bind(TENANT_ID, page_route).run().catch(() => {});

    return json({ success: true, page_route, section_key });
  }

  if (path === "/api/cms/block/save" && method === "POST") {
    const data = await body(request);
    const block = data.block || data;

    const page_route = block.page_route || data.page_route || "/";
    const section_key = block.section_key || data.section_key || "main";
    const block_key = block.block_key || data.block_key || id("block");

    await env.DB.prepare(`
      INSERT INTO cms_page_content_blocks
      (id, tenant_id, page_route, section_key, block_key, block_type, eyebrow, title, subtitle, body,
       image_url, alt_text, href, action_label, action_type, action_value, sort_order, is_visible,
       config_json, updated_at)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, datetime('now'))
      ON CONFLICT(tenant_id, page_route, section_key, block_key) DO UPDATE SET
        block_type = excluded.block_type,
        eyebrow = excluded.eyebrow,
        title = excluded.title,
        subtitle = excluded.subtitle,
        body = excluded.body,
        image_url = excluded.image_url,
        alt_text = excluded.alt_text,
        href = excluded.href,
        action_label = excluded.action_label,
        action_type = excluded.action_type,
        action_value = excluded.action_value,
        sort_order = excluded.sort_order,
        is_visible = excluded.is_visible,
        config_json = excluded.config_json,
        updated_at = datetime('now')
    `).bind(
      block.id || id("block"),
      TENANT_ID,
      page_route,
      section_key,
      block_key,
      block.block_type || "text",
      block.eyebrow || "",
      block.title || "",
      block.subtitle || "",
      block.body || "",
      block.image_url || "",
      block.alt_text || "",
      block.href || "",
      block.action_label || "",
      block.action_type || "",
      block.action_value || "",
      Number(block.sort_order || 50),
      block.is_visible === 0 ? 0 : 1,
      typeof block.config_json === "string" ? block.config_json : JSON.stringify(block.config_json || {})
    ).run();

    return json({ success: true, page_route, section_key, block_key });
  }

  if (path === "/api/cms/page/save" && method === "POST") {
    const data = await body(request);
    const page = data.page || data;
    const route_path = page.route_path || "/";
    const slug = page.slug || (route_path === "/" ? "home" : route_path.replace(/^\//, ""));

    await env.DB.prepare(`
      INSERT INTO cms_pages
      (id, tenant_id, route_path, slug, title, status, seo_title, meta_description, og_image_url,
       page_type, template_key, sort_order, is_homepage, show_header, show_footer, updated_at)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, datetime('now'))
      ON CONFLICT(tenant_id, route_path) DO UPDATE SET
        slug = excluded.slug,
        title = excluded.title,
        status = excluded.status,
        seo_title = excluded.seo_title,
        meta_description = excluded.meta_description,
        og_image_url = excluded.og_image_url,
        page_type = excluded.page_type,
        template_key = excluded.template_key,
        sort_order = excluded.sort_order,
        is_homepage = excluded.is_homepage,
        show_header = excluded.show_header,
        show_footer = excluded.show_footer,
        updated_at = datetime('now')
    `).bind(
      page.id || id("page"),
      TENANT_ID,
      route_path,
      slug,
      page.title || "Untitled Page",
      page.status || "draft",
      page.seo_title || page.title || "",
      page.meta_description || "",
      page.og_image_url || "",
      page.page_type || "standard",
      page.template_key || "default",
      Number(page.sort_order || 50),
      page.is_homepage ? 1 : 0,
      page.show_header === 0 ? 0 : 1,
      page.show_footer === 0 ? 0 : 1
    ).run();

    return json({ success: true, route_path });
  }

  if (path === "/api/cms/publish" && method === "POST") {
    const data = await body(request);
    const route = data.route_path || data.route || "/";

    await env.DB.prepare(`
      UPDATE cms_pages
      SET status = 'published',
          published_at = datetime('now'),
          updated_at = datetime('now'),
          published_by = ?
      WHERE tenant_id = ? AND route_path = ?
    `).bind(sessionUser?.email || sessionUser?.id || "dashboard", TENANT_ID, route).run();

    return json({
      success: true,
      route_path: route,
      preview_url: route === "/" ? "/" : route,
      message: "Page marked published. Static page regeneration can be wired after the client approves the build."
    });
  }

  return null;
}
