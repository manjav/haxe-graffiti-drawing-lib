  /*

import openfl.geom.Point;  /**
{
    public var type(get, set) : String;
    public var color(get, set) : Int;
    public var alpha(get, set) : Float;
    public var size(get, set) : Float;
    public var blur(get, set) : Float;
    public var commands(get, set) : Array<Int>;
    public var drawingData(get, set) : Array<Float>;
    public var position(get, set) : Point;
private var _type : String;private var _color : Int;private var _alpha : Float;private var _size : Float;private var _blur : Float;private var _position : Point;private var _commnads : Array<Int>;private var _drawingData : Array<Float>;  /**
    {
        super();  // store properties  _type = type;_color = color;_alpha = alpha;_size = size;_blur = blur;_position = position.clone();_commnads = commands.concat(new Array<Int>());_drawingData = drawingData.concat(new Array<Float>());
    }  /**
        return value;
    }private function get_type() : String{return _type;
    }  /**
        return value;
    }private function get_color() : Int{return _color;
    }  /**
        return value;
    }private function get_alpha() : Float{return _alpha;
    }  /**
        return value;
    }private function get_size() : Float{return _size;
    }  /**
        return value;
    }private function get_blur() : Float{return _blur;
    }  /**
        return value;
    }private function get_commands() : Array<Int>{return _commnads;
    }  /**
        return value;
    }private function get_drawingData() : Array<Float>{return _drawingData;
    }  /**
        return value;
    }private function get_position() : Point{return _position;
    }  /**
    }
}