import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="review"
export default class extends Controller {
  static targets = ["enPhrase", "switchingButton"];
  switchEnPhraseVisibility() {
    if (this.enPhraseTarget.classList.contains("hidden")) {
      this.enPhraseTarget.classList.remove("hidden");
      this.switchingButtonTarget.textContent = "英文を隠す";
    } else {
      this.enPhraseTarget.classList.add("hidden");
      this.switchingButtonTarget.textContent = "英文を表示";
    }
  }
}
