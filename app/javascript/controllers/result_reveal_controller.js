import { Controller } from "@hotwired/stimulus";
import confetti from "canvas-confetti";

const wait = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

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
    if (this.confettiFrameId) cancelAnimationFrame(this.confettiFrameId);
    if (this.numberFrameId) cancelAnimationFrame(this.numberFrameId);
  }

  async connect() {
    const t = this.constructor.TIMINGS;

    await wait(t.INITIAL_REVEAL);
    this.summaryTarget.classList.remove("opacity-0", "translate-y-4");

    await wait(t.CHART_START);
    await this.animateChartSequence();
  }

  async animateChartSequence() {
    const t = this.constructor.TIMINGS;
    const { score, passed } = this;

    const radius = parseFloat(this.barTarget.getAttribute("r")) || 45;
    const circumference = 2 * Math.PI * radius;
    const offset = circumference - (score / 100) * circumference;

    this.barTarget.style.strokeDasharray = `${circumference} ${circumference}`;
    this.barTarget.style.strokeDashoffset = offset;

    this.animateNumber(0, score, t.ANIMATION_DURATION);

    await wait(t.ANIMATION_DURATION);
    this.revealResultColor(passed);

    await wait(t.NEXT_ELEMENTS_DELAY);
    this.showNextElements();
  }

  revealResultColor(passed) {
    const t = this.constructor.TIMINGS;

    this.barTarget.classList.remove("text-slate-200");
    this.barTarget.classList.add(passed ? "text-emerald-500" : "text-red-500");

    if (passed) this.fireConfetti();

    this.barTarget.classList.add("scale-105");
    setTimeout(
      () => this.barTarget.classList.remove("scale-105"),
      t.SCALE_EFFECT,
    );
  }

  async showNextElements() {
    const t = this.constructor.TIMINGS;

    const show = (el) => el?.classList.remove("opacity-0", "translate-y-full");

    if (this.hasMessageTarget) show(this.messageTarget);

    await wait(t.STAGGER);
    if (this.hasScoreDetailTarget) show(this.scoreDetailTarget);

    await wait(t.STAGGER);
    if (this.hasActionButtonsTarget) {
      this.actionButtonsTargets.forEach(show);
    }

    await wait(t.STAGGER);
    if (this.hasDetailTableTarget) show(this.detailTableTarget);
  }

  animateNumber(start, end, duration) {
    if (!this.hasScoreTextTarget) return;

    let startTimestamp = null;

    const step = (timestamp) => {
      if (!startTimestamp) startTimestamp = timestamp;
      const progress = Math.min((timestamp - startTimestamp) / duration, 1);
      this.scoreTextTarget.innerText = Math.floor(
        progress * (end - start) + start,
      );
      if (progress < 1) this.numberFrameId = requestAnimationFrame(step);
    };

    this.numberFrameId = requestAnimationFrame(step);
  }

  fireConfetti() {
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

      if (Date.now() < end) this.confettiFrameId = requestAnimationFrame(frame);
    };
    frame();
  }

  get score() {
    return this.scoreValue;
  }
  get passed() {
    return this.passedValue;
  }
}
