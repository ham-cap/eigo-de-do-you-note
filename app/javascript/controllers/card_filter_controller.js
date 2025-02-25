import { Controller } from "@hotwired/stimulus";

// connects to data-controller="card-filter"
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

    const turboParamsString =
      event.currentTarget.querySelector("a").dataset.turboParams;
    const turboParams = JSON.parse(turboParamsString);

    const newTarget = turboParams.target;

    const hiddenField = document.querySelector('input[name="target"]');
    if (hiddenField) {
      hiddenField.setAttribute("value", newTarget);
    }
  }
}
