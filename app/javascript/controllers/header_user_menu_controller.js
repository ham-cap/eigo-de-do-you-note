import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="header-user-menu"
export default class extends Controller {
  static targets = ["headerUserMenu"];

  connect() {
    if (this.hasHeaderUserMenuTarget) {
      document.addEventListener("click", this.handleOutsideClick.bind(this));
    }
  }

  disconnect() {
    if (this.hasHeaderUserMenuTarget) {
      document.removeEventListener("click", this.handleOutsideClick.bind(this));
    }
  }

  changeVisibility(event) {
    event.stopPropagation();
    if (this.hasHeaderUserMenuTarget) {
      this.toggleMenu();
    }
  }

  toggleMenu() {
    if (this.headerUserMenuTarget.classList.contains("is-visible")) {
      this.headerUserMenuTarget.classList.remove("is-visible");
    } else {
      this.headerUserMenuTarget.classList.add("is-visible");
    }
  }

  handleOutsideClick(event) {
    if (
      this.headerUserMenuTarget.classList.contains("is-visible") &&
      !this.headerUserMenuTarget.contains(event.target)
    ) {
      this.headerUserMenuTarget.classList.remove("is-visible");
    }
  }
}
