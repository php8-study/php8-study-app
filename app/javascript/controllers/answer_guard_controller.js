import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["checkbox"];
  static values = { active: { type: Boolean, default: false } };

  submit(event) {
    if (!this.activeValue) return;

    const isChecked = this.checkboxTargets.some((checkbox) => checkbox.checked);

    if (!isChecked) {
      event.preventDefault();
      window.alert(
        "回答を選択してください。\n後で回答する場合は「後で回答する」ボタンを使用してください。",
      );
    }
  }
}
