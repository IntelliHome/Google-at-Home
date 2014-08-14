(function(window, $, undefined) {

    $(document).ready(function() {
        var $command = $('.command');
        var $tileDetail = $('.tile-detail');
        var $body = $('body');
        var $gpioPopover = $('.gpio-tags,.gpio-pins');
        $command.click(function() {
            var $commandPost = $.post($(this).attr("data-post"), function(data) {
                $(this).toggleClass("tile-status-off", data.result);
            }, "json");
        });
        $tileDetail.click(function() {
            window.location.href = $(this).attr("data-post");
        });
        $body.on('click', '.delete-row', function() {
            alert("/delete-" + $(this).attr("data-type") + "/" + $(this).parent().parent().attr("id"));
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
            placement: 'right'
        });
        $body.on('click', '.modal-add', function() {
            var $thisButton = $(this);
            var buttonText = $(this).children('span').text();
            $thisButton.attr('disabled', 'disabled');
            $thisButton.children('span').text("  Loading...");
            $thisButton.children('i').addClass('fa fa-spinner fa-spin');
            alert($thisButton.parent().parent(".form-data-body").find('form').serialize());
            var $thisForm = $thisButton.parent().parent(".form-data-body").find('form');
            $.post($thisButton.attr('data-action') + '/', $thisForm.serialize(), function(data) {
                    $thisButton.removeAttr('disabled');
                    $thisButton.children('span').text(buttonText);
                    $thisButton.children('i').removeClass('fa fa-spinner fa-spin');
                    $thisForm.each(function() {
                        this.reset();
                    });
                    if ($thisButton.hasClass('is-popover')) {
                        $thisButton.parent(".form-data-body").hide('fast');
                    } else {
                        $thisButton.parent(".modal").modal("hide");
                    }
                },
                'json' // JSON response
            );
        });
        $body.on('click','.popover-form-open',function(){
            $(this).fadeOut('fast');
            $(this).parent('.popover-content').find(".form-data-body").fadeIn("fast").toggleClass('hide');
        });
        $body.on('click','.popover-form-close',function(){
            $(this).parent().parent(".form-data-body").fadeOut("fast").toggleClass('hide');
            $(this).parent().parent().parent('.popover-content').find(".popover-form-open").fadeIn('fast');
        });
        $('#fancyClock').tzineClock();
    });
})(window, jQuery);