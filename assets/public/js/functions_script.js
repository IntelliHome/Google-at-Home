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
            $('#gpios-table tbody').append('<tr class="gpio" id="">
                                                <td class="gpio-id"></td>
                                                <td class="gpio-pin-id"></td>
                                                <td class="gpio-node"></td>
                                                <td class="gpio-type"><%= $_->type %></td>
                                                <td class="gpio-value"><%= $_->value %></td>
                                                <td class="gpio-driver <%= $_->driver %>"><%= $_->driver %></td>
                                                <td>
                                                    <button type="button" class="btn btn-default">
                                                        <span class="glyphicon glyphicon-th-list gpio-tags" id="<%= $_->id %>"></span> Tags
                                                    </button>
                                                </td>
                                                <td>
                                                    <button type="button" class="btn btn-default">
                                                        <span class="glyphicon glyphicon-th-list gpio-pins" id="<%= $_->id %>"></span> Pins
                                                    </button>
                                                </td>
                                                <td>
                                                    <a href="#" class="gpio-delete" id="<%= $_->id %>">
                                                        <span class="glyphicon glyphicon-trash"></span>
                                                    </a>
                                                </td>
                                            </tr>');
        });
        $nodeAdd.click(function() {
            /* TODO: Open Node box to insert new gpio */
        });
        $('#fancyClock').tzineClock();
    });
})(window, jQuery);