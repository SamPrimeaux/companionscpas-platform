(function () {
    'use strict';

    // Sitewide footer component – single source of truth for Contact, Quick Links, and InnerAnimalMedia signature.
    var FOOTER_HTML = '<div class="footer-content">' +
        '<div class="footer-section"><h4>Contact</h4>' +
        '<button onclick="window.openContactModal && window.openContactModal(); return false;" style="background: linear-gradient(135deg, #dc2626 0%, #ea580c 100%); color: white; border: none; padding: 0.75rem 1.5rem; border-radius: 8px; font-weight: 600; cursor: pointer; font-size: 1rem; margin-bottom: 1rem; box-shadow: 0 4px 6px rgba(220, 38, 38, 0.3); transition: transform 0.2s, box-shadow 0.2s;" onmouseover="this.style.transform=\'translateY(-2px)\'; this.style.boxShadow=\'0 6px 12px rgba(220, 38, 38, 0.4)\';" onmouseout="this.style.transform=\'translateY(0)\'; this.style.boxShadow=\'0 4px 6px rgba(220, 38, 38, 0.3)\';">Get in Touch</button>' +
        '<p><strong>Admin:</strong> <a href="#" onclick="window.openContactModal && window.openContactModal(\'admin\'); return false;" style="cursor:pointer; color: var(--accent);">admin@companionscpas.org</a></p>' +
        '<p>P.O. Box 102</p><p>Dry Prong, LA 71423</p></div>' +
        '<div class="footer-section"><h4>Nonprofit Info</h4><p>501(c)(3) Tax-Exempt</p><p>EIN: 93-2791656</p></div>' +
        '<div class="footer-section"><h4>Quick Links</h4><a href="/">Home</a><a href="/about">About Us</a><a href="/adopt">Adopt</a><a href="/services">Services</a><a href="/donate">Donate</a></div>' +
        '</div><div class="footer-bottom"><div class="copyright">&copy; 2026 Companions of CPAS. All rights reserved.</div>' +
        '<div class="signature"><span>Developed by</span><img src="https://imagedelivery.net/g7wf09fCONpnidkRnR_5vw/87aac7e9-d6c7-4a53-df89-605e8020e000/avatar" alt="InnerAnimalMedia" class="signature-logo" width="72" height="72"></div></div>';

    function injectSiteFooter() {
        var el = document.getElementById('site-footer');
        if (el) el.innerHTML = FOOTER_HTML;
    }

    // Live site logo from dashboard Settings → D1 (Publish). Single source of truth.
    (function applyBrandLogo() {
        var sizePx = { small: 56, medium: 72, large: 96, xlarge: 120 };
        function run() {
            var imgs = document.querySelectorAll('img[data-brand-logo], .header-wrap .nav .brand img');
            if (!imgs.length) return false;
            fetch('/api/brand/logo?t=' + Date.now(), { cache: 'no-store', credentials: 'same-origin' })
                .then(function (r) { return r.ok ? r.json() : null; })
                .then(function (data) {
                    if (data && data.url) {
                        var h = (data.size && sizePx[data.size]) ? sizePx[data.size] : sizePx.large;
                        imgs.forEach(function (img) {
                            img.src = data.url;
                            img.style.height = h + 'px';
                            img.style.width = 'auto';
                        });
                    }
                    var footerH = (data && data.footerSignatureHeight) ? Number(data.footerSignatureHeight) : 72;
                    document.querySelectorAll('img.signature-logo').forEach(function (img) {
                        img.style.height = footerH + 'px';
                        img.style.width = 'auto';
                    });
                })
                .catch(function () {});
            return true;
        }
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', function () {
                injectSiteFooter();
                run();
                setTimeout(run, 200);
            });
        } else {
            injectSiteFooter();
            run();
            setTimeout(run, 200);
        }
    })();

    // Active navigation highlighting
    const currentPath = window.location.pathname;
    const navLinks = document.querySelectorAll('[data-nav]');
    const mobileNavLinks = document.querySelectorAll('[data-nav-mobile]');

    navLinks.forEach(link => {
        const href = link.getAttribute('href');
        if (href === currentPath || (currentPath === '/' && href === '/')) {
            link.classList.add('active');
        }
    });

    mobileNavLinks.forEach(link => {
        const href = link.getAttribute('href');
        if (href === currentPath || (currentPath === '/' && href === '/')) {
            link.classList.add('active');
        }
    });

    // Header scroll effect
    const header = document.querySelector('.header-wrap');
    let lastScroll = 0;

    window.addEventListener('scroll', () => {
        const currentScroll = window.pageYOffset;
        if (currentScroll > 50) {
            header?.classList.add('scrolled');
        } else {
            header?.classList.remove('scrolled');
        }
        lastScroll = currentScroll;
    });

    // Mobile Menu Toggle
    const mobileMenuBtn = document.querySelector('.mobile-menu-btn');
    const mobileNav = document.querySelector('.mobile-nav');
    const mobileNavClose = document.querySelector('.mobile-nav-close');
    const mobileNavOverlay = document.querySelector('.mobile-nav-overlay');

    function openMobileNav() {
        mobileNav?.classList.add('active');
        document.body.style.overflow = 'hidden';
        document.body.classList.add('mobile-nav-open');
    }

    function closeMobileNav() {
        mobileNav?.classList.remove('active');
        document.body.style.overflow = '';
        document.body.classList.remove('mobile-nav-open');
    }

    mobileMenuBtn?.addEventListener('click', () => {
        if (mobileNav?.classList.contains('active')) {
            closeMobileNav();
        } else {
            openMobileNav();
        }
    });

    mobileNavClose?.addEventListener('click', closeMobileNav);
    mobileNavOverlay?.addEventListener('click', closeMobileNav);

    // Close mobile menu on link click
    mobileNavLinks.forEach(link => {
        link.addEventListener('click', closeMobileNav);
    });

    // Global Contact Modal Functions (available on all pages)
    window._contactModalEscapeHandler = null;

    window.openContactModal = function (type = 'general') {
        let modal = document.getElementById('contactModal');

        if (!modal) {
            modal = window.createContactModal();
        }

        // Set inquiry type after modal is in DOM
        setTimeout(() => {
            const select = document.getElementById('contactType');
            if (select) {
                if (type === 'admin') {
                    select.value = 'admin';
                } else if (type === 'adoption') {
                    select.value = 'adoption';
                } else if (type === 'partnership') {
                    select.value = 'volunteer';
                } else if (type === 'donation') {
                    select.value = 'donation';
                }
            }
        }, 0);

        modal.classList.add('active');
        document.body.style.overflow = 'hidden';

        // Escape key to close
        if (window._contactModalEscapeHandler) {
            document.removeEventListener('keydown', window._contactModalEscapeHandler);
        }
        window._contactModalEscapeHandler = function (e) {
            if (e.key === 'Escape') {
                window.closeContactModal();
                document.removeEventListener('keydown', window._contactModalEscapeHandler);
                window._contactModalEscapeHandler = null;
            }
        };
        document.addEventListener('keydown', window._contactModalEscapeHandler);
    };

    window.closeContactModal = function () {
        const modal = document.getElementById('contactModal');
        if (modal) {
            modal.classList.remove('active');
            document.body.style.overflow = '';
            const form = document.getElementById('contactForm');
            if (form) form.reset();
        }
        if (window._contactModalEscapeHandler) {
            document.removeEventListener('keydown', window._contactModalEscapeHandler);
            window._contactModalEscapeHandler = null;
        }
    };

    window.createContactModal = function () {
        // Remove existing modal if any
        const existing = document.getElementById('contactModal');
        if (existing) {
            existing.remove();
        }

        const modal = document.createElement('div');
        modal.id = 'contactModal';
        modal.className = 'modal-overlay';
        modal.innerHTML = `
            <div class="modal modal-clay">
                <div class="modal-header">
                    <button type="button" class="close-btn" aria-label="Close">&times;</button>
                    <h3>Contact Us</h3>
                    <p>How can we help?</p>
                </div>
                <div class="modal-body">
                    <form id="contactForm">
                        <div class="form-group">
                            <label for="contactName">Full Name *</label>
                            <input type="text" id="contactName" required placeholder="John Doe" autocomplete="name">
                        </div>
                        <div class="form-group">
                            <label for="contactEmail">Email Address *</label>
                            <input type="email" id="contactEmail" required placeholder="john@example.com" autocomplete="email">
                        </div>
                        <div class="form-group">
                            <label for="contactPhone">Phone Number</label>
                            <input type="tel" id="contactPhone" placeholder="(318) 555-0123" autocomplete="tel">
                        </div>
                        <div class="form-group">
                            <label for="contactType">Inquiry Type *</label>
                            <select id="contactType" required>
                                <option value="">Select inquiry type...</option>
                                <option value="admin">Administrative Inquiry</option>
                                <option value="general">General Question</option>
                                <option value="adoption">Adoption Inquiry</option>
                                <option value="donation">Donation Question</option>
                                <option value="volunteer">Volunteer Opportunity</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="contactMessage">Message *</label>
                            <textarea id="contactMessage" required placeholder="Tell us how we can help..." style="min-height:120px"></textarea>
                        </div>
                        <button type="submit" class="submit-btn">Send Message</button>
                    </form>
                </div>
            </div>
        `;
        document.body.appendChild(modal);

        // Close button - programmatic handler for reliability
        const closeBtn = modal.querySelector('.close-btn');
        if (closeBtn) {
            closeBtn.addEventListener('click', (e) => {
                e.preventDefault();
                e.stopPropagation();
                window.closeContactModal();
            });
        }

        // Attach form handler after modal is in DOM
        const form = document.getElementById('contactForm');
        if (form) {
            form.addEventListener('submit', async (e) => {
                e.preventDefault();
                const submitBtn = e.target.querySelector('button[type="submit"]');
                const originalText = submitBtn.textContent;
                submitBtn.disabled = true;
                submitBtn.textContent = 'Sending...';

                try {
                    const response = await fetch('/api/help-request', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({
                            name: document.getElementById('contactName').value,
                            email: document.getElementById('contactEmail').value,
                            phone: document.getElementById('contactPhone').value,
                            message: document.getElementById('contactMessage').value,
                            requestType: document.getElementById('contactType').value
                        })
                    });

                    const result = await response.json();
                    if (response.ok) {
                        alert('Thank you! Your message has been sent. We\'ll get back to you soon.');
                        window.closeContactModal();
                    } else {
                        alert('Error: ' + (result.error || 'Failed to send message'));
                        submitBtn.disabled = false;
                        submitBtn.textContent = originalText;
                    }
                } catch (error) {
                    console.error('Submission error:', error);
                    alert('Failed to send message. Please try again.');
                    submitBtn.disabled = false;
                    submitBtn.textContent = originalText;
                }
            });
        }

        // Close on overlay click
        modal.addEventListener('click', (e) => {
            if (e.target.id === 'contactModal' || e.target === modal) {
                window.closeContactModal();
            }
        });

        return modal;
    };

    // Donate Modal (only if exists on page)
    const donateModal = document.getElementById('donateModal');
    if (donateModal) {
        const donateButtons = document.querySelectorAll('[data-modal="donate"]');
        const donateModalClose = document.getElementById('closeDonateModal');

        donateButtons.forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.preventDefault();
                donateModal.classList.add('active');
                document.body.style.overflow = 'hidden';
            });
        });

        donateModalClose?.addEventListener('click', () => {
            donateModal.classList.remove('active');
            document.body.style.overflow = '';
        });

        donateModal.addEventListener('click', (e) => {
            if (e.target === donateModal) {
                donateModal.classList.remove('active');
                document.body.style.overflow = '';
            }
        });

        // Donation Type Tabs (One-Time vs Monthly)
        const donationTabs = document.querySelectorAll('.donation-tab');
        let selectedDonationType = 'one-time';

        donationTabs.forEach(tab => {
            tab.addEventListener('click', () => {
                donationTabs.forEach(t => t.classList.remove('active'));
                tab.classList.add('active');
                selectedDonationType = tab.dataset.type;
            });
        });

        // Amount Selection
        const amountBtns = document.querySelectorAll('.amount-btn');
        const customAmountInput = document.getElementById('customAmount');
        let selectedAmount = 50;

        amountBtns.forEach(btn => {
            btn.addEventListener('click', () => {
                amountBtns.forEach(b => b.classList.remove('active'));
                btn.classList.add('active');
                selectedAmount = parseInt(btn.dataset.amount);
                if (customAmountInput) customAmountInput.value = '';
            });
        });

        customAmountInput?.addEventListener('input', (e) => {
            amountBtns.forEach(b => b.classList.remove('active'));
            selectedAmount = parseFloat(e.target.value) || 0;
        });

        const donateForm = document.getElementById('donateForm');
        donateForm?.addEventListener('submit', async (e) => {
            e.preventDefault();
            const btn = donateForm.querySelector('.form-submit');
            const originalText = btn.innerText;
            btn.innerText = 'Processing...';
            btn.disabled = true;

            const formData = {
                amount: selectedAmount,
                type: selectedDonationType,
                firstName: donateForm.firstName.value,
                lastName: donateForm.lastName.value,
                email: donateForm.email.value
            };

            setTimeout(() => {
                alert(`${selectedDonationType === 'monthly' ? 'Monthly' : 'One-time'} donation of $${selectedAmount} initiated!\n\nStripe Checkout integration ready.`);
                btn.innerText = originalText;
                btn.disabled = false;
                donateModal.classList.remove('active');
                document.body.style.overflow = '';
                donateForm.reset();
                amountBtns[1]?.classList.add('active');
                selectedAmount = 50;
            }, 1500);
        });
    }

    // Request Help Modal (only if exists on page)
    const helpModal = document.getElementById('helpModal');
    if (helpModal) {
        const helpButtons = document.querySelectorAll('[data-modal="help"]');
        const helpModalClose = helpModal.querySelector('.close-btn');

        helpButtons.forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.preventDefault();
                helpModal.classList.add('active');
                document.body.style.overflow = 'hidden';
            });
        });

        helpModalClose?.addEventListener('click', () => {
            helpModal.classList.remove('active');
            document.body.style.overflow = '';
        });

        helpModal.addEventListener('click', (e) => {
            if (e.target === helpModal) {
                helpModal.classList.remove('active');
                document.body.style.overflow = '';
            }
        });

        const helpForm = document.getElementById('helpForm');
        helpForm?.addEventListener('submit', async (e) => {
            e.preventDefault();
            const btn = helpForm.querySelector('.button.primary');
            const originalText = btn.innerText;
            btn.innerText = 'Sending...';
            btn.disabled = true;

            setTimeout(() => {
                alert('Request received! We will be in touch shortly.');
                btn.innerText = originalText;
                btn.disabled = false;
                helpModal.classList.remove('active');
                document.body.style.overflow = '';
                helpForm.reset();
            }, 1500);
        });
    }
})();
