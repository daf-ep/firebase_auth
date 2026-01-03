import { Params } from "../config/params.js";

class AppHeader extends HTMLElement {
  connectedCallback() {
    this.innerHTML = `
      <header>
        <picture>
          <source srcset="${Params.assets.logo.dark}" media="(prefers-color-scheme: dark)">
          <source srcset="${Params.assets.logo.light}" media="(prefers-color-scheme: light)">
          <img
            src="${Params.assets.logo.light}"
            alt="Application logo"
            class="logo"
            loading="eager"
            decoding="async"
          >
        </picture>
      </header>
    `;
  }
}

customElements.define("app-header", AppHeader);