  /*

import com.nocircleno.graffiti.events.GraffitiObjectEvent;import com.nocircleno.graffiti.tools.TextSettings;import openfl.display.Sprite;import openfl.events.Event;import openfl.events.FocusEvent;import openfl.events.MouseEvent;import openfl.events.TextEvent;import openfl.geom.Point;import openfl.text.TextField;import openfl.text.TextFormat;import openfl.text.TextFieldAutoSize;import openfl.text.TextFieldType;import openfl.text.AntiAliasType;import openfl.text.GridFitType;import openfl.filters.GlowFilter;import openfl.filters.BitmapFilterQuality;  /**
{
    public var textSetting(get, set) : TextSettings;
    public var text(get, set) : String;
private var _textfield : TextField;private var _textSettings : TextSettings;private var _bg : Sprite;  /**
    {
        super();  // store settings  _textSettings = textSettings.clone();  // create background  _bg = new Sprite();_bg.alpha = 0;addChild(_bg);  // create textfield  _textfield = new TextField();_textfield.name = "text_label";_textfield.embedFonts = _textSettings.embeddedFont;_textfield.antiAliasType = AntiAliasType.ADVANCED;_textfield.gridFitType = GridFitType.PIXEL;_textfield.autoSize = TextFieldAutoSize.LEFT;_textfield.multiline = true;_textfield.wordWrap = false;_textfield.defaultTextFormat = _textSettings.textFormat;_textfield.type = TextFieldType.INPUT;_textfield.selectable = false;_textfield.background = _textSettings.backgroundColor != -(1) ? true : false;_textfield.backgroundColor = _textSettings.backgroundColor != -(1) ? _textSettings.backgroundColor : 0xFFFFFF;_textfield.border = _textSettings.borderColor != -(1) ? true : false;_textfield.borderColor = _textSettings.borderColor != -(1) ? _textSettings.borderColor : 0xFFFFFF;addChild(_textfield);_textfield.addEventListener(Event.CHANGE, updateBackground, false, 0, true);_textfield.addEventListener(FocusEvent.FOCUS_OUT, focusHandler, false, 0, true);this.addEventListener(Event.ADDED_TO_STAGE, init);  // enable double click to edit  this.doubleClickEnabled = true;this.addEventListener(MouseEvent.DOUBLE_CLICK, mouseHandler, false, 0, true);this.addEventListener(Event.REMOVED_FROM_STAGE, removeEventHandler);updateBackground(null);
    }  /**
        return setting;
    }private function get_textSetting() : TextSettings{return _textSettings;
    }  /**
        return t;
    }private function get_text() : String{return _textfield.text;
    }  /**
                }
            }
        }
        else {_bg.alpha = 0;_bg.filters = [];
        }
        return select;
    }  /**************************************************************************
        }
        else if (!_showSelectionRectangle && _selected) {_bg.filters = [];
        }
    }  /**
            }
            else {_bg.alpha = 0;_bg.filters = [];
            }stage.focus = null;_textfield.setSelection(0, 0);
        }
        else {_bg.alpha = 1;_bg.filters = [new GlowFilter(GraffitiObject.EDIT_COLOR, 1, 4, 4, 2, BitmapFilterQuality.HIGH, false, true)];  // calculate starting cursor position  var selectedIndex : Int = _textfield.getCharIndexAtPoint(this.mouseX, this.mouseY);stage.focus = _textfield;_textfield.setSelection(selectedIndex, selectedIndex);
        }
        return edit;
    }  /**************************************************************************
    }  /**************************************************************************
    }  /**************************************************************************
    }  /**************************************************************************
        }
    }  /**************************************************************************
        }
    }
}