import { chromium } from 'playwright';

const url = process.argv[2] || 'https://companionscpas-platform.samprimeauxwork.workers.dev';

const browser = await chromium.launch();
const page = await browser.newPage();

await page.goto(url, { waitUntil: 'networkidle' });

const images = await page.evaluate(async () => {
  const results = [];

  const imgs = Array.from(document.images);

  for (const img of imgs) {
    const src = img.currentSrc || img.src;

    let size = null;
    try {
      const res = await fetch(src, { method: 'HEAD' });
      size = res.headers.get('content-length');
    } catch {}

    results.push({
      src,
      rendered: `${img.clientWidth}x${img.clientHeight}`,
      natural: `${img.naturalWidth}x${img.naturalHeight}`,
      size_bytes: size ? Number(size) : null
    });
  }

  return results;
});

console.table(images);

await browser.close();
