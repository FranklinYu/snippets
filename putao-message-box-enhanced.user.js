// ==UserScript==
// @name         PuTao message box enhanced
// @namespace    https://pt.sjtu.edu.cn
// @version      0.1.0
// @description  check messages with same name as search keyword
// @author       Franklin Yu
// @include      https://pt.sjtu.edu.cn/messages.php*
// @grant        none
// ==/UserScript==

let params = getParams();
if (params.action == 'viewmailbox' && typeof params.keyword == 'string' && params.keyword !== '') {
	let button = $('<input/>', {id: 'select-exact-match', class: 'btn', type: 'button', value: '符合搜索', click: selectExactMatch});
	$('input[name=markread]').parent().prepend(button);
}

function selectExactMatch() {
	let str = $('#searchinput').val();
	$('#select-exact-match').parent().parent().siblings('tr').slice(1, -1).each(function() {
		let row = $(this);
		if (row.children().slice(1, 2).text() === str) {
			row.find('input.checkbox').prop('checked', true);
		}
	});
}

function getParams(paramsString) {
	if (paramsString === void 0) { paramsString = location.search.substring(1); }
	var params = {};
	var regex = /([^&=]+)=?([^&]*)/g;
	for (var match = regex.exec(paramsString); match !== null; match = regex.exec(paramsString)) {
		params[decodeURIComponent(match[1])] = decodeURIComponent(match[2]);
	}
	return params;
}
