/*

import openfl.display.DisplayObject;import openfl.geom.Point;import com.nocircleno.graffiti.tools.ITool;  /**
{
    public var renderType(get, never) : String;
    public var type(get, set) : String;
    public var layerType(get, never) : String;
    public var mode(get, set) : String;
    public var objectDrawingMode(get, set) : Bool;
private var _renderType : String;private var _mode : String;private var _type : String;private var commands : Array<Int> = new Array<Int>();private var drawingData : Array<Float> = new Array<Float>();private var _upperCornerBounds : Point = new Point(Float.MAX_VALUE, Float.MAX_VALUE);private var _lowerRightCornerBounds : Point = new Point(Float.MIN_VALUE, Float.MIN_VALUE);private var _objectDrawingMode : Bool = false;public function new()
    {
    }  /**
    }  /**
        return t;
    }private function get_type() : String{return _type;
    }  /**
        }
        else {layer = LayerType.DRAWING_LAYER;
        }return layer;
    }  /**
        }
        else {_mode = ToolMode.NORMAL;
        }
        return toolMode;
    }private function get_mode() : String{return _mode;
    }  /**
        return mode;
    }private function get_objectDrawingMode() : Bool{return _objectDrawingMode;
    }  /**
    }  /**
    }
}