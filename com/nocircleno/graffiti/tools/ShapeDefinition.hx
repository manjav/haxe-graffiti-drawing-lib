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

import openfl.Vector;
import openfl.geom.Point; 

 /**
* ShapeDefinition Class is used to represent a single shape graphic.
*/  
	
class ShapeDefinition
{
    public var type(get, set) : String;
    public var commands(get, set) : Vector<Int>;
    public var drawingData(get, set) : Vector<Float>;
    public var width(get, set) : Float;
    public var height(get, set) : Float;
    public var position(get, set) : Point;
    public var strokeColor(get, set) : Int;
    public var fillColor(get, set) : Int;
    public var strokeAlpha(get, set) : Float;
    public var fillAlpha(get, set) : Float;
    public var strokeSize(get, set) : Float;
		
	private var _type : String;
	private var _strokeColor : Int;
	private var _fillColor : Int;
	private var _strokeAlpha : Float;
	private var _fillAlpha : Float;
	private var _strokeSize : Float;
	private var _position : Point;
	private var _shapeWidth : Float;
	private var _shapeHeight : Float;
	private var _commnads : Vector<Int>;
	private var _drawingData : Vector<Float>;

	/**
	* The <code>ShapeDefinition</code> constructor.
	*
	* @param type Type of shape.
	* @param strokeColor Color of the shape stroke. Set to -1 for no stroke.
	* @param fillColor Color of the shape fill. Set to -1 for no fill.
	* @param strokeAlpha Alpha value of the shape stroke.
	* @param fillAlpha Alpha value of the shape fill.
	* @param strokeSize Size of the stroke.
	* @param commands Commands used to draw the brush mark.
	* @param drawingData Drawing data.
	* @param position Position of the brush mark.
	*/ 
	
	public function new(type : String, strokeColor : Int, fillColor : Int, strokeAlpha : Float, fillAlpha : Float, strokeSize : Float, shapeWidth : Float, shapeHeight : Float, commands : Vector<Int>, drawingData : Vector<Float>, position : Point)
    {
		// store properties 
		_type = type; 
		_strokeColor = strokeColor;
		_fillColor = fillColor;
		_strokeAlpha = strokeAlpha;
		_fillAlpha = fillAlpha;
		_strokeSize = strokeSize;
		_shapeWidth = shapeWidth;
		_shapeHeight = shapeHeight;
		_commnads = commands.concat(new Vector<Int>());
		_drawingData = drawingData.concat(new Vector<Float>());
		_position = position.clone();
    } 

	/**
	* Type of the brush.
	*/ 
	private function set_type(value : String) : String
	{
		_type = value;
        return value;
    }
	private function get_type() : String
	{
		return _type;
    } 

	/**
	* Commands value of the brush mark.
	*/  
	private function set_commands(value : Vector<Int>) : Vector<Int>
	{
		_commnads = value.concat(new Vector<Int>());
        return value;
    }
	private function get_commands() : Vector<Int>
	{
		return _commnads;
    }  
	
	/**
	* Drawing Data of the shape.
	*/  
	private function set_drawingData(value : Vector<Float>) : Vector<Float>
	{
		_drawingData = value.concat(new Vector<Float>());
        return value;
    }
	private function get_drawingData() : Vector<Float>{return _drawingData;
    } 

	/**
	* Width of the Shape
	*/
	private function set_width(value : Float) : Float
	{
		_shapeWidth = value;
        return value;
    }
	private function get_width() : Float
	{
		return _shapeWidth;
    }  
	
	/**
	* Height of the Shape
	*/
	private function set_height(value : Float) : Float
	{
		_shapeHeight = value;
        return value;
    }
	private function get_height() : Float
	{
		return _shapeHeight;
    }  
	
	/**
	* Position of the shape.
	*/
	private function set_position(value : Point) : Point
	{
		_position = value.clone();
        return value;
    }
	private function get_position() : Point
	{
		return _position;
    }  
	
	/**
	* Stroke Color of the Shape, set to -1 for no stroke.
	*/
	private function get_strokeColor() : Int
	{
		return _strokeColor;
	}
	private function set_strokeColor(value : Int) : Int
	{
		_strokeColor = value;
        return value;
    }  
	
	/**
	* Fill Color of the Shape, set to -1 for no fill.
	*/  
	private function get_fillColor() : Int
	{
		return _fillColor;
	}
    private function set_fillColor(value : Int) : Int
	{
		_fillColor = value;
        return value;
    }  
	
	/**
	* Alpha value for Shape Stroke.
	*/ 
	private function get_strokeAlpha() : Float
	{
		return _strokeAlpha;
    }
	private function set_strokeAlpha(value : Float) : Float
	{
		_strokeAlpha = value;
        return value;
    }
	
	/**
	* Alpha value for Shape Fill.
	*/  
	private function get_fillAlpha() : Float
	{
		return _fillAlpha;
    }
	private function set_fillAlpha(value : Float) : Float
	{
		_fillAlpha = value;
        return value;
    } 

	/**
	* Size of the Shape stroke.
	*/ 
	private function get_strokeSize() : Float
	{
		return _strokeSize;
    }
	private function set_strokeSize(value : Float) : Float
	{
		_strokeSize = value;
        return value;
    }

	/**
	* The <code>clone</code> method will return a new instance of the ShapeDefinition.
	*
	* @return Returns new ShapeDefinition with all the same settings.
	*/
	public function clone() : ShapeDefinition
	{
		return new ShapeDefinition(_type, _strokeColor, _fillColor, _strokeAlpha, _fillAlpha, _strokeSize, _shapeWidth, _shapeHeight, _commnads, _drawingData, _position);
    }
}