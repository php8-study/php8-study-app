import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["item", "button"];

  connect() {
    this.filter({ params: { type: "all" } });
  }

  filter(event) {
    const type = event.params ? event.params.type : "all";

    this.itemTargets.forEach((element) => {
      const isCorrect = element.dataset.correct === "true";

      if (type === "incorrect" && isCorrect) {
        element.classList.add("hidden");
        element.setAttribute("aria-hidden", "true");
      } else {
        element.classList.remove("hidden");
        element.setAttribute("aria-hidden", "false");
      }
    });

    if (event.currentTarget) {
      this.updateActiveButton(event.currentTarget);
    }
  }

  updateActiveButton(clickedButton) {
    this.buttonTargets.forEach((btn) => {
      if (btn === clickedButton) {
        btn.classList.add("bg-indigo-600", "text-white", "border-transparent");
        btn.classList.remove(
          "bg-white",
          "text-slate-600",
          "border-slate-200",
          "hover:text-indigo-600",
        );
        btn.setAttribute("aria-pressed", "true");
      } else {
        btn.classList.remove(
          "bg-indigo-600",
          "text-white",
          "border-transparent",
        );
        btn.classList.add(
          "bg-white",
          "text-slate-600",
          "border-slate-200",
          "hover:text-indigo-600",
        );
        btn.setAttribute("aria-pressed", "false");
      }
    });
  }
}
