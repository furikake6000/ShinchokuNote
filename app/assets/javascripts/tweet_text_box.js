$(document).on('turbolinks:load', function(){
    $tweettext_form = $("#tweettext_form");
    $tweettext_count = $("#tweettext_count");
    $tweettext_form.keyup(function() {
        $tweettext_count.text($tweettext_form.val().length);
    });
})