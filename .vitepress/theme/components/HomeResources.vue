<script setup>
const resources = [
  {
    title: 'Shops Pro',
    version: 'v1.1.0',
    description: 'Full economy system with shop ownership, employees, stock management, loyalty programs, coupons, weapon serials, and 5 shop types.',
    link: '/resources/shops/',
    icon: 'shop',
    tags: ['Economy', 'Management', 'UI'],
    color: '#94DD0C',
  },
  {
    title: 'Horde Mission',
    version: 'v1.1.4',
    description: 'Wave-based survival with 4 maps, group play, 20-level progression, mystery box, radio sync, and rejoin system.',
    link: '/resources/horde/',
    icon: 'sword',
    tags: ['Combat', 'Multiplayer', 'PvE'],
    color: '#FF6B6B',
  },
  {
    title: 'Advanced Crafting',
    version: 'v1.1.5',
    description: 'Workbenches, recipes, blueprints, tech trees, tool durability, persistent queues, and a full leveling system.',
    link: '/resources/crafting/',
    icon: 'hammer',
    tags: ['Crafting', 'Progression', 'UI'],
    color: '#4ECDC4',
  },
  {
    title: 'Dumpster Diving',
    version: 'v1.3.3',
    description: 'Loot dumpsters, befriend rat companions with perks, run expeditions, trade with the Hobo King, and recycle scrap.',
    link: '/resources/dumpsters/',
    icon: 'recycle',
    tags: ['Survival', 'Companions', 'Economy'],
    color: '#FFE66D',
  },
  {
    title: 'Beekeeping',
    version: 'v1.3.1',
    description: 'Manage hives, produce 3 honey types, handle infections and aggression, protect with gear, and collaborate with players.',
    link: '/resources/beekeeping/',
    icon: 'bee',
    tags: ['Farming', 'Production', 'Coop'],
    color: '#F7B731',
  },
]
</script>

<template>
  <section class="resources-section">
    <div class="container">
      <div class="section-header">
        <span class="section-badge">Resources</span>
        <h2 class="section-title">Our Scripts</h2>
        <p class="section-desc">Every script supports QBCore, QBox, and ESX with auto-detection, auto-database setup, and multi-language support.</p>
      </div>
      <div class="resource-grid">
        <a
          v-for="resource in resources"
          :key="resource.title"
          :href="resource.link"
          class="resource-card"
        >
          <div class="card-header">
            <div class="card-icon" :style="{ '--icon-color': resource.color }">
              <!-- Shop icon -->
              <svg v-if="resource.icon === 'shop'" xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="m2 7 4.41-4.41A2 2 0 0 1 7.83 2h8.34a2 2 0 0 1 1.42.59L22 7"/><path d="M4 12v8a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-8"/><path d="M15 22v-4a2 2 0 0 0-2-2h-2a2 2 0 0 0-2 2v4"/><path d="M2 7h20"/><path d="M22 7v3a2 2 0 0 1-2 2a2.7 2.7 0 0 1-1.59-.63.7.7 0 0 0-.82 0A2.7 2.7 0 0 1 16 12a2.7 2.7 0 0 1-1.59-.63.7.7 0 0 0-.82 0A2.7 2.7 0 0 1 12 12a2.7 2.7 0 0 1-1.59-.63.7.7 0 0 0-.82 0A2.7 2.7 0 0 1 8 12a2.7 2.7 0 0 1-1.59-.63.7.7 0 0 0-.82 0A2.7 2.7 0 0 1 4 12a2 2 0 0 1-2-2V7"/></svg>
              <!-- Sword icon -->
              <svg v-if="resource.icon === 'sword'" xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="14.5 17.5 3 6 3 3 6 3 17.5 14.5"/><line x1="13" x2="19" y1="19" y2="13"/><line x1="16" x2="20" y1="16" y2="20"/><line x1="19" x2="21" y1="21" y2="19"/></svg>
              <!-- Hammer icon -->
              <svg v-if="resource.icon === 'hammer'" xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="m15 12-8.5 8.5c-.83.83-2.17.83-3 0 0 0 0 0 0 0a2.12 2.12 0 0 1 0-3L12 9"/><path d="M17.64 15 22 10.64"/><path d="m20.91 11.7-1.25-1.25c-.6-.6-.93-1.4-.93-2.25v-.86L16.01 4.6a5.56 5.56 0 0 0-3.94-1.64H9l.92.82A6.18 6.18 0 0 1 12 8.4v1.56l2 2h2.47l2.26 1.91"/></svg>
              <!-- Recycle icon -->
              <svg v-if="resource.icon === 'recycle'" xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M7 19H4.815a1.83 1.83 0 0 1-1.57-.881 1.785 1.785 0 0 1-.004-1.784L7.196 9.5"/><path d="M11 19h8.203a1.83 1.83 0 0 0 1.556-.89 1.784 1.784 0 0 0 0-1.775l-1.226-2.12"/><path d="m14 16-3 3 3 3"/><path d="M8.293 13.596 7.196 9.5 3.1 10.598"/><path d="m9.344 5.811 1.093-1.892A1.83 1.83 0 0 1 11.985 3a1.784 1.784 0 0 1 1.546.888l3.943 6.843"/><path d="m13.378 9.633 4.096 1.098 1.097-4.096"/></svg>
              <!-- Bee icon -->
              <svg v-if="resource.icon === 'bee'" xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M12 12a5 5 0 0 0-5 5c0 2.76 2.24 5 5 5s5-2.24 5-5a5 5 0 0 0-5-5z"/><path d="M12 2v4"/><path d="M9 6h6"/><path d="M7 10h10"/><path d="M9 14h6"/><path d="m8 22 1-5"/><path d="m16 22-1-5"/></svg>
            </div>
            <span class="card-version">{{ resource.version }}</span>
          </div>
          <h3 class="card-title">{{ resource.title }}</h3>
          <p class="card-desc">{{ resource.description }}</p>
          <div class="card-tags">
            <span v-for="tag in resource.tags" :key="tag" class="tag">{{ tag }}</span>
          </div>
          <div class="card-link">
            View Documentation
            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14"/><path d="m12 5 7 7-7 7"/></svg>
          </div>
        </a>
      </div>
    </div>
  </section>
</template>

<style scoped>
.resources-section {
  padding: 64px 24px;
  max-width: 1152px;
  margin: 0 auto;
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
  max-width: 560px;
  margin: 0 auto;
  line-height: 1.6;
}

.resource-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
}

.resource-card {
  position: relative;
  display: flex;
  flex-direction: column;
  padding: 28px;
  border-radius: 16px;
  background: var(--vp-c-bg-soft);
  border: 1px solid var(--vp-c-divider);
  text-decoration: none;
  color: inherit;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  overflow: hidden;
}

.resource-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 3px;
  background: var(--icon-color, var(--vp-c-brand-1));
  opacity: 0;
  transition: opacity 0.3s ease;
}

.resource-card:hover {
  border-color: var(--vp-c-brand-1);
  transform: translateY(-4px);
  box-shadow:
    0 12px 40px rgba(0, 0, 0, 0.12),
    0 0 0 1px rgba(148, 221, 12, 0.1);
}

.resource-card:hover::before {
  opacity: 1;
}

.card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16px;
}

.card-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 52px;
  height: 52px;
  border-radius: 14px;
  background: color-mix(in srgb, var(--icon-color) 12%, transparent);
  color: var(--icon-color);
  flex-shrink: 0;
}

.card-version {
  font-size: 12px;
  font-weight: 600;
  color: var(--vp-c-text-3);
  background: var(--vp-c-default-soft);
  padding: 2px 10px;
  border-radius: 100px;
  letter-spacing: 0.02em;
}

.card-title {
  font-size: 20px;
  font-weight: 700;
  margin: 0 0 8px;
  letter-spacing: -0.01em;
  color: var(--vp-c-text-1);
}

.card-desc {
  font-size: 14px;
  color: var(--vp-c-text-2);
  line-height: 1.6;
  margin: 0 0 16px;
  flex: 1;
}

.card-tags {
  display: flex;
  gap: 6px;
  flex-wrap: wrap;
  margin-bottom: 16px;
}

.tag {
  font-size: 11px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  padding: 3px 10px;
  border-radius: 6px;
  background: var(--vp-c-default-soft);
  color: var(--vp-c-text-2);
}

.card-link {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 14px;
  font-weight: 600;
  color: var(--vp-c-brand-1);
  margin-top: auto;
}

.resource-card:hover .card-link svg {
  transform: translateX(4px);
}

.card-link svg {
  transition: transform 0.2s ease;
}

@media (max-width: 960px) {
  .resource-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 640px) {
  .resources-section {
    padding: 48px 16px;
  }
  .resource-grid {
    grid-template-columns: 1fr;
  }
  .section-title {
    font-size: 28px;
  }
}
</style>
