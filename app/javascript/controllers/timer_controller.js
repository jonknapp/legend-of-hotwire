import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    // delete this.element.dataset.controller;
    this.start = new Date();
    this.interval = setInterval(() => {
      const numberOfSeconds =
        (new Date().getTime() - this.start.getTime()) / 1000;
      this.element.textContent = `${numberOfSeconds} seconds`;
    }, 200);
  }

  disconnect() {
    if (this.interval) {
      clearInterval(this.interval);
    }
  }
}
