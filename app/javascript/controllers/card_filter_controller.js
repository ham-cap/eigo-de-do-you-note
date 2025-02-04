import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="card-filter"
export default class extends Controller {
  static targets = ["filterButton"];

  changeFilterDesign(event) {
    if (!event.currentTarget.classList.contains("is-selected")) {
      event.currentTarget.classList.add("is-selected");
      const unclickedButtons = this.filterButtonTargets.filter(
        (target) => target !== event.currentTarget
      );
      unclickedButtons.map((button) => button.classList.remove("is-selected"));
    }
  }
}
