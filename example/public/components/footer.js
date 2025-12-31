import { Params } from "../config/params.js";
import { S } from "../i18n/i18n.js";

class AppFooter extends HTMLElement {
    connectedCallback() {
        const year = new Date().getFullYear();

        this.innerHTML = `
      <footer class="footer">
        <p class="subtitle">
          © ${year} ${Params["app"]["name"]}. ${S("all_rights_reserved")}
        </p>
      </footer>
    `;
    }
}

customElements.define("app-footer", AppFooter);