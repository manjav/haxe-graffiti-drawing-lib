/*
*  	Graffiti 3.0
*  	______________________________________________________________________
*  	www.nocircleno.com/graffiti/
*/

/*
* 	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* 	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* 	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* 	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* 	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* 	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* 	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* 	OTHER DEALINGS IN THE SOFTWARE.
*/

package com.nocircleno.graffiti.tools;


import openfl.text.Font;
import openfl.text.TextFormat;


/**
	* TextTool Class is used to create and edit text objects for the graffiti library.
	*
	* @langversion 3.0
* @playerversion Flash 10 AIR 1.5 
	*/
class TextTool implements ITool
{
    public var layerType(get, never) : String;
    public var renderType(get, never) : String;
    public var textSettings(get, set) : TextSettings;

    
    private var LAYER_TYPE : String = LayerType.OBJECT_LAYER;
    
    private var _renderType : String = ToolRenderType.SINGLE_CLICK;
    private var _textSettings : TextSettings;
    
    /**
		* The <code>TextTool</code> constructor.
		*
		* @param textSettings TextSettings instance used when the TextTool is used.
		* 
		* @example The following code creates an instance of the TextTool.
		* <listing version="3.0" >
		* var fmt:TextFormat = new TextFormat();
		* fmt.font = "Arial";
		* fmt.size = 22;
		* fmt.color = 0x000000;
		* 
		* var textSettings:TextSettings = new TextSettings(fmt);
		* 
		* var textTool:TextTool = new TextTool(textSettings);
		* </listing>
		* 
		*/
    public function new(textSettings : TextSettings)
    {
        
        // store properties
        _textSettings = textSettings;
    }
    
    /**
		* Layer to create on.
		*/
    private function get_layerType() : String{
        return LAYER_TYPE;
    }
    
    /**
		* Text Tool Render Mode
		*/
    private function get_renderType() : String{
        return _renderType;
    }
    
    /**
		* Text Settings used by the Text Tool
		*/
    private function get_textSettings() : TextSettings{return _textSettings;
    }
    
    private function set_textSettings(value : TextSettings) : TextSettings
    {
        _textSettings = value;
        return value;
    }
}

