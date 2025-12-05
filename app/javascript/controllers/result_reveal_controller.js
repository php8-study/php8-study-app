import { Controller } from "@hotwired/stimulus";
import confetti from "canvas-confetti";

export default class extends Controller {
  static targets = [
    "bar",
    "scoreText",
    "summary",
    "message",
    "scoreDetail",
    "detailTable",
    "actionButtons",
  ];
  static values = { score: Number, passed: Boolean };

  disconnect() {
    if (this.confettiFrameId) {
      cancelAnimationFrame(this.confettiFrameId);
    }
  }

  connect() {
    setTimeout(() => {
      this.summaryTarget.classList.remove("opacity-0", "translate-y-4");
    }, 100);

    setTimeout(() => {
      this.animateChart();
    }, 600);
  }

  animateChart() {
    const score = this.scoreValue;
    const passed = this.passedValue;
    const duration = 1000;

    const circumference = 283;
    const offset = circumference - (score / 100) * circumference;

    this.barTarget.style.strokeDasharray = `${circumference} ${circumference}`;
    this.barTarget.style.strokeDashoffset = offset;

    this.animateNumber(0, score, duration);

    setTimeout(() => {
      this.revealResultColor(passed);
    }, duration);

    setTimeout(() => this.showNextElements(), duration + 500);
  }

  revealResultColor(passed) {
    this.barTarget.classList.remove("text-slate-200");

    if (passed) {
      this.barTarget.classList.add("text-emerald-500");
      this.fireConfetti();
    } else {
      this.barTarget.classList.add("text-red-500");
    }

    this.barTarget.style.transform = "scale(1.05)";
    setTimeout(() => {
      this.barTarget.style.transform = "scale(1)";
    }, 200);
  }

  fireConfetti() {
    const duration = 3000;
    const end = Date.now() + duration;

    const frame = () => {
      confetti({
        particleCount: 5,
        angle: 60,
        spread: 55,
        origin: { x: 0 },
        colors: ['#34D399', '#60A5FA', '#FBBF24']
      });
      confetti({
        particleCount: 5,
        angle: 120,
        spread: 55,
        origin: { x: 1 },
        colors: ['#34D399', '#60A5FA', '#FBBF24']
      });

      if (Date.now() < end) {
        this.confettiFrameId = requestAnimationFrame(frame);
      }
    };

    frame();
  }

  animateNumber(start, end, duration) {
    if (!this.hasScoreTextTarget) return;

    let startTimestamp = null;
    const step = (timestamp) => {
      if (!startTimestamp) startTimestamp = timestamp;
      const progress = Math.min((timestamp - startTimestamp) / duration, 1);
      const currentScore = Math.floor(progress * (end - start) + start);

      this.scoreTextTarget.innerText = currentScore;

      if (progress < 1) {
        window.requestAnimationFrame(step);
      }
    };
    window.requestAnimationFrame(step);
  }

  showNextElements() {
    if (this.hasMessageTarget) this.messageTarget.classList.remove("opacity-0");

    setTimeout(() => {
      if (this.hasScoreDetailTarget)
        this.scoreDetailTarget.classList.remove("opacity-0");
    }, 300);

    setTimeout(() => {
      if (this.hasActionButtonsTarget) {
        this.actionButtonsTarget.classList.remove("opacity-0", "translate-y-4");
      }
    }, 600);

    setTimeout(() => {
      if (this.hasDetailTableTarget)
        this.detailTableTarget.classList.remove("opacity-0");
    }, 900);
  }
}
