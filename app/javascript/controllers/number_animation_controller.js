import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { end: Number };

  animate(duration = 1000) {
    let startTimestamp = null;
    const start = 0;
    const end = this.endValue;

    const step = (timestamp) => {
      if (!startTimestamp) startTimestamp = timestamp;
      const progress = Math.min((timestamp - startTimestamp) / duration, 1);

      this.element.innerText = Math.floor(progress * (end - start) + start);

      if (progress < 1) {
        this.frameId = requestAnimationFrame(step);
      }
    };

    this.frameId = requestAnimationFrame(step);
  }

  disconnect() {
    if (this.frameId) cancelAnimationFrame(this.frameId);
  }
}
