<template>
  <div class="hero-logo">
    <img src="/logo.png" alt="Samuel's Development" />
  </div>
</template>

<style scoped>
.hero-logo {
  display: flex;
  justify-content: center;
  margin-bottom: 24px;
}

.hero-logo img {
  width: 100px;
  height: 100px;
  object-fit: contain;
}

@media (min-width: 640px) {
  .hero-logo img {
    width: 120px;
    height: 120px;
  }
}
</style>
