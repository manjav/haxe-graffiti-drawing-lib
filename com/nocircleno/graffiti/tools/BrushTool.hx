  /*

import openfl.display.DisplayObject;import openfl.display.Sprite;import openfl.display.Shape;import openfl.display.LineScaleMode;import openfl.display.CapsStyle;import openfl.display.JointStyle;import openfl.display.GraphicsPathCommand;import openfl.display.GraphicsPathWinding;import openfl.filters.BlurFilter;import openfl.filters.BitmapFilterQuality;import openfl.geom.Rectangle;import openfl.geom.Point;import com.nocircleno.graffiti.tools.ITool;import com.nocircleno.graffiti.tools.ToolRenderType;import com.nocircleno.graffiti.tools.BrushType;import com.nocircleno.graffiti.utils.Conversions;  /**
{
    public var size(get, set) : Float;
    public var color(get, set) : Int;
    public var alpha(get, set) : Float;
    public var blur(get, set) : Float;
  // store local references for performance reasons  private var sin : Function = Math.sin;private var cos : Function = Math.cos;private var atan2 : Function = Math.atan2;private var abs : Function = Math.abs;private var _size : Float;private var _halfSize : Float;private var _fourthSize : Float;private var _eighthSize : Float;private var _sixteenthSize : Float;private var _color : Int;private var _alpha : Float;private var _blur : Float;  /**
    {
        super();  // set render type  _renderType = ToolRenderType.CONTINUOUS;  // store size  size = brushSize;  // store color  color = brushColor;  // store alpha  alpha = brushAlpha;  // brush blur  blur = brushBlur;  // store type  type = brushType;  // store mode  mode = toolMode;  // store object drawing mode  _objectDrawingMode = objectDrawingMode;
    }  /**
        }
        return brushSize;
    }private function get_size() : Float{return _size;
    }  /**
        return brushColor;
    }private function get_color() : Int{return _color;
    }  /**
        }
        else if (brushAlpha > 1) {brushAlpha = 1;
        }_alpha = brushAlpha;
        return brushAlpha;
    }private function get_alpha() : Float{return _alpha;
    }  /**
        }_blur = brushBlur;
        return brushBlur;
    }private function get_blur() : Float{return _blur;
    }  /**
        }
        else {_type = BrushType.SQUARE;
        }
        return brushType;
    }  /**
            }if (drawingData[i + 1] < _upperCornerBounds.y) {_upperCornerBounds.y = drawingData[i + 1];
            }
        }  // where the farthest upper left point becomes 0, 0    // adjust all data points so they are in a local symbol space  for (i in 0...numDrawingData){drawingData[i] -= _upperCornerBounds.x;drawingData[i + 1] -= _upperCornerBounds.y;
        }return new BrushDefinition(_type, _color, _alpha, _size, _blur, commands, drawingData, new Point(_upperCornerBounds.x, _upperCornerBounds.y));
    }  /**
        }
        else {genBrushSize = brushSize;genBrushHalfSize = brushSize / 2;genBrushFourthSize = brushSize / 4;genBrushEighthSize = brushSize / 8;genBrushSixteenthSize = brushSize / 16;
        }  // check brush color  if (brushColor < 0) {genColor = _color;
        }
        else {genColor = brushColor;
        }  // apply blur filter if blur is grater than zero  if (_blur > 0) {brush_sp.filters = [new BlurFilter(_blur, _blur, BitmapFilterQuality.MEDIUM)];
        }  //////////////////////////////////////////////////////////    // Round Shape Brush    //////////////////////////////////////////////////////////  if (_type == BrushType.ROUND) {brush_sp.graphics.beginFill(genColor, 1);brush_sp.graphics.drawCircle(0, 0, genBrushHalfSize);brush_sp.graphics.endFill();
        }
        else if (_type == BrushType.HORIZONTAL_LINE || _type == BrushType.VERTICAL_LINE || _type == BrushType.SQUARE) {if (_type == BrushType.HORIZONTAL_LINE) {xOffset = genBrushHalfSize;yOffset = genBrushSixteenthSize;
            }
            else if (_type == BrushType.VERTICAL_LINE) {xOffset = genBrushSixteenthSize;yOffset = genBrushHalfSize;
            }
            else if (_type == BrushType.SQUARE) {xOffset = genBrushHalfSize;yOffset = genBrushHalfSize;
            }brush_sp.graphics.beginFill(genColor, 1);brush_sp.graphics.drawRect(-xOffset, -yOffset, xOffset << 1, yOffset << 1);brush_sp.graphics.endFill();
        }
        else if (_type == BrushType.FORWARD_LINE) {brush_sp.graphics.beginFill(genColor, 1);brush_sp.graphics.moveTo(genBrushHalfSize - genBrushEighthSize, -genBrushHalfSize);brush_sp.graphics.lineTo(genBrushHalfSize, -genBrushHalfSize);brush_sp.graphics.lineTo(-genBrushHalfSize + genBrushEighthSize, genBrushHalfSize);brush_sp.graphics.lineTo(-genBrushHalfSize, genBrushHalfSize);brush_sp.graphics.lineTo(genBrushHalfSize - genBrushEighthSize, -genBrushHalfSize);brush_sp.graphics.endFill();
        }
        else if (_type == BrushType.BACKWARD_LINE) {brush_sp.graphics.beginFill(genColor, 1);brush_sp.graphics.moveTo(-genBrushHalfSize + genBrushEighthSize, -genBrushHalfSize);brush_sp.graphics.lineTo(-genBrushHalfSize, -genBrushHalfSize);brush_sp.graphics.lineTo(genBrushHalfSize - genBrushEighthSize, genBrushHalfSize);brush_sp.graphics.lineTo(genBrushHalfSize, genBrushHalfSize);brush_sp.graphics.lineTo(-genBrushHalfSize + genBrushEighthSize, -genBrushHalfSize);brush_sp.graphics.endFill();
        }
        else if (_type == BrushType.DIAMOND) {brush_sp.graphics.beginFill(genColor, 1);brush_sp.graphics.moveTo(0, -genBrushHalfSize);brush_sp.graphics.lineTo(genBrushHalfSize, 0);brush_sp.graphics.lineTo(0, genBrushHalfSize);brush_sp.graphics.lineTo(-genBrushHalfSize, 0);brush_sp.graphics.lineTo(0, -genBrushHalfSize);brush_sp.graphics.endFill();
        }return brush_sp;
    }  /**
        }  // if we only have one point then draw a single shape of the  if (point2 == null) {  //////////////////////////////////////////////////////////    // Round Shape Brush    //////////////////////////////////////////////////////////  if (_type == BrushType.ROUND) {commands.push(GraphicsPathCommand.MOVE_TO);drawingData.push(point1.x);drawingData.push(point1.y);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(point1.x + 1);drawingData.push(point1.y + 1);
            }
            else if (_type == BrushType.HORIZONTAL_LINE || _type == BrushType.VERTICAL_LINE || _type == BrushType.SQUARE) {if (_type == BrushType.HORIZONTAL_LINE) {xOffset = _halfSize;yOffset = _sixteenthSize;
                }
                else if (_type == BrushType.VERTICAL_LINE) {xOffset = _sixteenthSize;yOffset = _halfSize;
                }
                else if (_type == BrushType.SQUARE) {xOffset = _halfSize;yOffset = _halfSize;
                }commands.push(GraphicsPathCommand.MOVE_TO);drawingData.push(point1.x - xOffset);drawingData.push(point1.y - yOffset);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(point1.x - xOffset + (xOffset << 1));drawingData.push(point1.y - yOffset);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(point1.x - xOffset + (xOffset << 1));drawingData.push(point1.y - yOffset + (yOffset << 1));commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(point1.x - xOffset);drawingData.push(point1.y - yOffset + (yOffset << 1));commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(point1.x - xOffset);drawingData.push(point1.y - yOffset);
            }
            else if (_type == BrushType.FORWARD_LINE) {commands.push(GraphicsPathCommand.MOVE_TO);drawingData.push(point1.x + _halfSize - _eighthSize);drawingData.push(point1.y - _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(point1.x + _halfSize);drawingData.push(point1.y - _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(point1.x - _halfSize + _eighthSize);drawingData.push(point1.y + _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(point1.x - _halfSize);drawingData.push(point1.y + _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(point1.x + _halfSize - _eighthSize);drawingData.push(point1.y - _halfSize);
            }
            else if (_type == BrushType.BACKWARD_LINE) {commands.push(GraphicsPathCommand.MOVE_TO);drawingData.push(point1.x - _halfSize + _eighthSize);drawingData.push(point1.y - _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(point1.x - _halfSize);drawingData.push(point1.y - _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(point1.x + _halfSize - _eighthSize);drawingData.push(point1.y + _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(point1.x + _halfSize);drawingData.push(point1.y + _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(point1.x - _halfSize + _eighthSize);drawingData.push(point1.y - _halfSize);
            }
            else if (_type == BrushType.DIAMOND) {commands.push(GraphicsPathCommand.MOVE_TO);drawingData.push(point1.x);drawingData.push(point1.y - _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(point1.x + _halfSize);drawingData.push(point1.y);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(point1.x);drawingData.push(point1.y + _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(point1.x - _halfSize);drawingData.push(point1.y);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(point1.x);drawingData.push(point1.y - _halfSize);
            }
        }
        else {  // check for order of points  if (point1.x <= point2.x) {vPoint1 = point1;vPoint2 = point2;
            }
            else {vPoint1 = point2;vPoint2 = point1;
            }  //////////////////////////////////////////////////////////    // Round Shape Brushes    //////////////////////////////////////////////////////////  if (_type == BrushType.ROUND) {commands.push(GraphicsPathCommand.MOVE_TO);drawingData.push(point1.x);drawingData.push(point1.y);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(point2.x);drawingData.push(point2.y);
            }
            else if (_type == BrushType.HORIZONTAL_LINE || _type == BrushType.VERTICAL_LINE || _type == BrushType.SQUARE) {if (_type == BrushType.HORIZONTAL_LINE) {xOffset = _halfSize;yOffset = _sixteenthSize;
                }
                else if (_type == BrushType.VERTICAL_LINE) {xOffset = _sixteenthSize;yOffset = _halfSize;
                }
                else if (_type == BrushType.SQUARE) {xOffset = _halfSize;yOffset = _halfSize;
                }if (vPoint1.y < vPoint2.y) {commands.push(GraphicsPathCommand.MOVE_TO);drawingData.push(vPoint1.x + xOffset);drawingData.push(vPoint1.y - yOffset);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint2.x + xOffset);drawingData.push(vPoint2.y - yOffset);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint2.x + xOffset);drawingData.push(vPoint2.y + yOffset);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint2.x - xOffset);drawingData.push(vPoint2.y + yOffset);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint1.x - xOffset);drawingData.push(vPoint1.y + yOffset);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint1.x - xOffset);drawingData.push(vPoint1.y - yOffset);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint1.x + xOffset);drawingData.push(vPoint1.y - yOffset);
                }
                else {commands.push(GraphicsPathCommand.MOVE_TO);drawingData.push(vPoint1.x - xOffset);drawingData.push(vPoint1.y - yOffset);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint2.x - xOffset);drawingData.push(vPoint2.y - yOffset);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint2.x + xOffset);drawingData.push(vPoint2.y - yOffset);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint2.x + xOffset);drawingData.push(vPoint2.y + yOffset);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint1.x + xOffset);drawingData.push(vPoint1.y + yOffset);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint1.x - xOffset);drawingData.push(vPoint1.y + yOffset);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint1.x - xOffset);drawingData.push(vPoint1.y - yOffset);
                }  //////////////////////////////////////////////////////////    // Foward Line Shape Brush    //////////////////////////////////////////////////////////  
            }
            else if (_type == BrushType.FORWARD_LINE) {angleBetweenPoints = Conversions.degrees(atan2(vPoint2.x - vPoint1.x, vPoint2.y - vPoint1.y));commands.push(GraphicsPathCommand.MOVE_TO);drawingData.push(vPoint1.x - _halfSize);drawingData.push(vPoint1.y + _halfSize);if (angleBetweenPoints >= 135) {commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint2.x - _halfSize);drawingData.push(vPoint2.y + _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint2.x + _halfSize - _eighthSize);drawingData.push(vPoint2.y - _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint2.x + _halfSize);drawingData.push(vPoint2.y - _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint1.x + _halfSize);drawingData.push(vPoint1.y - _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint1.x - _halfSize + _eighthSize);drawingData.push(vPoint1.y + _halfSize);
                }
                else if (angleBetweenPoints >= 90) {commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint1.x + _halfSize - _eighthSize);drawingData.push(vPoint1.y - _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint2.x + _halfSize - _eighthSize);drawingData.push(vPoint2.y - _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint2.x + _halfSize);drawingData.push(vPoint2.y - _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint2.x - _halfSize + _eighthSize);drawingData.push(vPoint2.y + _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint1.x - _halfSize + _eighthSize);drawingData.push(vPoint1.y + _halfSize);
                }
                else {commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint1.x + _halfSize - _eighthSize);drawingData.push(vPoint1.y - _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint1.x + _halfSize);drawingData.push(vPoint1.y - _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint2.x + _halfSize);drawingData.push(vPoint2.y - _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint2.x - _halfSize + _eighthSize);drawingData.push(vPoint2.y + _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint2.x - _halfSize);drawingData.push(vPoint2.y + _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint1.x - _halfSize + _eighthSize);drawingData.push(vPoint1.y + _halfSize);
                }commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint1.x - _halfSize);drawingData.push(vPoint1.y + _halfSize);
            }
            else if (_type == BrushType.BACKWARD_LINE) {angleBetweenPoints = Conversions.degrees(atan2(vPoint2.x - vPoint1.x, vPoint2.y - vPoint1.y));commands.push(GraphicsPathCommand.MOVE_TO);drawingData.push(vPoint1.x - _halfSize);drawingData.push(vPoint1.y - _halfSize);if (angleBetweenPoints <= 45) {commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint1.x - _halfSize + _eighthSize);drawingData.push(vPoint1.y - _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint1.x + _halfSize);drawingData.push(vPoint1.y + _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint2.x + _halfSize);drawingData.push(vPoint2.y + _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint2.x + _halfSize - _eighthSize);drawingData.push(vPoint2.y + _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint2.x - _halfSize);drawingData.push(vPoint2.y - _halfSize);
                }
                //////////////////////////////////////////////////////////
                // Diamond Shape Brush
                //////////////////////////////////////////////////////////
                else if (angleBetweenPoints <= 90) {commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint1.x - _halfSize + _eighthSize);drawingData.push(vPoint1.y - _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint2.x - _halfSize + _eighthSize);drawingData.push(vPoint2.y - _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint2.x + _halfSize);drawingData.push(vPoint2.y + _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint2.x + _halfSize - _eighthSize);drawingData.push(vPoint2.y + _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint1.x + _halfSize - _eighthSize);drawingData.push(vPoint1.y + _halfSize);
                }
                else {commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint2.x - _halfSize);drawingData.push(vPoint2.y - _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint2.x - _halfSize + _eighthSize);drawingData.push(vPoint2.y - _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint2.x + _halfSize);drawingData.push(vPoint2.y + _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint1.x + _halfSize);drawingData.push(vPoint1.y + _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint1.x + _halfSize - _eighthSize);drawingData.push(vPoint1.y + _halfSize);
                }
            }
            else if (_type == BrushType.DIAMOND) {if (abs(point2.x - point1.x) > abs(point2.y - point1.y)) {commands.push(GraphicsPathCommand.MOVE_TO);drawingData.push(vPoint1.x);drawingData.push(vPoint1.y - _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint2.x);drawingData.push(vPoint2.y - _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint2.x + _halfSize);drawingData.push(vPoint2.y);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint2.x);drawingData.push(vPoint2.y + _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint1.x);drawingData.push(vPoint1.y + _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint1.x - _halfSize);drawingData.push(vPoint1.y);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint1.x);drawingData.push(vPoint1.y - _halfSize);
                }
                else {  // check for order of points based of y  if (point1.y < point2.y) {vPoint1 = point1;vPoint2 = point2;
                    }
                    else {vPoint1 = point2;vPoint2 = point1;
                    }  // store brush segment  commands.push(GraphicsPathCommand.MOVE_TO);drawingData.push(vPoint1.x + _halfSize);drawingData.push(vPoint1.y);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint2.x + _halfSize);drawingData.push(vPoint2.y);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint2.x);drawingData.push(vPoint2.y + _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint2.x - _halfSize);drawingData.push(vPoint2.y);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint1.x - _halfSize);drawingData.push(vPoint1.y);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint1.x);drawingData.push(vPoint1.y - _halfSize);commands.push(GraphicsPathCommand.LINE_TO);drawingData.push(vPoint1.x + _halfSize);drawingData.push(vPoint1.y);
                }
            }
        }  // draw brush session  targetCast.graphics.clear();if (_type == BrushType.ROUND) {targetCast.graphics.lineStyle(_size, _color, _alpha, false, LineScaleMode.NORMAL, CapsStyle.ROUND);
        }
        else {targetCast.graphics.beginFill(_color, _alpha);
        }targetCast.graphics.drawPath(commands, drawingData, GraphicsPathWinding.NON_ZERO);
    }
}