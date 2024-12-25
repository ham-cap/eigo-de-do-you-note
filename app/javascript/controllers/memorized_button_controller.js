import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="memorized-button"
export default class extends Controller {
  static targets = ["memorizedButton"];

  switchText() {
    this.memorizedButtonTarget.textContent =
      this.memorizedButtonTarget.textContent === "覚えた！"
        ? "忘れた！"
        : "覚えた！";
  }
}
