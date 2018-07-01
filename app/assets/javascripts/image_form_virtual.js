$(document).on('turbolinks:load', function(){
    let $virtualform = $('#image_form_virtual');
    let $realform = $('#image_form_hidden');
    let $preview = $('#image_form_preview');

    function disableEvent(e) {
        e.preventDefault();
        e.stopPropagation();
    }
    
    function pendFile(e){
        e.preventDefault();
        var images = e.originalEvent.dataTransfer.files;

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
    }

    $virtualform.click(function(){
        $realform.trigger('click');
    })

    $virtualform.on({
        'dragenter': disableEvent,
        'dragover': disableEvent,
        'dragleave': disableEvent,
        'drop': pendFile
    });

    $realform.on('change', function(e){
        let images = e.target.files;
        
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

    $('#new_post').submit(function(){
        console.log(data);
        console.log("Data posted!");

        return false;
    })
})
