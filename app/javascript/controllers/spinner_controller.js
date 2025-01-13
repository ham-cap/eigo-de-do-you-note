import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="spinner"
export default class extends Controller {
  static targets = ["form", "spinner"];

  connect() {
    this.formTarget.addEventListener("submit", () => {
      this.showSpinner();
    });
  }

  showSpinner() {
    this.formTarget.classList.add("hidden");
    this.spinnerTarget.classList.add("is-visible");
  }
}
