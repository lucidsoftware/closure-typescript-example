goog.provide('Message');

/**
 * @constructor
 * @param {string} message
 */
var Message = function(message) {
	/** @private {string} */
	this.message = message;
}

/**
 * @return {string}
 */
Message.prototype.getMessage = function() {
	return this.message;
}

/**
 * @param {string} message
 * @return {string}
 */
Message.prototype.setMessage = function(message) {
	this.message = message;
}