// Point class
function Point(x, y){
    this.x = x;
    this.y = y;
}
Point.prototype = {
    X: function(){
        return this.x;
    },

    Y: function(){
        return this.y;
    }
}
// Better way but not working on IE
/*class Point{
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
}*/

$(document).on('turbolinks:load', function(){
    var $canvas = $('#image_edit_canvas');
    var ctx = $canvas[0].getContext('2d');
    var $canvas_ui = $('#image_edit_ui_canvas');
    var ctx_ui = $canvas_ui[0].getContext('2d');

    var $trim_button = $('#trim_button');

    var start_pos = null;
    var end_pos = null;

    function getExpandRate(){
        // canvas.width()は実際の横幅
        // canvas[0].widthはcanvasの内部的解像度
        return $canvas.width() / $canvas[0].width;
    }

    function getClickedCanvasPos(e){
        var rect = e.target.getBoundingClientRect();
        var exp_rate = getExpandRate();
        var mouse_pos_X = Math.floor((e.clientX - rect.left) / exp_rate);
        var mouse_pos_Y = Math.floor((e.clientY - rect.top) / exp_rate);
        return new Point(mouse_pos_X, mouse_pos_Y);
    }

    function getTouchedCanvasPos(e){
        var rect = e.target.getBoundingClientRect();
        var tpos = e.originalEvent.changedTouches[0];
        var exp_rate = getExpandRate();
        var touch_pos_X = Math.floor((tpos.clientX - rect.left) / exp_rate);
        var touch_pos_Y = Math.floor((tpos.clientY - rect.top) / exp_rate);
        return new Point(touch_pos_X, touch_pos_Y);
    }

    $canvas_ui.mousedown(function(e){
        start_pos = getClickedCanvasPos(e);
        end_pos = null;
    });

    $canvas_ui.mouseup(function(e){
        end_pos = getClickedCanvasPos(e);
    });

    $canvas_ui.mousemove(function(e){
        if(start_pos && !end_pos){
            var mouse_pos = getClickedCanvasPos(e);
            var rect_width = mouse_pos.X() - start_pos.X();
            var rect_height = mouse_pos.Y() - start_pos.Y();

            ctx_ui.clearRect(0, 0, $canvas_ui[0].width, $canvas_ui[0].height);

            ctx_ui.strokeRect(start_pos.X(), start_pos.Y(), rect_width, rect_height);
        }
    });

    $canvas_ui.on("touchstart", function(e){
        event.preventDefault();
        start_pos = getTouchedCanvasPos(e);
        end_pos = null;
    });

    $canvas_ui.on("touchend", function(e){
        event.preventDefault();
        end_pos = getTouchedCanvasPos(e);
    });

    $canvas_ui.on("touchmove", function(e){
        event.preventDefault();
        if(start_pos && !end_pos){
            var touch_pos = getTouchedCanvasPos(e);
            var rect_width = touch_pos.X() - start_pos.X();
            var rect_height = touch_pos.Y() - start_pos.Y();

            ctx_ui.clearRect(0, 0, $canvas_ui[0].width, $canvas_ui[0].height);

            ctx_ui.strokeRect(start_pos.X(), start_pos.Y(), rect_width, rect_height);
        }
    });

    $trim_button.click(function(e){
        if(start_pos && end_pos){
            var rect_x = Math.min(start_pos.X(), end_pos.X());
            var rect_y = Math.min(start_pos.Y(), end_pos.Y());
            var rect_width = Math.abs(end_pos.X() - start_pos.X());
            var rect_height = Math.abs(end_pos.Y() - start_pos.Y());
            
            var trim_img = ctx.getImageData(rect_x, rect_y, rect_width, rect_height);

            $canvas.attr({
                width: rect_width,
                height: rect_height
            });
            $canvas_ui.attr({
                width: rect_width,
                height: rect_height
            });

            ctx.putImageData(trim_img, 0, 0);
            ctx_ui.clearRect(0, 0, $canvas_ui[0].width, $canvas_ui[0].height);
        }
    });
})