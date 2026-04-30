from pathlib import Path
import re

PAGES = ["public/adopt.html", "public/services.html", "public/donate.html"]

FINAL_MODAL_CSS = r'''
<style id="cpas-modal-final-v1">
.cpas-donate-modal{position:fixed!important;inset:0!important;z-index:100000!important;display:none!important;align-items:center!important;justify-content:center!important;padding:24px!important;background:rgba(3,6,12,.72)!important;backdrop-filter:blur(18px)!important}
.cpas-donate-modal.open{display:flex!important}
.cpas-donate-panel{width:min(640px,calc(100vw - 36px))!important;max-height:min(760px,calc(100vh - 48px))!important;overflow:auto!important;border-radius:28px!important;background:linear-gradient(180deg,#fff,#f4efff)!important;color:#172033!important;box-shadow:0 34px 120px rgba(0,0,0,.45)!important;border:1px solid rgba(255,255,255,.78)!important}
.cpas-donate-head{display:flex!important;justify-content:space-between!important;gap:18px!important;padding:30px 30px 18px!important;border-bottom:1px solid rgba(23,32,51,.08)!important}
.cpas-donate-head h2,.cpas-donate-head h3{margin:0 0 8px!important;color:#172033!important;font-size:30px!important;line-height:1!important}
.cpas-donate-head p{margin:0!important;color:#526174!important;font-weight:700!important;line-height:1.5!important}
.cpas-donate-close,.cpas-close,[data-close-donate]{width:42px!important;height:42px!important;border:0!important;border-radius:999px!important;background:#6d5593!important;color:#fff!important;font-size:20px!important;font-weight:900!important;cursor:pointer!important}
.cpas-donate-body,.cpas-donate-form{display:grid!important;gap:14px!important;padding:24px 30px 30px!important}
.cpas-donate-grid{display:grid!important;grid-template-columns:1fr 1fr!important;gap:14px!important}
.cpas-donate-grid .full{grid-column:1/-1!important}
.cpas-amounts{display:grid!important;grid-template-columns:repeat(4,1fr)!important;gap:12px!important}
.cpas-amounts button,.cpas-donate-form button.choice,.cpas-donate-form .choice{min-height:52px!important;border-radius:14px!important;border:1px solid rgba(23,32,51,.12)!important;background:#fff!important;color:#172033!important;font-weight:900!important}
.cpas-amounts button.active,.cpas-donate-form button.active,.cpas-donate-form .active{background:#6d5593!important;color:#fff!important}
.cpas-donate-form label{color:#172033!important;font-weight:900!important;font-size:12px!important;text-transform:uppercase!important;letter-spacing:.08em!important}
.cpas-donate-form input,.cpas-donate-form select,.cpas-donate-form textarea{width:100%!important;min-height:52px!important;border-radius:14px!important;border:1px solid rgba(23,32,51,.13)!important;background:#fff!important;color:#172033!important;padding:0 16px!important;font:inherit!important;font-weight:700!important}
.cpas-donate-form textarea{padding:14px 16px!important;min-height:86px!important}
.cpas-donate-submit,.cpas-donate-form button[type="submit"]{width:100%!important;min-height:56px!important;border:0!important;border-radius:16px!important;background:#6d5593!important;color:#fff!important;font-weight:950!important;box-shadow:0 18px 48px rgba(109,85,147,.26)!important}
@media(max-width:720px){.cpas-donate-grid,.cpas-amounts{grid-template-columns:1fr!important}.cpas-donate-head,.cpas-donate-body,.cpas-donate-form{padding-left:20px!important;padding-right:20px!important}}
</style>
'''

FINAL_MODAL_JS = r'''
<script id="cpas-modal-final-js">
(() => {
  const modal = document.getElementById("cpasDonateModal");
  if (!modal) return;

  function openModal(e){
    if (e) e.preventDefault();
    modal.classList.add("open");
    modal.setAttribute("aria-hidden","false");
    document.body.style.overflow = "hidden";
  }

  function closeModal(){
    modal.classList.remove("open");
    modal.setAttribute("aria-hidden","true");
    document.body.style.overflow = "";
  }

  // Modal triggers only. Never hijack normal href="/donate" nav.
  document.querySelectorAll("[data-open-demo-donate], [data-open-donate-modal]").forEach(el => {
    el.addEventListener("click", openModal);
  });

  document.querySelectorAll("[data-close-donate], .cpas-donate-close, .cpas-close").forEach(el => {
    el.addEventListener("click", closeModal);
  });

  modal.addEventListener("click", e => {
    if (e.target === modal) closeModal();
  });

  window.addEventListener("keydown", e => {
    if (e.key === "Escape") closeModal();
  });

  window.openDonateModal = openModal;
  window.closeDonateModal = closeModal;
})();
</script>
'''

for file in PAGES:
    p = Path(file)
    s = p.read_text(errors="ignore")

    # Remove old legacy donate modal HTML blocks only.
    s = re.sub(r'\n?\s*<div class="modal-overlay" id="donateModal"[\s\S]*?</div>\s*(?=\n\s*<script|\n\s*<div|\n\s*<section|\n\s*</main>)', '\n', s, flags=re.I)

    # Remove old scripts that define or bind legacy donateModal/openDonateModal,
    # but keep animal/contact/application modal scripts as much as possible by targeting script blocks.
    s = re.sub(r'\n?\s*<script\b[^>]*>[\s\S]*?(?:function openDonateModal|id === [\'"]donateModal[\'"]|getElementById\([\'"]donateModal[\'"]\)|window\.openDonateModal)[\s\S]*?</script>\s*', '\n', s, flags=re.I)

    # Remove old modal style blocks if they target #donateModal heavily.
    s = re.sub(r'\n?\s*<style\b[^>]*>[\s\S]*?#donateModal[\s\S]*?</style>\s*', '\n', s, flags=re.I)

    # Remove previous duplicate cpas modal CSS/JS, then install final once.
    s = re.sub(r'\n?\s*<style id="cpas-modal-final-v1">[\s\S]*?</style>\s*', '\n', s, flags=re.I)
    s = re.sub(r'\n?\s*<script id="cpas-modal-final-js">[\s\S]*?</script>\s*', '\n', s, flags=re.I)
    s = re.sub(r'\n?\s*<script id="cpas-donate-modal-js">[\s\S]*?</script>\s*', '\n', s, flags=re.I)

    if 'id="cpas-modal-final-v1"' not in s:
        s = s.replace("</head>", FINAL_MODAL_CSS + "\n</head>", 1)
    if 'id="cpas-modal-final-js"' not in s:
        s = s.replace("</body>", FINAL_MODAL_JS + "\n</body>", 1)

    # Critical: normal nav Donate must route, not open modal.
    s = s.replace('document.querySelectorAll("[data-open-demo-donate], .donate-link, [href=\'/donate\']")',
                  'document.querySelectorAll("[data-open-demo-donate], [data-open-donate-modal]")')
    s = s.replace('document.querySelectorAll("[data-open-demo-donate], .donate-link, [href=\\"/donate\\"]")',
                  'document.querySelectorAll("[data-open-demo-donate], [data-open-donate-modal]")')

    p.write_text(s)
    print("repaired modal conflicts:", file)
