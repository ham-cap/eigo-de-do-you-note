import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="review"
export default class extends Controller {
  static targets = ["enPhrase", "switchingButton"];
  switchEnPhraseVisibility() {
    if (this.enPhraseTarget.classList.contains("hidden")) {
      this.enPhraseTarget.classList.remove("hidden");
    } else {
      this.enPhraseTarget.classList.add("hidden");
    }

    this.switchingButtonTarget.textContent =
      this.switchingButtonTarget.textContent === "英文を表示"
        ? "英文を隠す"
        : "英文を表示";
  }
}
