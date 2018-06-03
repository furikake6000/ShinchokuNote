$(document).on('turbolinks:load', function(){
    let timezoneOffsetHour = new Date().getTimezoneOffset() / 60 * -1;
    let timezone = (timezoneOffsetHour >= 0 ? "+" : "-") + 
                    ("00" + Math.abs(timezoneOffsetHour)).slice(-2) + 
                    ":00";
    $('.date-picker').datetimepicker({
        format: "YYYY/MM/DD HH:mm" + timezone,
        inline: true,
        showTodayButton: true,
        sideBySide: true,
        icons: {
            time: 'fa fa-clock-o',
            date: 'fa fa-calendar',
            up: 'fa fa-chevron-up',
            down: 'fa fa-chevron-down',
            previous: 'fa fa-chevron-left',
            next: 'fa fa-chevron-right',
            today: 'fa fa-calendar-plus-o',
            clear: 'fa fa-trash',
            close: 'fa fa-remove'
        }
    });
});