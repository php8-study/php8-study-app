import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.dismiss();
    }, 4000);
  }

  dismiss() {
    this.element.classList.add("opacity-0", "translate-y-[-20px]", "scale-95");
    setTimeout(() => {
      this.element.remove();
    }, 500);
  }
}
