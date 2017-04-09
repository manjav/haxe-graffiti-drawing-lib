  /**  	Graffiti 3.0*  	______________________________________________________________________*  	www.nocircleno.com/graffiti/*/    /** 	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,* 	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES* 	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND* 	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT* 	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,* 	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING* 	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR* 	OTHER DEALINGS IN THE SOFTWARE.*/  package com.nocircleno.graffiti.tools;

import openfl.geom.Point;  /**	* LineDefinition Class is used to represent a single shape graphic.	*	* @langversion 3.0    * @playerversion Flash 10 AIR 1.5 	*/  class LineDefinition extends Dynamic
{
    public var type(get, set) : String;
    public var commands(get, set) : Array<Int>;
    public var drawingData(get, set) : Array<Float>;
    public var width(get, set) : Float;
    public var height(get, set) : Float;
    public var position(get, set) : Point;
    public var strokeColor(get, set) : Int;
    public var strokeAlpha(get, set) : Float;
    public var strokeSize(get, set) : Float;
private var _type : String;private var _strokeColor : Int;private var _strokeAlpha : Float;private var _strokeSize : Float;private var _position : Point;private var _lineWidth : Float;private var _lineHeight : Float;private var _commnads : Array<Int>;private var _drawingData : Array<Float>;  /**		* The <code>LineDefinition</code> constructor.		*		* @param type Type of shape.		* @param strokeColor Color of the shape stroke. Set to -1 for no stroke.		* @param strokeAlpha Alpha value of the shape stroke.		* @param strokeSize Size of the stroke.		* @param lineWidth Width of the bounding box around the line.		* @param lineHeight Height of the bounding box around the line.		* @param commands Commands used to draw the brush mark.		* @param drawingData Drawing data.		* @param position Position of the brush mark.		* 		*/  public function new(type : String, strokeColor : Int, strokeAlpha : Float, strokeSize : Float, lineWidth : Float, lineHeight : Float, commands : Array<Int>, drawingData : Array<Float>, position : Point)
    {
        super();  // store properties  _type = type;_strokeColor = strokeColor;_strokeAlpha = strokeAlpha;_strokeSize = strokeSize;_lineWidth = lineWidth;_lineHeight = lineHeight;_commnads = commands.concat(new Array<Int>());_drawingData = drawingData.concat(new Array<Float>());_position = position.clone();
    }  /**		* Type of the brush.		*/  private function set_type(value : String) : String{_type = value;
        return value;
    }private function get_type() : String{return _type;
    }  /**		* Commands value of the line definition marks.		*/  private function set_commands(value : Array<Int>) : Array<Int>{_commnads = value.concat(new Array<Int>());
        return value;
    }private function get_commands() : Array<Int>{return _commnads;
    }  /**		* Drawing Data of the line.		*/  private function set_drawingData(value : Array<Float>) : Array<Float>{_drawingData = value.concat(new Array<Float>());
        return value;
    }private function get_drawingData() : Array<Float>{return _drawingData;
    }  /**		* Width of the line		*/  private function set_width(value : Float) : Float{_lineWidth = value;
        return value;
    }private function get_width() : Float{return _lineWidth;
    }  /**		* Height of the Shape		*/  private function set_height(value : Float) : Float{_lineHeight = value;
        return value;
    }private function get_height() : Float{return _lineHeight;
    }  /**		* Position of the shape.		*/  private function set_position(value : Point) : Point{_position = value.clone();
        return value;
    }private function get_position() : Point{return _position;
    }  /**		* Stroke Color of the Shape, set to -1 for no stroke.		*/  private function get_strokeColor() : Int{return _strokeColor;
    }private function set_strokeColor(value : Int) : Int{_strokeColor = value;
        return value;
    }  /**		* Alpha value for Shape Stroke.		*/  private function get_strokeAlpha() : Float{return _strokeAlpha;
    }private function set_strokeAlpha(value : Float) : Float{_strokeAlpha = value;
        return value;
    }  /**		* Size of the Shape stroke.		*/  private function get_strokeSize() : Float{return _strokeSize;
    }private function set_strokeSize(value : Float) : Float{_strokeSize = value;
        return value;
    }  /**		* The <code>clone</code> method will return a new instance of the LineDefinition.		*		* @return Returns new LineDefinition with all the same settings.		*/  public function clone() : LineDefinition{return new LineDefinition(_type, _strokeColor, _strokeAlpha, _strokeSize, _lineWidth, _lineHeight, _commnads, _drawingData, _position);
    }
}