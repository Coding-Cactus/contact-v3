import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
    static targets = ["overlay"]

    new() {
        this.overlayTarget.classList.add("show")
    }

    close() {
        this.overlayTarget.classList.remove("show")
    }
}
