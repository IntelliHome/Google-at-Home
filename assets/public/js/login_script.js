$(function() {
    var userField = $("input[name=username]");
    var passwordField = $("input[name=password]");
    $('button[type="submit"]').click(function(e) {
        e.preventDefault();
        if (userField.val() == "") {
            //remove success mesage replaced with error message
            $("#output").removeClass(' alert alert-success');
            $("#output").addClass("alert alert-danger animated fadeInUp").html("Did you forget to enter username?");
        } else if (passwordField.val() == "") {
            //remove success mesage replaced with error message
            $("#output").removeClass(' alert alert-success');
            $("#output").addClass("alert alert-danger animated fadeInUp").html("Did you forget to enter password?");
        } else {
            var loginRequest = $.ajax({
                type: "POST",
                url: '/auth',
                data: {
                    username: userField.val(),
                    password: passwordField.val()
                },
                dataType: 'json', //gives back a JSON object
            });
            loginRequest.done(function(msg) {
                //Display a message for login
                /*
                        $("#output").addClass("alert alert-success animated fadeInUp").html("Welcome back " + "<span style='text-transform:uppercase'>" + userField.val() + "</span>");
                        $("#output").removeClass(' alert-danger');
                        $("input").css({
                            "height":"0",
                            "padding":"0",
                            "margin":"0",
                            "opacity":"0"
                        });
                        */
                //Change button  
                /*
                        $('button[type="submit"]').html("continue")
                            .removeClass("btn-info")
                            .addClass("btn-default").click(function(){
                                $("input").css({
                                    "height":"auto",
                                    "padding":"10px",
                                    "opacity":"1"
                                }).val("");
                            });
                        */

                //Display user avatar
                /*
                        $(".avatar").css({
                                "background-image": "url('http://api.randomuser.me/0.3.2/portraits/women/35.jpg')"
                        });
                        */
                window.location.href = msg.redirectURL;
            });
            loginRequest.fail(function() {
                //remove success mesage replaced with error message
                $("#output").removeClass(' alert alert-success');
                $("#output").addClass("alert alert-danger animated fadeInUp").html("Server have some trouble!");
            });

        }
    });
});