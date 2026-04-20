<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue'

const props = defineProps({
  title: { type: String, default: 'Vehicle Hacking Device' },
})

const progress = ref(0)
let raf = 0

onMounted(() => {
  const start = performance.now()
  const tick = (now) => {
    const elapsed = (now - start) / 1000
    progress.value = (Math.sin(elapsed * 0.9) * 0.5 + 0.5) * 72 + 14
    raf = requestAnimationFrame(tick)
  }
  raf = requestAnimationFrame(tick)
})

onBeforeUnmount(() => cancelAnimationFrame(raf))
</script>

<template>
  <div class="cs-overlay" role="dialog" aria-label="Coming soon">
    <div class="cs-backdrop"></div>
    <div class="cs-grid"></div>
    <div class="cs-scanline"></div>
    <div class="cs-vignette"></div>

    <div class="cs-panel">
      <div class="cs-panel-bar">
        <span class="cs-dot cs-dot--r"></span>
        <span class="cs-dot cs-dot--y"></span>
        <span class="cs-dot cs-dot--g"></span>
        <span class="cs-panel-title">sd-vehhack :: deploy.sh</span>
        <span class="cs-panel-meta">SECURE</span>
      </div>

      <div class="cs-panel-body">
        <div class="cs-line">
          <span class="cs-muted">$</span>
          <span class="cs-cmd">./initialize --target={{ title.toLowerCase().replace(/ /g, '_') }}</span>
        </div>
        <div class="cs-line cs-muted">[&nbsp;OK&nbsp;] payload compiled</div>
        <div class="cs-line cs-muted">[&nbsp;OK&nbsp;] signatures verified</div>
        <div class="cs-line">
          <span class="cs-muted">[ .. ]</span>
          <span>awaiting release authorization</span>
        </div>

        <div class="cs-headline" data-text="COMING SOON">COMING SOON</div>

        <div class="cs-sub">
          <span class="cs-prefix">//</span>
          documentation is locked pending deployment<span class="cs-cursor">█</span>
        </div>

        <div class="cs-progress">
          <div class="cs-progress-track">
            <div class="cs-progress-bar" :style="{ width: progress + '%' }"></div>
          </div>
          <div class="cs-progress-meta">
            <span>PROGRESS</span>
            <span>{{ progress.toFixed(1) }}%</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.cs-overlay {
  position: fixed;
  inset: var(--vp-nav-height, 64px) 0 0 0;
  z-index: 40;
  pointer-events: none;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  font-family: 'JetBrains Mono', 'Fira Code', ui-monospace, SFMono-Regular, Menlo, monospace;
}

.cs-backdrop {
  position: absolute;
  inset: 0;
  background:
    radial-gradient(ellipse at center, rgba(15, 16, 20, 0.55) 0%, rgba(15, 16, 20, 0.92) 70%);
  backdrop-filter: blur(2px);
}

.cs-grid {
  position: absolute;
  inset: 0;
  background-image:
    linear-gradient(rgba(148, 221, 12, 0.06) 1px, transparent 1px),
    linear-gradient(90deg, rgba(148, 221, 12, 0.06) 1px, transparent 1px);
  background-size: 42px 42px;
  mask-image: radial-gradient(ellipse at center, black 20%, transparent 75%);
  -webkit-mask-image: radial-gradient(ellipse at center, black 20%, transparent 75%);
  animation: cs-grid-pan 24s linear infinite;
}

.cs-scanline {
  position: absolute;
  inset: 0;
  background: repeating-linear-gradient(
    to bottom,
    transparent 0,
    transparent 3px,
    rgba(148, 221, 12, 0.03) 3px,
    rgba(148, 221, 12, 0.03) 4px
  );
  mix-blend-mode: overlay;
}

.cs-scanline::after {
  content: "";
  position: absolute;
  left: 0;
  right: 0;
  height: 140px;
  background: linear-gradient(
    to bottom,
    transparent 0%,
    rgba(148, 221, 12, 0.08) 45%,
    rgba(148, 221, 12, 0.16) 50%,
    rgba(148, 221, 12, 0.08) 55%,
    transparent 100%
  );
  animation: cs-scan 6s linear infinite;
}

.cs-vignette {
  position: absolute;
  inset: 0;
  box-shadow: inset 0 0 220px 40px rgba(0, 0, 0, 0.75);
}

.cs-panel {
  position: relative;
  z-index: 2;
  width: min(640px, 92vw);
  background: rgba(10, 12, 16, 0.82);
  border: 1px solid rgba(148, 221, 12, 0.35);
  border-radius: 10px;
  box-shadow:
    0 0 0 1px rgba(148, 221, 12, 0.08),
    0 20px 60px -10px rgba(0, 0, 0, 0.7),
    0 0 80px -20px rgba(148, 221, 12, 0.35);
  backdrop-filter: blur(14px);
  overflow: hidden;
  animation: cs-pop 0.5s ease-out;
}

.cs-panel::before {
  content: "";
  position: absolute;
  inset: 0;
  pointer-events: none;
  background:
    linear-gradient(115deg, transparent 45%, rgba(148, 221, 12, 0.08) 50%, transparent 55%);
  background-size: 200% 200%;
  animation: cs-sheen 4.5s ease-in-out infinite;
}

.cs-panel-bar {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 14px;
  background: rgba(148, 221, 12, 0.05);
  border-bottom: 1px solid rgba(148, 221, 12, 0.18);
  font-size: 0.72rem;
  color: rgba(255, 255, 255, 0.55);
  letter-spacing: 0.04em;
}

.cs-dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  display: inline-block;
}
.cs-dot--r { background: #ff5f56; box-shadow: 0 0 8px rgba(255, 95, 86, 0.5); }
.cs-dot--y { background: #ffbd2e; }
.cs-dot--g { background: #27c93f; }

.cs-panel-title {
  flex: 1;
  text-align: center;
  font-weight: 600;
}

.cs-panel-meta {
  font-size: 0.6rem;
  padding: 2px 8px;
  background: rgba(148, 221, 12, 0.12);
  border: 1px solid rgba(148, 221, 12, 0.3);
  border-radius: 4px;
  color: var(--vp-c-brand-1);
  letter-spacing: 0.12em;
  font-weight: 700;
}

.cs-panel-body {
  padding: 22px 26px 24px;
  font-size: 0.82rem;
  color: rgba(255, 255, 255, 0.82);
  line-height: 1.7;
}

.cs-line {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.cs-muted { color: rgba(148, 221, 12, 0.7); }
.cs-cmd { color: #fff; }

.cs-headline {
  position: relative;
  margin: 18px 0 6px;
  font-size: clamp(2.25rem, 5.5vw, 3.6rem);
  font-weight: 900;
  letter-spacing: 0.02em;
  color: var(--vp-c-brand-1);
  text-align: center;
  text-shadow:
    0 0 10px rgba(148, 221, 12, 0.6),
    0 0 40px rgba(148, 221, 12, 0.25);
  animation: cs-flicker 5s infinite;
}

.cs-headline::before,
.cs-headline::after {
  content: attr(data-text);
  position: absolute;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  pointer-events: none;
  mix-blend-mode: screen;
}

.cs-headline::before {
  color: #ff3b3b;
  animation: cs-glitch-r 2.8s infinite steps(1);
  clip-path: inset(0 0 60% 0);
}

.cs-headline::after {
  color: #00b3ff;
  animation: cs-glitch-b 3.2s infinite steps(1);
  clip-path: inset(55% 0 0 0);
}

.cs-sub {
  text-align: center;
  font-size: 0.85rem;
  color: rgba(255, 255, 255, 0.6);
  margin-bottom: 20px;
}

.cs-prefix { color: var(--vp-c-brand-1); margin-right: 6px; }

.cs-cursor {
  display: inline-block;
  color: var(--vp-c-brand-1);
  margin-left: 4px;
  animation: cs-blink 1s steps(2) infinite;
}

.cs-progress { margin-top: 6px; }

.cs-progress-track {
  height: 4px;
  background: rgba(148, 221, 12, 0.1);
  border-radius: 2px;
  overflow: hidden;
  position: relative;
}

.cs-progress-bar {
  height: 100%;
  background: linear-gradient(90deg, rgba(148, 221, 12, 0.6), var(--vp-c-brand-1));
  box-shadow: 0 0 12px rgba(148, 221, 12, 0.6);
  transition: width 0.1s linear;
}

.cs-progress-meta {
  display: flex;
  justify-content: space-between;
  font-size: 0.65rem;
  letter-spacing: 0.16em;
  color: rgba(148, 221, 12, 0.75);
  margin-top: 8px;
}

@keyframes cs-pop {
  0%   { opacity: 0; transform: scale(0.96) translateY(6px); filter: blur(4px); }
  100% { opacity: 1; transform: scale(1) translateY(0); filter: blur(0); }
}

@keyframes cs-scan {
  0%   { transform: translateY(-20%); }
  100% { transform: translateY(120vh); }
}

@keyframes cs-sheen {
  0%, 100% { background-position: 200% 0; }
  50%      { background-position: -100% 0; }
}

@keyframes cs-grid-pan {
  0%   { background-position: 0 0, 0 0; }
  100% { background-position: 42px 42px, 42px 42px; }
}

@keyframes cs-flicker {
  0%, 97%, 100% { opacity: 1; }
  97.5%         { opacity: 0.75; }
  98%           { opacity: 1; }
  98.5%         { opacity: 0.4; }
  99%           { opacity: 1; }
}

@keyframes cs-glitch-r {
  0%, 100% { transform: translate(0); }
  20%      { transform: translate(-2px, 0); }
  40%      { transform: translate(1px, -1px); }
  60%      { transform: translate(-1px, 1px); }
  80%      { transform: translate(2px, 0); }
}

@keyframes cs-glitch-b {
  0%, 100% { transform: translate(0); }
  25%      { transform: translate(2px, 1px); }
  50%      { transform: translate(-1px, 0); }
  75%      { transform: translate(1px, -1px); }
}

@keyframes cs-blink {
  0%, 100% { opacity: 1; }
  50%      { opacity: 0; }
}

@media (prefers-reduced-motion: reduce) {
  .cs-panel,
  .cs-panel::before,
  .cs-headline,
  .cs-headline::before,
  .cs-headline::after,
  .cs-scanline::after,
  .cs-grid,
  .cs-cursor { animation: none; }
}
</style>
