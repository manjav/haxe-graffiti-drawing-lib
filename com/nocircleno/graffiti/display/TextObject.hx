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

import com.nocircleno.graffiti.events.GraffitiObjectEvent;
import com.nocircleno.graffiti.tools.TextSettings;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.FocusEvent;
import openfl.events.MouseEvent;
import openfl.events.TextEvent;
import openfl.geom.Point;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.text.AntiAliasType;
import openfl.text.GridFitType;
import openfl.filters.GlowFilter;
import openfl.filters.BitmapFilterQuality;

/**
* TextObject Class displays text as a GraffitiObject on the GraffitiCanvas.
*/
class TextObject extends GraffitiObject
{
	public var textSetting(get, set) : TextSettings;
	public var text(get, set) : String;
	private var _textfield : TextField;
	private var _textSettings : TextSettings;
	private var _bg : Sprite;

	/**
	* The <code>TextObject</code> constructor.
	*
	* @param textSettings TextSettings instance.
	*/
	public function new(textSettings : TextSettings)
	{
		super();

		// store settings
		_textSettings = textSettings.clone();

		// create background
		_bg = new Sprite(); _bg.alpha = 0; addChild(_bg);

		// create textfield
		_textfield = new TextField(); _textfield.name = "text_label";
		_textfield.embedFonts = _textSettings.embeddedFont;
		_textfield.antiAliasType = AntiAliasType.ADVANCED;
		_textfield.gridFitType = GridFitType.PIXEL;
		_textfield.autoSize = TextFieldAutoSize.LEFT;
		_textfield.multiline = true; _textfield.wordWrap = false;
		_textfield.defaultTextFormat = _textSettings.textFormat;
		_textfield.type = TextFieldType.INPUT;
		_textfield.selectable = false;
		_textfield.background = _textSettings.backgroundColor != -(1) ? true : false;
		_textfield.backgroundColor = _textSettings.backgroundColor != -(1) ? _textSettings.backgroundColor : 0xFFFFFF;
		_textfield.border = _textSettings.borderColor != -(1) ? true : false;
		_textfield.borderColor = _textSettings.borderColor != -(1) ? _textSettings.borderColor : 0xFFFFFF;
		addChild(_textfield);

		_textfield.addEventListener(Event.CHANGE, updateBackground, false, 0, true);
		_textfield.addEventListener(FocusEvent.FOCUS_OUT, focusHandler, false, 0, true);
		this.addEventListener(Event.ADDED_TO_STAGE, init);

		// enable double click to edit
		this.doubleClickEnabled = true;
		this.addEventListener(MouseEvent.DOUBLE_CLICK, mouseHandler, false, 0, true);
		this.addEventListener(Event.REMOVED_FROM_STAGE, removeEventHandler);

		updateBackground(null);
	}


	/**
	* Set the text settings for the Text object.
	*/
	private function set_textSetting(setting : TextSettings) : TextSettings
	{
		_textSettings = setting;
		_textfield.embedFonts = _textSettings.embeddedFont;
		_textfield.background = _textSettings.backgroundColor != -(1) ? true : false;
		_textfield.backgroundColor = _textSettings.backgroundColor != -(1) ? _textSettings.backgroundColor : 0xFFFFFF;
		_textfield.border = _textSettings.borderColor != -(1) ? true : false;
		_textfield.borderColor = _textSettings.borderColor != -(1) ? _textSettings.borderColor : 0xFFFFFF;
		_textfield.setTextFormat(_textSettings.textFormat);
		_textfield.defaultTextFormat = _textSettings.textFormat;

		updateBackground(null);

		return setting;
	}

	private function get_textSetting() : TextSettings
	{
		return _textSettings;
	}


	/**
	* Set the text displayed by the Text Object.
	*/
	private function set_text(t : String) : String
	{
		_textfield.text = t; updateBackground(null);
		return t;
	}

	private function get_text() : String
	{
		return _textfield.text;
	}


	/**
	* Set Text selected state.
	*/
	override private function set_selected(select : Bool) : Bool
	{
		_selected = select;

		if (_selected)
		{
			if (!_textfield.selectable)
			{
				_bg.alpha = 1;

				if (_showSelectionRectangle)
				{
					_bg.filters = [new GlowFilter(GraffitiObject.SELECTED_COLOR, 1, 4, 4, 2, BitmapFilterQuality.HIGH, false, true)];
				}
			}
		}
		else
		{
			_bg.alpha = 0;
			_bg.filters = [];
		}

		return select;
	}

	/**************************************************************************
		Method	: updateSelectionRectangle()

		Purpose	: This method will update the display of the selection rect.
	***************************************************************************/
	override private function updateSelectionRectangle() : Void
	{
		if (_showSelectionRectangle && _selected)
		{
			_bg.filters = [new GlowFilter(GraffitiObject.SELECTED_COLOR, 1, 4, 4, 2, BitmapFilterQuality.HIGH, false, true)];
		}
		else if (!_showSelectionRectangle && _selected)
		{
			_bg.filters = [];
		}
	}

	/**
	* Set Text edit state.
	*/
	override private function set_editing(edit : Bool) : Bool
	{
		super.editing = edit; _bg.mouseEnabled = edit;
		_textfield.mouseEnabled = edit;
		_textfield.selectable = edit;
		if (!_editing)
		{
			if (_selected)
			{
				_bg.alpha = 1;
				_bg.filters = [new GlowFilter(GraffitiObject.SELECTED_COLOR, 1, 4, 4, 2, BitmapFilterQuality.HIGH, false, true)];
			}
			else
			{
				_bg.alpha = 0;
				_bg.filters = [];
			}

			stage.focus = null;
			_textfield.setSelection(0, 0);
		}
		else
		{
			_bg.alpha = 1;
			_bg.filters = [new GlowFilter(GraffitiObject.EDIT_COLOR, 1, 4, 4, 2, BitmapFilterQuality.HIGH, false, true)];

			// calculate starting cursor position
			var selectedIndex : Int = _textfield.getCharIndexAtPoint(this.mouseX, this.mouseY);

			stage.focus = _textfield;
			_textfield.setSelection(selectedIndex, selectedIndex);

		}
		return edit;
	}


	/**************************************************************************
		Method	: init()

		Purpose	: This method will initialize the Text object.

		Params	: e - Event Object
	***************************************************************************/
	private function init(e : Event) : Void
	{
		this.removeEventListener(Event.ADDED_TO_STAGE, init);
		//selected = true;
		//editing = true;
	}

	/**************************************************************************
		Method	: removeEventHandler()

		Purpose	: This method will remove the event listeners for this object.

		Params	: e - Event Object
	***************************************************************************/
	private function removeEventHandler(e : Event) : Void
	{
		_textfield.removeEventListener(Event.CHANGE, updateBackground, false);
		_textfield.removeEventListener(FocusEvent.FOCUS_OUT, focusHandler, false);
		this.removeEventListener(Event.REMOVED_FROM_STAGE, removeEventHandler);
		this.removeEventListener(MouseEvent.DOUBLE_CLICK, mouseHandler, false);
	}

	/**************************************************************************
		Method	: updateBackground()

		Purpose	: This method will redraw the background.

		Params	: e - Event Object
	***************************************************************************/
	private function updateBackground(e : Event) : Void
	{
		_bg.graphics.clear();
		_bg.graphics.beginFill(0xFFFFFF, 1);
		_bg.graphics.drawRect(0, 0, _textfield.width, _textfield.height);
	}

	/**************************************************************************
		Method	: updateBackground()

		Purpose	: This method will handle the double click event to enable
				  editing.

		Params	: e - Event Object
	***************************************************************************/
	private function mouseHandler(e : MouseEvent) : Void
	{
		if (e.type == MouseEvent.DOUBLE_CLICK && !_editing)
		{
			this.editing = true;
		}
	}

	/**************************************************************************
		Method	: focusHandler()

		Purpose	: This method will handle when the textfield loses stage
				  focus.

		Params	: e - FocusEvent Object
	***************************************************************************/
	private function focusHandler(e : FocusEvent) : Void
	{
		if (e.type == FocusEvent.FOCUS_OUT)
		{
			editing = false;
		}
	}
}