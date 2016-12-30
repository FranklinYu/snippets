// ==UserScript==
// @name         M-Team bug fix
// @namespace    https://tp.m-team.cc/userdetails.php?id=161867
// @version      0.1.0
// @description  fix bug
// @author       Franklin Yu
// @include      https://tp.m-team.cc/usercp.php?action=personal
// @grant        none
// ==/UserScript==

{
    let textArea = document.getElementsByName("info")[0];
    textArea.value = textArea.value.replace(/&amp;/g, '&');
}
