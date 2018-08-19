$(document).on('turbolinks:load', function(){
    $commenttext_form = $("#commenttext_form");
    $commenttext_count = $("#commenttext_count");
    $comment_submit = $("#comment_submit");

    var maxtextlen = 1000;

    $commenttext_form.keyup(function() {
        var textlen = $commenttext_form.val().length;
        $commenttext_count.text(textlen + " / " + maxtextlen);

        if(textlen == 0 || textlen > maxtextlen){
            $comment_submit.prop("disabled", true);
        }else{
            $comment_submit.prop("disabled", false);
        }
    });
})