<template>
  <section class="quickstart-section">
    <div class="container">
      <div class="section-header">
        <span class="section-badge">Quick Start</span>
        <h2 class="section-title">Up and Running in Minutes</h2>
        <p class="section-desc">Every script follows the same simple installation process.</p>
      </div>
      <div class="steps-grid">
        <div class="step-card">
          <div class="step-number">1</div>
          <h3>Download</h3>
          <p>Purchase from <a href="https://fivem.samueldev.shop" target="_blank">our store</a> and download via Keymaster.</p>
        </div>
        <div class="step-connector">
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14"/><path d="m12 5 7 7-7 7"/></svg>
        </div>
        <div class="step-card">
          <div class="step-number">2</div>
          <h3>Drop In</h3>
          <p>Extract into your <code>resources</code> folder. Database &amp; framework detected automatically.</p>
        </div>
        <div class="step-connector">
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14"/><path d="m12 5 7 7-7 7"/></svg>
        </div>
        <div class="step-card">
          <div class="step-number">3</div>
          <h3>Add Items</h3>
          <p>Copy item definitions to your inventory system (<code>ox_inventory</code>, <code>qb-core</code>, or ESX).</p>
        </div>
        <div class="step-connector">
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14"/><path d="m12 5 7 7-7 7"/></svg>
        </div>
        <div class="step-card">
          <div class="step-number">4</div>
          <h3>Configure</h3>
          <p>Tweak <code>config.lua</code> to your liking. All options are documented here.</p>
        </div>
      </div>

      <div class="deps-box">
        <h4>Common Dependencies</h4>
        <div class="deps-grid">
          <div class="dep">
            <span class="dep-name">Framework</span>
            <span class="dep-values">QBCore / QBox / ESX</span>
          </div>
          <div class="dep">
            <span class="dep-name">Target</span>
            <span class="dep-values">ox_target / qb-target</span>
          </div>
          <div class="dep">
            <span class="dep-name">Library</span>
            <span class="dep-values">ox_lib</span>
          </div>
          <div class="dep">
            <span class="dep-name">Database</span>
            <span class="dep-values">oxmysql</span>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
.quickstart-section {
  padding: 48px 0;
  max-width: 100%;
}

.container {
  width: 100%;
}

.section-header {
  text-align: center;
  margin-bottom: 48px;
}

.section-badge {
  display: inline-block;
  padding: 4px 14px;
  border-radius: 100px;
  font-size: 13px;
  font-weight: 600;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  color: var(--vp-c-brand-1);
  background: var(--vp-c-brand-soft);
  border: 1px solid rgba(148, 221, 12, 0.2);
  margin-bottom: 16px;
}

.section-title {
  font-size: 36px;
  font-weight: 800;
  letter-spacing: -0.03em;
  line-height: 1.2;
  margin: 0 0 12px;
  background: linear-gradient(135deg, var(--vp-c-text-1) 40%, var(--vp-c-brand-1));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.section-desc {
  font-size: 16px;
  color: var(--vp-c-text-2);
  max-width: 480px;
  margin: 0 auto;
  line-height: 1.6;
}

.steps-grid {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  margin-bottom: 40px;
}

.step-card {
  flex: 1;
  max-width: 220px;
  padding: 24px 20px;
  border-radius: 14px;
  background: var(--vp-c-bg-soft);
  border: 1px solid var(--vp-c-divider);
  text-align: center;
}

.step-card h3 {
  font-size: 16px;
  font-weight: 700;
  margin: 12px 0 8px;
  color: var(--vp-c-text-1);
}

.step-card p {
  font-size: 13px;
  color: var(--vp-c-text-2);
  line-height: 1.5;
  margin: 0;
}

.step-card code {
  font-size: 12px;
  padding: 1px 5px;
  border-radius: 4px;
  background: var(--vp-c-default-soft);
  color: var(--vp-c-brand-1);
}

.step-card a {
  color: var(--vp-c-brand-1);
  text-decoration: none;
  font-weight: 600;
}

.step-number {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 36px;
  height: 36px;
  border-radius: 10px;
  background: var(--vp-c-brand-soft);
  color: var(--vp-c-brand-1);
  font-size: 16px;
  font-weight: 800;
}

.step-connector {
  color: var(--vp-c-divider);
  flex-shrink: 0;
}

.deps-box {
  padding: 28px 32px;
  border-radius: 16px;
  background: var(--vp-c-bg-soft);
  border: 1px solid var(--vp-c-divider);
}

.deps-box h4 {
  font-size: 14px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  color: var(--vp-c-text-2);
  margin: 0 0 16px;
  text-align: center;
}

.deps-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
}

.dep {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
  text-align: center;
}

.dep-name {
  font-size: 12px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  color: var(--vp-c-brand-1);
}

.dep-values {
  font-size: 14px;
  color: var(--vp-c-text-1);
  font-weight: 500;
}

@media (max-width: 768px) {
  .steps-grid {
    flex-direction: column;
    gap: 8px;
  }
  .step-connector {
    transform: rotate(90deg);
  }
  .step-card {
    max-width: 100%;
    width: 100%;
  }
  .deps-grid {
    grid-template-columns: repeat(2, 1fr);
  }
  .section-title {
    font-size: 28px;
  }
}
</style>
