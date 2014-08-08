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
            /* TODO: Open Node box to insert new gpio */
        });
        $('#fancyClock').tzineClock();
    });
})(window, jQuery);