# @hostily/captcha-svelte

**Deutsch**

Svelte-Komponente (Svelte 4 und 5) für [hostily Captcha](https://captcha.hostily.de): eine dünne Hülle um das Web Component
`<hostily-captcha>`. SSR-sicher (SvelteKit). Die Komponente liefert nur das **Token**; das Secret gehört nie in den Browser – das Token
prüft Ihr Server (z. B. mit `@hostily/captcha`).

```sh
npm install @hostily/captcha-svelte
```

```svelte
<script>
  import { HostilyCaptcha } from "@hostily/captcha-svelte";
  let captcha;
  let token = "";
</script>

<form method="post" action="/kontakt">
  <HostilyCaptcha bind:this={captcha} siteKey="IHR_SITE_KEY" onVerify={(t) => (token = t)} onExpire={() => (token = "")} />
  <button>Senden</button>
</form>
```

Im Formular steht das Token im Feld `hostily-captcha-token`; `onVerify` bekommt es zusätzlich. Die Komponente ist in der Syntax
geschrieben, die Svelte 4 und 5 gleichermaßen übersetzen (Rückrufe als Props); in Svelte 5 läuft sie im Legacy-Modus des
Aufrufers unverändert, Ihre eigenen Komponenten dürfen Runes nutzen.

| Prop | Bedeutung | Vorgabe |
|---|---|---|
| `siteKey` | Site-Key des Projekts (Pflicht) | – |
| `api` | Basisadresse des Dienstes | `https://captcha.hostily.de/api/` |
| `modus` | `"sichtbar"` / `"unsichtbar"` | `"sichtbar"` |
| `sprache` | `"de"` / `"en"` | aus `<html lang>` |
| `theme` | `"hell"` / `"dunkel"` | System |
| `feld` | Name des Token-Feldes | `hostily-captcha-token` |
| `recaptchaKompatibel` | zusätzlich `g-recaptcha-response` | `false` |
| `widgetUrl` | Adresse des Widget-Skripts (selbst gehostet) | `<api>/../widget/hostily-captcha.js` |
| `klasse` | CSS-Klasse am Element | – |
| `onVerify(token)` | Token liegt vor | – |
| `onError(meldung, code)` | Fehler; `code`: `netz`, `gesperrt`, `abgelehnt`, `challenge`, `rechnen`, `verfahren`, `skript` | – |
| `onExpire()` | Token abgelaufen oder vom Widget zurückgesetzt (nicht nach eigenem `reset()`) | – |

Per `bind:this`: `reset()` (nach Absenden per Ajax; ein Token gilt nur einmal), `loesen()` (Promise mit dem Token), `token()`.
Das Widget-Skript wird einmal je Seite geladen, erst im Browser (`onMount`). CSP: `script-src` und `connect-src` für
captcha.hostily.de, `worker-src blob:`, `script-src 'wasm-unsafe-eval'`.

Geprüft (SvelteKit 2.70, Produktionsbuild mit adapter-node, Browsertest gegen den echten Dienst): Svelte 4.2 und Svelte 5.57.
Beispielprojekt: `beispiel/`, Test: `test/lauf.sh`.

**English**

Svelte component (Svelte 4 and 5) for [hostily Captcha](https://captcha.hostily.de): a thin wrapper around the `<hostily-captcha>`
web component, SSR-safe (SvelteKit). It only delivers the **token**; verify it on your server with the secret.
Usage as above. Props: `siteKey` (required), `api`, `modus` (`sichtbar`/`unsichtbar` = visible/invisible), `sprache` (`de`/`en`),
`theme` (`hell`/`dunkel` = light/dark), `feld`, `recaptchaKompatibel`, `widgetUrl`, `klasse` (CSS class), callbacks
`onVerify(token)`, `onError(message, code)`, `onExpire()` (not fired by your own `reset()`). Methods via `bind:this`: `reset()`,
`loesen()`, `token()`. The script is loaded once per page, in the browser only.
Tested: SvelteKit 2.70 production builds with Svelte 4.2 and 5.57, browser test against the live service.

MIT
