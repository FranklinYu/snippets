// ==UserScript==
// @name Refined IETF Datatracker
// @namespace https://franklinyu.github.io
// @match https://datatracker.ietf.org/doc/*
// @grant none
// ==/UserScript==

const title = document.querySelector('#content h2 small')
const anchor = document.createElement('a')
title.replaceWith(anchor)
anchor.append(title)
anchor.href = `https://tools.ietf.org/html/${title.innerText}`
