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
import openfl.geom.Point;
import com.nocircleno.graffiti.tools.ITool;

/**
* BitmapTool Class is the base class used by Tools that draw to the bitmap layer.
*/

class BitmapTool implements ITool
{
	public var renderType(get, never) : String;
	public var type(get, set) : String;
	public var layerType(get, never) : String;
	public var mode(get, set) : String;
	public var objectDrawingMode(get, set) : Bool;

	private var _renderType : String;
	private var _mode : String;
	private var _type : String; private var commands : Array<Int> = new Array<Int>();
	private var drawingData : Array<Float> = new Array<Float>();
	private var _upperCornerBounds : Point = new Point(Float.MAX_VALUE, Float.MAX_VALUE);
	private var _lowerRightCornerBounds : Point = new Point(Float.MIN_VALUE, Float.MIN_VALUE);
	private var _objectDrawingMode : Bool = false;

	public function new()
	{
	}

	/**
	* Render Type
	*/
	private function get_renderType() : String
	{
		return _renderType;
	}

	/**
	* Type of Tool Option
	*/
	private function set_type(t : String) : String
	{
		_type = t;
		return t;
	}

	private function get_type() : String
	{
		return _type;
	}

	/**
	* Layer Tool Writes In
	*/
	private function get_layerType() : String
	{
		var layer : String;
		if (_objectDrawingMode)
		{
			layer = LayerType.OBJECT_LAYER;
		}
		else
		{
			layer = LayerType.DRAWING_LAYER;
		}
		return layer;
	}

	/**
	* Drawing Mode
	*/
	private function set_mode(toolMode : String) : String
	{
		// store mode
		if (toolMode != null && ToolMode.validMode(toolMode))
		{
			_mode = toolMode;
		}
		else
		{
			_mode = ToolMode.NORMAL;
		}
		return toolMode;
	}

	private function get_mode() : String
	{
		return _mode;
	}

	/**
	* Object Drawing Mode
	*/
	private function set_objectDrawingMode(mode : Bool) : Bool
	{
		_objectDrawingMode = mode;
		return mode;
	}

	private function get_objectDrawingMode() : Bool
	{
		return _objectDrawingMode;
	}

	/**
	* The <code>resetTool</code> method will reset the drawing data held by the tool.
	*/
	public function resetTool() : Void
	{
		_upperCornerBounds.x = Float.MAX_VALUE;
		_upperCornerBounds.y = Float.MAX_VALUE;
		_lowerRightCornerBounds.x = Float.MIN_VALUE;
		_lowerRightCornerBounds.y = Float.MIN_VALUE;
		commands = new Array<Int>();
		drawingData = new Array<Float>();
	}

	/**
	* The <code>apply</code> method applies the BitmapTool to the DisplayObject passed
	* to the method.
	*
	* @param drawingTarget Sprite that the bitmap tool will draw to.
	* @param point1 Starting point to apply tool.
	* @param point2 End point to apply tool.
	*/
	public function apply(drawingTarget : DisplayObject, point1 : Point, point2 : Point = null) : Void
	{
	}
}