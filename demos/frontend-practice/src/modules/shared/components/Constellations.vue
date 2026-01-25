<template>
  <div class="constellations-overlay">
    <svg width="100%" height="100%" xmlns="http://www.w3.org/2000/svg">
      <g class="star-group">
        <!-- Stars (Fixed relative positions) -->
        <circle v-for="(star, index) in stars" :key="index" 
          :cx="star.x + '%'" 
          :cy="star.y + '%'" 
          :r="star.r" 
          class="star"
          :style="{ animationDelay: star.delay + 's', opacity: star.opacity }"
        />
        
        <!-- Faint Constellation Lines -->
        <g class="lines">
          <line x1="20%" y1="30%" x2="35%" y2="25%" class="const-line" />
          <line x1="35%" y1="25%" x2="45%" y2="40%" class="const-line" />
          <line x1="45%" y1="40%" x2="30%" y2="55%" class="const-line" />
          
          <line x1="80%" y1="70%" x2="95%" y2="60%" class="const-line" />
          <line x1="95%" y1="60%" x2="100%" y2="80%" class="const-line" />
          
          <line x1="25%" y1="85%" x2="40%" y2="95%" class="const-line" />
          <line x1="40%" y1="95%" x2="50%" y2="80%" class="const-line" />
        </g>
      </g>
    </svg>
  </div>
</template>

<script setup lang="ts">
const stars = Array.from({ length: 100 }, () => ({
  x: Math.random() * 200 - 50, // Wider range to cover rotation arc
  y: Math.random() * 100 - 50, // Mostly in the upper half
  r: Math.random() * 0.6 + 0.1, // Fixed: Small points of light
  delay: Math.random() * 5,
  opacity: Math.random() * 0.5 + 0.1
}));
</script>

<style scoped>
.constellations-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 1;
  pointer-events: none;
  overflow: hidden;
}

.star-group {
  animation: rotate-heavenly 300s linear infinite;
  transform-origin: 50% 150%; /* Fixed: Center much lower */
}

.star {
  fill: white;
  animation: twinkle-subtle 4s infinite ease-in-out;
}

.const-line {
  stroke: rgba(255, 255, 255, 0.05);
  stroke-width: 0.5;
  stroke-dasharray: 1 4;
}

@keyframes twinkle-subtle {
  0%, 100% { opacity: 0.2; }
  50% { opacity: 0.6; }
}

@keyframes rotate-heavenly {
  from { transform: rotate(-20deg); }
  to { transform: rotate(20deg); }
}
</style>
