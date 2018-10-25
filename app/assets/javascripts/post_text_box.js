$(document).on('turbolinks:load', function () {
    $text_form = $("#new_text_form");
    $text_count = $("#text_count");
    $post_submit = $("#post_submit");
    $tweet_submit = $("#tweet_submit");

    var maxtextlen = $("#respond_to")[0] ? 108 : 110;

    $text_form.keyup(function () {
        var textlen = $text_form.text().length;
        $text_count.text(textlen + " / " + maxtextlen);

        if (textlen == 0 || textlen > maxtextlen) {
            $post_submit.prop("disabled", true);
            $tweet_submit.prop("disabled", true);
        } else {
            $post_submit.prop("disabled", false);
            $tweet_submit.prop("disabled", false);
        }
    });

    $.setPlaceholder();
})