import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    document.body.classList.add("overflow-hidden") 
  }

  close() {
    this.element.remove()
  }

  stop(e) {
    e.stopPropagation() 
  }

  disconnect() {
    document.body.classList.remove("overflow-hidden")
  }
}
