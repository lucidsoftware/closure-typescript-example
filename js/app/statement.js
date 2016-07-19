goog.provide('Statement');

/**
 * @constructor
 * @param {string} statement
 */
var Statement = function(statement) {
	/** @private {string} */
	this.statement = statement;
}

/**
 * @return {string}
 */
Statement.prototype.getStatement = function() {
	return this.statement;
}

/**
 * @param {string} statement
 * @return {string}
 */
Statement.prototype.setStatement = function(statement) {
	this.statement = statement;
}