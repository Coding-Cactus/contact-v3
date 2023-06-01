import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
    static targets = ["dropdown", "selected", "singleHidden", "selectAll"]

    toggleOpen() {
        this.dropdownTarget.classList.toggle("open")
    }

    selectOption(e) {
        this.dropdownTarget.classList.remove("open")

        const top = this.selectedTarget
        const topText = top.innerText
        const topClasses = top.parentElement.className
        const topId = top.parentElement.getAttribute("data-option")
        const topIndex = top.parentElement.getAttribute("data-index")

        top.innerText = e.target.innerText
        top.parentElement.className = e.target.className
        top.parentElement.setAttribute("data-index", e.target.getAttribute("data-index"))
        top.parentElement.setAttribute("data-option", e.target.getAttribute("data-option"))

        this.singleHiddenTarget.value = top.parentElement.getAttribute("data-option")

        setTimeout(() => {
            e.target.innerText = topText
            e.target.className = topClasses;
            e.target.setAttribute("data-option", topId)
            e.target.setAttribute("data-index", topIndex)

            const ul = e.target.parentElement

            Array.from(ul.children)
                .sort((a, b) => Number(a.getAttribute("data-index")) - Number(b.getAttribute("data-index")))
                .forEach(elem => ul.appendChild(elem));
        }, 300)
    }

    checkboxChange(e) {
        const elem    = e.target;
        const options = document.querySelectorAll("#filters input[type='checkbox']:not(#filter_statuses_all)");

        if (elem.id === "filter_statuses_all") {
            options.forEach(input => { input.checked = elem.checked });
        } else {
            this.selectAllTarget.checked = elem.checked && (Array.from(options).every(o => o.checked));
        }
    }
}
