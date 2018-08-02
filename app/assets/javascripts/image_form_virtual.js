$(document).on('turbolinks:load', function(){
    // Max size of image(3MB)
    let MAX_IMAGE_SIZE = 1024 * 1024 * 1.5;  // IE doesn't allow const
    
    let $postform = $('#new_post');
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

    function loadImageToEditorModal($img, load_and_confirm){
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

    // Ref: (https://stackoverflow.com/a/15754051)
    function dataURItoBlob(dataURI) {
        var byteString = atob(dataURI.split(',')[1]);
        var ab = new ArrayBuffer(byteString.length);
        var ia = new Uint8Array(ab);
        for (var i = 0; i < byteString.length; i++) {
            ia[i] = byteString.charCodeAt(i);
        }
        return new Blob([ab]);
    }

    // Ref: (https://stackoverflow.com/a/29390393)
    function blobToFile(theBlob, fileName){
        //A Blob() is almost a File() - it's just missing the two properties below which we will add
        theBlob.lastModifiedDate = new Date();
        theBlob.name = fileName;
        return theBlob;
    }

    function dataURItoFile(dataURI, fileName){
        let blob = dataURItoBlob(dataURI);
        let file = blobToFile(blob, fileName);
        file.type = "image/png";
        return file;
    }

    $clickandselect.click(function(){
        $('<input type="file" accept="image/*">').on('change', function(e) {
            let images = e.target.files;
            loadImages(images);
        })[0].click();
    })

    $editconfirm.click(confirmImageFromEditorModal);

    $virtualform.on({
        'dragenter': disableEvent,
        'dragover': disableEvent,
        'dragleave': disableEvent,
        'drop': pendFile
    });

    $postform.submit(function(e){
        disableEvent(e);

        // Reading all infomations from form
        let fd = new FormData($postform[0]);

        // Appending submit information
        let $clickedbutton = $(this).find("input[type=submit]:focus");
        fd.append($clickedbutton[0].name, true);

        // Appending image files
        let newvalue = [];
        $.each($pendingimages, function(i, $pimage){
            new_file = dataURItoBlob($pimage[0].src);
            newvalue.push(new_file);
        });
        fd.append('post[image]', newvalue);

        console.log("Entry lists:");
        for(var pair of fd.entries()) {
            console.log(pair[0]+ ', '+ pair[1]); 
        }

        $.ajax({
            type: $postform[0].method,
            url: $postform[0].action,
            data: fd,
            processData: false,
            contentType: false,
            dataType: 'json'
          })
    })
})
