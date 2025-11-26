import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["target", "template"]

  add(event) {
    event.preventDefault()

    const content = this.templateTarget.innerHTML
    const randomId = new Date().getTime()
    const newContent = content.replace(/NEW_RECORD/g, randomId)
    this.targetTarget.insertAdjacentHTML("beforeend", newContent)
  }

  remove(event) {
    event.preventDefault()

    const wrapper = event.target.closest(".nested-form-wrapper")
    const destroyInput = wrapper.querySelector("input[name*='_destroy']")

    if (destroyInput) {
      destroyInput.value = "1"
      wrapper.style.display = "none"
    } else {
      wrapper.remove()
    }
  }
}
