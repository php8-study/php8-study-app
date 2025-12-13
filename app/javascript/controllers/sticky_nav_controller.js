import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
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
      this.element.classList.remove("fixed");
      this.element.classList.add("absolute");
    } else {
      this.element.classList.remove("absolute");
      this.element.classList.add("fixed");
    }
  }
}
