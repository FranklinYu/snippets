// ==UserScript==
// @name Refined Chocolatey
// @namespace https://franklinyu.github.io/
// @icon https://upload.wikimedia.org/wikipedia/commons/b/b0/Chocolatey_icon.png
// @match https://chocolatey.org/account/Packages
// @grant none
// ==/UserScript==

const domParser = new DOMParser();
document.querySelector('#published th.last').innerHTML = 'Download<br>This Version / Total';
const promises = [];
for (const row of document.querySelectorAll('#published tbody tr')) {
	const id = row.children[2].innerText;
	const version = row.children[3].innerText;
	promises.push((async () => {
		const resp = await fetch(`https://chocolatey.org/api/v2/Packages(Id='${id}',Version='${version}')/`);
		const doc = domParser.parseFromString(await resp.text(), 'application/xml');
		const downloadCount = doc.querySelector('VersionDownloadCount').innerHTML;
		row.children[5].innerText = downloadCount + ' / ' + row.children[5].innerText;
		return parseInt(downloadCount);
	})());
}
Promise.all(promises).then((counts) => {
	const total = document.querySelector('td.total');
	total.innerText = counts.reduce((a, b) => a + b, 0) + ' / ' + total.innerText;
});
