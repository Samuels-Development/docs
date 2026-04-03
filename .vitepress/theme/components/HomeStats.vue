<template>
  <div class="stats-bar">
    <div class="stat-item">
      <span class="stat-value">400+</span>
      <span class="stat-label">Happy Customers</span>
    </div>
    <div class="stat-divider"></div>
    <div class="stat-item">
      <span class="stat-value">5</span>
      <span class="stat-label">Premium Scripts</span>
    </div>
    <div class="stat-divider"></div>
    <div class="stat-item">
      <span class="stat-value">QBCore & ESX</span>
      <span class="stat-label">Framework Support</span>
    </div>
    <div class="stat-divider"></div>
    <div class="stat-item">
      <span class="stat-value">5</span>
      <span class="stat-label">Languages</span>
    </div>
  </div>
</template>

<style scoped>
.stats-bar {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 24px;
  margin-top: 32px;
  padding: 16px 32px;
  border-radius: 12px;
  background: var(--vp-c-bg-soft);
  border: 1px solid var(--vp-c-divider);
  flex-wrap: wrap;
}

.stat-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 2px;
  padding: 0 12px;
}

.stat-value {
  font-size: 18px;
  font-weight: 700;
  color: var(--vp-c-brand-1);
  letter-spacing: -0.02em;
}

.stat-label {
  font-size: 12px;
  color: var(--vp-c-text-2);
  text-transform: uppercase;
  letter-spacing: 0.05em;
  font-weight: 500;
}

.stat-divider {
  width: 1px;
  height: 32px;
  background: var(--vp-c-divider);
}

@media (max-width: 640px) {
  .stats-bar {
    gap: 16px;
    padding: 16px;
  }
  .stat-divider {
    display: none;
  }
  .stat-item {
    min-width: 100px;
  }
}
</style>
