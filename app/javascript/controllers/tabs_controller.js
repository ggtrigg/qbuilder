import { Controller } from "@hotwired/stimulus"
import { Tab } from "bootstrap"

// Connects to data-controller="tabs"
export default class extends Controller {

  connect() {
    this.element.querySelectorAll('button.nav-link').forEach((el) => new Tab(el))
  }

  disconnect() {
    this.element.querySelectorAll('button.nav-link').forEach((el) => Tab.getInstance(el).dispose())
  }

  show(event) {
    Tab.getInstance(event.currentTarget).show();
  }
}
