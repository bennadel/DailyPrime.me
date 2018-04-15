
// Require core modules.
var express = require( "express" );

// Require our application modules.
var videos = require( "../../../libs/videos" );

// ----------------------------------------------------------------------------------- //
// ----------------------------------------------------------------------------------- //

var router = module.exports = express.Router();

// Homepage route.
router.get(
	"/",
	function ( request, response, next ) {

		var video = videos[ Math.floor( Math.random() * videos.length ) ];

		response.render(
			"main/views/home",
			{
				layout: "main/layouts/main",
				video: video
			}
		);

	}
);

// Video detail route.
router.get(
	"/primers/:slug",
	function ( request, response, next ) {

		var video = videos.find(
			( video ) => {

				return( video.id === request.params.slug );

			}
		);

		if ( ! video ) {

			throw( new Error( "NotFound" ) );

		}

		response.render(
			"main/views/detail",
			{
				layout: "main/layouts/main",
				video: video
			}
		);

	}
);

// Video list route.
router.get(
	"/primers",
	function ( request, response, next ) {

		response.render(
			"main/views/list",
			{
				layout: "main/layouts/main",
				videos: videos
			}
		);

	}
);

// Robots route.
router.get(
	"/robots.txt",
	function ( request, response, next ) {

		response.header( "Content-Type", "text/plain" );
		response.render(
			"main/views/robots",
			{
				layout: false
			}
		);

	}
);

// Fall-through Not-Found handler.
router.use(
	function ( request, response, next ) {

		throw( new Error( "NotFound" ) );

	}
);

// Error handler.
router.use(
	function ( error, request, response, next ) {

		if ( error.message === "NotFound" ) {

			response.status( 404 );
			response.render(
				"main/views/404.handlebars",
				{
					layout: "main/layouts/main"
				}
			);
			return;

		}

		console.log(
			JSON.stringify({
				error: {
					message: error.message,
					stack: error.stack
				}
			})
		);

		response.status( 500 );
		response.render(
			"main/views/500.handlebars",
			{
				layout: "main/layouts/main"
			}
		);

	}
);
