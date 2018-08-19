$(document).on('turbolinks:load', function(){
    $scheduletext_form = $("#scheduletext_form");
    $schedule_submit = $("#schedule_submit");

    var maxtextlen = 100;

    $scheduletext_form.keyup(function() {
        var textlen = $scheduletext_form.val().length;
        
        if(textlen == 0 || textlen > maxtextlen){
            $schedule_submit.prop("disabled", true);
        }else{
            $schedule_submit.prop("disabled", false);
        }
    });
})