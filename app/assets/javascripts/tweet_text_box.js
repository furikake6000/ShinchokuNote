$(document).on('turbolinks:load', function(){
    $tweettext_form = $("#tweettext_form");
    $tweettext_count = $("#tweettext_count");
    $tweet_submit = $("#tweet_submit");

    $tweettext_form.keyup(function() {
        let textlen = $tweettext_form.val().length;
        $tweettext_count.text(textlen);

        if(textlen > 140){
            $tweet_submit.prop("disabled", true);
        }else{
            $tweet_submit.prop("disabled", false);
        }
    });
})