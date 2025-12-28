<template>
<svg viewBox="0 0 512 512" fill="none" xmlns="http://www.w3.org/2000/svg">
    <defs>
        <linearGradient id="waveBodyGrad" x1="0" y1="512" x2="512" y2="0" gradientUnits="userSpaceOnUse">
            <stop offset="0%" stop-color="#051937" /> <stop offset="100%" stop-color="#004d7a" /> </linearGradient>

        <linearGradient id="dataRippleGrad" x1="150" y1="150" x2="350" y2="350" gradientUnits="userSpaceOnUse">
            <stop offset="0%" stop-color="#00ffe7" /> <stop offset="100%" stop-color="#00a8cc" /> </linearGradient>

        <filter id="coreGlow" x="-50%" y="-50%" width="200%" height="200%">
            <feGaussianBlur stdDeviation="6" result="coloredBlur"/>
            <feMerge>
                <feMergeNode in="coloredBlur"/>
                <feMergeNode in="SourceGraphic"/>
            </feMerge>
        </filter>
    </defs>

    <path d="M480,256 C480,140 360,60 256,60 C160,60 80,120 40,200 C20,240 20,300 60,360 C100,420 180,460 280,460 C380,460 460,380 480,280 L480,256 Z"
          fill="url(#waveBodyGrad)" opacity="0.1" /> <path d="M460,220 C440,120 340,80 256,80 C150,80 60,160 60,280 C60,380 140,440 256,440 C360,440 440,360 450,260 C465,160 380,180 340,220 C300,260 260,320 360,360 C400,375 440,340 460,280 Z"
          fill="url(#waveBodyGrad)" />

    <g stroke="url(#dataRippleGrad)" stroke-width="18" stroke-linecap="round" fill="none">
        <path d="M380,280 A80,80 0 0,1 280,340"/>
        <path d="M350,265 A50,50 0 0,1 295,310"/>
    </g>

    <circle cx="320" cy="240" r="25" fill="#FFFFFF" filter="url(#coreGlow)"/>
    <circle cx="320" cy="240" r="15" fill="url(#dataRippleGrad)"/>

</svg>
<!-- <svg viewBox="0 0 300 300" fill="none" xmlns="http://www.w3.org/2000/svg">
    <defs>
        <linearGradient id="oceanGradientSmall" x1="0" y1="300" x2="300" y2="0" gradientUnits="userSpaceOnUse">
            <stop offset="0%" stop-color="#003B73" />
            <stop offset="100%" stop-color="#00A8E8" />
        </linearGradient>
        <linearGradient id="eyeGradientSmall" x1="100" y1="100" x2="200" y2="200" gradientUnits="userSpaceOnUse">
            <stop offset="0%" stop-color="#00A8E8" />
            <stop offset="100%" stop-color="#4FD1C5" />
        </linearGradient>
    </defs>
    <g>
        <circle cx="150" cy="150" r="140" stroke="url(#oceanGradientSmall)" stroke-width="10" fill="none" opacity="0.9"/>
        <path d="M50,150 A100,100 0 0,1 250,150" stroke="#00A8E8" stroke-width="3" stroke-linecap="round" opacity="0.3" fill="none"/>
        <path d="M150,260 C90,260 40,210 40,150 C40,100 70,60 110,45 C130,38 160,40 180,55 C220,85 240,130 200,170 C170,200 120,180 110,150 C105,135 115,115 130,110"
              stroke="url(#oceanGradientSmall)" stroke-width="18" stroke-linecap="round" fill="none"/>
        <circle cx="150" cy="150" r="28" fill="url(#eyeGradientSmall)"/>
        <circle cx="150" cy="150" r="14" fill="#FFFFFF" opacity="0.9"/>
    </g>
</svg> -->


<!-- <svg
    xmlns="http://www.w3.org/2000/svg"
    fill="none"
    viewBox="0 0 24 24"
    stroke-width="1.5"
    stroke="currentColor"
    class="size-6"
  >
    <path
      stroke-linecap="round"
      stroke-linejoin="round"
      d="M3 15.5c1.4 1.1 2.8 1.6 4.2 1.6 2.1 0 3.5-1.05 4.8-2.06 1.35-1.04 2.63-2.02 4.5-2.02 1.2 0 2.4.38 3.5 1.12M3 11.5c1.4 1.1 2.8 1.6 4.2 1.6 2.1 0 3.5-1.05 4.8-2.06 1.35-1.04 2.63-2.02 4.5-2.02 1.2 0 2.4.38 3.5 1.12"
    />
    <path
      stroke-linecap="round"
      stroke-linejoin="round"
      d="M5.5 18.25s.75.75 2.25.75 2.25-.75 2.25-.75"
    />
  </svg> -->
</template>
