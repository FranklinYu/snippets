// ==UserScript==
// @name         Apple documentation class link
// @namespace    https://franklinyu.github.io/
// @version      0.2
// @description  create link for classes in code segments
// @icon         https://upload.wikimedia.org/wikipedia/commons/4/46/Apple_Store_logo.svg
// @author       Franklin Yu
// @include      https://developer.apple.com/reference/*
// @grant        none
// ==/UserScript==

for (let span of document.getElementsByClassName('syntax-type')) {
	let className = span.textContent;
	if (! /^\w+$/.test(className)) {
		console.warn("class name not recognized in", span);
		continue;
	}
	(async function() {
		const response = await fetch('/search/search_data.php?&q=' + className);
		if (! response.ok) {
			console.error("get %s when searching class %s", response.statusText, className);
			console.info('response:', response);
			throw new Error('Unexpected response');
		}
		const json = await response.json();
		if (json[0].title === className) {
			let anchor = document.createElement('A'); // HTMLAnchorElement
			anchor.href = result.url;
			span.replaceWith(anchor);
			anchor.appendChild(span);
		} else {
			console.warn("can't find %s in search results.", className);
			console.info('response:', response);
		}
	})();
}
