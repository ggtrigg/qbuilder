import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="question-editor"
export default class extends Controller {
  static targets = ["score", "choice"]

  connect() {
  }

  update(event) {
    if(event.currentTarget.value.match(/choice/)) {
      this.choiceTarget.classList.remove("d-none")
      this.scoreTarget.classList.add("d-none")
    }else if(event.currentTarget.value.match(/score/)) {
      this.choiceTarget.classList.add("d-none")
      this.scoreTarget.classList.remove("d-none")
    } else {
      this.choiceTarget.classList.add("d-none")
      this.scoreTarget.classList.add("d-none")
    }
  }
}
