// ==UserScript==
// @name         Bitbucket clean up
// @namespace    https://github.com/franklinyu/snippets
// @version      0.2.1
// @description  Block the useless "+1" comments.
// @author       Franklin Yu
// @require      https://cdnjs.cloudflare.com/ajax/libs/jquery/3.1.0/jquery.min.js
// @include      https://bitbucket.org/site/master/issues/*
// @grant        none
// ==/UserScript==

let blackList = [];
for (let comment of $('.issue-comment').toArray()) {
	if ($(comment).find('.comment-content').text().trim().startsWith('+1')) {
		$(comment).addClass('spam-comment');
		blackList.push(comment.id);
	}
}
console.info("blocked comments:\n", blackList);
