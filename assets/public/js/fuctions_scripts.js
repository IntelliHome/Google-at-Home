(function (window, $, undefined) {

	$(document).ready(function() {
        var $command = $('.command');
        var $tileDetail = $('.tile-detail');
        $command.click(function() {
            var $commandPost = $.post($(this).attr("data-post"),function( data ) {
                    $( this ).toggleClass( "tile-status-on", data.result );
                }, "json");
        });
        $tileDetail.click(function() {
            window.location.href = this.attr("data-post");
        });
	});
})(window, jQuery);