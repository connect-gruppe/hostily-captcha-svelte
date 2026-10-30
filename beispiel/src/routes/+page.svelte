<script>
  import { HostilyCaptcha } from "@hostily/captcha-svelte";

  // Pruefprojekt 19 des Dienstes: der Site-Key ist oeffentlich
  const SITE_KEY = "8cdc48a989b7c79151d6";
  let captcha;
  let token = "";
  let abgelaufen = 0;
  let fehler = "";
  let gesendet = "";

  function senden(e) {
    // Hier ginge der Formularinhalt an den eigenen Server, der das Token mit dem Secret beim Dienst prueft
    gesendet = String(new FormData(e.target).get("hostily-captcha-token") || "");
  }
  function zuruecksetzen() {
    captcha.reset();
    token = "";
  }
</script>

<main style="font-family: system-ui, sans-serif; margin: 2rem">
  <h1>hostily Captcha mit Svelte</h1>
  <form on:submit|preventDefault={senden}>
    <p><input name="nachricht" placeholder="Nachricht" /></p>
    <HostilyCaptcha
      bind:this={captcha}
      siteKey={SITE_KEY}
      sprache="de"
      onVerify={(t) => { token = t; fehler = ""; }}
      onError={(_m, code) => (fehler = code)}
      onExpire={() => { token = ""; abgelaufen += 1; }}
    />
    <p>
      <button type="button" id="reset-btn" on:click={zuruecksetzen}>Zurücksetzen</button>
      <button type="submit">Senden</button>
    </p>
  </form>
  <p>Token: <code id="token">{token}</code></p>
  <p>Abgelaufen: <span id="abgelaufen">{abgelaufen}</span> · Fehler: <span id="fehler">{fehler}</span></p>
  <p>Gesendet: <code id="gesendet">{gesendet}</code></p>
</main>
