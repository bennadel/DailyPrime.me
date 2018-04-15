
// Require core modules.
var express = require( "express" );
var expressHandlebars = require( "express-handlebars" );
var DogStatsD = require( "hot-shots" );
var os = require( "os" );
var path = require( "path" );

// Require our application modules.
var mainRouter = require( "./subsystems/main/controllers/main" );

// ----------------------------------------------------------------------------------- //
// ----------------------------------------------------------------------------------- //

// Define some common server-side paths.
var clientPath = path.join( __dirname, "..", "client" );
var subsystemsPath = path.join( __dirname, "subsystems" );

// Create our DogStatsD client.
var statsd = new DogStatsD({
	host: process.env.DOGSTATSD_HOST,
	port: process.env.DOGSTATSD_PORT,
	errorHandler: function ( error ) {

		console.log(
			JSON.stringify({
				log_level: "error",
				error: error
			})
		);

	}
});

var app = express();

// Setup the view rendering engine. The paths for the views, partials, and layouts will
// all be relative to the "subsystems" directory.
app.set( "view engine", "handlebars" );
app.set( "views", subsystemsPath );
app.engine(
	"handlebars",
	expressHandlebars({
		layoutsDir: subsystemsPath,
		partialsDir: subsystemsPath
	})
);

// Setup the global middleware.
app.use(
	function ( request, response, next ) {

		// Experimenting with StatsD collection inside Docker.
		statsd.increment( "page_request" );

		response.set( "X-Host-Name", os.hostname() );
		next();

	}
);

// Setup the static assets route handling.
app.use(
	"/assets",
	express.static( path.join( clientPath, "assets" ) )
);

// Setup the controllers.
app.use( mainRouter );

// ----------------------------------------------------------------------------------- //
// ----------------------------------------------------------------------------------- //

var port = ( process.env.PORT || 8080 );

// Wire the Expression application to an exposed port so that it can start
// receiving traffic.
app.listen(
	port,
	function () {
		
		console.log( "Express server has bootstrapped on port:", port );

	}
);
