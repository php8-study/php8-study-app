import { Controller } from "@hotwired/stimulus";
import confetti from "canvas-confetti";

export default class extends Controller {
  fire() {
    if (this.frameId) cancelAnimationFrame(this.frameId);
    
    const duration = 3000;
    const end = Date.now() + duration;

    const frame = () => {
      const defaults = {
        particleCount: 5,
        spread: 55,
        colors: ["#34D399", "#60A5FA", "#FBBF24"],
      };
      confetti({ ...defaults, angle: 60, origin: { x: 0 } });
      confetti({ ...defaults, angle: 120, origin: { x: 1 } });

      if (Date.now() < end) {
        this.frameId = requestAnimationFrame(frame);
      }
    };

    frame();
  }

  disconnect() {
    if (this.frameId) cancelAnimationFrame(this.frameId);
  }
}
