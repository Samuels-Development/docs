import DefaultTheme from 'vitepress/theme'
import HomeLayout from './components/HomeLayout.vue'
import YouTubeEmbed from './components/YouTubeEmbed.vue'
import ItemImageGrid from './components/ItemImageGrid.vue'
import VersionBadge from './components/VersionBadge.vue'
import HomeResources from './components/HomeResources.vue'
import HomeQuickStart from './components/HomeQuickStart.vue'
import HomeStats from './components/HomeStats.vue'
import HomeSupport from './components/HomeSupport.vue'
import './custom.css'

export default {
  extends: DefaultTheme,
  Layout: HomeLayout,
  enhanceApp({ app }) {
    app.component('YouTubeEmbed', YouTubeEmbed)
    app.component('ItemImageGrid', ItemImageGrid)
    app.component('VersionBadge', VersionBadge)
    app.component('HomeResources', HomeResources)
    app.component('HomeQuickStart', HomeQuickStart)
    app.component('HomeStats', HomeStats)
    app.component('HomeSupport', HomeSupport)
  },
}
