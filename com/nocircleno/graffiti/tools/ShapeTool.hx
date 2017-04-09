  /*

import openfl.display.DisplayObject;import openfl.display.Sprite;import openfl.display.LineScaleMode;import openfl.display.CapsStyle;import openfl.display.JointStyle;import openfl.display.GraphicsPathCommand;import openfl.display.GraphicsPathWinding;import openfl.geom.Rectangle;import openfl.geom.Point;import com.nocircleno.graffiti.tools.ITool;import com.nocircleno.graffiti.tools.ToolRenderType;import com.nocircleno.graffiti.tools.ShapeType;import com.nocircleno.graffiti.utils.Conversions;  /**
{
    public var strokeWidth(get, set) : Float;
    public var strokeColor(get, set) : Int;
    public var fillColor(get, set) : Int;
    public var strokeAlpha(get, set) : Float;
    public var fillAlpha(get, set) : Float;
  // store local references for performance reasons  private var cos : Function = Math.cos;private var sin : Function = Math.sin;private var sqrt : Function = Math.sqrt;private var pow : Function = Math.pow;private var abs : Function = Math.abs;private var max : Function = Math.max;private inline var MIN_SHAPE_SIZE_FOR_OBJECT : Int = 2;private inline var THETA : Int = 45;private var _strokeWidth : Float;private var _strokeColor : Int;private var _fillColor : Int;private var _strokeAlpha : Float;private var _fillAlpha : Float;  /**
    {
        super();  // set render type  _renderType = ToolRenderType.CLICK_DRAG;  // store size  this.strokeWidth = strokeWidth;  // store stroke color  this.strokeColor = strokeColor;  // store fill color  this.fillColor = fillColor;  // store stroke alpha  this.strokeAlpha = strokeAlpha;  // store fill alpha  this.fillAlpha = fillAlpha;  // store type  type = shapeType;  // store mode  mode = toolMode;  // store object drawing mode  _objectDrawingMode = objectDrawingMode;
    }  /**
        }
        else {layer = LayerType.DRAWING_LAYER;
        }return layer;
    }  /**
        }
        return strokeW;
    }private function get_strokeWidth() : Float{return _strokeWidth;
    }  /**
        return color;
    }private function get_strokeColor() : Int{return _strokeColor;
    }  /**
        return color;
    }private function get_fillColor() : Int{return _fillColor;
    }  /**
        return alpha;
    }private function get_strokeAlpha() : Float{return _strokeAlpha;
    }  /**
        return alpha;
    }private function get_fillAlpha() : Float{return _fillAlpha;
    }  /**
        }
        else {_type = ShapeType.RECTANGLE;
        }
        return shapeType;
    }  /**
            }if (drawingData[i] > _lowerRightCornerBounds.x) {_lowerRightCornerBounds.x = drawingData[i];
            }if (drawingData[i + 1] < _upperCornerBounds.y) {_upperCornerBounds.y = drawingData[i + 1];
            }if (drawingData[i + 1] > _lowerRightCornerBounds.y) {_lowerRightCornerBounds.y = drawingData[i + 1];
            }
        }  // calculate real width and height  var realWidth : Float = _lowerRightCornerBounds.x - _upperCornerBounds.x;var realHeight : Float = _lowerRightCornerBounds.y - _upperCornerBounds.y;  // adjust all data points so they are in a local symbol space    // where the farthest upper left point becomes 0, 0  for (i in 0...numDrawingData){drawingData[i] -= _upperCornerBounds.x;drawingData[i + 1] -= _upperCornerBounds.y;if (drawingData[i] > MIN_SHAPE_SIZE_FOR_OBJECT) {shapeValidWidth = true;
            }if (drawingData[i + 1] > MIN_SHAPE_SIZE_FOR_OBJECT) {shapeValidHeight = true;
            }
        }var shapeDef : ShapeDefinition;if (shapeValidWidth && shapeValidHeight) {shapeDef = new ShapeDefinition(_type, _strokeColor, _fillColor, _strokeAlpha, _fillAlpha, _strokeWidth, realWidth, realHeight, commands, drawingData, new Point(_upperCornerBounds.x, _upperCornerBounds.y));
        }return shapeDef;
    }  /**
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