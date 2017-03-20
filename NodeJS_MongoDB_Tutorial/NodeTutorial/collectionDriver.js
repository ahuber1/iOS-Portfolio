// Imports the various required packages. In this case, it's the
// ObjectID function from the MongoDB package
//
// NOTE: If you are familiar with traditional databases, you
// you probably understand the term "primary key". MongoDB has a
// similar concept: by default, new entities are assigned a unique
// _id field of datatype ObjectID that MongoDB uses for optimized
// lookup and insertion. Since ObjectID is a BSON type and not a
// JSON type, you'll have to convert any incoming strings to
// ObjectIDs if they are to be used when comparing against an "_id"
// field.
var ObjectID = require('mongodb').ObjectID;

// This function defined a CollectionDriver construction method;
// it stores a MongoDB client instance for later use.
CollectionDriver = function(db) {
    this.db = db;
};

// This section defines a helper method called getCollection to
// obtain a Mongo collection by name. You define class methods by
// adding functions to prototype.
//
// db.collection(name, callback) fetches the collection object
// and returns the collection (or an error) to the callback.
CollectionDriver.prototype.getCollection = function(collectionName, callback) {
    this.db.collection(collectionName, function(error, the_collection) {
        if ( error ) callback(error);
        else callback(null, the_collection);
    });
};

// CollectionDriver.prototype.findAll gets the collection in line
// A below, and if there is no error such as an inability to access
// the MongoDb server, it calls find() on it in line B above. This
// returns all of the found objects.
//
// find() returns a data cursor that can be used to iterate over the
// matching objects. find() can also accept a selector object to
// filter the results. toArray() organizes all the results in an
// array and passes it to the callback. This final callback then
// returns to the caller with either an error or all of the objects
// in the array.
CollectionDriver.prototype.findAll = function(collectionName, callback) {
    this.getCollection(collectionName, function(error, the_collection) { // A
        if ( error ) callback(error);
        else {
            the_collection.find().toArray(function(error, results) { // B
                if ( error ) callback(error);
                else callback(null, results);
            });
        }
    });
};

// In line A below, CollectionDriver.prototype.get obtains a single item
// from a collection by its _id. Similar to prototype.findAll method, this
// call first obtains the collection object then performs a findOne against
// the returned object. Since this matches the _id field, a find() or
// findOne() in this case, has to match it using the correct datatype.
//
// MongoDB stores _id fields as BSON type ObjectID. In line C above, ObjectID()
// (C) takes a string and turns it into a BSON ObjectID to match against the
// collection. However, ObjectID() is persnickety and requires the appropriate
// hex string or it will return an error: hence, the regex check up front in
// line B.
//
// This doesn't guarantee that there is a matching object with that _id, but it
// guarantees that ObjectID will be able to parse the string. The selector
// {'_id': ObjectID(id)} matches the _id field exactly against the supplied id.
//
// NOTE: Reading from a non-existant collection or entity is not an error; the
// MongoDB driver just returns an empty container.
CollectionDriver.prototype.get = function(collectionName, id, callback) { // A
    this.getCollection(collectionName, function(error, the_collection) {
        if ( error ) callback(error);
        else {
            var checkForHexRegExp = new RegExp("^[0-9a-fA-F]{24}$"); // B
            if (!checkForHexRegExp.test(id)) callback( { error: "invalid id" } );
            else  the_collection.findOne( { '_id' : ObjectID(id) }, function(error, doc) { // C
                if ( error ) callback(error);
                else callback(null, doc);
            });
        }
    });
};

// Like findAll and get, save first retrieves the collection object at line A.
// The callback then takes the supplied entity and adds a field to record the
// date it was crated at line B. Finally, you insert the modified object into
// the collection at line C. insert automatically adds _id to the object as well.
CollectionDriver.prototype.save = function(collectionName, obj, callback) {
    this.getCollection(collectionName, function(error, the_collection) { // A
        if (error) callback(error)
        else {
            obj.created_at = new Date(); // B
            the_collection.insert(obj, function() { // C
                callback(null, obj);
            });
        }
    });
};

// update() function takes an object and updates it in the collection using
// collectionDriver's save() method in line C. This assumes that the body's
// _id is the same as specified in the route at line A. Line B adds an
// updated_at field with the time the object is modified. Adding a
// modification timestamp is a food idea for understaning how changes
// later in your application's lifestyle.
//
// Note that this update operation replaces whatever was in there before with
// a new object; there is no property-level updating supported.
CollectionDriver.prototype.update = function(collectionName, obj, entityId, callback) {
    this.getCollection(collectionName, function(error, the_collection) {
        if (error) callback(error);
        else {
            obj._id = ObjectID(entityId); // A convert to a real obj id
            obj.upated_at = new Date();
            the_collection.save(obj, function(error, doc) { // C
                if (error) callback(error);
                else callback(null, obj);
            });
        }
    });
};

// delete() operates the same way as the other CRUD methods. It fetches the
// collection object in line A then calls remove() with the supplied id in
// line B.
CollectionDriver.prototype.delete = function(collectionName, entityId, callback) {
    this.getCollection(collectionName, function(error, the_collection) { // A
        if (error) callback(error);
        else {
            the_collection.remove( { '_id':ObjectID(entityId)}, function(error, doc) { // B
                if (error) callback(error);
                else callback(200, doc); // changed this to status 200
            });
        }
    });
};

// This line declares the exposed, or exported, entityies to other applications
// that list collectionDriver.js as a required module.
exports.CollectionDriver = CollectionDriver;
