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

package com.nocircleno.graffiti.managers;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.text.Font;
import com.nocircleno.graffiti.display.BrushObject;
import com.nocircleno.graffiti.display.GraffitiObject;
import com.nocircleno.graffiti.display.ShapeObject;
import com.nocircleno.graffiti.display.TextObject;
import com.nocircleno.graffiti.display.LineObject;
import com.nocircleno.graffiti.tools.BrushDefinition;
import com.nocircleno.graffiti.tools.ShapeDefinition;
import com.nocircleno.graffiti.tools.LineDefinition;
import com.nocircleno.graffiti.tools.TextSettings;
import com.nocircleno.graffiti.events.GraffitiObjectEvent;
import com.nocircleno.graffiti.tools.EditableParams;

/**
* GraffitiObjectManager Class manages graffiti objects on the GraffitiCanvas.  This is a singleton class, use the GraffitiObjectManager.getInstance() method to get an instance of this class.
*/
class GraffitiObjectManager extends EventDispatcher
{

	public var showSelectionRectangle(get, set) : Bool;
	public var objectList(get, never) : Array<GraffitiObject>;
	public var numberSelectedObjects(get, never) : Int;

	private static var _instance : GraffitiObjectManager;
	private var _objects : Array<GraffitiObject>;
	private var _selectedObjects : Array<GraffitiObject>;
	private var _pendingSettings : Dynamic;
	private var _objectContainer : Sprite;
	private var _showSelectionRectangle : Bool = true;

	/**
	* The <code>GraffitiObjectManager</code> constructor.
	*/
	public function new()
	{
		super(); init();
	}

	/**
	* Show selection rectangle when selected
	*/
	private function get_showSelectionRectangle() : Bool
	{
		return _showSelectionRectangle;
	}

	private function set_showSelectionRectangle(showRect : Bool) : Bool
	{
		// set flag
		_showSelectionRectangle = showRect;

		// update all registered objects
		var numSelectedObjects : Int = _objects.length;
		for (i in 0...numSelectedObjects)
			_objects[i].showSelectionRectangle = _showSelectionRectangle;

		return showRect;
	}

	/**
	* The <code>areObjectsSelected</code> method checks to see if any object is currently selected.
	*
	* @return true if one or more objects are selected, false if not.
	*/
	public function areObjectsSelected() : Bool
	{
		var isSelected : Bool = false;
		if (_selectedObjects != null)
			isSelected = _selectedObjects.length > 0;

		return isSelected;
	}

	/**
	* The <code>areMultipleObjectsSelected</code> method checks to see if more than one object is currently selected.
	*
	* @return true if more than one objects are selected, false if not.
	*/
	public function areMultipleObjectsSelected() : Bool
	{
		var isSelected : Bool = false;
		if (_selectedObjects != null)
			isSelected = _selectedObjects.length > 1;

		return isSelected;
	}

	/**
	* The <code>areMultipleObjectTypesSelected</code> method checks to see if mutliple object types are selected.
	*
	* @return true if more than one type of object is selected, false if not.
	*/
	public function areMultipleObjectTypesSelected() : Bool
	{
		var multipleObjectTypesSelected : Bool = false;
		var numSelectedObjects : Int = _selectedObjects.length;
		var lastClassType : String = null;

		for (i in 0 ... numSelectedObjects)
		{
			if (i == 0)
			{
				lastClassType = Type.getClassName(Type.getClass(_selectedObjects[i]));
			}
			else
			{
				if (lastClassType != Type.getClassName(Type.getClass(_selectedObjects[i])))
				{
					multipleObjectTypesSelected = true;
					break;
				}
			}
		}

		return multipleObjectTypesSelected;
	}

	/**
	* The <code>areMultipleValuesInSelection</code> method checks the passed param to see if there is more than one value within the selected objects.  This can be used to update UI with a mixed items display.  The EditableParam Class contains all the constants that can be passed to this method.
	*
	* @return true if more than one value is contained in selection for passed param.
	*/
	public function areMultipleValuesInSelection(param : String) : Bool
	{
		var multipleValuesInSelection : Bool = false;
		var numSelectedObjects : Int = _selectedObjects.length;
		var color : Int = -2;
		var lastColor : Int = -2;
		var alpha : Float = -1;
		var lastAlpha : Float = -1;
		var size : Float = -1;
		var lastSize : Float = -1;
		var font : Font = null;
		var lastFont : Font = null;
		for (i in 0...numSelectedObjects)
		{
			if (param == EditableParams.FILL_TEXT_COLOR)
			{
				if (Std.is(_selectedObjects[i], TextObject))
				{
					color = cast(_selectedObjects[i], TextObject).textSetting.textFormat.color;
				}
				else if (Std.is(_selectedObjects[i], BrushObject))
				{
					color = cast((_selectedObjects[i]), BrushObject).brushDefinition.color;
				}
				else if (Std.is(_selectedObjects[i], ShapeObject))
				{
					color = cast((_selectedObjects[i]), ShapeObject).shapeDefinition.fillColor;
				}
				if (lastColor > -2 && color != lastColor)
				{
					multipleValuesInSelection = true;
					break;
				}
				else
				{
					lastColor = color;
				}
			}
			else if (param == EditableParams.FONT)
			{
				if (Std.is(_selectedObjects[i], TextObject))
				{
					font = cast((_selectedObjects[i]), TextObject).textSetting.font;
					if (lastFont != null)
					{
						if (lastFont != font)
						{
							multipleValuesInSelection = true;
							break;
						}
						else
						{
							lastFont = font;
						}
					}
					else
					{
						lastFont = font;
					}
				}
			}
			else if (param == EditableParams.TEXT_SIZE)
			{
				if (Std.is(_selectedObjects[i], TextObject))
				{
					size = cast(_selectedObjects[i], TextObject).textSetting.textFormat.size;
					
					if (lastSize > -1 && size != lastSize)
					{
						multipleValuesInSelection = true;
						break;
					}
					else
					{
						lastSize = size;
					}
				}
			}
			else if (param == EditableParams.STROKE_COLOR)
			{
				if (Std.is(_selectedObjects[i], ShapeObject))
				{
					color = cast((_selectedObjects[i]), ShapeObject).shapeDefinition.strokeColor;
				}
				else if (Std.is(_selectedObjects[i], LineObject))
				{
					color = cast((_selectedObjects[i]), LineObject).lineDefinition.strokeColor;
				}
				if (lastColor > -2 && color != lastColor)
				{
					multipleValuesInSelection = true;
					break;
				}
				else
				{
					lastColor = color;
				}
			}
			else if (param == EditableParams.FILL_ALPHA)
			{
				if (Std.is(_selectedObjects[i], BrushObject))
				{
					alpha = cast((_selectedObjects[i]), BrushObject).brushDefinition.alpha;
				}
				else if (Std.is(_selectedObjects[i], ShapeObject))
				{
					alpha = cast((_selectedObjects[i]), ShapeObject).shapeDefinition.fillAlpha;
				}
				if (lastAlpha > -1 && alpha != lastAlpha)
				{
					multipleValuesInSelection = true; break;
				}
				else
				{
					lastAlpha = alpha;
				}
			}
			else if (param == EditableParams.STROKE_ALPHA)
			{
				if (Std.is(_selectedObjects[i], LineObject))
				{
					alpha = cast((_selectedObjects[i]), LineObject).lineDefinition.strokeAlpha;
				}
				else if (Std.is(_selectedObjects[i], ShapeObject))
				{
					alpha = cast((_selectedObjects[i]), ShapeObject).shapeDefinition.strokeAlpha;
				} if (lastAlpha > -1 && alpha != lastAlpha)
				{
					multipleValuesInSelection = true; break;
				}
				else
				{
					lastAlpha = alpha;
				}
			}
			else if (param == EditableParams.STROKE_SIZE)
			{
				if (Std.is(_selectedObjects[i], LineObject))
				{
					size = cast((_selectedObjects[i]), LineObject).lineDefinition.strokeSize;
				}
				else if (Std.is(_selectedObjects[i], ShapeObject))
				{
					size = cast((_selectedObjects[i]), ShapeObject).shapeDefinition.strokeSize;
				} if (lastSize > -1 && size != lastSize)
				{
					multipleValuesInSelection = true; break;
				}
				else
				{
					lastSize = size;
				}
			}
		} return multipleValuesInSelection;
	}

	/**
	* The <code>areObjectsBeingEdited</code> method checks to see if any object is being edited.
	*
	* @return true if one or more objects are edited, false if not.
	*/
	public function areObjectsBeingEdited() : Bool
	{
		var isEdit : Bool = false;
		var numObjects : Int = _objects.length;
		for (i in 0...numObjects)
		{
			if (_objects[i].editing)
			{
				isEdit = true;
				break;
			}
		}
		return isEdit;
	}

	/**
	* List of Graffiti Objects, they are sorted by depth
	*/
	private function get_objectList() : Array<GraffitiObject>
	{
		var sortedList : Array<GraffitiObject> = new Array<GraffitiObject>();
		for (i in 0..._objects.length)
		{
			sortedList[_objectContainer.getChildIndex(_objects[i])] = _objects[i];
		}
		return sortedList;
	}

	/**
		* Number of Selected Objects
		*/
	private function get_numberSelectedObjects() : Int
	{
		var so : Int = 0;
		if (_selectedObjects != null)
			so = _selectedObjects.length;

		return so;
	}

	/**
	* The <code>changeSettingsForSelectedObjects</code> method updates the settings for all selected objects.  You can
	*
	* @param settings Object that contains the settings for a GraffitObject.
	*
	* @example The following code creates a Graffiti Canvas instance.
	* <listing version="3.0" >
	*
	* 	// PARAMS
	* 	// --------------
	*   // Font
	*	// TextSize
	*	// FillTextColor
	*	// FillAlpha
	*	// StrokeColor
	*	// StrokeAlpha
	*	// StrokeSize
	*
	*	_objectManager.changeSettingsForSelectedObjects({FillTextColor:0xFF0000});
	*
	* </listing>
	*/
	public function changeSettingsForSelectedObjects(settings : Dynamic) : Void
	{
		var numberSelectedObjects : Int = _selectedObjects.length;
		var ts : TextSettings;
		var bd : BrushDefinition;
		var sd : ShapeDefinition;
		var ld : LineDefinition;

		for (setting in Reflect.fields(settings))
		{
			for (i in 0...numberSelectedObjects)
			{
				if (setting == EditableParams.FONT || setting == EditableParams.TEXT_SIZE)
				{
					if (Std.is(_selectedObjects[i], TextObject))
					{
						if (setting == EditableParams.FONT)
						{
							ts = cast((_selectedObjects[i]), TextObject).textSetting;
							ts.font = cast((Reflect.field(settings, setting)), Font);

							cast((_selectedObjects[i]), TextObject).textSetting = ts;
						}
						else if (setting == EditableParams.TEXT_SIZE)
						{
							ts = cast(_selectedObjects[i], TextObject).textSetting;
							ts.textFormat.size = cast(Reflect.field(settings, setting), Int);

							cast((_selectedObjects[i]), TextObject).textSetting = ts;
						}
					}
				}
				else if (setting == EditableParams.FILL_TEXT_COLOR)
				{
					if (Std.is(_selectedObjects[i], BrushObject))
					{
						bd = cast((_selectedObjects[i]), BrushObject).brushDefinition;
						bd.color = cast(Reflect.field(settings, setting), Int);

						cast((_selectedObjects[i]), BrushObject).brushDefinition = bd;
					}
					else if (Std.is(_selectedObjects[i], ShapeObject))
					{
						sd = cast((_selectedObjects[i]), ShapeObject).shapeDefinition;
						sd.fillColor = cast(Reflect.field(settings, setting), Int);

						cast((_selectedObjects[i]), ShapeObject).shapeDefinition = sd;
					}
					else if (Std.is(_selectedObjects[i], TextObject))
					{
						ts = cast((_selectedObjects[i]), TextObject).textSetting;
						ts.textFormat.color = cast(Reflect.field(settings, setting), Int);

						cast((_selectedObjects[i]), TextObject).textSetting = ts;
					}
				}
				else if (setting == EditableParams.FILL_ALPHA)
				{
					if (Std.is(_selectedObjects[i], BrushObject))
					{
						bd = cast((_selectedObjects[i]), BrushObject).brushDefinition;
						bd.alpha = cast(Reflect.field(settings, setting), Int);

						cast((_selectedObjects[i]), BrushObject).brushDefinition = bd;
					}
					else if (Std.is(_selectedObjects[i], ShapeObject))
					{
						sd = cast((_selectedObjects[i]), ShapeObject).shapeDefinition;
						sd.fillAlpha = cast(Reflect.field(settings, setting), Int);

						cast((_selectedObjects[i]), ShapeObject).shapeDefinition = sd;
					}
				}
				else if (setting == EditableParams.STROKE_COLOR)
				{
					if (Std.is(_selectedObjects[i], ShapeObject))
					{
						sd = cast((_selectedObjects[i]), ShapeObject).shapeDefinition;
						sd.strokeColor = cast(Reflect.field(settings, setting), Int);

						cast((_selectedObjects[i]), ShapeObject).shapeDefinition = sd;
					}
					else if (Std.is(_selectedObjects[i], LineObject))
					{
						ld = cast((_selectedObjects[i]), LineObject).lineDefinition;
						ld.strokeColor = cast(Reflect.field(settings, setting), Int);

						cast((_selectedObjects[i]), LineObject).lineDefinition = ld;
					}
				}
				else if (setting == EditableParams.STROKE_ALPHA)
				{
					if (Std.is(_selectedObjects[i], ShapeObject))
					{
						sd = cast((_selectedObjects[i]), ShapeObject).shapeDefinition;
						sd.strokeAlpha = cast(Reflect.field(settings, setting), Int);

						cast((_selectedObjects[i]), ShapeObject).shapeDefinition = sd;
					}
					else if (Std.is(_selectedObjects[i], LineObject))
					{
						ld = cast((_selectedObjects[i]), LineObject).lineDefinition;
						ld.strokeAlpha = cast(Reflect.field(settings, setting), Int);

						cast((_selectedObjects[i]), LineObject).lineDefinition = ld;
					}
				}
				else if (setting == EditableParams.STROKE_SIZE)
				{
					if (Std.is(_selectedObjects[i], ShapeObject))
					{
						sd = cast((_selectedObjects[i]), ShapeObject).shapeDefinition;
						sd.strokeSize = cast(Reflect.field(settings, setting), Int);

						cast((_selectedObjects[i]), ShapeObject).shapeDefinition = sd;
					}
					else if (Std.is(_selectedObjects[i], LineObject))
					{
						ld = cast((_selectedObjects[i]), LineObject).lineDefinition;
						ld.strokeSize = cast(Reflect.field(settings, setting), Int);

						cast((_selectedObjects[i]), LineObject).lineDefinition = ld;
					}
				}
			}
		}
	}

	/**
	* The <code>addObject</code> method adds a GraffitObject to the assets list held by this Class.
	*
	* @param object GraffitObject
	*/
	public function addObject(object : GraffitiObject) : Void
	{
		if (_objectContainer == null)
		{
			_objectContainer = cast((object.parent), Sprite);
		}
		// add listener so we know it it is removed from the stage
		object.addEventListener(Event.REMOVED_FROM_STAGE, cleanUp);

		// set show selection rectangle
		object.showSelectionRectangle = _showSelectionRectangle;

		// add to object list
		_objects.push(object);
	}

	/**
	* The <code>removeObject</code> method will remove a graffiti object from the object manager.
	*
	* @param object Graffiti Object to remove.
	*/
	public function removeObject(object : GraffitiObject) : Void
	{

		// remove item from entire list
		removeItemFromList(object, _objects);

		// remove item from selected list (if in it)
		removeItemFromList(object, _selectedObjects);
	}

	/**
	* The <code>moveSelectedObjects</code> method will move all selected objects by the x and y offset values passed.
	*
	* @param xOffset The amount to move each object on the x axis.
	* @param yOffset The amount to move each object on the y axis.
	*/
	public function moveSelectedObjects(xOffset : Float, yOffset : Float) : Void
	{
		var num : Int = _selectedObjects.length;
		for (i in 0...num)
		{
			_selectedObjects[i].x += xOffset;
			_selectedObjects[i].y += yOffset;
		}

		// dispatch move event if there are selected objects
		if (num > 0)
		{
			dispatchEvent(new GraffitiObjectEvent(_selectedObjects, GraffitiObjectEvent.MOVE));
		}
	}

	/**
	* The <code>setSelection</code> method selects one or more grafffiti objects.
	*
	* @param objectList Vector of GraffitObjects to select.
	*/
	public function setSelection(objectList : Array<GraffitiObject>) : Void
	{
		// make unique copy of the vector
		_selectedObjects = objectList.concat(new Array<GraffitiObject>());

		// select each object in the vector
		if (_selectedObjects.length > 0)
		{
			selectObjects();
			//\\_selectedObjects.forEach(selectObject, null);
		}

		// sync selection list with the main list
		if (_objects.length > 0)
		{
			syncListWithSelections();
			//\\_objects.forEach(syncListWithSelection, null);
		}

		if (_selectedObjects.length > 0)
		{
			dispatchEvent(new GraffitiObjectEvent(_selectedObjects, GraffitiObjectEvent.SELECT));
		}

	}

	/**
	* The <code>setSelectionByRectangle</code> method will select all objects that are within the passed rectangle.
	*
	* @param rect Rectangle used to make the selection.
	* @param includePartiallySelected Indicates if objects partly within the rectangle should be included in selection. Default is false.
	*/
	public function setSelectionByRectangle(rect : Rectangle, includePartiallySelected : Bool = false) : Void
	{
		var objectBounds : Rectangle;
		var insideRect : Bool;

		var numObjects : Int = _objects.length - 1;
		var newObjectsSelected : Bool = false;

		var deselectedObjects : Array<GraffitiObject> = new Array<GraffitiObject>();

		var i : Int = numObjects;
		while (i >= 0)
		{
			objectBounds = _objects[i].getBounds(_objectContainer);
			insideRect = (includePartiallySelected) ? rect.intersects(objectBounds) : rect.containsRect(objectBounds);

			if (!insideRect && _objects[i].selected)
			{
				removeItemFromList(_objects[i], _selectedObjects);
				_objects[i].selected = false;
				deselectedObjects.push(_objects[i]);
			}
			else if (!_objects[i].selected && insideRect)
			{
				newObjectsSelected = true;
				_objects[i].selected = true;
				_selectedObjects.push(_objects[i]);
			}
			i--;
		}

		// dispatch deselect events if objects where deselected
		if (deselectedObjects.length > 0)
		{
			dispatchEvent(new GraffitiObjectEvent(deselectedObjects, GraffitiObjectEvent.DESELECT));
		}

		// dispatch select events if objects where deselected
		if (_selectedObjects.length > 0 && newObjectsSelected)
		{
			dispatchEvent(new GraffitiObjectEvent(_selectedObjects, GraffitiObjectEvent.SELECT));
		}
	}

	/**
	* The <code>addToSelection</code> method will add a new graffiti object to selected objects.
	*
	* @param go Graffiti Object to select.
	*/
	public function addToSelection(go : GraffitiObject) : Void
	{
		if (_selectedObjects == null)
		{
			_selectedObjects = new Array<GraffitiObject>();
		}

		if (!go.selected)
		{
			go.selected = true;
			_selectedObjects.push(go);
			dispatchEvent(new GraffitiObjectEvent(_selectedObjects, GraffitiObjectEvent.SELECT));
		}
	}

	/**
	* The <code>removeFromSelection</code> method will remove a graffiti object from the selected objects.
	*
	* @param go Graffiti Object to remove from selection.
	*/
	public function removeFromSelection(go : GraffitiObject) : Void
	{
		if (_selectedObjects != null)
		{
			if (go.selected)
			{
				var numSelectedObjects : Int = _selectedObjects.length;
				for (i in 0...numSelectedObjects)
				{
					if (_selectedObjects[i] == go)
					{
						_selectedObjects.splice(i, 1);
						break;
					}
				}
				go.selected = false;

				var deselect : Array<GraffitiObject> = new Array<GraffitiObject>();
				deselect.push(go);
				dispatchEvent(new GraffitiObjectEvent(deselect, GraffitiObjectEvent.DESELECT));
			}
		}
	}

	/**
	* The <code>deselectAll</code> method deselects all selected objects.
	*/
	public function deselectAll() : Void
	{
		// deselect all object in vector
		if (_selectedObjects.length > 0)
		{
			deselectObjects();
			//\\_selectedObjects.forEach(deselectObject);
			dispatchEvent(new GraffitiObjectEvent(_selectedObjects.concat(new Array<GraffitiObject>()), GraffitiObjectEvent.DESELECT));
		}

		// clear selected object vector
		_selectedObjects = new Array<GraffitiObject>();
	}

	/**
	* The <code>selectAll</code> method selects all registered objects.
	*/
	public function selectAll() : Void
	{
		if (_objects.length > 0)
		{
			setSelection(_objects);
		}
	}

	/**
	* The <code>exitEditAll</code> method will turn off any object that is being edited.
	*/
	public function exitEditAll() : Void
	{
		var numObjects : Int = _objects.length - 1;

		var i : Int = numObjects;
		while (i >= 0)
		{
			if (_objects[i].editing)
			{
				_objects[i].editing = false;
			}
			i--;
		}
	}

	/**
	* The <code>deleteSelected</code> method deletes all selected objects.
	* This method removes the objects from the display list.
	*/
	public function deleteSelected() : Void
	{
		var numSelectedObjects : Int = _selectedObjects.length - 1;
		var gol : Array<GraffitiObject> = new Array<GraffitiObject>();

		// loop and delete all objects in the selected list
		var i : Int = numSelectedObjects;
		while (i >= 0)
		{
			if (!_selectedObjects[i].editing)
			{
				gol.push(_selectedObjects[i]);
			}
			--i;
		}
		if (gol.length > 0)
		{
			dispatchEvent(new GraffitiObjectEvent(gol, GraffitiObjectEvent.DELETE));
		}
	}

	/**************************************************************************
		Method	: init()

		Purpose	: This method will initalize the data to hold the objects.
	***************************************************************************/
	private function init() : Void
	{
		if (_objects != null)
		{
			return;
		}
		_objects = new Array<GraffitiObject>();
		_selectedObjects = new Array<GraffitiObject>();
	}

	/**************************************************************************
		Method	: removeItemFromList()

		Purpose	: This method will remove a graffiti object from the list
				  of registered objects.

		Params	: item - GraffitiObject
				  list - The list of graffiti objects.
	***************************************************************************/
	private function removeItemFromList(item : GraffitiObject, list : Array<GraffitiObject>) : Void
	{
		var itemIndex : Int = Lambda.indexOf(list, item);
		if (itemIndex != -1)
		{
			list.splice(itemIndex, 1);
		}
	}

	/**************************************************************************
		Method	: syncListWithSelection()

		Purpose	: This method will make sure if an item is in the main object
				  list and not in the selected list, it will deselect
				  that object.

		Params	: item - GraffitiObject
				  index - index of graffiti object in vector.
				  vector - The vector that stores the graffiti objects.
	***************************************************************************/
	private function syncListWithSelections() : Void
	{
		for (i in 0 ... _objects.length)
			syncListWithSelection(_objects[i], i, _objects);
	}
	private function syncListWithSelection(item : GraffitiObject, index : Int, vector : Array<GraffitiObject>) : Void
	{
		// if item is not in selected object list
		if (Lambda.indexOf(_selectedObjects, item) == -1)
		{
			// if object is selected, then deselect it
			if (item.selected)
			{
				item.selected = false;
				item.editing = false;
			}
		}
	}

	/**************************************************************************
		Method	: cleanUp()

		Purpose	: This method will handle the remove child from stage event
				  for a graffiti object.

		Params	: e - Event Object
	***************************************************************************/

	private function cleanUp(e : Event) : Void
	{
		e.currentTarget.removeEventListener(Event.REMOVED_FROM_STAGE, cleanUp);
		removeObject(cast((e.currentTarget), GraffitiObject));
	}
	
	
	
	/**************************************************************************
	Method	: selectObject()

	Purpose	: This method will select a graffiti object if not already
			  selected.

	Params	: item - GraffitiObject
			  index - index of graffiti object in vector.
			  vector - The vector that stores the graffiti objects.
	***************************************************************************/
	private function selectObjects() 
	{
		for (i in 0 ... _selectedObjects.length)
			selectObject(_selectedObjects[i], i, _selectedObjects);
	}
	private function selectObject(item : GraffitiObject, index : Int, vector : Array<GraffitiObject>) : Void
	{
		if (!item.selected)
		{
			item.selected = true;
		}
	}

	
		
	/**************************************************************************
		Method	: deselectObject()

		Purpose	: This method will deselect a graffiti object if already
				  selected.

		Params	: item - GraffitiObject
				  index - index of graffiti object in vector.
				  vector - The vector that stores the graffiti objects.
	***************************************************************************/
	private function deselectObjects() 
	{
		for (i in 0 ... _selectedObjects.length)
			deselectObject(_selectedObjects[i], i, _selectedObjects);
	}
	private function deselectObject(item : GraffitiObject, index : Int, vector : Array<GraffitiObject>) : Void
	{
		if (item.selected)
		{
			item.selected = false;

			// turn off editing
			if (item.editing)
			{
				item.editing = false;
			}
		}
	}
}