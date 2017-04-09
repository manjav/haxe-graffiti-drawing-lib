/*
*  	Graffiti 3.0
*  	______________________________________________________________________
*  	www.nocircleno.com/graffiti/
*/    /*
* 	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* 	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* 	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* 	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* 	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* 	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* 	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* 	OTHER DEALINGS IN THE SOFTWARE.
*/
package com.nocircleno.graffiti.display;

import openfl.display.Sprite;
import openfl.display.GraphicsPathWinding;
import openfl.display.LineScaleMode;
import openfl.display.CapsStyle;
import openfl.display.JointStyle;
import openfl.events.Event;
import openfl.events.FocusEvent;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.filters.GlowFilter;
import openfl.filters.BlurFilter;
import openfl.filters.BitmapFilterQuality;
import openfl.geom.Rectangle;
import com.nocircleno.graffiti.events.GraffitiObjectEvent;
import com.nocircleno.graffiti.tools.ShapeDefinition;
import com.nocircleno.graffiti.tools.ShapeType;

/**
* ShapeObject Class displays a Shape as a GraffitiObject on the GraffitiCanvas.
*

*/

class ShapeObject extends GraffitiObject
{
	public var shapeDefinition(get, set) : ShapeDefinition;
	private var _container : Sprite;
	private var _selectionRect : Sprite;
	private var _shapeDefinition : ShapeDefinition;

	/**
	* The <code>ShapeObject</code> constructor.
	*
	* @param shapeDefinition ShapeDefinition instance.
	*/

	public function new(shapeDefinition : ShapeDefinition)
	{
		super();

		// store settings
		_shapeDefinition = shapeDefinition;

		// create background
		_container = new Sprite();
		_container.name = "shape_container";
		addChild(_container);

		_selectionRect = new Sprite();
		_selectionRect.name = "selection_rectangle";
		_selectionRect.mouseChildren = false;
		_selectionRect.mouseEnabled = false;
		addChild(_selectionRect);

		// enable double click to edit
		this.addEventListener(Event.REMOVED_FROM_STAGE, removeEventHandler);

		// draw it
		render();
	}

	/**
	* Set the Shape Definition for the Shape object.
	*/
	private function set_shapeDefinition(definition : ShapeDefinition) : ShapeDefinition
	{
		_shapeDefinition = definition;
		render();
		return definition;
	}
	private function get_shapeDefinition() : ShapeDefinition
	{
		return _shapeDefinition;
	}

	/**
	* Set Text selected state.
	*/
	override private function set_selected(select : Bool) : Bool
	{
		_selected = select;
		if (_selected)
		{
			_selectionRect.graphics.clear();
			var bounds : Rectangle = _container.getBounds(this);
			_selectionRect.graphics.lineStyle(1, GraffitiObject.SELECTED_COLOR, 1, true, LineScaleMode.NORMAL, CapsStyle.SQUARE, JointStyle.MITER);
			_selectionRect.graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);

			_selectionRect.filters = [new GlowFilter(GraffitiObject.SELECTED_COLOR, 1, 4, 4, 2, BitmapFilterQuality.HIGH, false, false)];
		}
		else
		{
			_selectionRect.graphics.clear();
			_selectionRect.filters = [];
		}
		return select;
	}

	/**
	* Set Shape Edit State. Can not edit shapes now.
	*/

	override private function set_editing(edit : Bool) : Bool
	{
		return edit;
	}

	/**************************************************************************
		Method	: updateSelectionRectangle()

		Purpose	: This method will update the display of the selection rect.
	***************************************************************************/
	override private function updateSelectionRectangle() : Void
	{
		_selectionRect.visible = _showSelectionRectangle;
	}

	/**************************************************************************
		Method	: render()

		Purpose	: This method will render the Shape.
	***************************************************************************/
	private function render() : Void
	{
		// draw shape
		_container.graphics.clear();

		// if stroke color exists, define line style
		if (_shapeDefinition.strokeColor != -1)
		{

			// use square corners with miter joints for rectangle and square shapes
			if (_shapeDefinition.type == ShapeType.RECTANGLE || _shapeDefinition.type == ShapeType.SQUARE)
			{
				_container.graphics.lineStyle(_shapeDefinition.strokeSize, _shapeDefinition.strokeColor, _shapeDefinition.strokeAlpha, false, LineScaleMode.NORMAL, CapsStyle.SQUARE, JointStyle.MITER);
			}
			else
			{
				_container.graphics.lineStyle(_shapeDefinition.strokeSize, _shapeDefinition.strokeColor, _shapeDefinition.strokeAlpha);
			}
		}

		// if fill color exists, start fill
		if (_shapeDefinition.fillColor != -1)
		{
			_container.graphics.beginFill(_shapeDefinition.fillColor, _shapeDefinition.fillAlpha);
		}

		// draw shape
		_container.graphics.drawPath(_shapeDefinition.commands, _shapeDefinition.drawingData, GraphicsPathWinding.NON_ZERO);

		// if fill color exists then end fill
		if (_shapeDefinition.fillColor != -1)
		{
			_container.graphics.endFill();
		}
	}

	/**************************************************************************
		Method	: removeEventHandler()

		Purpose	: This method will remove the event listeners for this object.

		Params	: e - Event Object
	***************************************************************************/
	private function removeEventHandler(e : Event) : Void
	{
		this.removeEventListener(Event.REMOVED_FROM_STAGE, removeEventHandler);
	}
}