import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="creation-form"
export default class extends Controller {
  static targets = ["creationForm"];

  changeVisibility() {
    this.creationFormTarget.classList.toggle("hidden");
  }
}
