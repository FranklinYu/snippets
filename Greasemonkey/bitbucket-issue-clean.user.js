// ==UserScript==
// @name         Bitbucket clean up
// @namespace    https://github.com/franklinyu/snippets
// @version      0.2.1
// @description  Block the useless "+1" comments.
// @author       Franklin Yu
// @include      https://bitbucket.org/site/master/issues/*
// @grant        none
// ==/UserScript==

let blackList = [];
for (let comment of document.getElementsByClassName('issue-comment')) {
	let content = comment.getElementsByClassName('comment-content')[0];
	if (content.textContent.trim().startsWith('+1')) {
		comment.classList.add('spam-comment');
		blackList.push(comment);
	}
}
console.info("blocked comments:\n", blackList);
