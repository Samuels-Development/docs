<script setup>
import DefaultTheme from 'vitepress/theme'
import { useData } from 'vitepress'
import { computed } from 'vue'
import ComingSoon from './ComingSoon.vue'

const { Layout } = DefaultTheme
const { frontmatter, page } = useData()

const showComingSoon = computed(() => frontmatter.value.pageClass === 'coming-soon')
const comingSoonTitle = computed(() => frontmatter.value.comingSoonTitle || 'Vehicle Hacking Device')
</script>

<template>
  <Layout />
  <ComingSoon v-if="showComingSoon" :title="comingSoonTitle" />
</template>
