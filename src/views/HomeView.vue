<template>
  <main>
    <div class="w-100 d-flex flex-column align-center pt-8">
      <h1 class="my-8 font-weight-light">Recent Songs</h1>

      <div class="song-container d-flex">
        <Song
          v-for="(song, index) in recentSongs" :key="song.songName"
          :songName="song.songName" :artistName="song.artistName" :albumUrl="song.albumUrl"
          :isActive="index === recentSongs.length - 1"
          class="mx-2"
        />
      </div>
    </div>
  </main>

  <v-footer color="grey-lighten-3" app class="px-0">
    <PlaybackControls
      :songName="currentSong.songName"
      :artistName="currentSong.artistName"
      :albumUrl="currentSong.albumUrl"
      :spotifyLink="currentSong.albumUrl"
    />
  </v-footer>
</template>

<script setup lang="ts">
import Song from '@/components/Song.vue'
import PlaybackControls from '@/components/PlaybackControls.vue'
import { ref, computed } from 'vue'

const recentSongs = ref([
  { songName: 'Advertisement', artistName: 'Ed McMann & Lady D', albumUrl: '/dd-ad-albumart.png' },
  { songName: 'Pillow Talking', artistName: 'Lil Dicky', albumUrl: '/penith.webp' },
]);

const currentSong = computed(() => recentSongs.value[recentSongs.value.length - 1]);

</script>
