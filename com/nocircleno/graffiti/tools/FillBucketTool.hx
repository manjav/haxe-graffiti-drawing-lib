  /*

import openfl.display.DisplayObject;import openfl.geom.Point;import com.nocircleno.graffiti.tools.ITool;import com.nocircleno.graffiti.tools.ToolRenderType;  /**
{
    public var fillColor(get, set) : Int;
    public var useEntireCanvas(get, set) : Bool;
    public var useAdvancedFill(get, set) : Bool;
    public var smoothStrength(get, set) : Int;
    public var layerType(get, never) : String;
    public var renderType(get, never) : String;
private var LAYER_TYPE : String = LayerType.DRAWING_LAYER;private var _renderType : String = ToolRenderType.SINGLE_CLICK;private var _fillColor : Int;private var _useEntireCanvas : Bool;private var _useAdvancedFill : Bool;private var _smoothStrength : Int;  /**
    {_fillColor = fillColor;_useEntireCanvas = useEntireCanvas;_useAdvancedFill = useAdvancedFill;_smoothStrength = smoothStrength;
    }  /**
        return color;
    }private function get_fillColor() : Int{return _fillColor;
    }  /**
        return b;
    }private function get_useEntireCanvas() : Bool{return _useEntireCanvas;
    }  /**
        return b;
    }private function get_useAdvancedFill() : Bool{return _useAdvancedFill;
    }  /**
        return s;
    }private function get_smoothStrength() : Int{return _smoothStrength;
    }  /**
    }  /**
    }
}