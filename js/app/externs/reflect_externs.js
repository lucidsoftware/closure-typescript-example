/**
 * define metadata on an object or property
 * @param {?} metadataKey
 * @param {?} metadataValue
 * @param {?} target
 * @param {?=} propertyKey
 */
Reflect.prototype.defineMetadata = function(metadataKey, metadataValue, target, propertyKey) {};

/**
 * check for presence of a metadata key on the prototype chain of an object or property
 * @param {?} metadataKey
 * @param {?} target
 * @param {?=} propertyKey
 * @return {?}
 */
Reflect.prototype.hasMetadata = function(metadataKey, target, propertyKey){};

/**
 * check for presence of an own metadata key of an object or property
 * @param {?} metadataKey
 * @param {?} target
 * @param {?=} propertyKey
 * @return {?}
 */
Reflect.prototype.hasOwnMetadata = function(metadataKey, target, propertyKey){};

/**
 * get metadata value of a metadata key on the prototype chain of an object or property
 * @param {?} metadataKey
 * @param {?} target
 * @param {?=} propertyKey
 */
Reflect.prototype.getMetadata = function(metadataKey, target, propertyKey){};

/**
 * get metadata value of an own metadata key of an object or property
 * @param {?} metadataKey
 * @param {?} target
 * @param {?=} propertyKey
 * @return {?}
 */
Reflect.prototype.getOwnMetadata = function(metadataKey, target, propertyKey){};

/**
 * get all metadata keys on the prototype chain of an object or property
 * @param {?} target
 * @param {?=} propertyKey
 * @return {?}
 */
Reflect.prototype.getMetadataKeys = function(target, propertyKey){};

/**
 * get all own metadata keys of an object or property
 * @param {?} target
 * @param {?=} propertyKey
 * @return {?}
 */
Reflect.prototype.getOwnMetadataKeys = function(target, propertyKey){};

/**
 * delete metadata from an object or property
 * @param {?} metadataKey
 * @param {?} target
 * @param {?=} propertyKey
 */
Reflect.prototype.deleteMetadata = function(metadataKey, target, propertyKey){};

/**
 * apply metadata via a decorator to a constructor
 * @param {?} metadataKey
 * @param {?} metadataValue
 */
Reflect.prototype.metadata = function(metadataKey, metadataValue){};

/**
  * Applies a set of decorators to a property of a target object.
  * @param {?} decorators An array of decorators.
  * @param {?=} target The target object.
  * @param {?=} targetKey (Optional) The property key to decorate.
  * @param {?=} targetDescriptor (Optional) The property descriptor for the target key
  * @return {?}
  */
Reflect.prototype.decorate = function(decorators, target, targetKey, targetDescriptor){};