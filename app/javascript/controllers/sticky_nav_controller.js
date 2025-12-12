import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["nav"];
  static values = {
    footerSelector: String,
  };

  connect() {
    this.ticking = false;

    this.onScroll = () => {
      if (!this.ticking) {
        window.requestAnimationFrame(() => {
          this.handleScroll();
          this.ticking = false;
        });
        this.ticking = true;
      }
    };

    window.addEventListener("scroll", this.onScroll);
    window.addEventListener("resize", this.onScroll);

    this.handleScroll();
  }

  disconnect() {
    window.removeEventListener("scroll", this.onScroll);
    window.removeEventListener("resize", this.onScroll);
  }

  handleScroll() {
    const footerElement = document.querySelector(this.footerSelectorValue);
    if (!footerElement) return;

    const footerTop = footerElement.getBoundingClientRect().top;
    const windowHeight = window.innerHeight;

    const shouldUnfix = footerTop < windowHeight;

    if (shouldUnfix) {
      this.navTarget.classList.remove("fixed");
      this.navTarget.classList.add("absolute");
    } else {
      this.navTarget.classList.remove("absolute");
      this.navTarget.classList.add("fixed");
    }
  }
}
