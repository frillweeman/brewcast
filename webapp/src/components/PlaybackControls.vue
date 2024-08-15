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
      <v-btn icon @click="togglePlay">
        <v-icon>{{ isPlaying ? 'mdi-pause' : 'mdi-play' }}</v-icon>
      </v-btn>
    </div>
    <audio onpause="isPlaying = false" onplay="isPlaying = true" ref="player" :src="streamUrl" class="d-none" id="audio-player"></audio>
  </v-toolbar>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { defineProps } from 'vue';
import Hls from 'hls.js'
import { onMounted, watch } from 'vue';

const isLocal = window.location.hostname === 'localhost';
const streamUrl = ref(isLocal ? 'http://dunkinradio.org/hls/stream.m3u8' : '/hls/stream.m3u8');

const player = ref<HTMLAudioElement | null>(null);

onMounted(() => {
  var hls = new Hls();
  if (!player.value) return;

  if (Hls.isSupported()) {
    hls.loadSource(streamUrl.value);
    hls.attachMedia(player.value);
    hls.on(Hls.Events.MANIFEST_PARSED, function () {
      play();
    });
  } else if (player.value.canPlayType('application/vnd.apple.mpegurl')) {
    player.value.src = streamUrl.value;
    player.value.addEventListener('canplay', function () {
      play();
    });
  }
});

const props = defineProps<{ songName: string, artistName: string, albumUrl: string, spotifyLink: string }>();

const isPlaying = ref(false);
const volume = ref(50);
const oldVolume = ref(volume.value);
const isMuted = ref(false);

watch(volume, (newVolume) => {
  if (!player.value) return;
  player.value.volume = newVolume / 100;
});

const play = () => {
  player.value?.play();
};

const pause = () => {
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
</script>

