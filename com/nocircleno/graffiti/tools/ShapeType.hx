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
*/  package com.nocircleno.graffiti.tools;

/**
* Class provides constant values used to define the types of shapes available.
*
* @langversion 3.0
* @playerversion Flash 10 AIR 1.5 
*/
class ShapeType
{  

	/**
	* Rectangle Shape
	*/
	public static inline var RECTANGLE : String = "rectangle"; 

	/**
	* Square Shape
	*/ 
	public static inline var SQUARE : String = "square";  
	
	/**
	* Oval Shape
	*/
	public static inline var OVAL : String = "oval";

	/**
	* Circle Shape
	*/ 
	public static inline var CIRCLE : String = "circle"; 

	/**
	* The <code>validType</code> method is used to validate a shape type.
	* 
	* @param type String to check to see if it is a valid Shape Type.
	* 
	*/  
	public static function validType(type : String) : Bool
	{
		var valid : Bool = false;
		if (type == ShapeType.RECTANGLE || type == ShapeType.SQUARE || type == ShapeType.OVAL || type == ShapeType.CIRCLE) 
		{
			valid = true;
		}
		return valid;
    }

    public function new()
    {
    }
}