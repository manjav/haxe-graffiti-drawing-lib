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
import com.nocircleno.graffiti.tools.LineDefinition;
import com.nocircleno.graffiti.tools.LineType;

/**
* LineObject Class displays a Line as a GraffitiObject on the GraffitiCanvas.
*/

class LineObject extends GraffitiObject
{
	public var lineDefinition(get, set) : LineDefinition;
	private var _container : Sprite;
	private var _selectionRect : Sprite;
	private var _lineDefinition : LineDefinition;

	/**
	* The <code>LineObject</code> constructor.
	*
	* @param lineDefinition LineDefinition instance.
	*/
	public function new(lineDefinition : LineDefinition)
	{

		super();
		// store settings
		_lineDefinition = lineDefinition;

		// create background
		_container = new Sprite();
		_container.name = "line_container";
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
	* Set the Line Definition for the Line object.
	*/
	private function set_lineDefinition(definition : LineDefinition) : LineDefinition
	{
		_lineDefinition = definition; render();
		return definition;
	}

	private function get_lineDefinition() : LineDefinition
	{
		return _lineDefinition;
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

		if (_lineDefinition.type == LineType.SOLID)
		{
			_container.graphics.lineStyle(_lineDefinition.strokeSize, _lineDefinition.strokeColor, _lineDefinition.strokeAlpha);
			_container.graphics.drawPath(_lineDefinition.commands, _lineDefinition.drawingData, GraphicsPathWinding.NON_ZERO);
		}
		// draw DASHED line
		else if (_lineDefinition.type == LineType.DASHED)
		{
			_container.graphics.lineStyle(_lineDefinition.strokeSize, _lineDefinition.strokeColor, _lineDefinition.strokeAlpha, false, LineScaleMode.NORMAL, CapsStyle.SQUARE, JointStyle.MITER); _container.graphics.drawPath(_lineDefinition.commands, _lineDefinition.drawingData, GraphicsPathWinding.NON_ZERO);
		}
		// draw DOTTED line
		else if (_lineDefinition.type == LineType.DOTTED)
		{
			// draw dots
			_container.graphics.lineStyle(0, 0xFF0000, 0);
			_container.graphics.beginFill(_lineDefinition.strokeColor, _lineDefinition.strokeAlpha);
			_container.graphics.drawPath(_lineDefinition.commands, _lineDefinition.drawingData, GraphicsPathWinding.NON_ZERO);
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