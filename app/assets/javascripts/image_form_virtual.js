$(document).on('turbolinks:load', function(){
    const MAX_IMAGE_SIZE = ((2 ** 10) ** 2);

    let $virtualform = $('#image_form_virtual');
    let $realform = $('#image_form_hidden');
    let $clickandselect = $('#image_form_click_and_select');
    let $preview = $('#image_form_preview');
    let $editconfirm = $('#edit_confirm_button');
    let $canvas = $('#image_edit_canvas');
    let $canvas_ui = $('#image_edit_ui_canvas');
    let $imageeditmodal = $('#image_edit_modal');
    let imagecount = 0;
    let $pendingimages = {};

    function disableEvent(e) {
        e.preventDefault();
        e.stopPropagation();
    }

    function loadImageToEditorModal($img, load_and_confirm = true){
        // Set editing <img> id to 'editingimage' attr
        $canvas.attr('editingimage', $img.attr('id'));
        let ctx = $canvas[0].getContext('2d');
        let image = new Image();
        image.src = $img.attr('src');
        image.onload = function(e){
            let redratio = Math.min(
                1.0, 
                Math.sqrt(MAX_IMAGE_SIZE / (image.width * image.height))
            );
            $canvas.attr({
                width: image.width * redratio,
                height: image.height * redratio
            });
            $canvas_ui.attr({
                width: image.width * redratio,
                height: image.height * redratio
            });
            ctx.drawImage(image, 
                0, 0, 
                image.width * redratio, image.height * redratio
            );
            if(load_and_confirm){
                confirmImageFromEditorModal();
            }
        }
    }

    function confirmImageFromEditorModal(){
        // Confirm edited image
        let dataURI = $canvas[0].toDataURL();
        let $pendingimage = $('#' + $canvas.attr('editingimage'));
        $pendingimage.attr('src', dataURI);
    }

    function loadImages(images){
        $.each(images, function(){
            let reader = new FileReader();
            reader.onload = function(e){
                // Increment ID of images
                imagecount += 1;
                $preview.append($('<img>').attr({
                    src: e.target.result,
                    id: "pending_image_" + imagecount,
                    width: "120px",
                    title: "uploaded_image"
                }));
                let $pendingimage = $("#pending_image_" + imagecount);
                // Make the list of <img> tags
                $pendingimages[imagecount] = $pendingimage;

                // Make the click trigger of <img> tags
                $pendingimage.click(function(e){
                    // Set the image of canvas
                    loadImageToEditorModal($pendingimage);
                    $imageeditmodal.modal('toggle');
                });

                // Once load it on canvas to scale it (for large images)
                loadImageToEditorModal($pendingimage, true);
            }
            reader.readAsDataURL(this);
        })
    }
    
    function pendFile(e){
        e.preventDefault();
        var images = e.originalEvent.dataTransfer.files;

        loadImages(images);
    }

    $clickandselect.click(function(){
        $realform.trigger('click');
    })

    $editconfirm.click(confirmImageFromEditorModal);

    $virtualform.on({
        'dragenter': disableEvent,
        'dragover': disableEvent,
        'dragleave': disableEvent,
        'drop': pendFile
    });

    $realform.on('change', function(e){
        let images = e.target.files;
        
        loadImages(images);
    })

    $('#new_post').submit(function(){
        console.log(data);
        console.log("Data posted!");

        return false;
    })
})
