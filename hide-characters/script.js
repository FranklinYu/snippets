String.prototype.escapeRegExp = function() {
	"use strict";

	return this.replace(/[\-\[\]\/{}()*+?.\\\^$|]/g, "\\$&");
};

(function() {
	'use strict';

	var CHARACTERS;
	var REGEX;
	$.getJSON('characters.json', (data) => { CHARACTERS = data }).done(() => {
		REGEX = new RegExp('[^' + Object.keys(CHARACTERS).join('').escapeRegExp() + ']');
		console.log(REGEX);
	});
	$(document).ready(() => { $('#generate-button').on('click', generate); });

	function generate() {
		var targetDigit = parseInt($('#target-digit').val());
		var text = $('#text').val().toLowerCase();

		if (CHARACTERS == undefined) {
			console.error('character set not available');
			return;
		}
		var error = errorMessage(targetDigit, text);
		if (error != null) {
			console.error(error);
			return;
		}

		var output = [];
		for (let i = 0; i < 6; ++i)
			output.push(randomDigitExcept(targetDigit));
		for (let char of text) {
			let bitmap = CHARACTERS[char];
			for (let i = 0; i < 6; ++i) {
				output[i] += (bitmap[i] + ' ')
					.split('')
					.map((pixel) => pixel == 'x' ? targetDigit : randomDigitExcept(targetDigit))
					.join('');
			}
		}
		$('#output').html(output.join('<br>'));
	}

	function errorMessage(digit, text) {
		if (isNaN(digit) || digit > 9 || digit < 0)
			return 'digit is ' + digit;
		var invalidCharacter = REGEX.exec(text);
		if (invalidCharacter != null)
			return 'invalid character' + invalidCharacter;
	}

	function randomDigitExcept(digit) {
		var n = Math.floor(Math.random() * 9); // 0 ~ 8
		if (n >= digit)
			++n;
		return n;
	}
})();
