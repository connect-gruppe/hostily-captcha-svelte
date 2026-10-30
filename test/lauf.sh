#!/bin/bash
# Prueft @hostily/captcha-svelte: Paket bauen (node:22, svelte-package), als Tarball ins SvelteKit-Beispiel installieren, bauen und
# starten, SSR-HTML pruefen, Browsertest gegen das echte Pruefprojekt 19. Variante: 4 (Svelte 4) oder 5 (Svelte 5, Vorgabe).
#   flock /tmp/claude-0/ap-docker.lock integrationen/komponenten/svelte/test/lauf.sh [4|5]
set -e
. "$(dirname "$0")/../../test/container.sh"
KP_PAKET=svelte
V="${1:-5}"
case "$V" in
  4) PAK="svelte@4 @sveltejs/vite-plugin-svelte@3 vite@5 @sveltejs/kit@2 @sveltejs/adapter-node@5" ;;
  5) PAK="svelte@5 @sveltejs/vite-plugin-svelte@6 vite@7 @sveltejs/kit@2 @sveltejs/adapter-node@5" ;;
  *) echo "Variante 4 oder 5"; exit 1 ;;
esac
kp_pruefen
trap kp_ende EXIT INT TERM
kp_kopieren svelte svelte-$V
kp_start svelte-$V
echo "=== Paket bauen ==="
kp_ex "cd /arbeit/svelte-$V && npm install --no-package-lock 2>&1 | tail -1 && npm run build && npm pack --pack-destination /arbeit/svelte-$V/beispiel | tail -1"
echo "=== Beispiel: SvelteKit ($PAK) ==="
kp_ex "cd /arbeit/svelte-$V/beispiel && npm install --no-package-lock --save=false $PAK ./hostily-captcha-svelte-0.1.0.tgz 2>&1 | tail -2 && npx vite build 2>&1 | tail -4"
kp_ex "cd /arbeit/svelte-$V/beispiel && node -p \"'SvelteKit ' + require('@sveltejs/kit/package.json').version + ', Svelte ' + require('svelte/package.json').version\""
docker exec -d -w /arbeit/svelte-$V/beispiel -e PORT=$PORT -e HOST=0.0.0.0 $C node build
for i in $(seq 1 30); do curl -sf -o /dev/null http://localhost:$PORT/ && break; sleep 1; done
echo "=== Serverseitig gerendertes HTML ==="
HTML=$(curl -s http://localhost:$PORT/)
echo "$HTML" | grep -o '<hostily-captcha[^>]*>' | head -1
echo "$HTML" | grep -q '<hostily-captcha[^>]*data-site-key="8cdc48a989b7c79151d6"' && echo "OK     SSR: Element mit data-site-key im Server-HTML" || { echo "FEHLER SSR"; exit 1; }
echo "=== Browser (Playwright) ==="
kp_browser svelte-$V "sveltekit-svelte$V"
