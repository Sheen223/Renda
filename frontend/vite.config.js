import { defineConfig } from 'vite';
import wasm from 'vite-plugin-wasm';
import topLevelAwait from 'vite-plugin-top-level-await';

export default defineConfig({
  plugins: [
    wasm(),
    topLevelAwait()
  ],
  optimizeDeps: {
    exclude: ['@noir-lang/noir_js', '@noir-lang/backend_barretenberg']
  },
  build: {
    rollupOptions: {
      input: {
        main: './index.html',
        homepage: './homepage.html'
      }
    }
  }
});
