  /**  	Graffiti 3.0*  	______________________________________________________________________*  	www.nocircleno.com/graffiti/*/    /** 	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,* 	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES* 	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND* 	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT* 	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,* 	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING* 	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR* 	OTHER DEALINGS IN THE SOFTWARE.*/  package com.nocircleno.graffiti.tools;

import openfl.display.DisplayObject;import openfl.display.Sprite;import openfl.display.LineScaleMode;import openfl.display.CapsStyle;import openfl.display.JointStyle;import openfl.display.GraphicsPathCommand;import openfl.display.GraphicsPathWinding;import openfl.geom.Rectangle;import openfl.geom.Point;import com.nocircleno.graffiti.tools.ITool;import com.nocircleno.graffiti.tools.ToolRenderType;import com.nocircleno.graffiti.tools.ShapeType;import com.nocircleno.graffiti.utils.Conversions;  /**	* ShapeTool Class allows the user to draw RECTANGLE, SQUARE, OVAL or CIRCLE to the canvas.	* You can control the stroke and fill of the shape.	*	* @langversion 3.0    * @playerversion Flash 10 AIR 1.5 	*/  @:final class ShapeTool extends BitmapTool
{
    public var strokeWidth(get, set) : Float;
    public var strokeColor(get, set) : Int;
    public var fillColor(get, set) : Int;
    public var strokeAlpha(get, set) : Float;
    public var fillAlpha(get, set) : Float;
  // store local references for performance reasons  private var cos : Function = Math.cos;private var sin : Function = Math.sin;private var sqrt : Function = Math.sqrt;private var pow : Function = Math.pow;private var abs : Function = Math.abs;private var max : Function = Math.max;private inline var MIN_SHAPE_SIZE_FOR_OBJECT : Int = 2;private inline var THETA : Int = 45;private var _strokeWidth : Float;private var _strokeColor : Int;private var _fillColor : Int;private var _strokeAlpha : Float;private var _fillAlpha : Float;  /**		* The <code>ShapeTool</code> constructor.		* 		* @param strokeWidth Stroke width.		* @param strokeColor Stroke Color, pass -1 for NO stroke on Shape.		* @param fillColor Fill Color, pass -1 for NO fill in Shape.		* @param strokeAlpha Stroke Alpha, default is 1.		* @param fillAlpha Fill Alpha, default is 1.		* @param shapeType Type of Shape.		* @param toolMode Tool mode the Shape will be drawing with.		* @param objectDrawingMode Does the tool draw in object drawing mode.		* 		* @example The following code creates a Shape instance.		* <listing version="3.0" >		* // create a rectangle shape with red stroke width of 2 and no fill		* var rectangleShape:Shape = new Shape(2, 0xFF0000, -1, 1, 1, ShapeType.RECTANGLE);		* </listing>		*/  public function new(strokeWidth : Float = 1, strokeColor : Int = 0x000000, fillColor : Int = 0xFFFFFF, strokeAlpha : Float = 1, fillAlpha : Float = 1, shapeType : String = null, toolMode : String = null, objectDrawingMode : Bool = false)
    {
        super();  // set render type  _renderType = ToolRenderType.CLICK_DRAG;  // store size  this.strokeWidth = strokeWidth;  // store stroke color  this.strokeColor = strokeColor;  // store fill color  this.fillColor = fillColor;  // store stroke alpha  this.strokeAlpha = strokeAlpha;  // store fill alpha  this.fillAlpha = fillAlpha;  // store type  type = shapeType;  // store mode  mode = toolMode;  // store object drawing mode  _objectDrawingMode = objectDrawingMode;
    }  /**		* Type of Layer the tool will draw to.		*/  override private function get_layerType() : String{var layer : String;if (_objectDrawingMode) {layer = LayerType.OBJECT_LAYER;
        }
        else {layer = LayerType.DRAWING_LAYER;
        }return layer;
    }  /**		* Stroke width		*/  private function set_strokeWidth(strokeW : Float) : Float{if (strokeW > 0 || strokeW == -1) {  // set stroke size  _strokeWidth = strokeW;
        }
        return strokeW;
    }private function get_strokeWidth() : Float{return _strokeWidth;
    }  /**		* Color of the Stroke, set to -1 for no stroke.		*/  private function set_strokeColor(color : Int) : Int{_strokeColor = color;
        return color;
    }private function get_strokeColor() : Int{return _strokeColor;
    }  /**		* Color of the Fill, set to -1 for no fill.		*/  private function set_fillColor(color : Int) : Int{_fillColor = color;
        return color;
    }private function get_fillColor() : Int{return _fillColor;
    }  /**		* Alpha of the Stroke		*/  private function set_strokeAlpha(alpha : Float) : Float{_strokeAlpha = alpha;
        return alpha;
    }private function get_strokeAlpha() : Float{return _strokeAlpha;
    }  /**		* Alpha of the Fill		*/  private function set_fillAlpha(alpha : Float) : Float{_fillAlpha = alpha;
        return alpha;
    }private function get_fillAlpha() : Float{return _fillAlpha;
    }  /**		* Type of Shape		*/  override private function set_type(shapeType : String) : String{  // determine type  if (shapeType != null && ShapeType.validType(shapeType)) {_type = shapeType;
        }
        else {_type = ShapeType.RECTANGLE;
        }
        return shapeType;
    }  /**		* The <code>getShapeDefinition</code> method returns the shape data. This is used		* with object drawing mode.		* 		* @return The Shape definition.		*		*/  public function getShapeDefinition() : ShapeDefinition{var numDrawingData : Int = drawingData.length;var shapeValidWidth : Bool = false;var shapeValidHeight : Bool = false;  // determine the the lowest position  for (i in 0...numDrawingData){if (drawingData[i] < _upperCornerBounds.x) {_upperCornerBounds.x = drawingData[i];
            }if (drawingData[i] > _lowerRightCornerBounds.x) {_lowerRightCornerBounds.x = drawingData[i];
            }if (drawingData[i + 1] < _upperCornerBounds.y) {_upperCornerBounds.y = drawingData[i + 1];
            }if (drawingData[i + 1] > _lowerRightCornerBounds.y) {_lowerRightCornerBounds.y = drawingData[i + 1];
            }
        }  // calculate real width and height  var realWidth : Float = _lowerRightCornerBounds.x - _upperCornerBounds.x;var realHeight : Float = _lowerRightCornerBounds.y - _upperCornerBounds.y;  // adjust all data points so they are in a local symbol space    // where the farthest upper left point becomes 0, 0  for (i in 0...numDrawingData){drawingData[i] -= _upperCornerBounds.x;drawingData[i + 1] -= _upperCornerBounds.y;if (drawingData[i] > MIN_SHAPE_SIZE_FOR_OBJECT) {shapeValidWidth = true;
            }if (drawingData[i + 1] > MIN_SHAPE_SIZE_FOR_OBJECT) {shapeValidHeight = true;
            }
        }var shapeDef : ShapeDefinition;if (shapeValidWidth && shapeValidHeight) {shapeDef = new ShapeDefinition(_type, _strokeColor, _fillColor, _strokeAlpha, _fillAlpha, _strokeWidth, realWidth, realHeight, commands, drawingData, new Point(_upperCornerBounds.x, _upperCornerBounds.y));
        }return shapeDef;
    }  /**		* The <code>apply</code> method applies the line to the Sprite object passed		* to the method.		* 		* @param drawingTarget Sprite that the Shape will draw to.		* @param point1 Starting point to apply Shape.		* @param point2 End point to apply Shape.		*/  override public function apply(drawingTarget : DisplayObject, point1 : Point, point2 : Point = null) : Void{var k : Int;var xControl : Float;var yControl : Float;var xAnchor : Float;var yAnchor : Float;var r : Float;var r2 : Float;var d : Float;var d2 : Float;var controlAngleRadians : Float;var anchorAngleRadians : Float;var centerPoint : Point;  // clear drawing commands and data  resetTool();  // cast target as a Sprite  var targetCast : Sprite = cast((drawingTarget), Sprite);  // calculate dim differences  var xDiff : Float = point2.x - point1.x;var yDiff : Float = point2.y - point1.y;  // if stroke color exists, define line style  if (_strokeColor != -1) {  // use square corners with miter joints for rectangle and square shapes  if (_type == ShapeType.RECTANGLE || _type == ShapeType.SQUARE) {targetCast.graphics.lineStyle(_strokeWidth, _strokeColor, _strokeAlpha, false, LineScaleMode.NORMAL, CapsStyle.SQUARE, JointStyle.MITER);
            }
            else {targetCast.graphics.lineStyle(_strokeWidth, _strokeColor, _strokeAlpha);
            }
        }  // if fill color exists, start fill  if (_fillColor != -1) {targetCast.graphics.beginFill(_fillColor, _fillAlpha);
        }  // draw shape  if (_type == ShapeType.RECTANGLE) {commands.push(GraphicsPathCommand.MOVE_TO);drawingData.push(point1.x);drawingData.push(point1.y);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(point1.x + xDiff);drawingData.push(point1.y);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(point1.x + xDiff);drawingData.push(point1.y + yDiff);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(point1.x);drawingData.push(point1.y + yDiff);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(point1.x);drawingData.push(point1.y);
        }if (_type == ShapeType.SQUARE) {  // calculate length  var segmentLength : Float = abs(max(xDiff, yDiff));var squareWidth : Float = (point2.x < point1.x) ? -segmentLength : segmentLength;var squareHeight : Float = (point2.y < point1.y) ? -segmentLength : segmentLength;commands.push(GraphicsPathCommand.MOVE_TO);drawingData.push(point1.x);drawingData.push(point1.y);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(point1.x + squareWidth);drawingData.push(point1.y);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(point1.x + squareWidth);drawingData.push(point1.y + squareHeight);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(point1.x);drawingData.push(point1.y + squareHeight);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(point1.x);drawingData.push(point1.y);
        }
        else if (_type == ShapeType.OVAL) {r = xDiff / 2;r2 = yDiff / 2;d = r / cos(Conversions.radians(0.5 * THETA));d2 = r2 / cos(Conversions.radians(0.5 * THETA));centerPoint = new Point(point1.x + ((xDiff) / 2), point1.y + ((yDiff) / 2));commands.push(GraphicsPathCommand.MOVE_TO);drawingData.push(centerPoint.x + r);drawingData.push(centerPoint.y);  // draw the new preview circle  for (k in (THETA / 2)...361){controlAngleRadians = Conversions.radians(k);anchorAngleRadians = Conversions.radians(k + (THETA / 2));xControl = d * cos(controlAngleRadians);yControl = d2 * sin(controlAngleRadians);xAnchor = r * cos(anchorAngleRadians);yAnchor = r2 * sin(anchorAngleRadians);commands.push(GraphicsPathCommand.CURVE_TO);drawingData.push(centerPoint.x + xControl);drawingData.push(centerPoint.y + yControl);drawingData.push(centerPoint.x + xAnchor);drawingData.push(centerPoint.y + yAnchor);
            }
        }
        // draw shape
        else if (_type == ShapeType.CIRCLE) {var lineLength : Float = sqrt(pow(point2.x - point1.x, 2) + pow(point2.y - point1.y, 2));r = lineLength / 2;d = r / cos(Conversions.radians(0.5 * THETA));centerPoint = new Point(point1.x + ((xDiff) / 2), point1.y + ((yDiff) / 2));commands.push(GraphicsPathCommand.MOVE_TO);drawingData.push(centerPoint.x + r);drawingData.push(centerPoint.y);for (k in (THETA / 2)...361){controlAngleRadians = Conversions.radians(k);anchorAngleRadians = Conversions.radians(k + (THETA / 2));xControl = d * cos(controlAngleRadians);yControl = d * sin(controlAngleRadians);xAnchor = r * cos(anchorAngleRadians);yAnchor = r * sin(anchorAngleRadians);commands.push(GraphicsPathCommand.CURVE_TO);drawingData.push(centerPoint.x + xControl);drawingData.push(centerPoint.y + yControl);drawingData.push(centerPoint.x + xAnchor);drawingData.push(centerPoint.y + yAnchor);
            }
        }targetCast.graphics.drawPath(commands, drawingData, GraphicsPathWinding.NON_ZERO);  // if fill color exists then end fill  if (_fillColor != -1) {targetCast.graphics.endFill();
        }
    }
}