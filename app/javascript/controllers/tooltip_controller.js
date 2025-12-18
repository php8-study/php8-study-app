import { Controller } from "@hotwired/stimulus";

const OFFSET = 10;
const ANIMATION_DURATION = 200;
const HOVER_DELAY = 100;

export default class extends Controller {
  static targets = ["trigger", "content"];

  connect() {
    Object.assign(this.contentTarget.style, {
      position: "fixed",
      top: "-9999px",
      left: "-9999px",
      zIndex: "1000",
      width: "auto",
    });

    this.hide();
  }

  disconnect() {
    if (this.showTimeout) clearTimeout(this.showTimeout);
    if (this.hideTimeout) clearTimeout(this.hideTimeout);
  }

  show() {
    if (this.hideTimeout) clearTimeout(this.hideTimeout);

    const { top, left } = this.calculatePosition();

    Object.assign(this.contentTarget.style, {
      top: `${top}px`,
      left: `${left}px`,
    });

    this.contentTarget.classList.remove("invisible", "opacity-0");
  }

  hide() {
    this.hideTimeout = setTimeout(() => {
      this.contentTarget.classList.add("invisible", "opacity-0");

      this.showTimeout = setTimeout(() => {
        if (this.contentTarget.classList.contains("invisible")) {
          this.contentTarget.style.top = "-9999px";
          this.contentTarget.style.left = "-9999px";
        }
      }, ANIMATION_DURATION);
    }, HOVER_DELAY);
  }

  calculatePosition() {
    const triggerRect = this.triggerTarget.getBoundingClientRect();
    const contentRect = this.contentTarget.getBoundingClientRect();
    const viewportWidth = window.innerWidth;

    let top = triggerRect.top - contentRect.height - OFFSET;
    let left = triggerRect.left + (triggerRect.width / 2) - (contentRect.width / 2);

    left = Math.max(OFFSET, left);
    
    const maxLeft = viewportWidth - contentRect.width - OFFSET;
    left = Math.min(left, maxLeft);

    if (top < OFFSET) {
      top = triggerRect.bottom + OFFSET;
    }

    return { top, left };
  }
}
