  /*

import openfl.display.Sprite;import openfl.display.GraphicsPathWinding;import openfl.display.LineScaleMode;import openfl.display.CapsStyle;import openfl.display.JointStyle;import openfl.events.Event;import openfl.events.FocusEvent;import openfl.events.MouseEvent;import openfl.geom.Point;import openfl.filters.GlowFilter;import openfl.filters.BlurFilter;import openfl.filters.BitmapFilterQuality;import openfl.geom.Rectangle;import com.nocircleno.graffiti.events.GraffitiObjectEvent;import com.nocircleno.graffiti.tools.LineDefinition;import com.nocircleno.graffiti.tools.LineType;  /**
{
    public var lineDefinition(get, set) : LineDefinition;
private var _container : Sprite;private var _selectionRect : Sprite;private var _lineDefinition : LineDefinition;  /**
    {
        super();  // store settings  _lineDefinition = lineDefinition;  // create background  _container = new Sprite();_container.name = "line_container";addChild(_container);_selectionRect = new Sprite();_selectionRect.name = "selection_rectangle";_selectionRect.mouseChildren = false;_selectionRect.mouseEnabled = false;addChild(_selectionRect);  // enable double click to edit  this.addEventListener(Event.REMOVED_FROM_STAGE, removeEventHandler);  // draw it  render();
    }  /**
        return definition;
    }private function get_lineDefinition() : LineDefinition{return _lineDefinition;
    }  /**
        }
        else {_selectionRect.graphics.clear();_selectionRect.filters = [];
        }
        return select;
    }  /**
        return edit;
    }  /**************************************************************************
    }  /**************************************************************************
        }
        else if (_lineDefinition.type == LineType.DASHED) {_container.graphics.lineStyle(_lineDefinition.strokeSize, _lineDefinition.strokeColor, _lineDefinition.strokeAlpha, false, LineScaleMode.NORMAL, CapsStyle.SQUARE, JointStyle.MITER);_container.graphics.drawPath(_lineDefinition.commands, _lineDefinition.drawingData, GraphicsPathWinding.NON_ZERO);
        }
        else if (_lineDefinition.type == LineType.DOTTED) {  // draw dots  _container.graphics.lineStyle(0, 0xFF0000, 0);_container.graphics.beginFill(_lineDefinition.strokeColor, _lineDefinition.strokeAlpha);_container.graphics.drawPath(_lineDefinition.commands, _lineDefinition.drawingData, GraphicsPathWinding.NON_ZERO);_container.graphics.endFill();
        }
    }  /**************************************************************************
    }
}