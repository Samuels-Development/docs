<script setup>
import { ref } from 'vue'

const props = defineProps({
  id: { type: String, required: true },
  title: { type: String, default: 'Video Preview' },
})

const playing = ref(false)
const thumbSrc = ref(`https://i.ytimg.com/vi/${props.id}/maxresdefault.jpg`)

function onThumbLoad(e) {
  // YouTube returns a 120x90 grey placeholder when maxresdefault doesn't exist
  if (e.target.naturalWidth <= 120 && thumbSrc.value.includes('maxresdefault')) {
    thumbSrc.value = `https://i.ytimg.com/vi/${props.id}/hqdefault.jpg`
  }
}

function onThumbError() {
  if (thumbSrc.value.includes('maxresdefault')) {
    thumbSrc.value = `https://i.ytimg.com/vi/${props.id}/hqdefault.jpg`
  }
}
</script>

<template>
  <div class="yt-embed">
    <div class="yt-embed-inner">
      <!-- Thumbnail with play button -->
      <button
        v-if="!playing"
        class="yt-embed-thumb"
        :aria-label="`Play ${title}`"
        @click="playing = true"
      >
        <img
          :src="thumbSrc"
          :alt="title"
          loading="lazy"
          @load="onThumbLoad"
          @error="onThumbError"
        />
        <span class="yt-embed-play">
          <svg viewBox="0 0 68 48" width="68" height="48">
            <path
              d="M66.52 7.74c-.78-2.93-2.49-5.41-5.42-6.19C55.79.13 34 0 34 0S12.21.13 6.9 1.55c-2.93.78-4.63 3.26-5.42 6.19C.06 13.05 0 24 0 24s.06 10.95 1.48 16.26c.78 2.93 2.49 5.41 5.42 6.19C12.21 47.87 34 48 34 48s21.79-.13 27.1-1.55c2.93-.78 4.64-3.26 5.42-6.19C67.94 34.95 68 24 68 24s-.06-10.95-1.48-16.26z"
              fill="rgba(0,0,0,.75)"
            />
            <path d="M45 24L27 14v20" fill="#fff" />
          </svg>
        </span>
      </button>

      <!-- Iframe (loaded on click) -->
      <iframe
        v-else
        :src="`https://www.youtube.com/embed/${id}?autoplay=1&rel=0`"
        :title="title"
        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
        allowfullscreen
      />
    </div>
    <p class="yt-embed-caption">{{ title }}</p>
  </div>
</template>

<style scoped>
.yt-embed {
  margin: 20px 0;
  border-radius: 12px;
  border: 1px solid var(--vp-c-divider);
  background: var(--vp-c-bg-soft);
  overflow: hidden;
  transition: border-color 0.25s ease;
}

.yt-embed:hover {
  border-color: var(--vp-c-brand-1);
}

.yt-embed-inner {
  position: relative;
  padding-bottom: 56.25%;
  height: 0;
  overflow: hidden;
  background: #000;
}

.yt-embed-thumb {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  padding: 0;
  border: none;
  cursor: pointer;
  background: none;
}

.yt-embed-thumb img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
  transition: opacity 0.3s ease;
}

.yt-embed-thumb:hover img {
  opacity: 0.85;
}

.yt-embed-play {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  transition: transform 0.2s ease, filter 0.2s ease;
  filter: drop-shadow(0 2px 8px rgba(0, 0, 0, 0.4));
}

.yt-embed-thumb:hover .yt-embed-play {
  transform: translate(-50%, -50%) scale(1.1);
}

.yt-embed-thumb:hover .yt-embed-play path:first-child {
  fill: var(--vp-c-brand-1);
  transition: fill 0.2s ease;
}

.yt-embed-inner iframe {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  border: 0;
}

.yt-embed-caption {
  margin: 0;
  padding: 10px 16px;
  font-size: 13px;
  font-weight: 500;
  color: var(--vp-c-text-2);
  border-top: 1px solid var(--vp-c-divider);
}
</style>
