// ==UserScript==
// @name        refined Debian BTS
// @namespace   https://franklinyu.github.io
// @match       https://bugs.debian.org/cgi-bin/bugreport.cgi
// @grant       none
// @version     0.1
// @author      Franklin Yu
// @description Update "mailto:" links with readable names of email addresses.
// ==/UserScript==

const REPLY_REGEXP = /^mailto:(\d+)@bugs.debian.org/
for (const anchor of document.querySelectorAll("a[href*='@bugs.debian.org']")) {
  console.debug(anchor.href)
  const subscribe = anchor.href.match(/^mailto:(\d+)-subscribe@bugs.debian.org$/)
  if (subscribe) {
    const bugId = parseInt(subscribe[1], 10)
    anchor.href = `mailto:Debian bug ${bugId} subscription <${bugId}-subscribe@bugs.debian.org>`
    continue
  }
  const reply = anchor.href.match(REPLY_REGEXP)
  if (reply) {
    const bugId = parseInt(reply[1], 10)
    anchor.href = anchor.href.replace(REPLY_REGEXP, `mailto:Debian bug ${bugId} <${bugId}@bugs.debian.org>`)
  }
}
