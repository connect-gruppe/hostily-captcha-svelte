import type { SvelteComponent } from "svelte";

export interface HostilyCaptchaProps {
  siteKey: string;
  api?: string;
  modus?: "sichtbar" | "unsichtbar";
  sprache?: "de" | "en";
  theme?: "hell" | "dunkel";
  feld?: string;
  recaptchaKompatibel?: boolean;
  widgetUrl?: string;
  klasse?: string;
  onVerify?: (token: string) => void;
  onError?: (meldung: string, code: string) => void;
  onExpire?: () => void;
}

/** Komponente <HostilyCaptcha>; Methoden per bind:this: reset(), loesen(), token(). */
export class HostilyCaptcha extends SvelteComponent<HostilyCaptchaProps> {
  reset(): void;
  loesen(): Promise<string>;
  token(): string;
}
export default HostilyCaptcha;
