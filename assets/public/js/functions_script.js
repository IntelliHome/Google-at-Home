(function(window, $, undefined) {

    $(document).ready(function() {
        var $command = $('.command');
        var $tileDetail = $('.tile-detail');
        var $table = $('table');
        var $gpioPopover = $('.gpio-tags,.gpio-pins');
        var $addButton = $('#add-gpio,#add-node,#add-room,.add-tag');
        $command.click(function() {
            var $commandPost = $.post($(this).attr("data-post"), function(data) {
                $(this).toggleClass("tile-status-off", data.result);
            }, "json");
        });
        $tileDetail.click(function() {
            window.location.href = $(this).attr("data-post");
        });
        $table.on('click', '.delete-' + $(this).attr("data-type"), function() {
            $.post("/delete-" + $(this).attr("data-type") + "/" + $(this).parent().parent().attr("id"), function(data) {
                $(this).parent().parent().remove();
            }, "json");
        });
        $gpioPopover.popover({
            html: true,
            title: function() {
                return $(this).parent().find('.popover-' + $(this).attr('data-poptype')).find('.head').html();
            },
            content: function() {
                return $(this).parent().find('.popover-' + $(this).attr('data-poptype')).find('.content').html();
            },
            container: 'body',
            placement: 'bottom'
        });
        $addButton.click(function() {
            $("#" + $(this).attr('data-action') + "-spinner").addClass('fa fa-spinner fa-spin');
            $("form#" + $(this).attr('data-action') + "-form").submit(function(event) {
                $.post($(this).attr('data-action') + '/', $("form#" + $(this).attr('data-action') + "-form").serialize(), function(data) {
                        $("#" + $(this).attr('data-action') + "-spinner").removeClass('fa fa-spinner fa-spin');
                        $("#" + $(this).attr('data-action') + "-box").modal('hide').each(function() {
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