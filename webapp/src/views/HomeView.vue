<template>
  <main>
    <div class="w-100 d-flex flex-column align-center pt-8">
      <h1 class="mt-8 mb-4 font-weight-light">Recent Songs</h1>

      <div ref="songContainerEl" class="song-container d-flex pa-4 w-100" style="position: relative">
        <Song
          v-for="(song, index) in recentSongs" :key="song.songName"
          :songName="song.songName" :artistName="song.artistName" :albumUrl="song.albumUrl"
          :isActive="index === recentSongs.length - 1"
          class="mx-2"
        />
        <v-overlay :attach="songContainerEl" contained persistent :model-value="true" class="d-flex align-center justify-center">
          <v-card style="max-width: 80%; margin: auto">
            <v-card-title class="text-center">Coming Soon</v-card-title>
            <v-card-text>
              Dunkin' Radio removed song data from their stream, so we're working on a music recognition system to fill in the gaps.
            </v-card-text>
          </v-card>
        </v-overlay>
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
// import SpotifyPlaylist from '@/components/SpotifyPlaylist.vue'
import { ref, computed } from 'vue'

const songContainerEl = ref<HTMLElement | undefined>(undefined);

const recentSongs = ref([
  { songName: 'Advertisement', artistName: 'Ed McMann & Lady D', albumUrl: '/dd-ad-albumart.png' },
  { songName: 'Pillow Talking', artistName: 'Lil Dicky', albumUrl: '/penith.webp' },
]);

const currentSong = computed(() => recentSongs.value[recentSongs.value.length - 1]);

</script>
