  /**  	Graffiti 3.0*  	______________________________________________________________________*  	www.nocircleno.com/graffiti/*/    /** 	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,* 	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES* 	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND* 	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT* 	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,* 	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING* 	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR* 	OTHER DEALINGS IN THE SOFTWARE.*/  package com.nocircleno.graffiti.tools;

import openfl.display.DisplayObject;import openfl.geom.Point;import com.nocircleno.graffiti.tools.ITool;import com.nocircleno.graffiti.tools.ToolRenderType;  /**	* Fill Bucket Tool Class allows the user to flood fill a part of the canvas.	*	* @langversion 3.0    * @playerversion Flash 10 AIR 1.5 	*/  @:final class FillBucketTool implements ITool
{
    public var fillColor(get, set) : Int;
    public var useEntireCanvas(get, set) : Bool;
    public var useAdvancedFill(get, set) : Bool;
    public var smoothStrength(get, set) : Int;
    public var layerType(get, never) : String;
    public var renderType(get, never) : String;
private var LAYER_TYPE : String = LayerType.DRAWING_LAYER;private var _renderType : String = ToolRenderType.SINGLE_CLICK;private var _fillColor : Int;private var _useEntireCanvas : Bool;private var _useAdvancedFill : Bool;private var _smoothStrength : Int;  /**		* The <code>FillBucketTool</code> constructor.		* 		* @param fillColor Color to fill with.  This color should have an alpha value.		* @param useEntireCanvas Use underlaid and overlaid display object when filling.		* @param useAdvancedFill Apply a smoothing to the fill before applying it to the canvas.		* @param smoothStrength Smoothing setting for advanced fill.		*		* @example The following code creates a Fill Bucket Tool instance.		* <listing version="3.0" >		* // create a fill bucket tool		* var fillTool:FillBucketTool = new FillBucketTool(0xFFFF0000, false); 		* </listing>		* 		*/  public function new(fillColor : Int, useEntireCanvas : Bool = false, useAdvancedFill : Bool = true, smoothStrength : Int = 8)
    {_fillColor = fillColor;_useEntireCanvas = useEntireCanvas;_useAdvancedFill = useAdvancedFill;_smoothStrength = smoothStrength;
    }  /**		* Fill Color		*/  private function set_fillColor(color : Int) : Int{_fillColor = color;
        return color;
    }private function get_fillColor() : Int{return _fillColor;
    }  /**		* Use the entire canvas when filling including an overlaid and underlaid display objects.		*/  private function set_useEntireCanvas(b : Bool) : Bool{_useEntireCanvas = b;
        return b;
    }private function get_useEntireCanvas() : Bool{return _useEntireCanvas;
    }  /**		* Smooth out the fill before applying to the canvas.		*/  private function set_useAdvancedFill(b : Bool) : Bool{_useAdvancedFill = b;
        return b;
    }private function get_useAdvancedFill() : Bool{return _useAdvancedFill;
    }  /**		* Smoothing strength when using advanded fill.		*/  private function set_smoothStrength(s : Int) : Int{_smoothStrength = s;
        return s;
    }private function get_smoothStrength() : Int{return _smoothStrength;
    }  /**		* Layer to create on.		*/  private function get_layerType() : String{return LAYER_TYPE;
    }  /**		* Fill Bucket Render Mode		*/  private function get_renderType() : String{return _renderType;
    }
}