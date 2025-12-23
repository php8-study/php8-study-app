import { Controller } from "@hotwired/stimulus";

const OFFSET = 10;

export default class extends Controller {
  static targets = ["trigger", "content"];

  connect() {
    Object.assign(this.contentTarget.style, {
      position: "fixed",
      top: "0",
      left: "0",
      transform: "translate3d(-9999px, -9999px, 0)"
    });
    this.contentTarget.classList.add("invisible", "opacity-0");
  }

  disconnect() {
    if (this.hideTimeout) clearTimeout(this.hideTimeout);
  }

  show() {
    if (this.hideTimeout) clearTimeout(this.hideTimeout);

    this.contentTarget.classList.remove("invisible");

    this.updatePosition();

    requestAnimationFrame(() => {
      this.contentTarget.classList.remove("opacity-0");
    });
  }

  hide() {
    this.contentTarget.classList.add("opacity-0");

    this.hideTimeout = setTimeout(() => {
      if (this.contentTarget && this.contentTarget.classList.contains("opacity-0")) {
        this.contentTarget.classList.add("invisible");
        this.contentTarget.style.transform = "translate3d(-9999px, -9999px, 0)";
      }
    }, 200);
  }

  updatePosition() {
    const triggerRect = this.triggerTarget.getBoundingClientRect();
    const contentRect = this.contentTarget.getBoundingClientRect();
    
    let top = triggerRect.top - contentRect.height - OFFSET;
    let left = triggerRect.left + (triggerRect.width / 2) - (contentRect.width / 2);

    if (left < OFFSET) left = OFFSET;

    const maxLeft = window.innerWidth - contentRect.width - OFFSET;
    if (left > maxLeft) left = maxLeft;

    if (top < OFFSET) {
      top = triggerRect.bottom + OFFSET;
    }

    Object.assign(this.contentTarget.style, {
      transform: "none",
      top: `${top}px`,
      left: `${left}px`
    });
  }
}
