<template>
  <section class="support-section">
    <div class="container">
      <div class="support-grid">
        <a href="https://discord.gg/FzPehMQaBQ" target="_blank" class="support-card discord">
          <div class="support-icon">
            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="currentColor"><path d="M20.317 4.37a19.791 19.791 0 0 0-4.885-1.515.074.074 0 0 0-.079.037c-.21.375-.444.864-.608 1.25a18.27 18.27 0 0 0-5.487 0 12.64 12.64 0 0 0-.617-1.25.077.077 0 0 0-.079-.037A19.736 19.736 0 0 0 3.677 4.37a.07.07 0 0 0-.032.027C.533 9.046-.32 13.58.099 18.057a.082.082 0 0 0 .031.057 19.9 19.9 0 0 0 5.993 3.03.078.078 0 0 0 .084-.028 14.09 14.09 0 0 0 1.226-1.994.076.076 0 0 0-.041-.106 13.107 13.107 0 0 1-1.872-.892.077.077 0 0 1-.008-.128 10.2 10.2 0 0 0 .372-.292.074.074 0 0 1 .077-.01c3.928 1.793 8.18 1.793 12.062 0a.074.074 0 0 1 .078.01c.12.098.246.198.373.292a.077.077 0 0 1-.006.127 12.299 12.299 0 0 1-1.873.892.077.077 0 0 0-.041.107c.36.698.772 1.362 1.225 1.993a.076.076 0 0 0 .084.028 19.839 19.839 0 0 0 6.002-3.03.077.077 0 0 0 .032-.054c.5-5.177-.838-9.674-3.549-13.66a.061.061 0 0 0-.031-.03zM8.02 15.33c-1.183 0-2.157-1.085-2.157-2.419 0-1.333.956-2.419 2.157-2.419 1.21 0 2.176 1.096 2.157 2.42 0 1.333-.956 2.418-2.157 2.418zm7.975 0c-1.183 0-2.157-1.085-2.157-2.419 0-1.333.955-2.419 2.157-2.419 1.21 0 2.176 1.096 2.157 2.42 0 1.333-.946 2.418-2.157 2.418z"/></svg>
          </div>
          <div class="support-content">
            <h3>Join our Discord</h3>
            <p>Get help from the community and our support team. Report bugs, request features, or just chat.</p>
          </div>
          <span class="support-arrow">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M7 17l9.2-9.2M17 17V7.8H7.8"/></svg>
          </span>
        </a>

        <a href="https://fivem.samueldev.shop" target="_blank" class="support-card store">
          <div class="support-icon">
            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="8" cy="21" r="1"/><circle cx="19" cy="21" r="1"/><path d="M2.05 2.05h2l2.66 12.42a2 2 0 0 0 2 1.58h9.78a2 2 0 0 0 1.95-1.57l1.65-7.43H5.12"/></svg>
          </div>
          <div class="support-content">
            <h3>Visit the Store</h3>
            <p>Browse all our scripts. Instant delivery via Keymaster. Use code <strong>WELCOME20</strong> for 20% off.</p>
          </div>
          <span class="support-arrow">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M7 17l9.2-9.2M17 17V7.8H7.8"/></svg>
          </span>
        </a>
      </div>

      <div class="warning-banner">
        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3"/><path d="M12 9v4"/><path d="M12 17h.01"/></svg>
        <p>Our scripts are sold <strong>exclusively</strong> on <a href="https://fivem.samueldev.shop" target="_blank">fivem.samueldev.shop</a>. Do not purchase from unauthorized resellers.</p>
      </div>
    </div>
  </section>
</template>

<style scoped>
.support-section {
  padding: 0 0 48px;
  max-width: 100%;
}

.container {
  width: 100%;
}

.support-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
  margin-bottom: 24px;
}

.support-card {
  display: flex;
  align-items: center;
  gap: 20px;
  padding: 28px;
  border-radius: 16px;
  background: var(--vp-c-bg-soft);
  border: 1px solid var(--vp-c-divider);
  text-decoration: none;
  color: inherit;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
}

.support-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
}

.support-card.discord:hover {
  border-color: #5865F2;
}

.support-card.store:hover {
  border-color: var(--vp-c-brand-1);
}

.support-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 56px;
  height: 56px;
  border-radius: 14px;
  flex-shrink: 0;
}

.discord .support-icon {
  background: rgba(88, 101, 242, 0.12);
  color: #5865F2;
}

.store .support-icon {
  background: var(--vp-c-brand-soft);
  color: var(--vp-c-brand-1);
}

.support-content {
  flex: 1;
}

.support-content h3 {
  font-size: 18px;
  font-weight: 700;
  margin: 0 0 4px;
  color: var(--vp-c-text-1);
}

.support-content p {
  font-size: 14px;
  color: var(--vp-c-text-2);
  line-height: 1.5;
  margin: 0;
}

.support-content strong {
  color: var(--vp-c-brand-1);
  font-weight: 700;
}

.support-arrow {
  color: var(--vp-c-text-3);
  flex-shrink: 0;
  transition: transform 0.2s ease;
}

.support-card:hover .support-arrow {
  transform: translate(2px, -2px);
}

.warning-banner {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 16px 24px;
  border-radius: 12px;
  background: rgba(234, 179, 8, 0.08);
  border: 1px solid rgba(234, 179, 8, 0.2);
  color: #eab308;
}

.warning-banner p {
  margin: 0;
  font-size: 14px;
  color: var(--vp-c-text-2);
  line-height: 1.5;
}

.warning-banner a {
  color: var(--vp-c-brand-1);
  font-weight: 600;
  text-decoration: none;
}

.warning-banner svg {
  flex-shrink: 0;
}

@media (max-width: 768px) {
  .support-grid {
    grid-template-columns: 1fr;
  }
  .support-section {
    padding: 0 0 32px;
  }
}
</style>
