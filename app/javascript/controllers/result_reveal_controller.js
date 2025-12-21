import { Controller } from "@hotwired/stimulus";

const wait = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

export default class extends Controller {
  static targets = [
    "summary",
    "message",
    "scoreDetail",
    "detailTable",
    "actionButtons",
  ];

  static values = { passed: Boolean };

  static outlets = ["chart-animation", "number-animation", "confetti"];

  static TIMINGS = {
    INITIAL: 100,
    ANIMATION_START: 600,
    DURATION: 1000,
    NEXT_DELAY: 500,
    STAGGER: 300,
  };

  disconnect() {}

  async connect() {
    const t = this.constructor.TIMINGS;

    await wait(t.INITIAL);
    this.summaryTarget.classList.remove("opacity-0", "translate-y-4");

    await wait(t.ANIMATION_START);

    if (this.hasChartAnimationOutlet)
      this.chartAnimationOutlet.animate(t.DURATION);
    if (this.hasNumberAnimationOutlet)
      this.numberAnimationOutlet.animate(t.DURATION);

    await wait(t.DURATION);
    this.revealResult();

    await wait(t.NEXT_DELAY);
    this.showNextElements();
  }

  revealResult() {
    const isPassed = this.passedValue;

    if (this.hasChartAnimationOutlet) {
      this.chartAnimationOutlet.setColor(isPassed);
      this.chartAnimationOutlet.pulse();
    }

    if (isPassed && this.hasConfettiOutlet) {
      this.confettiOutlet.fire();
    }
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
}
