import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    footerSelector: String,
  };

  connect() {
    this.observer = new IntersectionObserver(this.handleIntersect.bind(this), {
      root: null,
      threshold: 0,
    });

    const footer = document.querySelector(this.footerSelectorValue);

    if (footer) {
      this.observer.observe(footer);

      const rect = footer.getBoundingClientRect();
      const isIntersecting = rect.top < window.innerHeight;

      if (isIntersecting) {
        this.element.classList.remove("fixed");
        this.element.classList.add("absolute");
      } else {
        this.element.classList.remove("absolute");
        this.element.classList.add("fixed");
      }
    } else {
      console.warn(
        `[sticky-nav] Footer not found: ${this.footerSelectorValue}`,
      );
    }
  }

  disconnect() {
    if (this.observer) this.observer.disconnect();
  }

  handleIntersect(entries) {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        this.element.classList.remove("fixed");
        this.element.classList.add("absolute");
      } else {
        this.element.classList.remove("absolute");
        this.element.classList.add("fixed");
      }
    });
  }
}
