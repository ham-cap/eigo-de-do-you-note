import {Controller} from "@hotwired/stimulus";

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
        '<img src="/assets/checked-box.png" alt="覚えた状態チェックマーク" class="unchecked w-6 h-6"><span class="inline-block ml-[1rem] font-semibold">覚えた！！</span>';
      this.memorizedButtonTarget.classList.add(
        "bg-white",
        "rounded-md",
        "hover:border-gray-500"
      );
    } else {
      this.memorizedButtonTarget.innerHTML = "";
      this.memorizedButtonTarget.innerHTML =
        '<img src="/assets/unchecked-box.png" alt="覚えていない状態のチェックマーク" class="checked w-6 h-6"><span class="inline-block ml-[1rem] font-semibold">覚えた！！</span>';
      this.memorizedButtonTarget.classList.add(
        "bg-white",
        "rounded-md",
        "hover:border-gray-500"
      );
    }
  }
}
