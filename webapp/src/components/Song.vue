<template>
  <v-card :disabled="!isActive" width="190">
    <v-img class="ma-3" rounded :lazy-src="defaultAlbumUrl" :src="albumUrl ?? defaultAlbumUrl" />
    <v-card-title class="text-h5">{{ songName }}</v-card-title>
    <v-card-subtitle class="text-subtitle-1 mb-6">{{ artistName }}</v-card-subtitle>
  </v-card>
</template>

<script setup lang="ts">
import { defineProps, computed } from 'vue';

const defaultAlbumUrl = '/dd-ad-albumart.png';

const props = defineProps<{ songName: string, artistName: string, albumUrl: string, isActive: boolean }>();
</script>
