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
import openfl.text.FontType;
import openfl.text.TextFormat;


/**
* TextSettings Class is used to configure the look of text for the graffiti library.
*/
class TextSettings 
{
    public var embeddedFont(get, never) : Bool;
    public var font(get, set) : Font;
    public var textFormat(get, set) : TextFormat;
    public var backgroundColor(get, set) : Int;
    public var borderColor(get, set) : Int;

    
    private var _font : Font;
    private var _textFormat : TextFormat;
    private var _embeddedFont : Bool = false;
    private var _backgroundColor : Int;
    private var _borderColor : Int;
    
    /**
		* The <code>TextSettings</code> constructor.
		*
		* @param font Font object used for text.
		* @param textFormat TextFormat Object used to display Text.
		* @param backgroundColor Background Color used for the text, set to -1 for no background.
		* @param borderColor Border Color used for the text, set to -1 for no border.
		* 
		* @example The following code creates an instance of the TextSettings.
		* <listing version="3.0" >
		* var allFonts:Array = Font.enumerateFonts(true);
		* allFonts.sortOn("fontName", Array.CASEINSENSITIVE);
		* 
		* var fmt:TextFormat = new TextFormat();
		* fmt.size = 22;
		* fmt.color = 0x000000;
		* 
		* var textSettings:TextSettings = new TextSettings(Font(allFonts[0]), fmt, -1, 0xFF0000);
		* </listing>
		* 
		*/
    public function new(font : Font, textFormat : TextFormat, backgroundColor : Int = -1, borderColor : Int = -1)
    {
        // store properties
        this.font = font;
        this.textFormat = new TextFormat(textFormat.font, textFormat.size, textFormat.color);
        _backgroundColor = backgroundColor;
        _borderColor = borderColor;
    }
    
    /**
		* Is the font used an embedded font.
		*/
    private function get_embeddedFont() : Bool{return _embeddedFont;
    }
    
    /**
		* Font Object
		*/
    private function set_font(f : Font) : Font{
        
        _font = f;
        
        // check to see if font is embedded or not
        if (_font.fontType == FontType.DEVICE) {
            _embeddedFont = false;
        }
        else {
            _embeddedFont = true;
        }  // update text format object if exist  
        
        
        
        if (_textFormat != null) {
            _textFormat.font = _font.fontName;
        }
        return f;
    }
    
    private function get_font() : Font{
        return _font;
    }
    
    /**
		* Text Format for Text
		*/
    private function set_textFormat(fmt : TextFormat) : TextFormat{
        
        _textFormat = fmt;
        _textFormat.font = _font.fontName;
        return fmt;
    }
    
    private function get_textFormat() : TextFormat{
        return _textFormat;
    }
    
    /**
		* Background Color of Text.  Set to -1 for no background.
		*/
    private function set_backgroundColor(color : Int) : Int{
        _backgroundColor = color;
        return color;
    }
    
    private function get_backgroundColor() : Int{
        return _backgroundColor;
    }
    
    /**
		* Border Color of Text.  Set to -1 for no border.
		*/
    private function set_borderColor(color : Int) : Int{
        _borderColor = color;
        return color;
    }
    
    private function get_borderColor() : Int{
        return _borderColor;
    }
    
    /**
		* The <code>clone</code> method will return a new instance of the TextSettings.
		*
		* @return Returns new TextSettings with all the same settings.
		*/
    public function clone() : TextSettings{
        
        return new TextSettings(_font, _textFormat, _backgroundColor, _borderColor);
    }
}

