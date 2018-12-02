// ==UserScript==
// @name SSL Labs Refined
// @description Improve SSL Labs
// @namespace https://franklinyu.github.io
// @version 0.1.0
// @include https://www.ssllabs.com/ssltest/analyze.html?*
// @grant none
// ==/UserScript==

HTMLCollection.prototype.filter = Array.prototype.filter
NodeList.prototype.find = Array.prototype.find

/**
 * 
 * @param {HTMLElement} elem the header
 * @param {string} hash hexadecimal SHA-256
 */
function addCertLinks(elem, hash) {
  const crtSh = document.createElement('a')
  crtSh.href = 'https://crt.sh/?q=' + hash
  crtSh.innerText = 'crt.sh'

  const censys = document.createElement('a')
  censys.href = 'https://censys.io/certificates/' + hash
  censys.innerText = 'Censys'

  elem.append(' ', crtSh, ' ', censys)
}

/** @type {HTMLDivElement[]} */
const certElements = document.getElementsByClassName('serverKeyCert')
  .filter(e => e.innerText.trim() === 'Server Key and Certificate #1')
for (const certElement of certElements) {
  const table = certElement.closest('table')
  /** @type {string} */
  const hash = table.querySelector('.greySmall').innerText.match(/[0-9a-f]{64}/)[0]

  addCertLinks(certElement, hash)

  const row = table.querySelectorAll('tbody tr')
    .find(tr => tr.cells[0].innerText.trim() === 'Certificate Transparency')
  {
    const anchor = document.createElement('a')
    const bytes = hash.match(/.{2}/g).map(str => parseInt(str, 16))
    const b64 = encodeURIComponent(btoa(String.fromCharCode(...bytes)))
    anchor.href = 'https://transparencyreport.google.com/https/certificates/' + b64
    anchor.innerText = 'Google report'
    row.cells[1].append(' ', anchor)
  }
}
