  /**  	Graffiti 3.0*  	______________________________________________________________________*  	www.nocircleno.com/graffiti/*/    /** 	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,* 	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES* 	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND* 	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT* 	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,* 	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING* 	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR* 	OTHER DEALINGS IN THE SOFTWARE.*/  package com.nocircleno.graffiti.tools;

import com.nocircleno.graffiti.tools.ITool;import openfl.geom.Rectangle;import openfl.geom.Point; /*** SelectionTool Class is used to select an object.** @langversion 3.0* @playerversion Flash 10 AIR 1.5 */  class SelectionTool implements ITool
{
    public var layerType(get, never) : String;
    public var renderType(get, never) : String;
    public var startSelectionPoint(never, set) : Point;
    public var endSelectionPoint(never, set) : Point;
    public var selectionRectangle(get, never) : Rectangle;	
	private var LAYER_TYPE : String = LayerType.OBJECT_LAYER;	private var _renderType : String = ToolRenderType.CLICK_DRAG;	private var _selectionRectangle : Rectangle;	private var _startPoint : Point;private var _endPoint : Point;  /**	* The <code>SelectionTool</code> constructor.	* @example The following code creates a Graffiti Canvas instance. 	* <listing version="3.0" >	* var selectionTool:SelectionTool = new SelectionTool();	* </listing>	*/ 	public function new()
    {		_startPoint = new Point();_endPoint = new Point();		_selectionRectangle = new Rectangle();
    } 	/**	* Layer to work on.	*/ 	private function get_layerType() : String	{		return LAYER_TYPE;
    }	/**	* Selection Tool Render Mode	*/  	private function get_renderType() : String	{		return _renderType;
    }		private function set_startSelectionPoint(p : Point) : Point	{		if (p != null) 		{			_startPoint = new Point(p.x, p.y);			_selectionRectangle = new Rectangle(_startPoint.x, _startPoint.y, 0, 0);
        }
        else 		{			_startPoint = null;_selectionRectangle = null;
        }
        return p;
    }		private function set_endSelectionPoint(p : Point) : Point	{		if (_startPoint != null)		{			_endPoint.x = p.x;			_endPoint.y = p.y;			if (_endPoint.x < _startPoint.x) 			{				_selectionRectangle.x = _endPoint.x;
            }
            else			{				_selectionRectangle.x = _startPoint.x;
            }						if (_endPoint.y < _startPoint.y) 			{				_selectionRectangle.y = _endPoint.y;
            }
            else 			{				_selectionRectangle.y = _startPoint.y;
            }  						// update width and height  			_selectionRectangle.width = Math.abs(_endPoint.x - _startPoint.x);			_selectionRectangle.height = Math.abs(_endPoint.y - _startPoint.y);
        }
        return p;
    }	private function get_selectionRectangle() : Rectangle	{		return _selectionRectangle;
    }
}