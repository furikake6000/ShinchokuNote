$(document).on('turbolinks:load', function(){
    var $shinchoku_dodeska_tab = $('#shinchoku_dodeska_tab');

    $('.comments_tab_toggler').on('click', function() {
        $('#commentslist_tab').tab('show');
    });

    $('.shinchoku_dodeska_tab_toggler').hover(function() {
        $shinchoku_dodeska_tab.removeClass('d-none');
    }, function() {
        $shinchoku_dodeska_tab.addClass('d-none');
    });

    $shinchoku_dodeska_tab.hover(function() {
        $shinchoku_dodeska_tab.removeClass('d-none');
    }, function() {
        $shinchoku_dodeska_tab.addClass('d-none');
    });
});