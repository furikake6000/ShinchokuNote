$(document).on('turbolinks:load', function(){
    $tweettext_form = $("#tweettext_form");
    $tweettext_count = $("#tweettext_count");
    $tweet_submit = $("#tweet_submit");

    let maxtextlen = $("#tweet_respond_to")[0] ? 108 : 110;

    $tweettext_form.keyup(function() {
        let textlen = $tweettext_form.val().length;
        $tweettext_count.text(textlen + " / " + maxtextlen);

        if(textlen == 0 || textlen > maxtextlen){
            $tweet_submit.prop("disabled", true);
        }else{
            $tweet_submit.prop("disabled", false);
        }
    });
})