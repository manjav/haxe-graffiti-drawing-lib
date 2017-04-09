/**  	Graffiti 3.0*  	______________________________________________________________________*  	www.nocircleno.com/graffiti/*/  /** 	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,* 	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES* 	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND* 	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT* 	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,* 	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING* 	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR* 	OTHER DEALINGS IN THE SOFTWARE.*/  package com.nocircleno.graffiti.tools;

/**	* The Tool Drawing Mode	*	* @langversion 3.0    * @playerversion Flash 10 AIR 1.5 	*/class ToolMode
{  /**		*Use for regular drawing.		*/  public static inline var NORMAL : String = "normal";  /**		*Use for eraser functionality.		*/  public static inline var ERASE : String = "erase";  /**		* The <code>validMode</code> method is used to validate a mode type.		* 		* @param mode String to check to see if it is a valid Tool Mode		* 		*/  public static function validMode(mode : String) : Bool{var valid : Bool = false;if (mode == ToolMode.NORMAL || mode == ToolMode.ERASE) {valid = true;
        }return valid;
    }

    public function new()
    {
    }
}