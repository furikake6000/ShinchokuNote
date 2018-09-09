$(document).on('turbolinks:load', function(){
    var $shinchoku_dodeska_tab = $('#shinchoku_dodeska_tab');

    $('.comments_tab_toggler').on('click', function() {
        $('#commentslist_tab').tab('show');
    });

    // スマートフォンなど用の挙動
    // 長おしで出る右クリックメニューをなくす
    $('.shinchoku_dodeska_tab_toggler').on('contextmenu', function(e) {
        $shinchoku_dodeska_tab.removeClass('d-none');
        e.preventDefault();
    });
    // 短めに押すと普通の進捗どうですか
    $('.shinchoku_dodeska_tab_toggler').on('click', function(e) {
        $shinchoku_dodeska_tab.addClass('d-none');
    });
    // スタンプを押すとスタンプタブが隠れる
    $('.shinchoku_stamp').on('click', function(e) {
        $shinchoku_dodeska_tab.addClass('d-none');
    });

    $('.shinchoku_dodeska_tab_toggler').hover(function(e) {
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