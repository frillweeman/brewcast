<template>
  <v-toolbar class="px-6 py-2" color="transparent">
    <div class="d-flex flex-row align-center">
      <v-img class="mr-4" width="64px" :src="albumUrl" />
      <div>
        <h3>{{ songName }}</h3>
        <p>{{ artistName }}</p>
      </div>
    </div>

    <v-spacer />
    
    <div class="d-flex flex-row align-center">
      <div class="d-none d-sm-flex">
        <v-slider
          @start="isMuted = false"
          v-model="volume" 
          max="100" 
          thumb-size="16" 
          class="mr-4"
          width="100"
          hide-details
        />
      </div>
      <v-btn icon @click="toggleMute">
        <v-icon>{{ isMuted ? 'mdi-volume-off' : 'mdi-volume-high' }}</v-icon>
      </v-btn>
      <v-btn :loading="isLoadingStream" icon v-bind="props" @click="togglePlay">
        <v-icon>{{ isPlaying ? 'mdi-pause' : 'mdi-play' }}</v-icon>
      </v-btn>
    </div>
    <audio onpause="isPlaying = false" onplay="isPlaying = true" ref="player" :src="streamUrl" class="d-none" id="audio-player"></audio>
    <v-overlay persistent max-width="500" class="d-flex justify-center align-center" :model-value="!hasAgreed">
      <v-card>
        <v-card-title class="text-center">Access Authorization and Disclaimer</v-card-title>
        <v-card-text id="legal-agreement">
          By accessing this website and the Dunkin Radio stream, you confirm that you are authorized to do so. Your use of this site is at your own risk, and neither the website owner nor MixHits Radio, LLC, is liable for any damages or issues that may arise. By clicking "Agree," you accept full responsibility for compliance with all applicable terms and conditions.
        </v-card-text>
        <v-card-actions>
          <v-btn variant="text" color="red" href="https://www.youtube.com/watch?v=dQw4w9WgXcQ">Nah, Fuck this</v-btn>
          <v-spacer />
          <v-btn variant="tonal" color="primary" @click="agreeToTerms">Agree</v-btn>
        </v-card-actions>
      </v-card>
    </v-overlay>
  </v-toolbar>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { defineProps } from 'vue';
import Hls from 'hls.js'
import { watch, onMounted } from 'vue';
import CryptoJS from 'crypto-js';

const isLocal = window.location.hostname === 'localhost';
const streamUrl = ref(isLocal ? 'https://dunkinradio.org/hls/stream.m3u8' : '/hls/stream.m3u8');
const hasAgreed = ref(false);
const hasPlayed = ref(false);

const isLoadingStream = ref(false);

const player = ref<HTMLAudioElement | null>(null);

const props = defineProps<{ songName: string, artistName: string, albumUrl: string, spotifyLink: string }>();

const isPlaying = ref(false);
const volume = ref(100);
const oldVolume = ref(volume.value);
const isMuted = ref(false);

watch(volume, (newVolume) => {
  if (!player.value) return;
  player.value.volume = newVolume / 100;
});

const initStream = () => {
  isLoadingStream.value = true;
  setTimeout(() => { isLoadingStream.value = false }, 800);

  var hls = new Hls();
  if (!player.value) return;

  if (Hls.isSupported()) {
    hls.loadSource(streamUrl.value);
    hls.attachMedia(player.value);
  } else if (player.value.canPlayType('application/vnd.apple.mpegurl')) {
    player.value.src = streamUrl.value;
  }

  hasPlayed.value = true;
}

const play = () => {
  if (!hasAgreed.value)
    return;
  if (!hasPlayed.value)
    initStream();

  player.value?.play();
  isPlaying.value = true;
};

const pause = () => {
  isPlaying.value = false;
  player.value?.pause();
};

const togglePlay = () => {
  isPlaying.value = !isPlaying.value;
  if (isPlaying.value) {
    play();
  } else {
    pause();
  }
};

const toggleMute = () => {
  isMuted.value = !isMuted.value;
  isMuted.value ? mute() : unmute();
};

const mute = () => {
  oldVolume.value = volume.value;
  volume.value = 0;
};

const unmute = () => {
  volume.value = oldVolume.value;
};

const LEGAL_AGREEMENT_KEY = 'legalAgreementHash';
const hashLegalAgreement = () => {
  const legalAgreementElement = document.getElementById('legal-agreement');
  if (legalAgreementElement) {
    const textContent = legalAgreementElement.textContent || '';
    return CryptoJS.SHA256(textContent).toString();
  }
  return '';
};
const checkAgreement = () => {
  const storedHash = localStorage.getItem(LEGAL_AGREEMENT_KEY);
  const currentHash = hashLegalAgreement();
  if (storedHash === currentHash) {
    hasAgreed.value = true;
  }
};
const agreeToTerms = () => {
  const currentHash = hashLegalAgreement();
  localStorage.setItem(LEGAL_AGREEMENT_KEY, currentHash);
  hasAgreed.value = true;
  play();
};

onMounted(checkAgreement);
</script>

