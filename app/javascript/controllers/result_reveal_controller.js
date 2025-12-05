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

  static TIMINGS = {
    INITIAL_REVEAL: 100,
    CHART_START: 600,
    ANIMATION_DURATION: 1000,
    SCALE_EFFECT: 200,
    NEXT_ELEMENTS_DELAY: 500,
    STAGGER: 300,
  };

  disconnect() {
    if (this.confettiFrameId) {
      cancelAnimationFrame(this.confettiFrameId);
    }
    if (this.numberFrameId) {
      cancelAnimationFrame(this.numberFrameId);
    }
  }

  connect() {
    setTimeout(() => {
      this.summaryTarget.classList.remove("opacity-0", "translate-y-4");
    }, this.constructor.TIMINGS.INITIAL_REVEAL);

    setTimeout(() => {
      this.animateChart();
    }, this.constructor.TIMINGS.CHART_START);
  }

  animateChart() {
    const score = this.scoreValue;
    const passed = this.passedValue;
    const duration = this.constructor.TIMINGS.ANIMATION_DURATION;

    const radius = parseFloat(this.barTarget.getAttribute("r")) || 45; // default 45
    const circumference = 2 * Math.PI * radius;
    const offset = circumference - (score / 100) * circumference;

    this.barTarget.style.strokeDasharray = `${circumference} ${circumference}`;
    this.barTarget.style.strokeDashoffset = offset;

    this.animateNumber(0, score, duration);

    setTimeout(() => {
      this.revealResultColor(passed);
    }, duration);

    setTimeout(
      () => this.showNextElements(),
      duration + this.constructor.TIMINGS.NEXT_ELEMENTS_DELAY,
    );
  }

  revealResultColor(passed) {
    this.barTarget.classList.remove("text-slate-200");

    if (passed) {
      this.barTarget.classList.add("text-emerald-500");
      this.fireConfetti();
    } else {
      this.barTarget.classList.add("text-red-500");
    }

    this.barTarget.classList.add("scale-105");
    setTimeout(() => {
      this.barTarget.classList.remove("scale-105");
    }, this.constructor.TIMINGS.SCALE_EFFECT);
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
        colors: ["#34D399", "#60A5FA", "#FBBF24"],
      });
      confetti({
        particleCount: 5,
        angle: 120,
        spread: 55,
        origin: { x: 1 },
        colors: ["#34D399", "#60A5FA", "#FBBF24"],
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
        this.numberFrameId = requestAnimationFrame(step);
      }
    };
    this.numberFrameId = requestAnimationFrame(step);
  }

  showNextElements() {
    const stagger = this.constructor.TIMINGS.STAGGER;
    if (this.hasMessageTarget) this.messageTarget.classList.remove("opacity-0");

    setTimeout(() => {
      if (this.hasScoreDetailTarget)
        this.scoreDetailTarget.classList.remove("opacity-0");
    }, stagger);

    setTimeout(() => {
      if (this.hasActionButtonsTarget) {
        this.actionButtonsTarget.classList.remove("opacity-0", "translate-y-4");
      }
    }, stagger * 2);

    setTimeout(() => {
      if (this.hasDetailTableTarget)
        this.detailTableTarget.classList.remove("opacity-0");
    }, stagger * 3);
  }
}
