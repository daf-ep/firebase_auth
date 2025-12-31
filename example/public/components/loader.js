class AppLoader extends HTMLElement {
  connectedCallback() {
    this.innerHTML = `
      <div class="showbox">
        <div class="loader center">
          <svg class="circular" viewBox="25 25 50 50">
            <circle
              class="path"
              cx="50"
              cy="50"
              r="20"
              fill="none"
              stroke-width="2"
              stroke-miterlimit="10"
            />
          </svg>
        </div>
      </div>
    `;
  }
}

customElements.define("app-loader", AppLoader);