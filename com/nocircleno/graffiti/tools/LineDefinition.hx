  /*

import openfl.geom.Point;  /**
{
    public var type(get, set) : String;
    public var commands(get, set) : Array<Int>;
    public var drawingData(get, set) : Array<Float>;
    public var width(get, set) : Float;
    public var height(get, set) : Float;
    public var position(get, set) : Point;
    public var strokeColor(get, set) : Int;
    public var strokeAlpha(get, set) : Float;
    public var strokeSize(get, set) : Float;
private var _type : String;private var _strokeColor : Int;private var _strokeAlpha : Float;private var _strokeSize : Float;private var _position : Point;private var _lineWidth : Float;private var _lineHeight : Float;private var _commnads : Array<Int>;private var _drawingData : Array<Float>;  /**
    {
        super();  // store properties  _type = type;_strokeColor = strokeColor;_strokeAlpha = strokeAlpha;_strokeSize = strokeSize;_lineWidth = lineWidth;_lineHeight = lineHeight;_commnads = commands.concat(new Array<Int>());_drawingData = drawingData.concat(new Array<Float>());_position = position.clone();
    }  /**
        return value;
    }private function get_type() : String{return _type;
    }  /**
        return value;
    }private function get_commands() : Array<Int>{return _commnads;
    }  /**
        return value;
    }private function get_drawingData() : Array<Float>{return _drawingData;
    }  /**
        return value;
    }private function get_width() : Float{return _lineWidth;
    }  /**
        return value;
    }private function get_height() : Float{return _lineHeight;
    }  /**
        return value;
    }private function get_position() : Point{return _position;
    }  /**
    }private function set_strokeColor(value : Int) : Int{_strokeColor = value;
        return value;
    }  /**
    }private function set_strokeAlpha(value : Float) : Float{_strokeAlpha = value;
        return value;
    }  /**
    }private function set_strokeSize(value : Float) : Float{_strokeSize = value;
        return value;
    }  /**
    }
}