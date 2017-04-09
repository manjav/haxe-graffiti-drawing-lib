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

package com.nocircleno.graffiti.display;

import openfl.display.Sprite;
import openfl.events.EventDispatcher;
import com.nocircleno.graffiti.events.GraffitiObjectEvent;

/**
* GraffitiObject Class is the base class for all object used in the Graffiti Library.
*
*/
class GraffitiObject extends Sprite
{
	public var selected(get, set) : Bool;
	public var showSelectionRectangle(get, set) : Bool;
	public var editing(get, set) : Bool;

	/**
	* Selected Color
	*/
	public static inline var SELECTED_COLOR : Int = 0xFF0000;

	/**
	* Edit Color
	*/
	public static inline var EDIT_COLOR : Int = 0xFFCC00;

	private var _selected : Bool = false;
	private var _editing : Bool = false;
	private var _showSelectionRectangle : Bool = true;

	public function new()
	{
		super();
	}

	/**
	* Selected state.
	*/
	private function set_selected(select : Bool) : Bool
	{
		_selected = select;
		return select;
	}
	private function get_selected() : Bool
	{
		return _selected;
	}

	/**
	* Show selection rectangle when selected
	*/
	private function set_showSelectionRectangle(showRect : Bool) : Bool
	{
		_showSelectionRectangle = showRect;
		updateSelectionRectangle();
		return showRect;
	}
	private function get_showSelectionRectangle() : Bool
	{
		return _showSelectionRectangle;
	}
	private function updateSelectionRectangle() : Void
	{
	}

	/**
	* Edited state.
	*/
	private function set_editing(edit : Bool) : Bool
	{
		// only dispatch event if it is different than the current setting
		if (edit != _editing)
		{
			var gol : Array<GraffitiObject> = new Array<GraffitiObject>();
			gol.push(this);
			if (edit)
				dispatchEvent(new GraffitiObjectEvent(gol, GraffitiObjectEvent.ENTER_EDIT));
			else dispatchEvent(new GraffitiObjectEvent(gol, GraffitiObjectEvent.EXIT_EDIT));
		}
		_editing = edit;
		return edit;
	}

	private function get_editing() : Bool
	{
		return _editing;
	}
}