// 1
var http = require('http'),
    express = require('express'),
    path = require('path'),
    MongoClient = require('mongodb').MongoClient,
    Server = require('mongodb').Server,
    CollectionDriver = require('./collectionDriver').CollectionDriver;

// Creates an Express app and sets its port to 3000 by default.
// You can overwrite this default by creatin and environment variable
// named PORT. This customization is very handy; it allows you
// to have applications that listen on multiple ports.
var app = express();
app.set('port', process.env.PORT || 3000);

// Set up Jade
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

// This tells Express to parse the incoming body data; if it's JSON, then
// create a JSON object with it. By putting this call first, the body
// parsing will be called before the other route handlers. This way
// req.body can be passed directly to the driver code as a JavaScript
// object.
app.use(express.bodyParser());

// Line A below assumes the MongoDB instance is running locally on the
// default port of 27017. If you ever run a MongoDb server elsewhere
// you'll have to modify these values, but leave them as-is for this
// tutorial.
//
// Line B creates a new MongoClient and the call to open in line C
// attempts to establish a connection. If your connection attempt
// fails, it is most likely because you haven't yet started your
// MongoDB server. In the absence of a connection, the app exists
// at line D.
//
// If the client does connect, it opens the MyDatabase database at
// line E. A MongoDB instance can contain multiple databases, all
// which have unique namespaces and uniue data. Finally, you create
// the CollectionDriver object in line F and pass in a handle to the
// MongoDB client.
var mongoHost = 'localHost'; // A
var mongoPort = 27017;
var collectionDriver;

var mongoClient = new MongoClient(new Server(mongoHost, mongoPort)); // B
mongoClient.open(function(err, mongoClient) { // C
    if (!mongoClient) {
        console.error("Error! Exiting... Must start MongoDB first");
        process.exit(1); // D
    }
    var db = mongoClient.db("MyDatabase"); // E
    collectionDriver = new CollectionDriver(db); // F
});

// Tells Express to use the middleware express.static which serves up
// static files in response to incoming requests.
//
// path.join(__dirname, 'public') maps the local subfolder public to
// the base route /; it uses the NOde.js path module to create a
// platform-independent subfolder string. Using the static handler,
// anything in /public can be accessed by name.
app.use(express.static(path.join(__dirname, 'public')));

// Tells Express to match the root "/" and return the given
// HTML in the response. send formats the various response
// headers for you — such as content-type and status code —
// so you can focus on writing great code instead.
// app.get('/', function (req, res) {
//     res.send('<html><body><h1>Hello World</h1></body></html>')
// });

// The two app.get statements below creates two new routes: /:collection
// and /:collection/:entity. These call the collectionDriver.findAll and
// collectionDriver.get methods respectfully and return either the JSON
// objects or objects, an HTML document, or an error depending on the
// result.
//
// When you define the /collection route in Expres it will match "collection"
// exactly. However, if you define the route as /:collection as in Line A.,
// then it will match any first-level path storing the requested name in the
// req.params collection in line B. In this case, you define the endpoint to
// match any URL to a MongoDB collection using findAll of CollectionDriver
// in line C.
//
// If the fetch is successful, then the code checks if the request specifies
// that it accepts an HTML result in the header at line E. If so, line F stores
// the rendered HTML from the data.jade template in response. This simply
// presents the contents of the collection in an HTML table.
//
// By default, web browsers specify that they accept HTML in their requests.
// When other types of clients request this endpoint such as iOS apps using
// NSURLSession, this method instead returns a machine-parsable JSON document
// at line G. res.send() returns a success code along with the JSON document
// generated by the collection driver at line H.
//
// In the case where a two-level URL path is specified, line I treats this as
// a collection name and entity _id. You then request teh specific entity
// using the get() collectionDriver's method in line J. If that entity is found,
// you return it as JSON document at line K.
app.get('/:collection', function(req, res) { //A
   var params = req.params; //B
   collectionDriver.findAll(req.params.collection, function(error, objs) { //C
    	  if (error) { res.send(400, error); } //D
	      else {
	          if (req.accepts('html')) { //E
    	          res.render('data', {objects: objs, collection: req.params.collection}); //F
              } else {
	          res.set('Content-Type','application/json'); //G
                  res.send(200, objs); //H
              }
         }
   	});
});

app.get('/:collection/:entity', function(req, res) { // I
    var params = req.params;
    var entity = params.entity;
    var collection = params.collection;
    if ( entity ) {
        collectionDriver.get(collection, entity, function(error, obj) { // J
            if (error) {
                res.send(400, error);
            }
            else {
                res.send(200, objs); // K
            }
        });
    }
    else {
        res.send(400, {
            error: 'bad url',
            url: req.url
        });
    }
});

// This creates a new route for the POST verb at line A which inserts
// the body as an object into the specified collection by calling save()
// that you just added to your driver. Line B returns the success code of
// HTTP 201 when the resource is created.
app.post('/:collection', function(req, res) { // A
    var object = req.body;
    var collection = req.params.collection;
    collectionDriver.save(collection, object, function(err, docs) {
        if (err) {
            res.send(400,err);
        }
        else {
            res.send(201, docs); // B
        }
    });
});

// The put callback follows the same pattern as the single-entity get:
// you match on the collection name and _id as shown in line A. Like
// the post route, put passes the JSON object from the body to the new
// collectionDriver's update() method in line B
//
// The updated object is returned in the response (line C), so the client
// can resolve and fields updated by the server such as updated_at.
app.put('/:collection/:entity', function(req, res) { // A
    var params = req.params;
    var entity = params.entity;
    var collection = params.collection;

    if (entity) {
        collectionDriver.update(collection, req.body, entity, function(error, objs) { // B
            if (error) {
                res.send(400, error);
            }
            else {
                res.send(200, objs); // C
            }
        });
    }
    else {
        var error = { "message" : "Cannot PUT a whole collection" };
        res.send(400, error);
    }
});

// The delete endpoint is very similar to put as shown by line A except that
// delete doesn't require a body. You pass the parameters to collectionDriver's
// delete() method at line B, and if the delete operation aws succesfsul then
// you return the original object with a response code of 200 at line C.
app.delete('/:collection/:entity', function(req, res) { // A
    var params = req.params;
    var entity = params.entity;
    var collection = params.collection;
    if (entity) {
        collectionDriver.delete(collection, entity, function(error, objs) { // B
            if (error) {
                res.send(400, error);
            }
            else {
                res.send(200, objs); // C 200 b/c includes original document
            }
        });
    }
    else {
        var error = { "message" : "Cannot DELETE a whole collection" };
        res.send(400, error);
    }
});

// Error handling
//
// app.use matches ALL requests. When placed at the end of the list
// of app.use and app.verb statements, this callback becomes a
// catch-all
//
// The call to res.render(view, params) fill sthe response body
// with output rendered from a templating engine. A templating
// engine takes a template file called a "view" from disk and
// replaces variables with a set of key-value parameters to
// produce a new document.
app.use(function (req, res) { // 1
    res.render('404', {url:req.url}); // 2, parameters inside { }
});

// This creates a new route which takes up to three path levels and
// displays those path components in the response body. Anything
// that starts with a : is mapped to a request parameter of the
// supplied name.
// app.get('/:a?/:b?/:c?', function (req, res) {
//     res.send(req.params.a + ' ' + req.params.b + ' ' + req.params.c);
// });

// 2

// WITHOUT Express
// http.createServer(function (req, res) {
//     res.writeHead(200, {'Content-Type': 'text/html'});
//     res.end('<html><body><h1>Hello World</h1></body></html>');
// }).listen(3000);
//
// console.log('Server running on port 3000');

// WITH Express
//
// This is a little more compact than before. app implements the
// function(req,res) callback separately instead of including it
// inline here in the createServer call. You’ve also added a
// completion handler callback that is called once the port is
// open and ready to receive requests. Now your app waits for the
// port to be ready before logging the “listening” message to the
// console.
http.createServer(app).listen(app.get('port'), function() {
    console.log('Express server listening on port ' + app.get('port'));
});
