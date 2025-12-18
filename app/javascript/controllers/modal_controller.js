import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    document.body.classList.add("overflow-hidden");
    document.addEventListener("keydown", this.handleKeydown);
  }

  close() {
    this.element.remove();
  }

  stop(e) {
    e.stopPropagation();
  }

  handleKeydown = (e) => {
    if (e.key === "Escape") {
      this.close();
    }
  };

  disconnect() {
    document.body.classList.remove("overflow-hidden");
  }
}
