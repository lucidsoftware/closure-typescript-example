/**
 * @constructor
 */
var Zone = function(){};

/** @type {Zone} */
Zone.prototype.parent;

/** @type {string} */
Zone.prototype.name;

/**
 * Returns a value associated with the `key`.
 *
 * If the current zone does not have a key, the request is delegated to the parent zone. Use
 * [ZoneSpec.properties] to configure the set of properties asseciated with the current zone.
 *
 * @param {?} key The key to retrieve.
 * @return {?} Tha value for the key, or `undefined` if not found.
 */
Zone.prototype.get = function(key){};

/**
 * Returns a Zone which defines a `key`.
 *
 * Recursively search the parent Zone until a Zone which has a property `key` is found.
 *
 * @param {string} key The key to use for identification of the returned zone.
 * @returns {Zone} The Zone which defines the `key`, `null` if not found.
 */
Zone.prototype.getZoneWith = function(key){};

/**
 * Used to create a child zone.
 *
 * @param {?} zoneSpec A set of rules which the child zone should follow.
 * @return {Zone} A new child zone.
 */
Zone.prototype.fork = function(zoneSpec){};

/**
 * Wraps a callback function in a new function which will properly restore the current zone upon
 * invocation.
 *
 * The wrapped function will properly forward `this` as well as `arguments` to the `callback`.
 *
 * Before the function is wrapped the zone can intercept the `callback` by declaring
 * [ZoneSpec.onIntercept].
 *
 * @param {?} callback the function which will be wrapped in the zone.
 * @param {string} source A unique debug location of the API being wrapped.
 * @return {?} A function which will invoke the `callback` through [Zone.runGuarded].
 */
Zone.prototype.wrap = function(callback, source) {};

/**
 * Invokes a function in a given zone.
 *
 * The invocation of `callback` can be intercepted be declaring [ZoneSpec.onInvoke].
 *
 * @param {?} callback The function to invoke.
 * @param {?=} applyThis
 * @param {?=} applyArgs
 * @param {string=} source A unique debug location of the API being invoked.
 * @return {?} Value from the `callback` function.
 */
Zone.prototype.run = function(callback, applyThis, applyArgs, source) {};

/**
 * Invokes a function in a given zone and catches any exceptions.
 *
 * Any exceptions thrown will be forwarded to [Zone.HandleError].
 *
 * The invocation of `callback` can be intercepted be declaring [ZoneSpec.onInvoke]. The
 * handling of exceptions can intercepted by declaring [ZoneSpec.handleError].
 *
 * @param {?} callback The function to invoke.
 * @param {?=} applyThis
 * @param {?=} applyArgs
 * @param {string=} source A unique debug location of the API being invoked.
 * @return {?} Value from the `callback` function.
 */
Zone.prototype.runGuarded = function(callback, applyThis, applyArgs, source) {};

/**
 * Execute the Task by restoring the [Zone.currentTask] in the Task's zone.
 *
 * @param {?} task
 * @param {?=} applyThis
 * @param {?=} applyArgs
 * @return {?}
 */
Zone.prototype.runTask = function(task, applyThis, applyArgs) {};

/**
 * @param  {string} source
 * @param  {?} callback
 * @param  {?=} data
 * @param  {?=} customSchedule
 * @return {?}
 */
 Zone.prototype.scheduleMicroTask = function(source, callback, data, customSchedule) {};

/**
 * @param  {string} source
 * @param  {?} callback
 * @param  {?} data
 * @param  {?} customSchedule
 * @return {?}
 */
Zone.prototype.scheduleMacroTask = function(source, callback, data, customSchedule, customCancel) {};


/**
 * @param  {string} source
 * @param  {?} callback
 * @param  {?} data
 * @param  {?} customSchedule
 * @param  {?} customCancel
 * @return {?}
 */
Zone.prototype.scheduleEventTask = function(source, callback, data, customSchedule, customCancel) {};

/**
 * @param  {?} task
 * @return {?}
 */
Zone.prototype.cancelTask = function(task) {};

/**
 * @constructor
 */
var ZoneType = function(){};

/** @type {Zone} */
ZoneType.prototype.current;

/** @type {Task} */
ZoneType.prototype.currentTask;

/** @return {?} */
ZoneType.prototype.assertZonePatched = function(){};

/**
 * @constructor
 */
var ZoneSpec = function(){};

/** @type {string} */
ZoneSpec.prototype.name;

/** @type {?} */
ZoneSpec.prototype.properties;

/**
 * Allows the interception of zone forking.
 *
 * When the zone is being forked, the request is forwarded to this method for interception.
 *
 * @param {ZoneDelegate} parentZoneDelegate Delegate which performs the parent [ZoneSpec] operation.
 * @param {Zone} currentZone The current [Zone] where the current interceptor has beed declared.
 * @param {Zone} targetZone The [Zone] which originally received the request.
 * @param {ZoneSpec} zoneSpec The argument passed into the `fork` method.
 * @return {Zone}
 */
ZoneType.prototype.onFork = function(parentZoneDelegate, currentZone, targetZone, zoneSpec){};

/**
 * Allows interception of the wrapping of the callback.
 *
 * @param {ZoneDelegate} parentZoneDelegate Delegate which performs the parent [ZoneSpec] operation.
 * @param {Zone} currentZone The current [Zone] where the current interceptor has beed declared.
 * @param {Zone} targetZone The [Zone] which originally received the request.
 * @param {?} delegate The argument passed into the `warp` method.
 * @param {string} source The argument passed into the `warp` method.
 * @return {?}
 */
ZoneType.prototype.onIntercept = function(parentZoneDelegate, currentZone, targetZone, delegate, source){};

/**
 * Allows interception of the callback invocation.
 *
 * @param {ZoneDelegate} parentZoneDelegate Delegate which performs the parent [ZoneSpec] operation.
 * @param {Zone} currentZone The current [Zone] where the current interceptor has beed declared.
 * @param {Zone} targetZone The [Zone] which originally received the request.
 * @param {?} delegate The argument passed into the `run` method.
 * @param {?} applyThis The argument passed into the `run` method.
 * @param {?} applyArgs The argument passed into the `run` method.
 * @param {string} source The argument passed into the `run` method.
 * @return {?}
 */
ZoneType.prototype.onInvoke = function(parentZoneDelegate, currentZone, targetZone, delegate, applyThis, applyArgs, source){};

/**
 * Allows interception of the error handling.
 *
 * @param {ZoneDelegate} parentZoneDelegate Delegate which performs the parent [ZoneSpec] operation.
 * @param {Zone} currentZone The current [Zone] where the current interceptor has beed declared.
 * @param {Zone} targetZone The [Zone] which originally received the request.
 * @param {?} error The argument passed into the `handleError` method.
 * @return {boolean}
 */
ZoneType.prototype.onHandleError = function(parentZoneDelegate, currentZone, targetZone, error){};

/**
 * Allows interception of task scheduling.
 *
 * @param {ZoneDelegate} parentZoneDelegate Delegate which performs the parent [ZoneSpec] operation.
 * @param {Zone} currentZone The current [Zone] where the current interceptor has beed declared.
 * @param {Zone} targetZone The [Zone] which originally received the request.
 * @param {Task} task The argument passed into the `scheduleTask` method.
 * @return {Task}
 */
ZoneType.prototype.onScheduleTask = function(parentZoneDelegate, currentZone, targetZone, task){};

/**
 * Allows interception of task scheduling.
 *
 * @param {ZoneDelegate} parentZoneDelegate Delegate which performs the parent [ZoneSpec] operation.
 * @param {Zone} currentZone The current [Zone] where the current interceptor has beed declared.
 * @param {Zone} targetZone The [Zone] which originally received the request.
 * @param {?} task The argument passed into the `scheduleTask` method.
 * @param {?} applyArgs
 * @return {?}
 */
ZoneType.prototype.onInvokeTask = function(parentZoneDelegate, currentZone, targetZone, task, applyThis, applyArgs){};

/**
 * Allows interception of task cancelation.
 *
 * @param {ZoneDelegate} parentZoneDelegate Delegate which performs the parent [ZoneSpec] operation.
 * @param {Zone} currentZone The current [Zone] where the current interceptor has beed declared.
 * @param {Zone} targetZone The [Zone] which originally received the request.
 * @param {Task} task The argument passed into the `cancelTask` method.
 * @return {?}
 */
ZoneType.prototype.onCancelTask = function(parentZoneDelegate, currentZone, targetZone, task){};

/**
 * Notifies of changes to the task queue empty status.
 *
 * @param {ZoneDelegate} delegate Delegate which performs the parent [ZoneSpec] operation.
 * @param {Zone} current The current [Zone] where the current interceptor has beed declared.
 * @param {Zone} target The [Zone] which originally received the request.
 * @param {HasTaskState} hasTaskState
 */
ZoneType.prototype.onHasTask = function(delegate, current, target, hasTaskState){};

/**
 * @constructor
 */
var ZoneDelegate = function(){};

/** @type {Zone} */
ZoneDelegate.prototype.zone;

/**
 * @param  {Zone} targetZone
 * @param  {ZoneSpec} zoneSpec
 * @return {Zone}
 */
ZoneDelegate.prototype.fork = function(targetZone, zoneSpec){};

/**
 * @param  {Zone} targetZone
 * @param  {ZoneSpec} callback
 * @param  {ZoneSpec} source
 * @return {?}
 */
ZoneDelegate.prototype.intercept = function(targetZone, callback, source){};

/**
 * @param  {Zone} targetZone
 * @param  {?} callback
 * @param  {?} applyThis
 * @param  {?} applyArgs
 * @param  {string} source
 * @return {?}
 */
ZoneDelegate.prototype.invoke = function(targetZone, callback, applyThis, applyArgs, source){};

/**
 * @param  {Zone} targetZone
 * @param  {?} error
 * @return {boolean}
 */
ZoneDelegate.prototype.handleError = function(targetZone, error){};

/**
 * @param  {Zone} targetZone
 * @param  {Task} task
 * @return {Task}
 */
ZoneDelegate.prototype.scheduleTask = function(targetZone, task){};

/**
 * @param  {Zone} targetZone
 * @param  {Task} task
 * @param  {?} applyThis
 * @param  {?} applyArgs
 * @return {?}
 */
ZoneDelegate.prototype.invokeTask = function(targetZone, task, applyThis, applyArgs){};

/**
 * @param  {Zone} targetZone
 * @param  {Task} task
 * @return {?}
 */
ZoneDelegate.prototype.cancelTask = function(targetZone, task){};

/**
 * @param  {Zone} targetZone
 * @param  {HasTaskState} isEmpty
 */
ZoneDelegate.prototype.hasTask = function(targetZone, isEmpty){};

/**
 * @typedef {{
 *	microTask: boolean,
 *	macroTask: boolean,
 * 	eventTask: boolean,
 *	change: TaskType
 * }}
 */
var HasTaskState;

/** @typedef {string} */
var TaskType;

/**
 * @constructor
 */
var TaskData = function(){};

/** @type {boolean} */
TaskData.prototype.isPeriodic;

/** @type {number} */
TaskData.prototype.delay;

/** @type {?number} */
TaskData.prototype.handleId;

/**
 * @constructor
 */
var Task = function(){};

/** @type {?} */
Task.prototype.type;

/** @type {string} */
Task.prototype.source;

/** @type {?} */
Task.prototype.invoke;

/** @type {?} */
Task.prototype.callback;

/** @type {TaskData} */
Task.prototype.data;

/** @type {?} */
Task.prototype.scheduleFn;

/** @type {?} */
Task.prototype.cancelFn;

/** @type {Zone} */
Task.prototype.zone;

/** @type {number} */
Task.prototype.runCount;

/**
 * @constructor
 */
var MicroTask = function(){};
/**
 * @constructor
 */
var MacroTask = function(){};
/**
 * @constructor
 */
var EventTask = function(){};