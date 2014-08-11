(function(window, $, undefined) {

    $(document).ready(function() {
        var $room = $('.room');
        var $container = $('.iso,#iso').isotope({
            itemSelector: '.tile-item',
            layoutMode: 'fitRows',
            getSortData: {
                name: '.name',
                pinNumber: '.pin-number',
                room: '[data-room]',
                tag: '[data-tag]'
            },
            masonry: {
                isFitWidth: true,
            }
        });
        $room.click(function() {
            $container.isotope({
                filter: "." + $(this).attr('id')
            });
        });
        $('#searchString').keyup(function(e) {
            clearTimeout($.data(this, 'timer'));
            if (e.keyCode == 13) {
                var myFilterValue = search(true);
                if (myFilterValue) {
                    $container.isotope({
                        filter: 'div.tile-item[data-tag="' + myFilterValue + '"]'
                    });
                }
            } else {
                $(this).data('timer', setTimeout(search, 500));
            }
        });

        function search(force) {
            var $existingString = $("#searchString").val();
            if (!force && $existingString.length < 3) return; //wasn't enter, not > 2 char
            $existingString = $existingString.toLowerCase();
            var $name = $(this).find('.name').text();
            var regex = new RegExp($existingString, 'g');
            return name.match(regex);
        }
    });
})(window, jQuery);