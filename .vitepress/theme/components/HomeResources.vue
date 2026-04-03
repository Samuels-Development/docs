<script setup>
import { ref } from 'vue'

const activeFilter = ref('all')

const resources = [
  {
    title: 'Shops Pro',
    version: 'v1.1.0',
    description: 'Full economy system with shop ownership, employees, stock management, loyalty programs, coupons, weapon serials, and 5 shop types.',
    link: '/resources/shops/',
    icon: 'shop',
    category: 'economy',
    tags: ['Economy', 'Management', 'UI'],
    color: '#94DD0C',
    featured: true,
  },
  {
    title: 'Horde Mission',
    version: 'v1.1.4',
    description: 'Wave-based survival with 4 maps, group play, 20-level progression, mystery box, radio sync, and rejoin system.',
    link: '/resources/horde/',
    icon: 'sword',
    category: 'combat',
    tags: ['Combat', 'Multiplayer', 'PvE'],
    color: '#FF6B6B',
    featured: true,
  },
  {
    title: 'Advanced Crafting',
    version: 'v1.1.5',
    description: 'Workbenches, recipes, blueprints, tech trees, tool durability, persistent queues, and a full leveling system.',
    link: '/resources/crafting/',
    icon: 'hammer',
    category: 'economy',
    tags: ['Crafting', 'Progression', 'UI'],
    color: '#4ECDC4',
    featured: true,
  },
  {
    title: 'Dumpster Diving',
    version: 'v1.3.3',
    description: 'Loot dumpsters, befriend rat companions with perks, run expeditions, trade with the Hobo King, and recycle scrap.',
    link: '/resources/dumpsters/',
    icon: 'recycle',
    category: 'economy',
    tags: ['Survival', 'Companions', 'Economy'],
    color: '#FFE66D',
    featured: true,
  },
  {
    title: 'Beekeeping',
    version: 'v1.3.1',
    description: 'Manage hives, produce 3 honey types, handle infections and aggression, protect with gear, and collaborate with players.',
    link: '/resources/beekeeping/',
    icon: 'bee',
    category: 'economy',
    tags: ['Farming', 'Production', 'Coop'],
    color: '#F7B731',
    featured: true,
  },
  {
    title: 'Bobcat Security Heist',
    version: 'v1.0.0',
    description: 'Multi-stage heist on the Bobcat Security facility with minigames, loot tables, and police alert integration.',
    link: '/resources/bobcat/',
    icon: 'shield',
    category: 'heist',
    tags: ['Heist', 'Combat', 'PvE'],
    color: '#A78BFA',
  },
  {
    title: 'Pacific Bank Heist',
    version: 'v1.0.0',
    description: 'Rob the Pacific Standard Bank with thermite, hacking, vault drilling, and configurable police response.',
    link: '/resources/pacificbank/',
    icon: 'bank',
    category: 'heist',
    tags: ['Heist', 'Combat', 'PvE'],
    color: '#60A5FA',
  },
  {
    title: 'Warehouse Heist',
    version: 'v1.0.0',
    description: 'Break into warehouses with lockpicking, hacking, and loot crates. Configurable difficulty and rewards.',
    link: '/resources/warehouse/',
    icon: 'warehouse',
    category: 'heist',
    tags: ['Heist', 'Stealth'],
    color: '#F472B6',
  },
  {
    title: 'Yacht Heist',
    version: 'v1.0.0',
    description: 'Board and rob the luxury yacht with multiple entry points, guard NPCs, and tiered loot.',
    link: '/resources/yacht/',
    icon: 'anchor',
    category: 'heist',
    tags: ['Heist', 'Combat'],
    color: '#38BDF8',
  },
  {
    title: 'Traphouse Robbery',
    version: 'v1.0.0',
    description: 'Raid traphouses with minigames, NPC guards, loot tables, and configurable cooldowns.',
    link: '/resources/traphouse/',
    icon: 'home',
    category: 'heist',
    tags: ['Heist', 'Combat'],
    color: '#FB923C',
  },
  {
    title: 'Coke Mission',
    version: 'v1.0.0',
    description: 'Multi-step cocaine processing mission with delivery routes, police alerts, and risk/reward mechanics.',
    link: '/resources/cokemission/',
    icon: 'package',
    category: 'crime',
    tags: ['Crime', 'Delivery'],
    color: '#E879F9',
  },
  {
    title: 'Corner Selling',
    version: 'v1.0.0',
    description: 'Sell items to street NPCs with dynamic pricing, police risk, turf zones, and reputation system.',
    link: '/resources/selling/',
    icon: 'map-pin',
    category: 'crime',
    tags: ['Crime', 'Economy'],
    color: '#34D399',
  },
  {
    title: 'Oxy Run',
    version: 'v1.0.0',
    description: 'Deliver oxy to NPCs across the map with randomized routes, police alerts, and configurable rewards.',
    link: '/resources/oxyrun/',
    icon: 'truck',
    category: 'crime',
    tags: ['Crime', 'Delivery'],
    color: '#F87171',
  },
  {
    title: 'Multi-Job',
    version: 'v1.0.0',
    description: 'Allow players to hold multiple jobs simultaneously with configurable limits and priority system.',
    link: '/resources/multijob/',
    icon: 'briefcase',
    category: 'economy',
    tags: ['Jobs', 'Utility'],
    color: '#818CF8',
  },
]

const filters = [
  { key: 'all', label: 'All Scripts' },
  { key: 'economy', label: 'Economy' },
  { key: 'heist', label: 'Heists' },
  { key: 'crime', label: 'Crime' },
  { key: 'combat', label: 'Combat' },
]

const filteredResources = () => {
  if (activeFilter.value === 'all') return resources
  return resources.filter(r => r.category === activeFilter.value)
}
</script>

<template>
  <section class="resources-section">
    <div class="container">
      <div class="section-header">
        <span class="section-badge">Resources</span>
        <h2 class="section-title">Our Scripts</h2>
        <p class="section-desc">14 premium scripts with auto-detection for QBCore, QBox, and ESX. Auto-database setup and multi-language support included.</p>
      </div>

      <div class="filter-bar">
        <button
          v-for="filter in filters"
          :key="filter.key"
          :class="['filter-btn', { active: activeFilter === filter.key }]"
          @click="activeFilter = filter.key"
        >
          {{ filter.label }}
        </button>
      </div>

      <div class="resource-grid">
        <a
          v-for="resource in filteredResources()"
          :key="resource.title"
          :href="resource.link"
          :class="['resource-card', { featured: resource.featured }]"
          :style="{ '--card-color': resource.color }"
        >
          <div class="card-glow"></div>
          <div class="card-header">
            <div class="card-icon">
              <!-- Shop -->
              <svg v-if="resource.icon === 'shop'" xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="m2 7 4.41-4.41A2 2 0 0 1 7.83 2h8.34a2 2 0 0 1 1.42.59L22 7"/><path d="M4 12v8a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-8"/><path d="M15 22v-4a2 2 0 0 0-2-2h-2a2 2 0 0 0-2 2v4"/><path d="M2 7h20"/><path d="M22 7v3a2 2 0 0 1-2 2a2.7 2.7 0 0 1-1.59-.63.7.7 0 0 0-.82 0A2.7 2.7 0 0 1 16 12a2.7 2.7 0 0 1-1.59-.63.7.7 0 0 0-.82 0A2.7 2.7 0 0 1 12 12a2.7 2.7 0 0 1-1.59-.63.7.7 0 0 0-.82 0A2.7 2.7 0 0 1 8 12a2.7 2.7 0 0 1-1.59-.63.7.7 0 0 0-.82 0A2.7 2.7 0 0 1 4 12a2 2 0 0 1-2-2V7"/></svg>
              <!-- Sword -->
              <svg v-if="resource.icon === 'sword'" xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="14.5 17.5 3 6 3 3 6 3 17.5 14.5"/><line x1="13" x2="19" y1="19" y2="13"/><line x1="16" x2="20" y1="16" y2="20"/><line x1="19" x2="21" y1="21" y2="19"/></svg>
              <!-- Hammer -->
              <svg v-if="resource.icon === 'hammer'" xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="m15 12-8.5 8.5c-.83.83-2.17.83-3 0 0 0 0 0 0 0a2.12 2.12 0 0 1 0-3L12 9"/><path d="M17.64 15 22 10.64"/><path d="m20.91 11.7-1.25-1.25c-.6-.6-.93-1.4-.93-2.25v-.86L16.01 4.6a5.56 5.56 0 0 0-3.94-1.64H9l.92.82A6.18 6.18 0 0 1 12 8.4v1.56l2 2h2.47l2.26 1.91"/></svg>
              <!-- Recycle -->
              <svg v-if="resource.icon === 'recycle'" xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M7 19H4.815a1.83 1.83 0 0 1-1.57-.881 1.785 1.785 0 0 1-.004-1.784L7.196 9.5"/><path d="M11 19h8.203a1.83 1.83 0 0 0 1.556-.89 1.784 1.784 0 0 0 0-1.775l-1.226-2.12"/><path d="m14 16-3 3 3 3"/><path d="M8.293 13.596 7.196 9.5 3.1 10.598"/><path d="m9.344 5.811 1.093-1.892A1.83 1.83 0 0 1 11.985 3a1.784 1.784 0 0 1 1.546.888l3.943 6.843"/><path d="m13.378 9.633 4.096 1.098 1.097-4.096"/></svg>
              <!-- Bee -->
              <svg v-if="resource.icon === 'bee'" xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M12 12a5 5 0 0 0-5 5c0 2.76 2.24 5 5 5s5-2.24 5-5a5 5 0 0 0-5-5z"/><path d="M12 2v4"/><path d="M9 6h6"/><path d="M7 10h10"/><path d="M9 14h6"/><path d="m8 22 1-5"/><path d="m16 22-1-5"/></svg>
              <!-- Shield -->
              <svg v-if="resource.icon === 'shield'" xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z"/></svg>
              <!-- Bank -->
              <svg v-if="resource.icon === 'bank'" xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><line x1="3" x2="21" y1="22" y2="22"/><line x1="6" x2="6" y1="18" y2="11"/><line x1="10" x2="10" y1="18" y2="11"/><line x1="14" x2="14" y1="18" y2="11"/><line x1="18" x2="18" y1="18" y2="11"/><polygon points="12 2 20 7 4 7"/></svg>
              <!-- Warehouse -->
              <svg v-if="resource.icon === 'warehouse'" xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M22 8.35V20a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V8.35A2 2 0 0 1 3.26 6.5l8-3.2a2 2 0 0 1 1.48 0l8 3.2A2 2 0 0 1 22 8.35Z"/><path d="M6 18h12"/><path d="M6 14h12"/><rect width="12" height="12" x="6" y="10"/></svg>
              <!-- Anchor -->
              <svg v-if="resource.icon === 'anchor'" xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22V8"/><path d="M5 12H2a10 10 0 0 0 20 0h-3"/><circle cx="12" cy="5" r="3"/></svg>
              <!-- Home -->
              <svg v-if="resource.icon === 'home'" xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M15 21v-8a1 1 0 0 0-1-1h-4a1 1 0 0 0-1 1v8"/><path d="M3 10a2 2 0 0 1 .709-1.528l7-5.999a2 2 0 0 1 2.582 0l7 5.999A2 2 0 0 1 21 10v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/></svg>
              <!-- Package -->
              <svg v-if="resource.icon === 'package'" xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="m7.5 4.27 9 5.15"/><path d="M21 8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16Z"/><path d="m3.3 7 8.7 5 8.7-5"/><path d="M12 22V12"/></svg>
              <!-- Map Pin -->
              <svg v-if="resource.icon === 'map-pin'" xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M20 10c0 4.993-5.539 10.193-7.399 11.799a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 16 0"/><circle cx="12" cy="10" r="3"/></svg>
              <!-- Truck -->
              <svg v-if="resource.icon === 'truck'" xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M14 18V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v11a1 1 0 0 0 1 1h2"/><path d="M15 18h2a1 1 0 0 0 1-1v-3.65a1 1 0 0 0-.22-.624l-3.48-4.35A1 1 0 0 0 13.52 8H14"/><circle cx="17" cy="18" r="2"/><circle cx="7" cy="18" r="2"/></svg>
              <!-- Briefcase -->
              <svg v-if="resource.icon === 'briefcase'" xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M16 20V4a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/><rect width="20" height="14" x="2" y="6" rx="2"/></svg>
            </div>
            <div class="card-badges">
              <span v-if="resource.featured" class="badge featured-badge">Featured</span>
              <span class="card-version">{{ resource.version }}</span>
            </div>
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
  padding: 48px 0 32px;
  max-width: 100%;
}

.container {
  width: 100%;
}

.section-header {
  text-align: center;
  margin-bottom: 32px;
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
  max-width: 600px;
  margin: 0 auto;
  line-height: 1.6;
}

/* Filter bar */
.filter-bar {
  display: flex;
  justify-content: center;
  gap: 8px;
  margin-bottom: 36px;
  flex-wrap: wrap;
}

.filter-btn {
  padding: 8px 20px;
  border-radius: 100px;
  font-size: 13px;
  font-weight: 600;
  border: 1px solid var(--vp-c-divider);
  background: var(--vp-c-bg-soft);
  color: var(--vp-c-text-2);
  cursor: pointer;
  transition: all 0.2s ease;
}

.filter-btn:hover {
  border-color: var(--vp-c-brand-1);
  color: var(--vp-c-text-1);
}

.filter-btn.active {
  background: var(--vp-c-brand-1);
  border-color: var(--vp-c-brand-1);
  color: #0f1014;
}

/* Grid */
.resource-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
}

.resource-card {
  --card-color: var(--vp-c-brand-1);
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

.card-glow {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 3px;
  background: var(--card-color);
  opacity: 0;
  transition: opacity 0.3s ease;
}

.resource-card:hover {
  border-color: color-mix(in srgb, var(--card-color) 50%, transparent);
  transform: translateY(-4px);
  box-shadow:
    0 12px 40px rgba(0, 0, 0, 0.15),
    0 0 0 1px color-mix(in srgb, var(--card-color) 10%, transparent);
}

.resource-card:hover .card-glow {
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
  background: color-mix(in srgb, var(--card-color) 12%, transparent);
  color: var(--card-color);
  flex-shrink: 0;
}

.card-badges {
  display: flex;
  align-items: center;
  gap: 8px;
}

.featured-badge {
  font-size: 10px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  padding: 3px 8px;
  border-radius: 6px;
  background: var(--vp-c-brand-soft);
  color: var(--vp-c-brand-1);
  border: 1px solid rgba(148, 221, 12, 0.2);
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
    grid-template-columns: 1fr;
  }
}

@media (max-width: 640px) {
  .resources-section {
    padding: 32px 0 24px;
  }
  .resource-grid {
    grid-template-columns: 1fr;
  }
  .section-title {
    font-size: 28px;
  }
  .filter-bar {
    gap: 6px;
  }
  .filter-btn {
    padding: 6px 14px;
    font-size: 12px;
  }
}
</style>
