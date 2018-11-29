$(document).on('turbolinks:load', function () {
    // Max size of image(3MB)
    var MAX_IMAGE_SIZE = 1024 * 1024 * 1.5;  // IE doesn't allow const

    var $postform = $('#new_post');
    var $postform_submit = $('#new_post input[type=submit]');
    var $preview = $('#image_form_preview');
    var $editconfirm = $('#edit_confirm_button');
    var $canvas = $('#image_edit_canvas');
    var $canvas_ui = $('#image_edit_ui_canvas');
    var $imageeditmodal = $('#image_edit_modal');
    var $textform = $('#text_form');
    var $imageselectbutton = $('#image_select_button');

    var imagecount = 0;
    var $pendingimages = {};

    // Do nothing (when d&d files to upload area)
    function disableEvent(e) {
        e.preventDefault();
        e.stopPropagation();
    }

    // Getting File from d&d files
    function pendFile(e) {
        e.preventDefault();
        var images = e.originalEvent.dataTransfer.files;

        loadImageFiles(images);
    }

    function loadImageToEditorModal($img, load_and_confirm) {
        // Set editing <img> id to 'editingimage' attr
        $canvas.attr('editingimage', $img.attr('id'));
        var ctx = $canvas[0].getContext('2d');
        var image = new Image();
        image.src = $img.attr('src');
        image.onload = function (e) {
            var redratio = Math.min(
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
            if (load_and_confirm) {
                confirmImageFromEditorModal();
            }
        }
    }

    function confirmImageFromEditorModal() {
        // Confirm edited image
        var dataURI = $canvas[0].toDataURL();
        var $pendingimage = $('#' + $canvas.attr('editingimage'));
        $pendingimage.attr('src', dataURI);
    }

    // DataURL -> <img> content
    function loadImage(src) {
        // Increment ID of images
        imagecount += 1;

        var $new_image_preview_box = $('<div>').attr({
            class: "image_preview_box",
            imagecount: imagecount
        }).appendTo($preview);

        $('<img>').attr({
            src: src,
            id: "pending_image_" + imagecount,
            class: "pending-image",
            title: "uploaded_image"
        }).appendTo($new_image_preview_box);

        var $deselect_button = $('<div>&times;</div>').attr({
            class: "deselect_button",
            id: "deselect_image_" + imagecount,
            imagecount: imagecount
        }).appendTo($new_image_preview_box);
        $deselect_button.click(function (e) {
            // delete image from pendingimages and preview area
            delete $pendingimages[$deselect_button.attr('imagecount')];
            $deselect_button.parent().remove();
        });

        var $pendingimage = $("#pending_image_" + imagecount);
        // Make the list of <img> tags
        $pendingimages[imagecount] = $pendingimage;

        // Make the click trigger of <img> tags
        $pendingimage.click(function (e) {
            // Set the image of canvas
            loadImageToEditorModal($pendingimage);
            $imageeditmodal.modal('toggle');
        });

        // Once load it on canvas to scale it (for large images)
        loadImageToEditorModal($pendingimage, true);
    }

    // Blob or File -> DataURL
    function loadImageFile(image) {
        var reader = new FileReader();
        reader.onload = function (e) {
            loadImage(e.target.result);
        }
        reader.readAsDataURL(image);
    }

    // Blob or File -> DataURL (multiple)
    function loadImageFiles(images) {
        $.each(images, function () {
            loadImageFile(this);
        })
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
    function blobToFile(theBlob, fileName) {
        //A Blob() is almost a File() - it's just missing the two properties below which we will add
        theBlob.lastModifiedDate = new Date();
        theBlob.name = fileName;
        return theBlob;
    }

    function dataURItoFile(dataURI, fileName) {
        var blob = dataURItoBlob(dataURI);
        var file = blobToFile(blob, fileName);
        file.type = "image/png";
        return file;
    }

    $imageselectbutton.click(function () {
        $('<input type="file" accept="image/*">').on('change', function (e) {
            var images = e.target.files;
            loadImageFiles(images);
        })[0].click();
    })

    $editconfirm.click(confirmImageFromEditorModal);

    $postform.on({
        'dragenter': disableEvent,
        'dragover': disableEvent,
        'dragleave': disableEvent,
        'drop': pendFile
    });

    $postform_submit.click(function (e) {
        $('#submit_type').attr('name', $(this).attr('name'))
    })

    $postform.submit(function (e) {
        disableEvent(e);

        // Reading all infomations from form
        var fd = new FormData($postform[0]);

        // Appending text
        fd.append('post[text]', $textform.textWithLF());

        // Appending image files
        $.each($pendingimages, function (i, $pimage) {
            fd.append('post[image][' + i + ']', dataURItoBlob($pimage[0].src));
        });

        $.ajax({
            type: $postform[0].method,
            url: $postform[0].action,
            data: fd,
            processData: false,
            contentType: false,
            dataType: 'json'
        }).done(function (data, status, xhr) {
            // If succeed, reload
            location.reload();
        }).fail(function (xhr, status, error) {
            console.log("Post#Create : " + status + " Error detected.");
        });
    })

    // Fig pasted detection (for Firefox, IE, etc...)
    $textform.on('input', function () {
        var $pastedImages = $textform.find("img");

        // If no image found, do nothing
        if ($pastedImages.length == 0) {
            return true;
        }

        $.each($pastedImages, function (i, $pimage) {
            loadImage($pimage.src);
            // delete the pasted <img> tag
            $pimage.remove();
        });
    })

    // Fig pasted detection (for Chrome)
    $textform.on('paste', function (e) {
        var clipdata = e.clipboardData;

        // If no image found, do nothing
        if (!clipdata ||
            !clipdata.types ||
            (clipdata.types.length != 1) ||
            (clipdata.types[0] != "Files")) {
            return true;
        }

        var pastedImageFiles = clipdata.items;
        $.each($pastedImageFiles, function (i, $pimagefile) {
            if ($pimagefile.type.indexOf('image') >= 0) {
                loadImage($pimage.getAsFile());
            }
        });
    })
})
