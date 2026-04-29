function json(data, status = 200) {
  return new Response(JSON.stringify(data, null, 2), {
    status,
    headers: { "Content-Type": "application/json" }
  });
}

function isLiveStripe(env) {
  return !!(env.STRIPE_SECRET_KEY && String(env.STRIPE_SECRET_KEY).startsWith("sk_") && !String(env.STRIPE_SECRET_KEY).includes("fake"));
}

export async function donationApiRoutes(request, env, url) {
  if (url.pathname === "/api/donations/create-intent" && request.method === "POST") {
    const data = await request.json().catch(() => ({}));

    const donorName = String(data.donor_name || "").trim();
    const donorEmail = String(data.donor_email || "").trim().toLowerCase();
    const frequency = String(data.frequency || "one_time").trim();
    const campaignId = String(data.campaign_id || "general").trim();
    const note = String(data.note || "").trim();
    const amountCents = Number(data.amount_cents || 0);

    if (!donorName || !donorEmail || !amountCents || amountCents < 100) {
      return json({ error: "Name, email, and donation amount of at least $1 are required." }, 400);
    }

    const id = "donation_intent_" + crypto.randomUUID();
    const liveStripe = isLiveStripe(env);

    let checkoutUrl = `/donate?demo_intent=${encodeURIComponent(id)}`;
    let providerCheckoutId = "demo_checkout_" + crypto.randomUUID();

    // Demo-safe placeholder. When accepted, replace this block with Stripe Checkout Session creation.
    // Required future fields: mode=payment/subscription, line_items, success_url, cancel_url, customer_email.
    if (liveStripe) {
      checkoutUrl = `/donate?stripe_ready_but_disabled_for_demo=${encodeURIComponent(id)}`;
    }

    await env.DB.prepare(`
      INSERT INTO donation_intents
      (id, donor_name, donor_email, amount_cents, frequency, campaign_id, note,
       provider_checkout_id, provider_checkout_url, status, metadata_json)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `).bind(
      id,
      donorName,
      donorEmail,
      amountCents,
      frequency,
      campaignId,
      note,
      providerCheckoutId,
      checkoutUrl,
      liveStripe ? "stripe_ready_demo_blocked" : "demo_created",
      JSON.stringify({
        stripe_prepared: true,
        resend_receipt_prepared: true,
        source: "adopt_support_modal"
      })
    ).run();

    return json({
      success: true,
      mode: liveStripe ? "stripe_ready_demo_blocked" : "demo",
      donation_intent_id: id,
      checkout_url: checkoutUrl,
      message: liveStripe
        ? "Donation intent saved. Stripe is configured, but live checkout is intentionally disabled for this proposal demo."
        : "Demo donation intent saved. Stripe Checkout and Resend receipt hooks are prepared for activation after approval."
    });
  }

  if (url.pathname === "/api/admin/donation-intents" && request.method === "GET") {
    const rows = await env.DB.prepare(`
      SELECT *
      FROM donation_intents
      ORDER BY created_at DESC
      LIMIT 100
    `).all();

    return json({ donation_intents: rows.results || [] });
  }

  return null;
}
