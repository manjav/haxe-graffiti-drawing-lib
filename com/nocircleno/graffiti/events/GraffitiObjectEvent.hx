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

package com.nocircleno.graffiti.events;

import openfl.events.Event;
import com.nocircleno.graffiti.display.GraffitiObject;

/**
* GraffitiObjectEvent Class is used to notify of object changes.
*/
class GraffitiObjectEvent extends Event
{
	public var graffitiObjects(get, never) : Array<GraffitiObject>;
	/**
	* Dispatched when an object is selected.
	*
	* @eventType com.nocircleno.graffiti.events.GraffitiObjectEvent.SELECT
	*/

	public static inline var SELECT : String = "select";

	/**
	* Dispatched when an object is deselected.
	*
	* @eventType com.nocircleno.graffiti.events.GraffitiObjectEvent.DESELECT
	*/
	public static inline var DESELECT : String = "deselect";

	/**
	* Dispatched when an object enters edit mode.
	*
	* @eventType com.nocircleno.graffiti.events.GraffitiObjectEvent.ENTER_EDIT
	*/
	public static inline var ENTER_EDIT : String = "enterEdit";

	/**
	* Dispatched when an object exits edit mode.
	*
	* @eventType com.nocircleno.graffiti.events.GraffitiObjectEvent.EXIT_EDIT
	*/
	public static inline var EXIT_EDIT : String = "exitEdit";

	/**
	* Dispatched when an object is deleted from the stage.
	*
	* @eventType com.nocircleno.graffiti.events.GraffitiObjectEvent.DELETE
	*/
	public static inline var DELETE : String = "delete";

	/**
	* Dispatched when an object is moved on the stage.
	*
	* @eventType com.nocircleno.graffiti.events.GraffitiObjectEvent.MOVE
	*/
	public static inline var MOVE : String = "move";
	private var _graffitiObjects : Array<GraffitiObject>;

	/**
	* The <code>GraffitiObjectEvent</code> constructor.
	*
	* @param gObjects List of Graffiti Object affected by event.
	* @param type Event type.
	* @param bubbles Does the event bubble.
	* @param cancelable Is the Event cancelable.
	*/
	public function new(gObjects : Array<GraffitiObject>, type : String, bubbles : Bool = false, cancelable : Bool = false)
	{
		super(type, bubbles, cancelable);
		_graffitiObjects = gObjects;
	}

	/**
	 * Graffiti Object affected by event.
	 */
	private function get_graffitiObjects() : Array<GraffitiObject>
	{
		return _graffitiObjects;
	}

	/**
	* The <code>clone</code> method will return a new instance of the ObjectEvent.
	*
	* @return Returns new ObjectEvent with all the same settings.
	*/
	override public function clone() : Event
	{
		return new GraffitiObjectEvent(_graffitiObjects, type, bubbles, cancelable);
	}

	/**
	* The <code>toString</code> method will output the event details.
	*
	* @return Returns the event information.
	*/
	override public function toString() : String
	{
		return formatToString("GraffitiObjectEvent", "type", "bubbles", "cancelable", "eventPhase");
	}
}