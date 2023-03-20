import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
    disable(e) {
        e.target.querySelector("[type='submit']").disabled = true
    }
}
