import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["trigger", "content"];

  connect() {
    this.hide();
  }

  show() {
    const triggerRect = this.triggerTarget.getBoundingClientRect();
    const contentRect = this.contentTarget.getBoundingClientRect();

    Object.assign(this.contentTarget.style, {
      position: "fixed",
      zIndex: "100",
      width: "auto",
      top: "auto",
      left: "auto",
      bottom: "auto",
      right: "auto",
    });

    const top = triggerRect.top - contentRect.height - 10;
    const left =
      triggerRect.left + triggerRect.width / 2 - contentRect.width / 2;

    this.contentTarget.style.top = `${top}px`;
    this.contentTarget.style.left = `${left}px`;

    this.contentTarget.classList.remove("invisible", "opacity-0");
  }

  hide() {
    this.contentTarget.classList.add("invisible", "opacity-0");
  }
}
