/**  	Graffiti 3.0*  	______________________________________________________________________*  	www.nocircleno.com/graffiti/*/  /** 	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,* 	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES* 	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND* 	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT* 	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,* 	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING* 	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR* 	OTHER DEALINGS IN THE SOFTWARE.*/  package com.nocircleno.graffiti.utils;

class Conversions
{  	/**	* The <code>radians</code> method converts a degree value to radians.	* 	* @param degrees Angle in degrees.	* 	*/ 	public static function radians(degrees : Float) : Float	{		return degrees * Math.PI / 180;
    }  		/**	* The <code>degrees</code> method converts a radian value to degrees.	* 	* @param radians Angle in radians.	* 	*/	public static function degrees(radians : Float) : Float	{		return radians * 180 / Math.PI;
    }

    public function new()
    {
    }
}