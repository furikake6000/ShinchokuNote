var Point = class{
    constructor(x, y){
        this.x = x;
        this.y = y;
    }

    X(){
        return this.x;
    }

    Y(){
        return this.y;
    }
}

$(document).on('turbolinks:load', function(){
    let $canvas = $('#image_edit_canvas');
    let ctx = $canvas[0].getContext('2d');

    let start_pos = null;

    function getExpandRate(){
        // canvas.width()は実際の横幅
        // canvas[0].widthはcanvasの内部的解像度
        return $canvas.width() / $canvas[0].width
    }

    function getClickedCanvasPos(e){
        let rect = e.target.getBoundingClientRect();
        let expRate = getExpandRate();
        mousePosX = Math.floor((e.clientX - rect.left) / expRate);
        mousePosY = Math.floor((e.clientY - rect.top) / expRate);
        return new Point(mousePosX, mousePosY);
    }

    $canvas.click(function(e){
        mousePos = getClickedCanvasPos(e);
        console.log("X: " + mousePos.X() + ", Y: " + mousePos.Y());
    })
})