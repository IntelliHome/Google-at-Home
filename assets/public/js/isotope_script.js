(function (window, $, undefined) {

	$(document).ready(function() {
        var $room = $('.room');
        var $container = $('.iso,#iso').isotope({
            itemSelector: '.tile-item',
            layoutMode: 'fitRows',
            getSortData: {
                name: '.name',
                pinNumber: '.pin-number',
                room: '[data-room]',
                tag:'[data-tag]'
            },
            masonry: {
                isFitWidth: true,
            }
        });
        $room.click(function() {
            $container.isotope({ filter: $( this ).attr('id') });
        });
	});
})(window, jQuery);