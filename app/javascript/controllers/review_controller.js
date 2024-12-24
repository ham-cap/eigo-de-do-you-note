import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="review"
export default class extends Controller {
  static targets = ["enPhrase", "switchingButton"];
  switchEnPhraseVisibility() {
    this.enPhraseTarget.style.display =
      this.enPhraseTarget.style.display === "none" ? "block" : "none";

    this.switchingButtonTarget.textContent =
      this.switchingButtonTarget.textContent === "英文を表示する"
        ? "英文を隠す"
        : "英文を表示する";
  }
}
