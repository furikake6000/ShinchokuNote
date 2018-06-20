function copyShareUrlToClipboard() {
    $("#share_url").select();
    document.execCommand("Copy");

    $("#share_icon").removeClass("fa-share-alt");
    $("#share_icon").addClass("fa-check");
    $("#share_button").removeClass("btn-primary");
    $("#share_button").removeClass("btn-secondary");
    $("#share_button").removeClass("btn-info");
    $("#share_button").addClass("btn-success");
}