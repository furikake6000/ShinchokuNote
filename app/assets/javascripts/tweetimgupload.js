$(function(){
    $('.form-tweetimg').on('change', 'input[type="file"]', function(e){
        var file = e.target.files[0];
        var reader = new FileReader();
        var $preview = $(".preview-tweetimg");

        if(file.type.indexOf("image") < 0){
            return false;
        }

        reader.onload = (function(f){
            return function(e){
                $preview.empty();
                $preview.append($('<img>').attr({
                    src: e.target.result,
                    width: "150px",
                    title: f.name
                }));
            }
        })(file);

        reader.readAsDataURL(file);
    })
})