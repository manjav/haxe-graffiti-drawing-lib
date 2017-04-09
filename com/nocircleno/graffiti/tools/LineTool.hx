  /*
*  	Graffiti 3.0
*  	______________________________________________________________________
*  	www.nocircleno.com/graffiti/
*/  

/*
* 	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* 	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* 	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* 	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* 	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* 	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* 	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* 	OTHER DEALINGS IN THE SOFTWARE.
*/

package com.nocircleno.graffiti.tools;



import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.display.LineScaleMode;
import openfl.display.CapsStyle;
import openfl.display.JointStyle;
import openfl.display.GraphicsPathCommand;
import openfl.display.GraphicsPathWinding;
import openfl.geom.Rectangle;
import openfl.geom.Point;
import com.nocircleno.graffiti.tools.ITool;
import com.nocircleno.graffiti.tools.ToolRenderType;
import com.nocircleno.graffiti.tools.LineType;
import com.nocircleno.graffiti.utils.Conversions;

/**
	* LineTool Class allows the user to draw a SOLID, DASHED or DOTTED line on the canvas.
	*
	* @langversion 3.0
* @playerversion Flash 10 AIR 1.5 
	*/
@:final class LineTool extends BitmapTool
{
    public var lineWidth(get, set) : Float;
    public var color(get, set) : Int;
    public var alpha(get, set) : Float;

    
    private inline var MIN_SHAPE_SIZE_FOR_OBJECT : Int = 2;
    
    // store local references for performance reasons
    private var sin : Function = Math.sin;
    private var cos : Function = Math.cos;
    private var sqrt : Function = Math.sqrt;
    private var pow : Function = Math.pow;
    private var atan2 : Function = Math.atan2;
    
    private inline var THETA : Float = 45;
    private inline var LINE_SEGMENT_LENGTH_BASE : Int = 4;
    
    private var _lineWidth : Float;
    private var _color : Int;
    private var _alpha : Float;
    
    private var _dotSpacing : Float;
    private var _r : Float;
    private var _d : Float;
    
    /**
		* The <code>LineTool</code> constructor.
		* 
		* @param lineWidth Line width.
		* @param lineColor Line Color.
		* @param lineType Type of Line.
		* @param toolMode Tool mode the Line will be drawing with.
		* @param objectDrawingMode 
		* 
		* @example The following code creates a Line instance.
		* <listing version="3.0" >
		* // create a dotted line of size 8 and the color of red
		* var dottedLine:Line = new Line(8, 0xFF0000, 1, LineType.DOTTED);
		* </listing>
		*/
    public function new(lineWidth : Float = 4, lineColor : Int = 0x000000, lineAlpha : Float = 1, lineType : String = null, toolMode : String = null, objectDrawingMode : Bool = false)
    {
        super();
        
        // set render type
        _renderType = ToolRenderType.CLICK_DRAG;
        
        // store size
        this.lineWidth = lineWidth;
        
        // store color
        color = lineColor;
        
        // store alpha
        _alpha = lineAlpha;
        
        // store type
        type = lineType;
        
        // store mode
        mode = toolMode;
        
        // store object drawing mode
        _objectDrawingMode = objectDrawingMode;
    }
    
    /**
		* Type of Layer the tool will draw to.
		*/
    override private function get_layerType() : String{
        
        var layer : String;
        
        if (_objectDrawingMode) {
            layer = LayerType.OBJECT_LAYER;
        }
        else {
            layer = LayerType.DRAWING_LAYER;
        }
        
        return layer;
    }
    
    /**
		* Size of the Line
		*/
    private function set_lineWidth(lineW : Float) : Float{
        
        if (lineW > 0) {
            
            // set brush size
            _lineWidth = lineW;
            
            // update values for dotted line
            _dotSpacing = 2 * _lineWidth;
            _r = _lineWidth * .5;
            _d = _r / cos(Conversions.radians(0.5 * THETA));
        }
        return lineW;
    }
    
    private function get_lineWidth() : Float{
        return _lineWidth;
    }
    
    /**
		* Color of the Line
		*/
    private function set_color(lineColor : Int) : Int{
        _color = lineColor;
        return lineColor;
    }
    
    private function get_color() : Int{
        return _color;
    }
    
    /**
		* Alpha of the Line
		*/
    private function set_alpha(lineAlpha : Float) : Float{
        _alpha = lineAlpha;
        return lineAlpha;
    }
    
    private function get_alpha() : Float{
        return _alpha;
    }
    
    /**
		* Type of Line
		*/
    override private function set_type(lineType : String) : String{
        
        // determine type
        if (lineType != null && LineType.validType(lineType)) {
            _type = lineType;
        }
        else {
            _type = LineType.SOLID;
        }
        return lineType;
    }
    
    /**
		* The <code>getLineDefinition</code> method returns the line data. This is used
		* with object drawing mode.
		* 
		* @return The Line definition.
		*
		*/
    public function getLineDefinition() : LineDefinition{
        
        var numDrawingData : Int = drawingData.length;
        
        var lineValidWidth : Bool = false;
        var lineValidHeight : Bool = false;
        
        // determine the the lowest position
        for (i in 0...numDrawingData){
            
            if (drawingData[i] < _upperCornerBounds.x) {
                _upperCornerBounds.x = drawingData[i];
            }
            
            if (drawingData[i] > _lowerRightCornerBounds.x) {
                _lowerRightCornerBounds.x = drawingData[i];
            }
            
            if (drawingData[i + 1] < _upperCornerBounds.y) {
                _upperCornerBounds.y = drawingData[i + 1];
            }
            
            if (drawingData[i + 1] > _lowerRightCornerBounds.y) {
                _lowerRightCornerBounds.y = drawingData[i + 1];
            }
        }  // calculate real width and height  
        
        
        
        var realWidth : Float = _lowerRightCornerBounds.x - _upperCornerBounds.x;
        var realHeight : Float = _lowerRightCornerBounds.y - _upperCornerBounds.y;
        
        // adjust all data points so they are in a local symbol space
        // where the farthest upper left point becomes 0, 0
        for (i in 0...numDrawingData){
            
            drawingData[i] -= _upperCornerBounds.x;
            drawingData[i + 1] -= _upperCornerBounds.y;
            
            if (drawingData[i] > MIN_SHAPE_SIZE_FOR_OBJECT) {
                lineValidWidth = true;
            }
            
            if (drawingData[i + 1] > MIN_SHAPE_SIZE_FOR_OBJECT) {
                lineValidHeight = true;
            }
        }
        
        var lineDef : LineDefinition;
        
        if (lineValidWidth || lineValidHeight) {
            lineDef = new LineDefinition(_type, _color, _alpha, _lineWidth, realWidth, realHeight, commands, drawingData, new Point(_upperCornerBounds.x, _upperCornerBounds.y));
        }
        
        return lineDef;
    }
    
    /**
		* The <code>apply</code> method applies the line to the Sprite object passed
		* to the method.
		* 
		* @param drawingTarget Sprite that the line will draw to.
		* @param point1 Starting point to apply line.
		* @param point2 End point to apply line.
		*/
    override public function apply(drawingTarget : DisplayObject, point1 : Point, point2 : Point = null) : Void{
        
        // clear drawing commands and data
        resetTool();
        
        // cast target as a Sprite
        var targetCast : Sprite = cast((drawingTarget), Sprite);
        
        // clear it
        targetCast.graphics.clear();
        
        var lineLength : Float = sqrt(pow(point2.x - point1.x, 2) + pow(point2.y - point1.y, 2));
        var angle : Float = atan2(point2.y - point1.y, point2.x - point1.x);
        var i : Int;
        
        // make sure second point is defined
        if (point2 != null) {
            
            // move to first point
            commands.push(GraphicsPathCommand.MOVE_TO);
            drawingData.push(point1.x);
            drawingData.push(point1.y);
            
            // draw SOLID line
            if (_type == LineType.SOLID) {
                
                // add line
                commands.push(GraphicsPathCommand.LINE_TO);
                drawingData.push(point2.x);
                drawingData.push(point2.y);
                
                targetCast.graphics.lineStyle(_lineWidth, _color, _alpha);
                targetCast.graphics.drawPath(commands, drawingData, GraphicsPathWinding.NON_ZERO);
            }
            else if (_type == LineType.DASHED) {
                
                var lineSegmentLength : Int = LINE_SEGMENT_LENGTH_BASE * _lineWidth;
                var lineSegmentLengthSpace : Int = LINE_SEGMENT_LENGTH_BASE * _lineWidth;
                var numberLineSegments : Int = Math.floor(lineLength / (lineSegmentLength + lineSegmentLengthSpace));
                var segmentStartPoint : Point = new Point();
                var segmentEndPoint : Point = new Point();
                
                // loop and draw all segments
                for (i in 0...numberLineSegments + 1){
                    
                    // calculate segment start point
                    segmentStartPoint.x = point1.x + (cos(angle) * (i * (lineSegmentLength + lineSegmentLengthSpace)));
                    segmentStartPoint.y = point1.y + (sin(angle) * (i * (lineSegmentLength + lineSegmentLengthSpace)));
                    
                    // calculate segment end point
                    segmentEndPoint.x = point1.x + (cos(angle) * (((i + 1) * (lineSegmentLength + lineSegmentLengthSpace)) - lineSegmentLengthSpace));
                    segmentEndPoint.y = point1.y + (sin(angle) * (((i + 1) * (lineSegmentLength + lineSegmentLengthSpace)) - lineSegmentLengthSpace));
                    
                    // check last segment and adjust length if needed
                    if (i == numberLineSegments) {
                        
                        var finalLength : Float = sqrt(pow((point2.x - segmentStartPoint.x), 2) + pow((point2.y - segmentStartPoint.y), 2));
                        
                        // if final length is less then or equal to the line segment then use end point to draw last segment
                        if (finalLength <= lineSegmentLength) {
                            segmentEndPoint.x = point2.x;
                            segmentEndPoint.y = point2.y;
                        }
                    }  // store segment  
                    
                    
                    
                    commands.push(GraphicsPathCommand.MOVE_TO);
                    drawingData.push(segmentStartPoint.x);
                    drawingData.push(segmentStartPoint.y);
                    
                    commands.push(GraphicsPathCommand.LINE_TO);
                    drawingData.push(segmentEndPoint.x);
                    drawingData.push(segmentEndPoint.y);
                }
                
                targetCast.graphics.lineStyle(_lineWidth, _color, _alpha, false, LineScaleMode.NORMAL, CapsStyle.SQUARE, JointStyle.MITER);
                targetCast.graphics.drawPath(commands, drawingData, GraphicsPathWinding.NON_ZERO);
            }
            else if (_type == LineType.DOTTED) {
                
                var k : Int;
                var xControl : Float;
                var yControl : Float;
                var xAnchor : Float;
                var yAnchor : Float;
                var controlAngleRadians : Float;
                var anchorAngleRadians : Float;
                
                var dotPos : Point = new Point();
                
                // loop and draw all points for the line
                for (i in 0...lineLength + 1){
                    
                    // calculate dot position
                    dotPos.x = point1.x + (cos(angle) * i);
                    dotPos.y = point1.y + (sin(angle) * i);
                    
                    commands.push(GraphicsPathCommand.MOVE_TO);
                    drawingData.push(dotPos.x + _r);
                    drawingData.push(dotPos.y);
                    
                    for (k in (THETA / 2)...361){
                        
                        controlAngleRadians = Conversions.radians(k);
                        anchorAngleRadians = Conversions.radians(k + (THETA / 2));
                        
                        xControl = _d * cos(controlAngleRadians);
                        yControl = _d * sin(controlAngleRadians);
                        xAnchor = _r * cos(anchorAngleRadians);
                        yAnchor = _r * sin(anchorAngleRadians);
                        
                        commands.push(GraphicsPathCommand.CURVE_TO);
                        drawingData.push(dotPos.x + xControl);
                        drawingData.push(dotPos.y + yControl);
                        drawingData.push(dotPos.x + xAnchor);
                        drawingData.push(dotPos.y + yAnchor);
                    }
                }  // draw dots  
                
                
                
                targetCast.graphics.lineStyle(0, 0xFF0000, 0);
                targetCast.graphics.beginFill(_color, _alpha);
                targetCast.graphics.drawPath(commands, drawingData, GraphicsPathWinding.NON_ZERO);
                targetCast.graphics.endFill();
            }
        }
    }
}

