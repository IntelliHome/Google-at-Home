$(document).ready(function() {
        var $container = $('.iso,#iso');

        // Fire Isotope only when images are loaded
        $container.imagesLoaded(function(){
            $container.isotope({
                itemSelector : '.alert',
                masonry: {
                    //columnWidth: '.col-md-4',
                    isFitWidth: true,
                    gutter: 20
                }
            });
        });

        // Infinite Scroll
        $('.iso,#iso').infinitescroll({
            navSelector  : 'div.pagination',
            nextSelector : 'div.pagination a:first',
            itemSelector : '.alert',
            bufferPx     : 200,
            loading: {
                finishedMsg: 'We\'re done here.',
                            //img: +templateUrl+'ajax-loader.gif'
            }
        },

        // Infinite Scroll Callback
        function( newElements ) {
            var $newElems = jQuery( newElements ).hide();
            $newElems.imagesLoaded(function(){
                $newElems.fadeIn();
                $container.isotope( 'appended', $newElems );
            });
        });
});