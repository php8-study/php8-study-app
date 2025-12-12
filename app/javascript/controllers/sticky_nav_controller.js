import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["nav"];
  static values = {
    footerSelector: String,
  };

  connect() {
    this.handleScroll = this.handleScroll.bind(this);
    window.addEventListener("scroll", this.handleScroll);
    this.handleScroll();
  }

  disconnect() {
    window.removeEventListener("scroll", this.handleScroll);
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
