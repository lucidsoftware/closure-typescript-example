#!/usr/bin/env node

goog.provide('main');

goog.require('Message');
goog.require('js.app.ts.greeter');

var main = function() {
	var greeter = goog.module.get('js.app.ts.greeter');

	/** @type {greeter.Greeter} */
	var myGreeter = new greeter.Greeter(new Message('hello world!'));

	/** @type {string} */
	var greeting = myGreeter.greet();

	console.log(greeting);
}

main();
