import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="memorized-button"
export default class extends Controller {
  static targets = ["memorizedButton"];

  switchText() {
    if (
      this.memorizedButtonTarget.children[0].alt ===
      "覚えていない状態のチェックマーク"
    ) {
      this.memorizedButtonTarget.innerHTML = "";
      this.memorizedButtonTarget.innerHTML =
        '<img src="/assets/check_mark.png" alt="覚えた状態チェックマーク" class="w-10 h-10">';
      this.memorizedButtonTarget.classList.add("bg-white", "rounded-full");
    } else {
      this.memorizedButtonTarget.innerHTML = "";
      this.memorizedButtonTarget.innerHTML =
        '<img src="/assets/check_mark_gray.png" alt="覚えていない状態のチェックマーク" class="w-10 h-10">';
      this.memorizedButtonTarget.classList.add("bg-white", "rounded-full");
    }
  }
}
