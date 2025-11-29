import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "bar",
    "message",
    "scoreDetail",
    "detailHeader",
    "detailTable",
    "summary",
    "actionButtons",
  ];
  static values = { score: Number, passed: Boolean };

  connect() {
    const animationDuration = 3000;
    setTimeout(() => {
      this.animateBar();
    }, 1000);

    setTimeout(
      () => {
        this.showMessageAndScore();
      },
      1000 + animationDuration + 500,
    );

    setTimeout(
      () => {
        this.showDetails();
      },
      1000 + animationDuration + 1500,
    );

    setTimeout(
      () => {
        this.showActionButtons();
      },
      1000 + animationDuration + 2000,
    );
  }

  animateBar() {
    const score = this.scoreValue;
    const finalBarColor = this.passedValue ? "bg-indigo-500" : "bg-red-500";
    this.barTarget.classList.remove("bg-gray-400");
    this.barTarget.classList.add(finalBarColor);

    setTimeout(() => {
      this.barTarget.style.width = `${score > 100 ? 100 : score}%`;
    }, 50);
  }

  showMessageAndScore() {
    if (this.passedValue) {
      this.summaryTarget.classList.remove("bg-gray-50", "border-gray-500");
      this.summaryTarget.classList.add("bg-green-50", "border-green-500");
      this.messageTarget.classList.add("text-green-700");
    } else {
      this.summaryTarget.classList.remove("bg-gray-50", "border-gray-500");
      this.summaryTarget.classList.add("bg-red-50", "border-red-500");
      this.messageTarget.classList.add("text-red-700");
    }
    this.messageTarget.classList.remove("opacity-0");
    this.scoreDetailTargets.forEach((el) => {
      el.classList.remove("opacity-0");
    });
  }

  showDetails() {
    this.detailHeaderTarget.classList.remove("opacity-0");
    this.detailTableTarget.classList.remove("opacity-0");
  }

  showActionButtons() {
    if (this.hasActionButtonsTarget) {
      this.actionButtonsTarget.classList.remove("opacity-0");
    }
  }
}
