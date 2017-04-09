/*
*  	Graffiti 3.0
*  	______________________________________________________________________
*  	www.nocircleno.com/graffiti/
*/  /*
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

import com.nocircleno.graffiti.display.GraffitiObject;
import openfl.display.Sprite;
import openfl.display.GraphicsPathWinding;
import openfl.display.LineScaleMode;
import openfl.display.CapsStyle;
import openfl.display.JointStyle;
import openfl.events.Event;
import openfl.events.FocusEvent;
import openfl.events.MouseEvent;
import openfl.events.TextEvent;
import openfl.geom.Point;
import openfl.filters.GlowFilter;
import openfl.filters.BlurFilter;
import openfl.filters.BitmapFilterQuality;
import openfl.geom.Rectangle;
import com.nocircleno.graffiti.events.GraffitiObjectEvent;
import com.nocircleno.graffiti.tools.BrushDefinition;
import com.nocircleno.graffiti.tools.BrushType;

/**
	* BrushObject Class displays single brush mark as a GraffitiObject on the GraffitiCanvas.
	*
	*/
class BrushObject extends GraffitiObject
{
	public var brushDefinition(get, set) : BrushDefinition;
	private var _container : Sprite;
	private var _selectionRect : Sprite;
	private var _brushDefinition : BrushDefinition;
	
	/**
	* The <code>BrushObject</code> constructor.
	*
	* @param brushDefinition BrushDefinition instance.
	*/
	public function new(brushDefinition : BrushDefinition)
	{
		super();
		// store settings
			_brushDefinition = brushDefinition;
			
			// create background
			_container = new Sprite();
			_container.name = "brush_mark_container";
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
	* Set the Brush Definition for the Brush Object.
	*/
	private function set_brushDefinition(definition : BrushDefinition) : BrushDefinition
	{
		_brushDefinition = definition;
		render();
		return definition;
	}
	private function get_brushDefinition() : BrushDefinition
	{
		return _brushDefinition;
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
	* Set Brush Edit State. Can not edit brush shapes now.
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

	Purpose	: This method will render the brush mark.
	***************************************************************************/  
	
	private function render():Void
	{
		
		// draw brush mark
		_container.graphics.clear();
		
		if(_brushDefinition.type == BrushType.ROUND)
		{
			_container.graphics.lineStyle(_brushDefinition.size, _brushDefinition.color, _brushDefinition.alpha, false, LineScaleMode.NORMAL, CapsStyle.ROUND);
		} 
		else
		{
			_container.graphics.beginFill(_brushDefinition.color, _brushDefinition.alpha);
		}
		
		_container.graphics.drawPath(_brushDefinition.commands, _brushDefinition.drawingData, GraphicsPathWinding.NON_ZERO); 
		
		// set blur on item
		if (_brushDefinition.blur > 0)
		{
			_container.filters = [new BlurFilter(_brushDefinition.blur, _brushDefinition.blur, BitmapFilterQuality.MEDIUM)];
		} 
		else 
		{
			_container.filters = [];
		}
		
	}
	
	/**************************************************************************
		Method	: removeEventHandler()
		
		Purpose	: This method will remove the event listeners for this object.
				  
		Params	: e - Event Object
	***************************************************************************/
	private function removeEventHandler(e:Event):Void
	{
		this.removeEventListener(Event.REMOVED_FROM_STAGE, removeEventHandler);
	}
	
}