import { defineConfig } from 'vitepress'

const globalSidebar = [
  {
    items: [
      { text: 'Getting Started', link: '/' },
    ],
  },
  {
    text: 'Economy & Jobs',
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
            text: 'Exports',
            collapsed: true,
            items: [
              { text: 'Client Exports', link: '/resources/shops/exports-client' },
              { text: 'Server Exports', link: '/resources/shops/exports-server' },
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
          {
            text: 'Hooks',
            collapsed: true,
            items: [
              { text: 'Client Hooks', link: '/resources/crafting/hooks-client' },
              { text: 'Server Hooks', link: '/resources/crafting/hooks-server' },
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
        ],
      },
      {
        text: 'Multijob & Boss Menu',
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
    ],
  },
  {
    text: 'Heists',
    items: [
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
      {
        text: 'Oil Rig Heist',
        collapsed: true,
        items: [
          { text: 'Overview', link: '/resources/oilrig/' },
          { text: 'Installation', link: '/resources/oilrig/installation' },
          { text: 'Configuration', link: '/resources/oilrig/configuration' },
          {
            text: 'Full Config Files',
            collapsed: true,
            items: [
              { text: 'config.lua', link: '/resources/oilrig/full-config' },
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
    ],
  },
  {
    text: 'Crime & Missions',
    items: [
      {
        text: 'Petty Crimes',
        collapsed: true,
        items: [
          { text: 'Overview', link: '/resources/pettycrime/' },
          { text: 'Installation', link: '/resources/pettycrime/installation' },
          { text: 'Configuration', link: '/resources/pettycrime/configuration' },
          { text: 'Minigames', link: '/resources/pettycrime/minigames' },
          {
            text: 'Full Config Files',
            collapsed: true,
            items: [
              { text: 'config.lua', link: '/resources/pettycrime/full-config' },
              { text: 'mailbox.lua', link: '/resources/pettycrime/full-config-mailbox' },
              { text: 'payphone.lua', link: '/resources/pettycrime/full-config-payphone' },
              { text: 'parkingmeter.lua', link: '/resources/pettycrime/full-config-parkingmeter' },
              { text: 'newsrack.lua', link: '/resources/pettycrime/full-config-newsrack' },
              { text: 'vending.lua', link: '/resources/pettycrime/full-config-vending' },
              { text: 'signrob.lua', link: '/resources/pettycrime/full-config-signrob' },
              { text: 'pickpocket.lua', link: '/resources/pettycrime/full-config-pickpocket' },
              { text: 'robaped.lua', link: '/resources/pettycrime/full-config-robaped' },
              { text: 'shoplift.lua', link: '/resources/pettycrime/full-config-shoplift' },
              { text: 'catalytic.lua', link: '/resources/pettycrime/full-config-catalytic' },
              { text: 'tiretheft.lua', link: '/resources/pettycrime/full-config-tiretheft' },
              { text: 'wheelloose.lua', link: '/resources/pettycrime/full-config-wheelloose' },
              { text: 'tireslash.lua', link: '/resources/pettycrime/full-config-tireslash' },
              { text: 'brakecut.lua', link: '/resources/pettycrime/full-config-brakecut' },
              { text: 'fuelsabotage.lua', link: '/resources/pettycrime/full-config-fuelsabotage' },
              { text: 'brickgas.lua', link: '/resources/pettycrime/full-config-brickgas' },
              { text: 'smashgrab.lua', link: '/resources/pettycrime/full-config-smashgrab' },
              { text: 'acstrip.lua', link: '/resources/pettycrime/full-config-acstrip' },
              { text: 'atmskimmer.lua', link: '/resources/pettycrime/full-config-atmskimmer' },
              { text: 'parceltheft.lua', link: '/resources/pettycrime/full-config-parceltheft' },
              { text: 'speedbomb.lua', link: '/resources/pettycrime/full-config-speedbomb' },
              { text: 'cardoor.lua', link: '/resources/pettycrime/full-config-cardoor' },
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
          {
            text: 'Exports',
            collapsed: true,
            items: [
              { text: 'Client Exports', link: '/resources/horde/exports-client' },
              { text: 'Server Exports', link: '/resources/horde/exports-server' },
            ],
          },
          { text: 'Creating New Maps', link: '/resources/horde/creating-maps' },
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
        text: 'Vehicle Hacking Device',
        collapsed: true,
        items: [
          { text: 'Overview', link: '/resources/vehhack/' },
          { text: 'Installation', link: '/resources/vehhack/installation' },
          { text: 'Configuration', link: '/resources/vehhack/configuration' },
          {
            text: 'Full Config Files',
            collapsed: true,
            items: [
              { text: 'config.lua', link: '/resources/vehhack/full-config' },
              { text: 'hacks.lua', link: '/resources/vehhack/full-config-hacks' },
              { text: 'logs.lua', link: '/resources/vehhack/full-config-logs' },
            ],
          },
        ],
      },
    ],
  },
  {
    text: 'Phone',
    items: [
      {
        text: 'Phone',
        collapsed: true,
        items: [
          { text: 'Overview', link: '/resources/phone/' },
          { text: 'Installation', link: '/resources/phone/installation' },
          { text: 'Configuration', link: '/resources/phone/configuration' },
          { text: 'Custom Apps', link: '/resources/phone/custom-apps' },
          {
            text: 'Exports',
            collapsed: true,
            items: [
              { text: 'Client Exports', link: '/resources/phone/exports-client' },
              { text: 'Server Exports', link: '/resources/phone/exports-server' },
            ],
          },
          {
            text: 'Events',
            collapsed: true,
            items: [
              { text: 'Client Events', link: '/resources/phone/events-client' },
              { text: 'Server Events', link: '/resources/phone/events-server' },
            ],
          },
          { text: 'lb-phone Compatibility', link: '/resources/phone/lb-phone-compatibility' },
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
  cleanUrls: true,

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
    ],

    sidebar: globalSidebar,

    socialLinks: [
      { icon: 'discord', link: 'https://discord.gg/FzPehMQaBQ' },
      { icon: 'github', link: 'https://github.com/Samuels-Development' },
    ],

    footer: {
      message: 'Scripts sold exclusively on <a href="https://fivem.samueldev.shop">fivem.samueldev.shop</a>',
      copyright: "Copyright &copy; 2024-2026 Samuel's Development",
    },

    search: {
      provider: 'local',
    },

    editLink: {
      pattern: 'https://github.com/Samuels-Development/docs/edit/master/:path',
      text: 'Suggest changes to this page',
    },

    outline: {
      level: [2, 3],
    },
  },
})
