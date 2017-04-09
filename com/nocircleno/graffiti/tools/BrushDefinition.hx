  /**  	Graffiti 3.0*  	______________________________________________________________________*  	www.nocircleno.com/graffiti/*/    /** 	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,* 	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES* 	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND* 	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT* 	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,* 	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING* 	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR* 	OTHER DEALINGS IN THE SOFTWARE.*/  package com.nocircleno.graffiti.tools;

import openfl.geom.Point;  /**	* BrushDefinition Class is used to store all information regarding a single brush mark.	*	* @langversion 3.0    * @playerversion Flash 10 AIR 1.5 	*/  class BrushDefinition extends Dynamic
{
    public var type(get, set) : String;
    public var color(get, set) : Int;
    public var alpha(get, set) : Float;
    public var size(get, set) : Float;
    public var blur(get, set) : Float;
    public var commands(get, set) : Array<Int>;
    public var drawingData(get, set) : Array<Float>;
    public var position(get, set) : Point;
private var _type : String;private var _color : Int;private var _alpha : Float;private var _size : Float;private var _blur : Float;private var _position : Point;private var _commnads : Array<Int>;private var _drawingData : Array<Float>;  /**		* The <code>BrushDefinition</code> constructor.		*		* @param color Color of the brush mark.		* @param alpha Alpha value of the brush mark.		* @param position Position of the brush mark.		* @param commands Commands used to draw the brush mark.		* @param drawingData Drawing data.		* 		*/  public function new(type : String, color : Int, alpha : Float, size : Float, blur : Float, commands : Array<Int>, drawingData : Array<Float>, position : Point)
    {
        super();  // store properties  _type = type;_color = color;_alpha = alpha;_size = size;_blur = blur;_position = position.clone();_commnads = commands.concat(new Array<Int>());_drawingData = drawingData.concat(new Array<Float>());
    }  /**		* Type of the brush.		*/  private function set_type(value : String) : String{_type = value;
        return value;
    }private function get_type() : String{return _type;
    }  /**		* Color of the brush mark.		*/  private function set_color(value : Int) : Int{_color = value;
        return value;
    }private function get_color() : Int{return _color;
    }  /**		* Alpha value of the brush mark.		*/  private function set_alpha(value : Float) : Float{_alpha = value;
        return value;
    }private function get_alpha() : Float{return _alpha;
    }  /**		* Size of the brush.		*/  private function set_size(value : Float) : Float{_size = value;
        return value;
    }private function get_size() : Float{return _size;
    }  /**		* Brush blur.		*/  private function set_blur(value : Float) : Float{_blur = value;
        return value;
    }private function get_blur() : Float{return _blur;
    }  /**		* Commands value of the brush mark.		*/  private function set_commands(value : Array<Int>) : Array<Int>{_commnads = value.concat(new Array<Int>());
        return value;
    }private function get_commands() : Array<Int>{return _commnads;
    }  /**		* Drawing Data of the brush mark.		*/  private function set_drawingData(value : Array<Float>) : Array<Float>{_drawingData = value.concat(new Array<Float>());
        return value;
    }private function get_drawingData() : Array<Float>{return _drawingData;
    }  /**		* Position of the brush mark.		*/  private function set_position(value : Point) : Point{_position = value.clone();
        return value;
    }private function get_position() : Point{return _position;
    }  /**		* The <code>clone</code> method will return a new instance of the BrushDefinition.		*		* @return Returns new BrushDefinition with all the same settings.		*/  public function clone() : BrushDefinition{return new BrushDefinition(_type, _color, _alpha, _size, _blur, _commnads, _drawingData, _position);
    }
}