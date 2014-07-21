(function (window, $, undefined) {

	$(document).ready(function() {
		var $container = $('.iso,#iso');

        // Fire Isotope only when images are loaded
    	$container.imagesLoaded(function(){
        	$container.isotope({
            	itemSelector : '.post',
           		masonry: {
                	isFitWidth: true,
           		}
        	});
    	});
    	$("[rel='tooltip']").tooltip();
    	$('.tile_detail').hammer({}).on("tap", function(event) {
        	if ( $(this).find('.caption').is( ":hidden" ) ) {
            	$(this).find('.caption').slideDown( 250 );
         	} else {
            	$(this).find('.caption').slideUp( 250 );
         	}
    	});
    	$('.tile_detail').hover(function(){
            $(this).find('.caption').slideDown(250);
        	},
        	function(){
            	$(this).find('.caption').slideUp(250);
        	}
    	);
	});
})(window, jQuery);