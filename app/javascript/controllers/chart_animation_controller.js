import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { score: Number };

  animate(duration = 1000) {
    const radius = parseFloat(this.element.getAttribute("r")) || 45;
    const circumference = 2 * Math.PI * radius;
    const offset = circumference - (this.scoreValue / 100) * circumference;

    this.element.style.strokeDasharray = `${circumference} ${circumference}`;
    this.element.style.strokeDashoffset = circumference;

    requestAnimationFrame(() => {
      this.element.style.strokeDashoffset = offset;
    });
  }

  setColor(isPassed) {
    this.element.classList.remove("text-slate-200");
    this.element.classList.add(isPassed ? "text-emerald-500" : "text-red-500");
  }

  pulse() {
    if (this.pulseTimer) clearTimeout(this.pulseTimer);

    this.element.classList.add("scale-105");
    setTimeout(() => this.element.classList.remove("scale-105"), 200);
  }

  disconnect() {
    if (this.pulseTimer) clearTimeout(this.pulseTimer);
  }
}
