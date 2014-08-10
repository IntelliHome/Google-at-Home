(function(window, $, undefined) {

    $(document).ready(function() {
        var $command = $('.command');
        var $tileDetail = $('.tile-detail');
        var $nodeDelete = $('.node-delete');
        var $gpioDelete = $('.gpio-delete');
        var $gpioTags = $('.gpio-tags');
        var $gpioPins = $('.gpio-pins');
        var $gpioAdd = $('#add-gpio');
        var $nodeAdd = $('#add-node');
        $command.click(function() {
            var $commandPost = $.post($(this).attr("data-post"), function(data) {
                $(this).toggleClass("tile-status-off", data.result);
            }, "json");
        });
        $tileDetail.click(function() {
            window.location.href = this.attr("data-post");
        });
        $nodeDelete.click(function() {
            var $nodeDeletePost = $.post("/delete-node/" + $(this).attr("id"), function(data) {
                $("tr.node#" + $(this).attr("id")).remove();
            }, "json");
        });
        $gpioDelete.click(function() {
            var $gpioDeletePost = $.post("/delete-gpio/" + $(this).attr("id"), function(data) {
                $("tr.gpio#" + $(this).attr("id")).remove();
            }, "json");
        });
        $gpioTags.click(function() {
            /* TODO: Open tags editable ( attr id as reference)*/
        });
        $gpioPins.click(function() {
            /* TODO: Open pin editable ( attr id as reference) */
        });
        $gpioAdd.click(function() {
            /* TODO: Open GPIO box to insert new gpio */
        });
        $nodeAdd.click(function() {
            $("#add-node-spinner").addClass('fa fa-spinner fa-spin');
            $( "form#add-node-form" ).submit(function( event ) {
                $.post( 'add-node/', $('form#add-node-form').serialize(), function(data) {
                            $("#add-node-spinner").removeClass('fa fa-spinner fa-spin');
                            $("#node-box").modal('hide').each(function() {
                                    this.reset();
                                });
                        },
                        'json' // JSON response
                    );
                event.preventDefault();
            });
        });
        $('#fancyClock').tzineClock();
    });
})(window, jQuery);