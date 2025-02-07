import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="creation-form"
export default class extends Controller {
  static targets = ["creationForm"];

  changeVisibility() {
    if (this.creationFormTarget.classList.contains("hidden")) {
      this.creationFormTarget.classList.remove("hidden");
    } else {
      this.creationFormTarget.classList.add("hidden");
    }
  }
}
