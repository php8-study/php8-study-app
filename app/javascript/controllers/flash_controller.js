import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.timeoutId = setTimeout(() => {
      this.dismiss();
    }, 4000);
  }

  disconnect() {
    if (this.timeoutId) {
      clearTimeout(this.timeoutId);
    }
  }

  dismiss() {
    if (this.timeoutId) {
      clearTimeout(this.timeoutId);
      this.timeoutId = null;
    }

    this.element.classList.add("opacity-0", "translate-y-[-20px]", "scale-95");
    setTimeout(() => {
      this.element.remove();
    }, 500);
  }
}
