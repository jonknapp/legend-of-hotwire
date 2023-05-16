import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.element.addEventListener("ended", this.endedEvent.bind(this));
  }

  // this doesn't work to stop audio from replaying if navigation occurs before completion
  disconnect() {
    if (this.element) {
      this.element.setAttribute("autoplay", false);
      this.element.pause();
      this.element.remove();
    }
  }

  endedEvent() {
    if (this.element) {
      this.element.remove();
    }
  }
}
