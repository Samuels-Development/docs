import DefaultTheme from 'vitepress/theme'
import HomeLayout from './components/HomeLayout.vue'
import YouTubeEmbed from './components/YouTubeEmbed.vue'
import ItemImageGrid from './components/ItemImageGrid.vue'
import VersionBadge from './components/VersionBadge.vue'
import './custom.css'

export default {
  extends: DefaultTheme,
  Layout: HomeLayout,
  enhanceApp({ app }) {
    app.component('YouTubeEmbed', YouTubeEmbed)
    app.component('ItemImageGrid', ItemImageGrid)
    app.component('VersionBadge', VersionBadge)
  },
}
