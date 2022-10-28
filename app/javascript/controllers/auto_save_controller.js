// Based on https://stevepolito.design/blog/rails-auto-save-form-data/
import { Controller } from "@hotwired/stimulus";

const notTheTokenField = ([field]) => field !== "authenticity_token";
const notAFileField = ([_, value]) => !(value instanceof File);

export default class extends Controller {
  static targets = ["form"];

  connect() {
    this.localStorageKey = window.location;
    this.setFormData();
  }

  clearLocalStorage() {
    if (!localStorage.getItem(this.localStorageKey)) return;
    localStorage.removeItem(this.localStorageKey);
  }

  getFormData() {
    const form = new FormData(this.formTarget);
    const data = Array.from(form.entries())
      .filter(notTheTokenField)
      .filter(notAFileField)
      .map(([field, value]) => [field, value]);
    return Object.fromEntries(data);
  }

  saveToLocalStorage() {
    const data = this.getFormData();
    localStorage.setItem(this.localStorageKey, JSON.stringify(data));
  }

  setFormData() {
    const storage = localStorage.getItem(this.localStorageKey);
    if (!storage) return;

    const data = JSON.parse(storage);
    const form = this.formTarget;

    Object.entries(data).forEach(([name, value]) => {
      const input = form.querySelector(`[name='${name}']`);
      input && (input.value = value);
    });
  }
}
