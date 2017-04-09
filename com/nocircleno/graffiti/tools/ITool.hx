  /**  	Graffiti 3.0*  	______________________________________________________________________*  	www.nocircleno.com/graffiti/*/    /** 	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,* 	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES* 	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND* 	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT* 	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,* 	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING* 	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR* 	OTHER DEALINGS IN THE SOFTWARE.*/  package com.nocircleno.graffiti.tools;

import openfl.display.DisplayObject;import openfl.geom.Point;  /**	* The ITool interface will be implemented by all tools.	*	* @langversion 3.0    * @playerversion Flash 10 AIR 1.5 	*/  interface ITool
{
    /**		* Type of Layer		*/var layerType(get, never) : String;      /**		* Render Type		*/  var renderType(get, never) : String;

}