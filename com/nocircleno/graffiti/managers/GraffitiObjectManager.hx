/*

import openfl.display.Sprite;import openfl.events.Event;import openfl.events.EventDispatcher;import openfl.geom.Point;import openfl.geom.Rectangle;import openfl.text.Font;import com.nocircleno.graffiti.display.BrushObject;import com.nocircleno.graffiti.display.GraffitiObject;import com.nocircleno.graffiti.display.ShapeObject;import com.nocircleno.graffiti.display.TextObject;import com.nocircleno.graffiti.display.LineObject;import com.nocircleno.graffiti.tools.BrushDefinition;import com.nocircleno.graffiti.tools.ShapeDefinition;import com.nocircleno.graffiti.tools.LineDefinition;import com.nocircleno.graffiti.tools.TextSettings;import com.nocircleno.graffiti.events.GraffitiObjectEvent;import com.nocircleno.graffiti.tools.EditableParams;  /**
{
    public var showSelectionRectangle(get, set) : Bool;
    public var objectList(get, never) : Array<GraffitiObject>;
    public var numberSelectedObjects(get, never) : Int;
private static var _instance : GraffitiObjectManager;private var _objects : Array<GraffitiObject>;private var _selectedObjects : Array<GraffitiObject>;private var _pendingSettings : Dynamic;private var _objectContainer : Sprite;private var _showSelectionRectangle : Bool = true;  /**
    {
        super();init();
    }  /**
    }private function set_showSelectionRectangle(showRect : Bool) : Bool{  // set flag  _showSelectionRectangle = showRect;  // update all registered objects  var numSelectedObjects : Int = _objects.length;for (i in 0...numSelectedObjects){_objects[i].showSelectionRectangle = _showSelectionRectangle;
        }
        return showRect;
    }  /**
        }return isSelected;
    }  /**
        }return isSelected;
    }  /**
            }
            else {if (lastClassType != Type.getClassName(_selectedObjects[i])) {multipleObjectTypesSelected = true;break;
                }
            }
        }return multipleObjectTypesSelected;
    }  /**
                }
                else if (Std.is(_selectedObjects[i], BrushObject)) {color = cast((_selectedObjects[i]), BrushObject).brushDefinition.color;
                }
                else if (Std.is(_selectedObjects[i], ShapeObject)) {color = cast((_selectedObjects[i]), ShapeObject).shapeDefinition.fillColor;
                }if (lastColor > -2 && color != lastColor) {multipleValuesInSelection = true;break;
                }
                else {lastColor = color;
                }
            }
            else if (param == EditableParams.FONT) {if (Std.is(_selectedObjects[i], TextObject)) {font = cast((_selectedObjects[i]), TextObject).textSetting.font;if (lastFont != null) {if (lastFont != font) {multipleValuesInSelection = true;break;
                        }
                        else {lastFont = font;
                        }
                    }
                    else {lastFont = font;
                    }
                }
            }
            else if (param == EditableParams.TEXT_SIZE) {if (Std.is(_selectedObjects[i], TextObject)) {size = as3hx.Compat.parseInt(cast((_selectedObjects[i]), TextObject).textSetting.textFormat.size);if (lastSize > -1 && size != lastSize) {multipleValuesInSelection = true;break;
                    }
                    else {lastSize = size;
                    }
                }
            }
            else if (param == EditableParams.STROKE_COLOR) {if (Std.is(_selectedObjects[i], ShapeObject)) {color = cast((_selectedObjects[i]), ShapeObject).shapeDefinition.strokeColor;
                }
                else if (Std.is(_selectedObjects[i], LineObject)) {color = cast((_selectedObjects[i]), LineObject).lineDefinition.strokeColor;
                }if (lastColor > -2 && color != lastColor) {multipleValuesInSelection = true;break;
                }
                else {lastColor = color;
                }
            }
            else if (param == EditableParams.FILL_ALPHA) {if (Std.is(_selectedObjects[i], BrushObject)) {alpha = cast((_selectedObjects[i]), BrushObject).brushDefinition.alpha;
                }
                else if (Std.is(_selectedObjects[i], ShapeObject)) {alpha = cast((_selectedObjects[i]), ShapeObject).shapeDefinition.fillAlpha;
                }if (lastAlpha > -1 && alpha != lastAlpha) {multipleValuesInSelection = true;break;
                }
                else {lastAlpha = alpha;
                }
            }
            else if (param == EditableParams.STROKE_ALPHA) {if (Std.is(_selectedObjects[i], LineObject)) {alpha = cast((_selectedObjects[i]), LineObject).lineDefinition.strokeAlpha;
                }
                else if (Std.is(_selectedObjects[i], ShapeObject)) {alpha = cast((_selectedObjects[i]), ShapeObject).shapeDefinition.strokeAlpha;
                }if (lastAlpha > -1 && alpha != lastAlpha) {multipleValuesInSelection = true;break;
                }
                else {lastAlpha = alpha;
                }
            }
            else if (param == EditableParams.STROKE_SIZE) {if (Std.is(_selectedObjects[i], LineObject)) {size = cast((_selectedObjects[i]), LineObject).lineDefinition.strokeSize;
                }
                else if (Std.is(_selectedObjects[i], ShapeObject)) {size = cast((_selectedObjects[i]), ShapeObject).shapeDefinition.strokeSize;
                }if (lastSize > -1 && size != lastSize) {multipleValuesInSelection = true;break;
                }
                else {lastSize = size;
                }
            }
        }return multipleValuesInSelection;
    }  /**
            }
        }return isEdit;
    }  /**
        }return sortedList;
    }  /**
        }return so;
    }  /**
                        }
                        else if (setting == EditableParams.TEXT_SIZE) {ts = cast((_selectedObjects[i]), TextObject).textSetting;ts.textFormat.size = as3hx.Compat.parseInt(Reflect.field(settings, setting));cast((_selectedObjects[i]), TextObject).textSetting = ts;
                        }
                    }
                }
                else if (setting == EditableParams.FILL_TEXT_COLOR) {if (Std.is(_selectedObjects[i], BrushObject)) {bd = cast((_selectedObjects[i]), BrushObject).brushDefinition;bd.color = as3hx.Compat.parseInt(Reflect.field(settings, setting));cast((_selectedObjects[i]), BrushObject).brushDefinition = bd;
                    }
                    else if (Std.is(_selectedObjects[i], ShapeObject)) {sd = cast((_selectedObjects[i]), ShapeObject).shapeDefinition;sd.fillColor = as3hx.Compat.parseInt(Reflect.field(settings, setting));cast((_selectedObjects[i]), ShapeObject).shapeDefinition = sd;
                    }
                    else if (Std.is(_selectedObjects[i], TextObject)) {ts = cast((_selectedObjects[i]), TextObject).textSetting;ts.textFormat.color = as3hx.Compat.parseInt(Reflect.field(settings, setting));cast((_selectedObjects[i]), TextObject).textSetting = ts;
                    }
                }
                else if (setting == EditableParams.FILL_ALPHA) {if (Std.is(_selectedObjects[i], BrushObject)) {bd = cast((_selectedObjects[i]), BrushObject).brushDefinition;bd.alpha = as3hx.Compat.parseInt(Reflect.field(settings, setting));cast((_selectedObjects[i]), BrushObject).brushDefinition = bd;
                    }
                    else if (Std.is(_selectedObjects[i], ShapeObject)) {sd = cast((_selectedObjects[i]), ShapeObject).shapeDefinition;sd.fillAlpha = as3hx.Compat.parseInt(Reflect.field(settings, setting));cast((_selectedObjects[i]), ShapeObject).shapeDefinition = sd;
                    }
                }
                else if (setting == EditableParams.STROKE_COLOR) {if (Std.is(_selectedObjects[i], ShapeObject)) {sd = cast((_selectedObjects[i]), ShapeObject).shapeDefinition;sd.strokeColor = as3hx.Compat.parseInt(Reflect.field(settings, setting));cast((_selectedObjects[i]), ShapeObject).shapeDefinition = sd;
                    }
                    else if (Std.is(_selectedObjects[i], LineObject)) {ld = cast((_selectedObjects[i]), LineObject).lineDefinition;ld.strokeColor = as3hx.Compat.parseInt(Reflect.field(settings, setting));cast((_selectedObjects[i]), LineObject).lineDefinition = ld;
                    }
                }
                else if (setting == EditableParams.STROKE_ALPHA) {if (Std.is(_selectedObjects[i], ShapeObject)) {sd = cast((_selectedObjects[i]), ShapeObject).shapeDefinition;sd.strokeAlpha = as3hx.Compat.parseInt(Reflect.field(settings, setting));cast((_selectedObjects[i]), ShapeObject).shapeDefinition = sd;
                    }
                    else if (Std.is(_selectedObjects[i], LineObject)) {ld = cast((_selectedObjects[i]), LineObject).lineDefinition;ld.strokeAlpha = as3hx.Compat.parseInt(Reflect.field(settings, setting));cast((_selectedObjects[i]), LineObject).lineDefinition = ld;
                    }
                }
                else if (setting == EditableParams.STROKE_SIZE) {if (Std.is(_selectedObjects[i], ShapeObject)) {sd = cast((_selectedObjects[i]), ShapeObject).shapeDefinition;sd.strokeSize = as3hx.Compat.parseInt(Reflect.field(settings, setting));cast((_selectedObjects[i]), ShapeObject).shapeDefinition = sd;
                    }
                    else if (Std.is(_selectedObjects[i], LineObject)) {ld = cast((_selectedObjects[i]), LineObject).lineDefinition;ld.strokeSize = as3hx.Compat.parseInt(Reflect.field(settings, setting));cast((_selectedObjects[i]), LineObject).lineDefinition = ld;
                    }
                }
            }
        }
    }  /**
        }  // add listener so we know it it is removed from the stage  object.addEventListener(Event.REMOVED_FROM_STAGE, cleanUp);  // set show selection rectangle  object.showSelectionRectangle = _showSelectionRectangle;  // add to object list  _objects.push(object);
    }  /**
    }  /**
        }  // dispatch move event if there are selected objects  if (num > 0) {dispatchEvent(new GraffitiObjectEvent(_selectedObjects, GraffitiObjectEvent.MOVE));
        }
    }  /**
        }  // sync selection list with the main list  if (_objects.length > 0) {_objects.forEach(syncListWithSelection, null);
        }if (_selectedObjects.length > 0) {dispatchEvent(new GraffitiObjectEvent(_selectedObjects, GraffitiObjectEvent.SELECT));
        }
    }  /**
        while (i >= 0){objectBounds = _objects[i].getBounds(_objectContainer);insideRect = (includePartiallySelected) ? rect.intersects(objectBounds) : rect.containsRect(objectBounds);if (!insideRect && _objects[i].selected) {removeItemFromList(_objects[i], _selectedObjects);_objects[i].selected = false;deselectedObjects.push(_objects[i]);
            }
            else if (!_objects[i].selected && insideRect) {newObjectsSelected = true;_objects[i].selected = true;_selectedObjects.push(_objects[i]);
            }
            i--;
        }  // dispatch deselect events if objects where deselected  if (deselectedObjects.length > 0) {dispatchEvent(new GraffitiObjectEvent(deselectedObjects, GraffitiObjectEvent.DESELECT));
        }  // dispatch select events if objects where deselected  if (_selectedObjects.length > 0 && newObjectsSelected) {dispatchEvent(new GraffitiObjectEvent(_selectedObjects, GraffitiObjectEvent.SELECT));
        }
    }  /**
        }if (!go.selected) {go.selected = true;_selectedObjects.push(go);dispatchEvent(new GraffitiObjectEvent(_selectedObjects, GraffitiObjectEvent.SELECT));
        }
    }  /**
                    }
                }go.selected = false;var deselect : Array<GraffitiObject> = new Array<GraffitiObject>();deselect.push(go);dispatchEvent(new GraffitiObjectEvent(deselect, GraffitiObjectEvent.DESELECT));
            }
        }
    }  /**
        }  // clear selected object vector  _selectedObjects = new Array<GraffitiObject>();
    }  /**
        }
    }  /**
        while (i >= 0){if (_objects[i].editing) {_objects[i].editing = false;
            }
            i--;
        }
    }  /**
        while (i >= 0){if (!_selectedObjects[i].editing) {gol.push(_selectedObjects[i]);
            }
            --i;
        }if (gol.length > 0) {dispatchEvent(new GraffitiObjectEvent(gol, GraffitiObjectEvent.DELETE));
        }
    }  /**************************************************************************
        }_objects = new Array<GraffitiObject>();_selectedObjects = new Array<GraffitiObject>();
    }  /**************************************************************************
        }
    }  /**************************************************************************
            }
        }
    }  /**************************************************************************
    }  /**************************************************************************
        }
    }  /**************************************************************************
            }
        }
    }
}