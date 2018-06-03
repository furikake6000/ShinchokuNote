$(document).on('turbolinks:load', function(){
    $scheduletext_form = $("#scheduletext_form");
    $schedule_submit = $("#schedule_submit");

    let maxtextlen = 100;

    $scheduletext_form.keyup(function() {
        let textlen = $scheduletext_form.val().length;
        
        if(textlen == 0 || textlen > maxtextlen){
            $schedule_submit.prop("disabled", true);
        }else{
            $schedule_submit.prop("disabled", false);
        }
    });
})