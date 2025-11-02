import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  build: {
    outDir: '../terraform/modules/frontend/s3_site',
    rollupOptions: {
      output: {
        // Customize filename patterns for different types of files
        entryFileNames: `assets/[name].js`, // For entry chunks (e.g., main.js)
        chunkFileNames: `assets/[name].js`, // For dynamic import chunks
        assetFileNames: `assets/[name].[ext]`, // For other assets like CSS, images, fonts
      },
    },
  }
})
