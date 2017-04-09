/*
*  	Graffiti 3.0
*  	______________________________________________________________________
*  	www.nocircleno.com/graffiti/
*/  /*
* 	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* 	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* 	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* 	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* 	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* 	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* 	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* 	OTHER DEALINGS IN THE SOFTWARE.
*/

package com.nocircleno.graffiti.events;

import openfl.events.Event; 
import openfl.geom.Rectangle;

/**
* The Canvas Event provides a custom Event for Canvas events.
*/

class CanvasEvent extends Event
{
	public var zoom(get, never) : Float;
	public var canvasWidth(get, never) : Int;
	public var canvasHeight(get, never) : Int;
	public var viewableRect(get, never) : Rectangle;


	/**
	* Dispatched when the canvas zoom value changes.
	*
	* @eventType com.nocircleno.graffiti.events.CanvasEvent.ZOOM
	*/
	public static inline var ZOOM : String = "zoom";


	/**
	* Dispatched when the canvas position is changed.
	*
	* @eventType com.nocircleno.graffiti.events.CanvasEvent.DRAG
	*/
	public static inline var DRAG : String = "drag";
	private var _canvasZoom : Float;
	private var _canvasWidth : Int;
	private var _canvasHeight : Int;
	private var _viewableRect : Rectangle;


	/**
	* The <code>CanvasEvent</code> constructor.
	*
	* @param type Type of Canvas Event.
	* @param zoom Zoom of the Canvas instance that dispatched the event.
	* @param canvasWidth Width of the Canvas instance that dispatched the event.
	* @param canvasHeight Height of the Canvas instance that dispatched the event.
	* @param viewableRect Viewable Rectangle of the Canvas instance that dispatched the event.
	* @param bubbles Does the event bubble.
	* @param cancelable Is the Event cancelable.
	*/
	public function new(type : String, zoom : Float, canvasWidth : Int, canvasHeight : Int, viewableRect : Rectangle, bubbles : Bool = false, cancelable : Bool = false)
	{
		super(type, bubbles, cancelable);
		// store canvas properties
		_canvasZoom = zoom;
		_canvasWidth = canvasWidth;
		_canvasHeight = canvasHeight;
		_viewableRect = viewableRect;
	}

	/**
	* Canvas Zoom value.
	*/
	private function get_zoom() : Float
	{
		return _canvasZoom;
	}

	/**
	* Canvas Width.
	*/
	private function get_canvasWidth() : Int
	{
		return _canvasWidth;
	}

	/**
	* Canvas Height
	*/
	private function get_canvasHeight() : Int
	{
		return _canvasHeight;
	}	
	/**
	* Viewable Rectangle of the Canvas.
	*/
	private function get_viewableRect() : Rectangle
	{
		return _viewableRect;
	}
}