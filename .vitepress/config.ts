import { defineConfig } from 'vitepress'

const globalSidebar = [
  {
    text: 'Getting Started',
    items: [
      { text: 'Getting Started', link: '/' },
    ],
  },
  {
    text: 'Resources',
    items: [
      {
        text: 'Shops Pro',
        collapsed: true,
        items: [
          { text: 'Overview', link: '/resources/shops/' },
          { text: 'Installation', link: '/resources/shops/installation' },
          {
            text: 'Configuration',
            collapsed: true,
            items: [
              { text: 'Main Config', link: '/resources/shops/config-main' },
              { text: 'Shops', link: '/resources/shops/config-shops' },
              { text: 'Management', link: '/resources/shops/config-management' },
              { text: 'Fallbacks', link: '/resources/shops/config-fallbacks' },
              { text: 'Theme', link: '/resources/shops/config-theme' },
            ],
          },
          {
            text: 'Full Config Files',
            collapsed: true,
            items: [
              { text: 'config.lua', link: '/resources/shops/full-config' },
              { text: 'shops.lua', link: '/resources/shops/full-config-shops' },
              { text: 'management.lua', link: '/resources/shops/full-config-management' },
              { text: 'fallbacks.lua', link: '/resources/shops/full-config-fallbacks' },
              { text: 'theme.lua', link: '/resources/shops/full-config-theme' },
              { text: 'logs.lua', link: '/resources/shops/full-config-logs' },
            ],
          },
          {
            text: 'Hooks',
            collapsed: true,
            items: [
              { text: 'Client Hooks', link: '/resources/shops/hooks-client' },
              { text: 'Server Hooks', link: '/resources/shops/hooks-server' },
            ],
          },
        ],
      },
      {
        text: 'Horde Mission',
        collapsed: true,
        items: [
          { text: 'Overview', link: '/resources/horde/' },
          { text: 'Installation', link: '/resources/horde/installation' },
          { text: 'Configuration', link: '/resources/horde/configuration' },
          {
            text: 'Maps',
            collapsed: true,
            items: [
              { text: 'Server Farm', link: '/resources/horde/maps-server-farm' },
              { text: 'Cayo Estate', link: '/resources/horde/maps-cayo-estate' },
              { text: 'Doomsday Bunker', link: '/resources/horde/maps-doomsday-bunker' },
              { text: 'Gunrunning Bunker', link: '/resources/horde/maps-gunrunning-bunker' },
            ],
          },
          {
            text: 'Full Config Files',
            collapsed: true,
            items: [
              { text: 'config.lua', link: '/resources/horde/full-config' },
              { text: 'logs.lua', link: '/resources/horde/full-config-logs' },
              { text: 'server_farm.lua', link: '/resources/horde/full-config-map-server-farm' },
              { text: 'cayo_estate.lua', link: '/resources/horde/full-config-map-cayo-estate' },
              { text: 'doomsday_bunker.lua', link: '/resources/horde/full-config-map-doomsday-bunker' },
              { text: 'gunrunning_bunker.lua', link: '/resources/horde/full-config-map-gunrunning-bunker' },
            ],
          },
          { text: 'Exports', link: '/resources/horde/exports' },
          { text: 'Creating New Maps', link: '/resources/horde/creating-maps' },
        ],
      },
      {
        text: 'Advanced Crafting',
        collapsed: true,
        items: [
          { text: 'Overview', link: '/resources/crafting/' },
          { text: 'Installation', link: '/resources/crafting/installation' },
          {
            text: 'Configuration',
            collapsed: true,
            items: [
              { text: 'Main Config', link: '/resources/crafting/config-main' },
              { text: 'Recipes', link: '/resources/crafting/config-recipes' },
              { text: 'Tech Trees', link: '/resources/crafting/config-techtrees' },
            ],
          },
          {
            text: 'Full Config Files',
            collapsed: true,
            items: [
              { text: 'config.lua', link: '/resources/crafting/full-config' },
              { text: 'recipes.lua', link: '/resources/crafting/full-config-recipes' },
              { text: 'techtrees.lua', link: '/resources/crafting/full-config-techtrees' },
              { text: 'logs.lua', link: '/resources/crafting/full-config-logs' },
            ],
          },
          { text: 'Blueprint Image Creator', link: '/resources/crafting/blueprint-creator' },
          { text: 'Placeable Workbenches', link: '/resources/crafting/placeable-workbenches' },
        ],
      },
      {
        text: 'Dumpster Diving',
        collapsed: true,
        items: [
          { text: 'Overview', link: '/resources/dumpsters/' },
          { text: 'Installation', link: '/resources/dumpsters/installation' },
          { text: 'Configuration', link: '/resources/dumpsters/configuration' },
          {
            text: 'Full Config Files',
            collapsed: true,
            items: [
              { text: 'config.lua', link: '/resources/dumpsters/full-config' },
              { text: 'rats.lua', link: '/resources/dumpsters/full-config-rats' },
              { text: 'recycler.lua', link: '/resources/dumpsters/full-config-recycler' },
            ],
          },
          { text: 'Rat Companions', link: '/resources/dumpsters/rat-companions' },
          { text: 'Recycler System', link: '/resources/dumpsters/recycler' },
          { text: 'Common Issues', link: '/resources/dumpsters/common-issues' },
        ],
      },
      {
        text: 'Beekeeping',
        collapsed: true,
        items: [
          { text: 'Overview', link: '/resources/beekeeping/' },
          { text: 'Installation', link: '/resources/beekeeping/installation' },
          { text: 'Configuration', link: '/resources/beekeeping/configuration' },
          { text: 'Full Config', link: '/resources/beekeeping/full-config' },
          { text: 'Common Issues', link: '/resources/beekeeping/common-issues' },
        ],
      },
      {
        text: 'Bobcat Security Heist',
        collapsed: true,
        items: [
          { text: 'Overview', link: '/resources/bobcat/' },
          { text: 'Installation', link: '/resources/bobcat/installation' },
          { text: 'Configuration', link: '/resources/bobcat/configuration' },
          {
            text: 'Full Config Files',
            collapsed: true,
            items: [
              { text: 'config.lua', link: '/resources/bobcat/full-config' },
            ],
          },
        ],
      },
      {
        text: 'Coke Mission',
        collapsed: true,
        items: [
          { text: 'Overview', link: '/resources/cokemission/' },
          { text: 'Installation', link: '/resources/cokemission/installation' },
          { text: 'Configuration', link: '/resources/cokemission/configuration' },
          {
            text: 'Full Config Files',
            collapsed: true,
            items: [
              { text: 'config.lua', link: '/resources/cokemission/full-config' },
            ],
          },
        ],
      },
      {
        text: 'Corner Selling',
        collapsed: true,
        items: [
          { text: 'Overview', link: '/resources/selling/' },
          { text: 'Installation', link: '/resources/selling/installation' },
          { text: 'Configuration', link: '/resources/selling/configuration' },
          {
            text: 'Full Config Files',
            collapsed: true,
            items: [
              { text: 'config.lua', link: '/resources/selling/full-config' },
              { text: 'logs.lua', link: '/resources/selling/full-config-logs' },
            ],
          },
        ],
      },
      {
        text: 'Multi-Job',
        collapsed: true,
        items: [
          { text: 'Overview', link: '/resources/multijob/' },
          { text: 'Installation', link: '/resources/multijob/installation' },
          { text: 'Configuration', link: '/resources/multijob/configuration' },
          {
            text: 'Full Config Files',
            collapsed: true,
            items: [
              { text: 'config.lua', link: '/resources/multijob/full-config' },
              { text: 'logs.lua', link: '/resources/multijob/full-config-logs' },
            ],
          },
        ],
      },
      {
        text: 'Oxy Run',
        collapsed: true,
        items: [
          { text: 'Overview', link: '/resources/oxyrun/' },
          { text: 'Installation', link: '/resources/oxyrun/installation' },
          { text: 'Configuration', link: '/resources/oxyrun/configuration' },
          {
            text: 'Full Config Files',
            collapsed: true,
            items: [
              { text: 'config.lua', link: '/resources/oxyrun/full-config' },
            ],
          },
        ],
      },
      {
        text: 'Pacific Bank Heist',
        collapsed: true,
        items: [
          { text: 'Overview', link: '/resources/pacificbank/' },
          { text: 'Installation', link: '/resources/pacificbank/installation' },
          { text: 'Configuration', link: '/resources/pacificbank/configuration' },
          {
            text: 'Full Config Files',
            collapsed: true,
            items: [
              { text: 'config.lua', link: '/resources/pacificbank/full-config' },
              { text: 'logs.lua', link: '/resources/pacificbank/full-config-logs' },
            ],
          },
        ],
      },
      {
        text: 'Traphouse Robbery',
        collapsed: true,
        items: [
          { text: 'Overview', link: '/resources/traphouse/' },
          { text: 'Installation', link: '/resources/traphouse/installation' },
          { text: 'Configuration', link: '/resources/traphouse/configuration' },
          {
            text: 'Full Config Files',
            collapsed: true,
            items: [
              { text: 'config.lua', link: '/resources/traphouse/full-config' },
              { text: 'logs.lua', link: '/resources/traphouse/full-config-logs' },
            ],
          },
        ],
      },
      {
        text: 'Warehouse Heist',
        collapsed: true,
        items: [
          { text: 'Overview', link: '/resources/warehouse/' },
          { text: 'Installation', link: '/resources/warehouse/installation' },
          { text: 'Configuration', link: '/resources/warehouse/configuration' },
          {
            text: 'Full Config Files',
            collapsed: true,
            items: [
              { text: 'config.lua', link: '/resources/warehouse/full-config' },
            ],
          },
        ],
      },
      {
        text: 'Yacht Heist',
        collapsed: true,
        items: [
          { text: 'Overview', link: '/resources/yacht/' },
          { text: 'Installation', link: '/resources/yacht/installation' },
          { text: 'Configuration', link: '/resources/yacht/configuration' },
          {
            text: 'Full Config Files',
            collapsed: true,
            items: [
              { text: 'config.lua', link: '/resources/yacht/full-config' },
            ],
          },
        ],
      },
    ],
  },
  {
    text: 'FAQ',
    items: [
      { text: 'General FAQ', link: '/faq/' },
      { text: 'Changing Locales', link: '/faq/changing-locales' },
      { text: 'Adding Police Alerts', link: '/faq/police-alerts' },
      { text: 'Dirty Money Types', link: '/faq/dirty-money' },
    ],
  },
]

export default defineConfig({
  title: "Samuel's Development",
  description: 'Documentation for FiveM scripts by Samuel\'s Development',
  lang: 'en-US',

  head: [
    ['link', { rel: 'icon', type: 'image/png', href: '/logo.png' }],
    ['meta', { name: 'theme-color', content: '#94DD0C' }],
    ['meta', { property: 'og:type', content: 'website' }],
    ['meta', { property: 'og:title', content: "Samuel's Development — Docs" }],
    ['meta', { property: 'og:description', content: 'Documentation for premium FiveM scripts' }],
  ],

  themeConfig: {
    logo: '/logo.png',
    siteTitle: "Samuel's Development",

    nav: [
      { text: 'Home', link: '/' },
      { text: 'Store', link: 'https://fivem.samueldev.shop' },
      { text: 'Discord', link: 'https://discord.gg/Tu94MCDDEa' },
    ],

    sidebar: globalSidebar,

    socialLinks: [
      { icon: 'discord', link: 'https://discord.gg/Tu94MCDDEa' },
      { icon: 'github', link: 'https://github.com/samuelsdevelopment' },
      {
        icon: {
          svg: '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M6 9l6 6 6-6"/></svg>',
        },
        link: 'https://fivem.samueldev.shop',
        ariaLabel: 'Store',
      },
    ],

    footer: {
      message: 'Scripts sold exclusively on <a href="https://fivem.samueldev.shop">fivem.samueldev.shop</a>',
      copyright: "Copyright &copy; 2024-2026 Samuel's Development",
    },

    search: {
      provider: 'local',
    },

    editLink: {
      pattern: 'https://github.com/samuelsdevelopment/docs/edit/main/:path',
      text: 'Suggest changes to this page',
    },

    outline: {
      level: [2, 3],
    },
  },
})
