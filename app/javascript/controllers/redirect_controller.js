// app/javascript/controllers/redirect_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    url: String,
    delay: Number
  }

  connect() {
    if (this.urlValue) {
      setTimeout(() => {
        window.location.href = this.urlValue
      }, this.delayValue || 0)
    }
  }
}