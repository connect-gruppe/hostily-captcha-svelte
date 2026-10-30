<!--
  hostily Captcha fuer Svelte 4 und 5 (Syntax, die beide uebersetzen). Duenne Huelle um <hostily-captcha>.
  Rueckrufe als Props: onVerify(token), onError(meldung, code), onExpire(). Methoden per bind:this: reset(), loesen().
-->
<script>
  import { onMount } from "svelte";
  import { ladeWidget, widgetAdresse } from "./lader.js";

  /** Site-Key des Projekts (oeffentlich). @type {string} */
  export let siteKey;
  /** Basisadresse des Dienstes, Vorgabe https://captcha.hostily.de/api/ @type {string | undefined} */
  export let api = undefined;
  /** "sichtbar" (Vorgabe) oder "unsichtbar" @type {"sichtbar" | "unsichtbar" | undefined} */
  export let modus = undefined;
  /** "de" oder "en"; ohne Angabe aus <html lang> @type {"de" | "en" | undefined} */
  export let sprache = undefined;
  /** "hell" oder "dunkel" erzwingen @type {"hell" | "dunkel" | undefined} */
  export let theme = undefined;
  /** Name des Token-Feldes, Vorgabe hostily-captcha-token @type {string | undefined} */
  export let feld = undefined;
  /** Zusaetzlich g-recaptcha-response setzen @type {boolean} */
  export let recaptchaKompatibel = false;
  /** Adresse des Widget-Skripts, wenn es nicht beim Dienst liegt @type {string | undefined} */
  export let widgetUrl = undefined;
  /** CSS-Klasse am Element @type {string | undefined} */
  export let klasse = undefined;
  /** Token liegt vor. @type {(token: string) => void} */
  export let onVerify = () => {};
  /** Fehler; code: netz, gesperrt, abgelehnt, challenge, rechnen, verfahren oder skript. @type {(meldung: string, code: string) => void} */
  export let onError = () => {};
  /** Token abgelaufen oder zurueckgesetzt, ohne dass reset() gerufen wurde. @type {() => void} */
  export let onExpire = () => {};

  /** @type {any} */
  let el;
  let eigenesReset = false;
  let hatteToken = false;

  /** Setzt das Widget zurueck (nach dem Absenden per Ajax). */
  export function reset() {
    eigenesReset = true;
    try { el && el.reset(); } finally { eigenesReset = false; hatteToken = false; }
  }
  /** Loest (falls noetig) und liefert das Token. @returns {Promise<string>} */
  export function loesen() {
    return el ? el.loesen() : Promise.reject(new Error("Widget noch nicht bereit"));
  }
  /** Aktuelles Token oder "". @returns {string} */
  export function token() {
    return (el && el.token) || "";
  }

  // onMount laeuft nur im Browser, nie beim Rendern auf dem Server
  onMount(() => {
    const geloest = (/** @type {any} */ ev) => { hatteToken = true; onVerify(ev.detail.token); };
    const fehler = (/** @type {any} */ ev) => { const d = ev.detail || {}; onError(d.meldung || "", d.code || ""); };
    const zurueck = () => { if (!eigenesReset && hatteToken) { hatteToken = false; onExpire(); } };
    el.addEventListener("geloest", geloest);
    el.addEventListener("fehler", fehler);
    el.addEventListener("zurueckgesetzt", zurueck);
    ladeWidget(widgetAdresse(api, widgetUrl)).catch((/** @type {Error} */ err) => onError(err.message, "skript"));
    return () => {
      el.removeEventListener("geloest", geloest);
      el.removeEventListener("fehler", fehler);
      el.removeEventListener("zurueckgesetzt", zurueck);
    };
  });
</script>

<hostily-captcha
  bind:this={el}
  class={klasse || null}
  data-site-key={siteKey}
  data-api={api}
  data-modus={modus}
  data-sprache={sprache}
  data-theme={theme}
  data-feld={feld}
  data-recaptcha-kompatibel={recaptchaKompatibel ? "" : undefined}
></hostily-captcha>
