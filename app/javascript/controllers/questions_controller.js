import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="questions"
export default class extends Controller {
  static targets = ["question"]

  connect() {
  }

  questionTargetDisconnected() {
    this.updateQuestionNumbers();
  }

  updateQuestionNumbers() {
    this.questionTargets.forEach((question, index) => {
      question.querySelector('.q-index').innerText = index + 1
    })
  }
}
