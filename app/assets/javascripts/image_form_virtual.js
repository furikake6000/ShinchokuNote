function disableEvent(e) {
    e.preventDefault();
    e.stopPropagation();
}

$(document).on('turbolinks:load', function(){
    let $virtualform = $('#image_form_virtual');
    let $realform = $('#image_form_hidden');
    let $preview = $('#image_form_preview');

    $virtualform.click(function(){
        $realform.trigger('click');
    })

    $virtualform.on({
        'dragenter': disableEvent,
        'dragover': disableEvent,
        'dragleave': disableEvent,
        'drop': disableEvent
    });

    $realform.on('change', function(e){
        $preview.empty();
        let images = e.target.files;
        console.log(images);
        
        $.each(images, function(){
            let reader = new FileReader();
            reader.onload = function(e){
                $preview.append($('<img>').attr({
                    src: e.target.result,
                    width: "120px",
                    title: "uploaded_image"
                }));
            }
            reader.readAsDataURL(this);
        })
    })
})