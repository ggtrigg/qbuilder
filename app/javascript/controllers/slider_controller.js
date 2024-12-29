import { Controller } from "@hotwired/stimulus"
import noUiSlider from 'nouislider'

// Connects to data-controller="slider"
export default class extends Controller {
  static targets = ["scoreRange"]

  connect() {
    if(this.scoreRangeTarget.value.match(/;/)) {
      this.startVal = this.scoreRangeTarget.value.split(';').map((x) => parseInt(x));
    } else {
      this.startVal = [1, 20];
    }
    noUiSlider.create(this.element, {
      start: this.startVal,
      // start: [0, 10],
      connect: true,
      step: 1,
      range: {
        'min': 0,
        'max': 20
      },
      pips: {
        mode: 'steps',
        density: 4
      }
    });
    this.element.noUiSlider.on('update', this.update.bind(this));
  }

  update(_values, _handle, unencoded) {
    this.scoreRangeTarget.value = unencoded.join(';');
  }
}
