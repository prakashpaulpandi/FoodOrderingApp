/* ========================================
   MealMate - Global JavaScript
   ======================================== */

(function() {
  'use strict';

  // ======================================
  // THEME MANAGEMENT
  // ======================================
  const ThemeManager = {
    STORAGE_KEY: 'mealmate_theme',
    DARK: 'dark',
    LIGHT: 'light',

    init() {
      const saved = localStorage.getItem(this.STORAGE_KEY) || this.LIGHT;
      this.apply(saved);
    },

    apply(theme) {
      document.documentElement.setAttribute('data-theme', theme);
      localStorage.setItem(this.STORAGE_KEY, theme);
      const btn = document.getElementById('themeToggle');
      if (btn) btn.textContent = theme === this.DARK ? '☀️' : '🌙';
    },

    toggle() {
      const current = document.documentElement.getAttribute('data-theme') || this.LIGHT;
      const next = current === this.DARK ? this.LIGHT : this.DARK;
      this.apply(next);
      Toast.show(next === this.DARK ? '🌙 Dark mode enabled' : '☀️ Light mode enabled', 'info');
    }
  };

  // ======================================
  // TOAST NOTIFICATIONS
  // ======================================
  const Toast = {
    container: null,

    getContainer() {
      if (!this.container) {
        this.container = document.querySelector('.mm-toast-container');
        if (!this.container) {
          this.container = document.createElement('div');
          this.container.className = 'mm-toast-container';
          document.body.appendChild(this.container);
        }
      }
      return this.container;
    },

    show(message, type = 'info', duration = 3000) {
      const icons = { success: '✅', error: '❌', info: 'ℹ️', warning: '⚠️' };
      const container = this.getContainer();
      const toast = document.createElement('div');
      toast.className = `mm-toast ${type}`;
      toast.innerHTML = `<span>${icons[type] || icons.info}</span><span>${message}</span>`;
      container.appendChild(toast);

      setTimeout(() => {
        toast.classList.add('leaving');
        toast.addEventListener('animationend', () => toast.remove());
      }, duration);
    }
  };

  // ======================================
  // PASSWORD TOGGLE
  // ======================================
  const PasswordToggle = {
    init() {
      document.querySelectorAll('.mm-password-toggle').forEach(btn => {
        btn.addEventListener('click', () => {
          const wrap = btn.closest('.mm-password-wrap');
          const input = wrap ? wrap.querySelector('input') : null;
          if (!input) return;
          const isPassword = input.type === 'password';
          input.type = isPassword ? 'text' : 'password';
          btn.textContent = isPassword ? '🙈' : '👁️';
        });
      });
    }
  };

  // ======================================
  // SCROLL REVEAL
  // ======================================
  const ScrollReveal = {
    init() {
      const elements = document.querySelectorAll('.reveal');
      if (!elements.length) return;

      const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            entry.target.classList.add('visible');
            observer.unobserve(entry.target);
          }
        });
      }, { threshold: 0.1, rootMargin: '0px 0px -50px 0px' });

      elements.forEach(el => observer.observe(el));
    }
  };

  // ======================================
  // SMOOTH SCROLL
  // ======================================
  const SmoothScroll = {
    init() {
      document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
          const target = document.querySelector(this.getAttribute('href'));
          if (target) {
            e.preventDefault();
            target.scrollIntoView({ behavior: 'smooth', block: 'start' });
          }
        });
      });
    }
  };

  // ======================================
  // QUANTITY CONTROLS
  // ======================================
  const QuantityControls = {
    init() {
      // Decrement buttons
      document.querySelectorAll('[data-qty-decrement]').forEach(btn => {
        btn.addEventListener('click', () => {
          const input = document.querySelector(btn.getAttribute('data-qty-decrement'));
          if (input) {
            const min = parseInt(input.getAttribute('min') || '1');
            const val = parseInt(input.value || '1');
            if (val > min) input.value = val - 1;
          }
        });
      });

      // Increment buttons
      document.querySelectorAll('[data-qty-increment]').forEach(btn => {
        btn.addEventListener('click', () => {
          const input = document.querySelector(btn.getAttribute('data-qty-increment'));
          if (input) {
            const max = parseInt(input.getAttribute('max') || '99');
            const val = parseInt(input.value || '1');
            if (val < max) input.value = val + 1;
          }
        });
      });
    }
  };

  // ======================================
  // INTERACTIVE EFFECTS
  // ======================================
  const InteractiveEffects = {
    init() {
      // Hover lift effect for cards
      document.querySelectorAll('.mm-restaurant-card, .mm-food-card, .mm-stat-card').forEach(card => {
        card.addEventListener('mouseenter', function() {
          this.style.transition = 'transform 0.3s cubic-bezier(0.4,0,0.2,1), box-shadow 0.3s ease';
        });
      });

      // Active state for nav links
      const currentPath = window.location.pathname;
      document.querySelectorAll('.mm-nav-link').forEach(link => {
        if (link.getAttribute('href') && currentPath.includes(link.getAttribute('href'))) {
          link.classList.add('active');
        }
      });
    }
  };

  // ======================================
  // CATEGORY FILTER
  // ======================================
  const CategoryFilter = {
    init() {
      document.querySelectorAll('.mm-category-chip').forEach(chip => {
        chip.addEventListener('click', function(e) {
          if (this.getAttribute('href') === '#') {
            e.preventDefault();
            document.querySelectorAll('.mm-category-chip').forEach(c => c.classList.remove('active'));
            this.classList.add('active');
          }
        });
      });
    }
  };

  // ======================================
  // IMAGE LAZY LOADING
  // ======================================
  const LazyLoad = {
    init() {
      const images = document.querySelectorAll('img[data-src]');
      if (!images.length) return;

      const observer = new IntersectionObserver(entries => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            const img = entry.target;
            img.src = img.getAttribute('data-src');
            img.removeAttribute('data-src');
            observer.unobserve(img);
          }
        });
      });

      images.forEach(img => observer.observe(img));
    }
  };

  // ======================================
  // NAVBAR SCROLL BEHAVIOR
  // ======================================
  const NavbarScroll = {
    init() {
      const navbar = document.querySelector('.mm-navbar');
      if (!navbar) return;

      let lastScroll = 0;
      window.addEventListener('scroll', () => {
        const current = window.pageYOffset;
        if (current > 80) {
          navbar.style.boxShadow = '0 4px 20px rgba(0,0,0,0.12)';
        } else {
          navbar.style.boxShadow = '0 2px 10px rgba(0,0,0,0.06)';
        }
        lastScroll = current;
      }, { passive: true });
    }
  };

  // ======================================
  // CONFETTI ANIMATION (for order success)
  // ======================================
  const Confetti = {
    start() {
      const colors = ['#FF4757', '#FFC312', '#2ED573', '#1E90FF', '#A29BFE', '#FF6B35'];
      const container = document.body;

      for (let i = 0; i < 100; i++) {
        const piece = document.createElement('div');
        const color = colors[Math.floor(Math.random() * colors.length)];
        const size = Math.random() * 10 + 6;
        const left = Math.random() * 100;
        const delay = Math.random() * 3;
        const duration = Math.random() * 3 + 2;

        piece.style.cssText = `
          position: fixed;
          left: ${left}vw;
          top: -20px;
          width: ${size}px;
          height: ${size}px;
          background: ${color};
          border-radius: ${Math.random() > 0.5 ? '50%' : '2px'};
          z-index: 9999;
          pointer-events: none;
          animation: confettiFall ${duration}s ease ${delay}s forwards;
          transform-origin: center;
        `;
        container.appendChild(piece);
        setTimeout(() => piece.remove(), (delay + duration) * 1000);
      }
    }
  };

  // ======================================
  // LOADING STATES
  // ======================================
  const LoadingState = {
    show(btn) {
      if (!btn) return;
      btn.disabled = true;
      btn.dataset.originalText = btn.innerHTML;
      btn.innerHTML = '<span style="display:inline-block;animation:spin 1s linear infinite;margin-right:8px">⟳</span> Processing...';
    },
    hide(btn) {
      if (!btn || !btn.dataset.originalText) return;
      btn.disabled = false;
      btn.innerHTML = btn.dataset.originalText;
    }
  };

  // ======================================
  // FORM VALIDATION
  // ======================================
  const FormValidation = {
    init() {
      document.querySelectorAll('form[data-validate]').forEach(form => {
        form.addEventListener('submit', function(e) {
          const inputs = this.querySelectorAll('[required]');
          let valid = true;
          inputs.forEach(input => {
            if (!input.value.trim()) {
              valid = false;
              input.style.borderColor = 'var(--primary)';
              input.addEventListener('input', () => {
                input.style.borderColor = '';
              }, { once: true });
            }
          });
          if (!valid) {
            e.preventDefault();
            Toast.show('Please fill in all required fields', 'error');
          }
        });
      });
    }
  };

  // ======================================
  // PASSWORD STRENGTH METER
  // ======================================
  const PasswordStrength = {
    init() {
      const passwordInputs = document.querySelectorAll('input[type="password"][data-strength]');
      passwordInputs.forEach(input => {
        const meter = document.querySelector(input.getAttribute('data-strength'));
        if (!meter) return;

        input.addEventListener('input', () => {
          const val = input.value;
          let strength = 0;
          if (val.length >= 8) strength++;
          if (/[A-Z]/.test(val)) strength++;
          if (/[0-9]/.test(val)) strength++;
          if (/[^A-Za-z0-9]/.test(val)) strength++;

          const labels = ['', 'Weak', 'Fair', 'Good', 'Strong'];
          const colors = ['', '#FF4757', '#FF6B35', '#FFC312', '#2ED573'];

          meter.style.width = (strength * 25) + '%';
          meter.style.background = colors[strength];
          const label = meter.parentElement.querySelector('.strength-label');
          if (label) {
            label.textContent = labels[strength];
            label.style.color = colors[strength];
          }
        });
      });
    }
  };

  // ======================================
  // CHECKOUT PAYMENT SELECTOR
  // ======================================
  const PaymentSelector = {
    init() {
      window.selectPayment = function(method) {
        document.querySelectorAll('.pay-option-wrapper').forEach(w => w.classList.remove('active'));
        const wrapper = document.getElementById('wrapper-' + method);
        if (wrapper) wrapper.classList.add('active');
        const radio = document.getElementById('radio-' + method);
        if (radio) radio.checked = true;
      };

      document.querySelectorAll('.upi-btn').forEach(btn => {
        btn.addEventListener('click', function(e) {
          e.preventDefault();
          document.querySelectorAll('.upi-btn').forEach(b => b.classList.remove('selected'));
          this.classList.add('selected');
        });
      });
    }
  };

  // ======================================
  // INITIALIZE ALL MODULES
  // ======================================
  function init() {
    ThemeManager.init();
    PasswordToggle.init();
    ScrollReveal.init();
    SmoothScroll.init();
    QuantityControls.init();
    InteractiveEffects.init();
    CategoryFilter.init();
    LazyLoad.init();
    NavbarScroll.init();
    FormValidation.init();
    PasswordStrength.init();
    PaymentSelector.init();

    // Theme toggle button
    const themeBtn = document.getElementById('themeToggle');
    if (themeBtn) {
      themeBtn.addEventListener('click', () => ThemeManager.toggle());
    }

    // Confetti on order success page
    if (document.querySelector('.mm-success-page')) {
      setTimeout(() => Confetti.start(), 500);
    }

    // Auto-hide alerts
    document.querySelectorAll('.mm-alert').forEach(alert => {
      setTimeout(() => {
        alert.style.opacity = '0';
        alert.style.transform = 'translateY(-10px)';
        alert.style.transition = 'all 0.3s ease';
        setTimeout(() => alert.remove(), 300);
      }, 4000);
    });
  }

  // Run on DOM ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

  // Expose global API
  window.MealMate = { Toast, ThemeManager, Confetti, LoadingState };

})();
