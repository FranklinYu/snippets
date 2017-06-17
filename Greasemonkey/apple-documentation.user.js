// ==UserScript==
// @name         Apple documentation class link
// @namespace    https://franklinyu.github.io/
// @version      0.1
// @description  create link for classes in code segments
// @author       Franklin Yu
// @include      https://developer.apple.com/reference/*
// @grant        none
// ==/UserScript==

for (let span of document.getElementsByClassName('syntax-type')) {
	let className = span.textContent;
	let xhr = new XMLHttpRequest();
	if (! /^\w+$/.test(className)) {
		console.warn("class name not recognized in", span);
		continue;
	}
	xhr.open('GET', '/search/search_data.php?&q=' + className);
	xhr.onreadystatechange = function() {
		if (this.readyState != 4)
			return;
		if (this.status == 200) {
			let result = JSON.parse(this.responseText).results[0];
			if (result.title === className) {
				let anchor = document.createElement('A'); // HTMLAnchorElement
				anchor.href = result.url;
				span.replaceWith(anchor);
				anchor.appendChild(span);
			} else {
				console.warn("can't find %s in search results.", className);
				console.info('request:', this);
			}
		} else {
			console.error("get %s when searching class %s", this.statusText, className);
			console.info('request:', this);
		}
	};
	xhr.send();
}
