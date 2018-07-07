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
    let $canvas_ui = $('#image_edit_ui_canvas');
    let ctx_ui = $canvas_ui[0].getContext('2d');

    let $trim_button = $('#trim_button');

    let start_pos = null;
    let end_pos = null;

    function getExpandRate(){
        // canvas.width()は実際の横幅
        // canvas[0].widthはcanvasの内部的解像度
        return $canvas.width() / $canvas[0].width;
    }

    function getClickedCanvasPos(e){
        let rect = e.target.getBoundingClientRect();
        let exp_rate = getExpandRate();
        let mouse_pos_X = Math.floor((e.clientX - rect.left) / exp_rate);
        let mouse_pos_Y = Math.floor((e.clientY - rect.top) / exp_rate);
        return new Point(mouse_pos_X, mouse_pos_Y);
    }

    function getTouchedCanvasPos(e){
        let rect = e.target.getBoundingClientRect();
        let tpos = e.originalEvent.changedTouches[0];
        let exp_rate = getExpandRate();
        let touch_pos_X = Math.floor((tpos.clientX - rect.left) / exp_rate);
        let touch_pos_Y = Math.floor((tpos.clientY - rect.top) / exp_rate);
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
            let mouse_pos = getClickedCanvasPos(e);
            let rect_width = mouse_pos.X() - start_pos.X();
            let rect_height = mouse_pos.Y() - start_pos.Y();

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
            let touch_pos = getTouchedCanvasPos(e);
            let rect_width = touch_pos.X() - start_pos.X();
            let rect_height = touch_pos.Y() - start_pos.Y();

            ctx_ui.clearRect(0, 0, $canvas_ui[0].width, $canvas_ui[0].height);

            ctx_ui.strokeRect(start_pos.X(), start_pos.Y(), rect_width, rect_height);
        }
    });

    $trim_button.click(function(e){
        if(start_pos && end_pos){
            let rect_width = end_pos.X() - start_pos.X();
            let rect_height = end_pos.Y() - start_pos.Y();
            
            let trim_img = ctx.getImageData(start_pos.X(), start_pos.Y(), rect_width, rect_height);

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