import Sortable from "stimulus-sortable"

// Connects to data-controller="qsortable"
export default class extends Sortable {
  onUpdate(event) {
    super.onUpdate(event);
    this.dispatch("update", {detail: { event: event } });
  }
}
