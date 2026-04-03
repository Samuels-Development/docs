<script setup>
import { ref, onMounted } from 'vue'

const props = defineProps({
  repo: { type: String, required: true },
  fallback: { type: String, default: '' },
})

const version = ref(props.fallback)

onMounted(async () => {
  try {
    const res = await fetch(`https://api.github.com/repos/sd-versions/${props.repo}/tags`)
    if (res.ok) {
      const tags = await res.json()
      if (tags.length > 0) {
        version.value = tags[0].name
      }
    }
  } catch {
    // keep fallback
  }
})
</script>

<template>
  <Badge v-if="version" type="tip" :text="'v' + version" />
</template>
