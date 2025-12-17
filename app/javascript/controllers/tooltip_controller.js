import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["trigger", "content"];

  connect() {
    Object.assign(this.contentTarget.style, {
      position: "fixed",
      top: "-9999px",
      left: "-9999px",
      zIndex: "100",
      width: "auto",
    });

    this.hide();
  }

  show() {
    if (this.timeout) {
      clearTimeout(this.timeout);
    }

    const triggerRect = this.triggerTarget.getBoundingClientRect();
    const contentRect = this.contentTarget.getBoundingClientRect();

    const top = triggerRect.top - contentRect.height - 10;
    const left =
      triggerRect.left + triggerRect.width / 2 - contentRect.width / 2;

    if (left < 10) {
      left = 10;
    }

    const maxLeft = window.innerWidth - contentRect.width - 10;
    if (left > maxLeft) {
      left = maxLeft;
    }

    if (top < 10) {
      top = triggerRect.bottom + 10;
    }

    this.contentTarget.style.top = `${top}px`;
    this.contentTarget.style.left = `${left}px`;

    this.contentTarget.classList.remove("invisible", "opacity-0");
  }

  hide() {
    this.timeout = setTimeout(() => {
      this.contentTarget.classList.add("invisible", "opacity-0");

      setTimeout(() => {
        if (this.contentTarget.classList.contains("invisible")) {
          this.contentTarget.style.top = "-9999px";
          this.contentTarget.style.left = "-9999px";
        }
      }, 200);
    }, 100);
  }
}
