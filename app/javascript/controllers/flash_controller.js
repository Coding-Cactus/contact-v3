import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
    static targets = ["flash"]

    flashTargetConnected(e) {
        setTimeout(() => {
            e.classList.add("visible")
            setTimeout(() => {
                e.classList.remove("visible")

                setTimeout(() => e.remove(), 500)
            }, 2000)
        }, 50);
    }
}
