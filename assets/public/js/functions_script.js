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
            var $thisButton = $(this);
            console.log($thisButton.parent().parent());
            $.post("/admin/delete_" + $thisButton.attr("data-type") + "/" + $thisButton.parent().parent().attr("id"), function(data) {
                if (data.result == 1) {
                    $thisButton.parent().parent().hide("fast").remove();
                    if ($thisButton.hasClass('.popover-remove-row')){
                        $(".popover-gpio-"+$thisButton.attr("data-type")).find('tr#'+$thisButton.parent().parent().attr("id")).remove();
                    }
                }
            }, 'json');
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
            var $thisForm = $thisButton.parent().parent(".form-data-body").find('form');
            var formData = JSON.stringify($thisForm.serializeArray());
                        console.log(formData);
            $.post("/admin/"+$thisButton.attr('data-action') + '/', {data: formData}, function(data) {
                    $thisButton.removeAttr('disabled');
                    $thisButton.children('span').text(buttonText);
                    $thisButton.children('i').removeClass('fa fa-spinner fa-spin');
                    $thisForm.each(function() {
                        this.reset();
                    });
                    if ($thisButton.hasClass('is-popover')) {
                        $thisButton.parent().parent(".form-data-body").hide('fast');
                        $thisButton.parent().parent().parent('.popover-content').find(".popover-form-open").fadeIn('fast');
                    } else {
                        $thisButton.parent().parent().parent().parent(".modal").modal("hide");
                    }
                    window.location.reload();
                },
                'json' // JSON response
            );
        });
        $body.on('click','.popover-form-open',function(){
            $(this).fadeOut('fast');
            $(this).parent('.popover-content').find(".form-data-body").fadeIn("fast").toggleClass('hide');
        });
        $body.on('click','.popover-form-close',function(){
            $(this).parent().parent(".form-data-body").hide("fast").toggleClass('hide');
            $(this).parent().parent().parent('.popover-content').find(".popover-form-open").fadeIn('fast');
        });
        $('#fancyClock').tzineClock();
    });
})(window, jQuery);