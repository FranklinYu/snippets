// ==UserScript==
// @name Latest Documentation Link
// @namespace https://franklinyu.github.io
// @include https://ruby-doc.org/core-*
// @include https://ruby-doc.org/stdlib-*
// @grant none
// ==/UserScript==

const versionHeader = document.querySelector('#versionheader p')
if (versionHeader) {
  const link = document.createElement('a')
  link.href = location.pathname.replace(/^\/(core|stdlib)-[.\d]+/, '/$1')
  link.innerText = 'here'
  versionHeader.innerHTML += ` Latest documentation is available ${link.outerHTML}.`
}
