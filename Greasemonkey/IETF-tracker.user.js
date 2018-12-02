// ==UserScript==
// @name Refined IETF Tracker
// @namespace https://franklinyu.github.io
// @match https://datatracker.ietf.org/doc/*
// @grant none
// ==/UserScript==

const title = $('#content h2 small')
title.wrap(`<a href="https://tools.ietf.org/html/${title.text()}"></a>`)
