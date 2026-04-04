<script setup>
import { ref, computed } from 'vue'
import JSZip from 'jszip'

const props = defineProps({
  images: {
    type: Array,
    required: true,
  },
  title: {
    type: String,
    default: 'Item Images',
  },
  zipName: {
    type: String,
    default: 'item-images',
  },
})

const totalSize = computed(() => props.images.length)
const zipping = ref(false)

function downloadImage(src, name) {
  const a = document.createElement('a')
  a.href = src
  a.download = name
  document.body.appendChild(a)
  a.click()
  document.body.removeChild(a)
}

async function downloadAll() {
  zipping.value = true
  try {
    const zip = new JSZip()
    const fetches = props.images.map(async (img) => {
      const res = await fetch(img.src)
      const blob = await res.blob()
      zip.file(img.name, blob)
    })
    await Promise.all(fetches)
    const content = await zip.generateAsync({ type: 'blob' })
    const url = URL.createObjectURL(content)
    const a = document.createElement('a')
    a.href = url
    a.download = `${props.zipName}.zip`
    document.body.appendChild(a)
    a.click()
    document.body.removeChild(a)
    URL.revokeObjectURL(url)
  } finally {
    zipping.value = false
  }
}
</script>

<template>
  <div class="img-grid-container">
    <div class="img-grid-header">
      <div class="img-grid-title">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="9" cy="9" r="2"/><path d="m21 15-3.086-3.086a2 2 0 0 0-2.828 0L6 21"/></svg>
        <span>{{ title }}</span>
        <span class="img-grid-count">{{ totalSize }} images</span>
      </div>
      <button class="img-grid-download-all" :disabled="zipping" @click="downloadAll">
        <svg v-if="!zipping" xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
        <svg v-else class="img-grid-spinner" xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 12a9 9 0 1 1-6.219-8.56"/></svg>
        {{ zipping ? 'Zipping...' : 'Download .zip' }}
      </button>
    </div>
    <div class="img-grid">
      <div
        v-for="img in images"
        :key="img.name"
        class="img-card"
        @click="downloadImage(img.src, img.name)"
      >
        <div class="img-card-preview">
          <img :src="img.src" :alt="img.alt || img.name" loading="lazy" />
          <div class="img-card-overlay">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
          </div>
        </div>
        <span class="img-card-name">{{ img.name }}</span>
      </div>
    </div>
  </div>
</template>

<style scoped>
.img-grid-container {
  margin: 20px 0;
  border-radius: 12px;
  border: 1px solid rgba(148, 221, 12, 0.15);
  background: linear-gradient(160deg, rgba(148, 221, 12, 0.06), transparent 60%);
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

:global(.dark) .img-grid-container {
  border-color: rgba(148, 221, 12, 0.12);
  background: linear-gradient(160deg, rgba(148, 221, 12, 0.08), transparent 60%);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
}

.img-grid-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 14px 18px;
  border-bottom: 1px solid rgba(148, 221, 12, 0.1);
  background: rgba(148, 221, 12, 0.04);
}

:global(.dark) .img-grid-header {
  background: rgba(148, 221, 12, 0.05);
}

.img-grid-title {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 13px;
  font-weight: 700;
  color: var(--vp-c-text-1);
}

.img-grid-title svg {
  color: var(--vp-c-brand-1);
}

.img-grid-count {
  font-weight: 500;
  color: var(--vp-c-text-3);
  font-size: 12px;
  padding: 2px 8px;
  border-radius: 10px;
  background: var(--vp-c-brand-soft);
}

.img-grid-download-all {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 7px 14px;
  border-radius: 8px;
  border: 1px solid var(--vp-c-brand-1);
  background: var(--vp-c-brand-soft);
  color: var(--vp-c-brand-1);
  font-size: 12px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.25s ease;
}

.img-grid-download-all:hover:not(:disabled) {
  background: rgba(148, 221, 12, 0.25);
  box-shadow: 0 0 12px rgba(148, 221, 12, 0.2);
  transform: translateY(-1px);
}

.img-grid-download-all:disabled {
  opacity: 0.7;
  cursor: wait;
}

.img-grid-spinner {
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

.img-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
  gap: 14px;
  padding: 18px;
}

.img-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  cursor: pointer;
}

.img-card-preview {
  position: relative;
  width: 100%;
  aspect-ratio: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 10px;
  background: var(--vp-c-bg);
  border: 1px solid var(--vp-c-divider);
  overflow: hidden;
  transition: all 0.25s ease;
}

.img-card:hover .img-card-preview {
  border-color: var(--vp-c-brand-1);
  transform: translateY(-3px);
  box-shadow: 0 6px 16px rgba(148, 221, 12, 0.15);
}

:global(.dark) .img-card:hover .img-card-preview {
  box-shadow: 0 6px 20px rgba(148, 221, 12, 0.12);
}

.img-card-preview img {
  width: 64px;
  height: 64px;
  object-fit: contain;
  image-rendering: pixelated;
  transition: all 0.25s ease;
}

.img-card:hover .img-card-preview img {
  opacity: 0.3;
  transform: scale(1.05);
}

.img-card-overlay {
  position: absolute;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.25s ease;
  color: var(--vp-c-brand-1);
}

.img-card:hover .img-card-overlay {
  opacity: 1;
}

.img-card-name {
  font-size: 11px;
  color: var(--vp-c-text-3);
  font-family: var(--vp-font-family-mono);
  text-align: center;
  word-break: break-all;
  line-height: 1.3;
  transition: color 0.25s ease;
}

.img-card:hover .img-card-name {
  color: var(--vp-c-brand-1);
}
</style>
