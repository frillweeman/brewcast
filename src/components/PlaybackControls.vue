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
        <v-icon>{{ isPlaying ? 'mdi-stop' : 'mdi-play' }}</v-icon>
      </v-btn>
    </div>
  </v-toolbar>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { defineProps } from 'vue';

const props = defineProps<{ songName: string, artistName: string, albumUrl: string, spotifyLink: string }>();

const isPlaying = ref(false);
const volume = ref(50);
const oldVolume = ref(volume.value);
const isMuted = ref(false);

const togglePlay = () => {
  isPlaying.value = !isPlaying.value;
  // Add logic to play or pause the HLS stream
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

