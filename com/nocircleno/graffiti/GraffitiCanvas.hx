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

package com.nocircleno.graffiti;



import com.nocircleno.graffiti.display.BrushObject;
import com.nocircleno.graffiti.tools.BrushDefinition;
import com.nocircleno.graffiti.display.ShapeObject;
import com.nocircleno.graffiti.tools.ShapeDefinition;
import com.nocircleno.graffiti.tools.LineDefinition;
import com.nocircleno.graffiti.display.LineObject;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.events.Event;
import openfl.geom.Point;
import openfl.geom.Rectangle;

import com.nocircleno.graffiti.events.GraffitiObjectEvent;
import com.nocircleno.graffiti.events.CanvasEvent;
import com.nocircleno.graffiti.tools.ITool;
import com.nocircleno.graffiti.tools.BitmapTool;
import com.nocircleno.graffiti.tools.ToolRenderType;
import com.nocircleno.graffiti.tools.BrushTool;
import com.nocircleno.graffiti.tools.BrushType;
import com.nocircleno.graffiti.tools.LineTool;
import com.nocircleno.graffiti.tools.LineType;
import com.nocircleno.graffiti.tools.ShapeTool;
import com.nocircleno.graffiti.tools.ShapeType;
import com.nocircleno.graffiti.tools.ToolMode;
import com.nocircleno.graffiti.tools.TextTool;
import com.nocircleno.graffiti.tools.FillBucketTool;
import com.nocircleno.graffiti.tools.SelectionTool;
import com.nocircleno.graffiti.tools.LayerType;
import com.nocircleno.graffiti.display.GraffitiObject;
import com.nocircleno.graffiti.display.TextObject;
import com.nocircleno.graffiti.managers.GraffitiObjectManager;
import com.nocircleno.graffiti.converters.FormatType;



/**
	* The GraffitiCanvas Class provides an area on stage to draw in.  It extends
	* the Sprite Class, so you can add it as a child anywhere in the display list.
	* Once you've created an instance of the GraffitiCanvas Class you can assign
	* different tools to the canvas.
	*
	* <p>2.5 Features:
	* <ul>
	*	  <li>Create a drawing area up to 4095x4095 pixels.</li>
	*	  <li>Brush Tool providing 7 different Brush shapes with transparency and blur.</li>
	*     <li>Line Tool providing Solid, Dashed and Dotted lines.</li>
	*     <li>Shape Tool providing Rectangle, Square, Oval and Circle Shapes.</li>
	*     <li>Fill Bucket Tool provides a way to quickly fill a solid area of color with another color.</li>
	*     <li>Text Tool allows you to create, edit and move text on the canvas.</li>
	*	  <li>Add a bitmap or vector image under and/or over the drawing area of the Canvas.</li>
	*     <li>Built in zoom functionality including ability to drag an obscured canvas with the mouse.</li>
	*     <li>Keep and control a history of the drawing allowing undo and redo's</li>
	*     <li>Easily get a copy of your drawing to use with your favorite image encoder.</li>
	* </ul></p>
	* <p>It is up to the developer to implement a UI for these features.
	* </p>
	*

	*/


import openfl.system.System;

class GraffitiCanvas extends Sprite
{
    public var objectManager(get, never) : GraffitiObjectManager;
    public var canvasWidth(get, set) : Int;
    public var canvasHeight(get, set) : Int;
    public var zoom(get, set) : Float;
    public var minZoom(get, never) : Float;
    public var maxZoom(get, never) : Float;
    public var activeTool(get, set) : ITool;
    public var overlay(never, set) : DisplayObject;
    public var underlay(never, set) : DisplayObject;
    public var mouseDrag(get, set) : Bool;
    public var canvasEnabled(get, set) : Bool;
    public var historyLength(get, never) : Int;
    public var maxHistoryLength(get, never) : Int;
    public var historyPosition(get, never) : Int;

    
    public static inline var HISTORY_LENGTH_CHANGE : String = "historyLengthChange";
    
    private inline var OBJECT_NUDGE_AMOUNT : Int = 1;
    private inline var OBJECT_SHIFT_NUDGE_AMOUNT : Int = 5;
    
    // display assets
    private var drawing_layer : Sprite;
    private var object_layer : Sprite;
    private var container : Sprite;
    private var canvas : Bitmap;
    private var overlay_do : DisplayObject;
    private var underlay_do : DisplayObject;
    
    // private properties
    private var _bmp : BitmapData;
    private var _canvasEnabled : Bool = true;
    private var _mouseDrag : Bool = false;
    private var _tool : ITool;
    private var _prevPoint : Point;
    private var _canvasWidth : Int;
    private var _canvasHeight : Int;
    private var _zoom : Float = 1;
    private var _minZoom : Int = 1;
    private var _maxZoom : Int;
    private var _history : Array<CanvasHistoryPoint>;
    private var _maxHistoryLength : Int;
    private var _historyPosition : Int = 0;
    private var _shiftKeyWasDown : Bool = false;
    private var _objectManager : GraffitiObjectManager;
    
    private var _nudgingObjects : Bool = false;
    private var _nudgeTimoutID : Int = -1;
    private var _keyboardShiftDown : Bool = false;
    private var _arrowKeysDownTacker : Array<Bool>;
    
    private var _lastMousePosition : Point = new Point();
    
    /**
		* The <code>GraffitiCanvas</code> constructor.
		* 
		* @param canvasWidth Width of the canvas.
		* @param canvasHeight Height of the canvas.
		* @param numberHistoryLevels Max number of History items to keep, if 0 then no history is kept.
		* @param overlay An optional DisplayObject that can be used as an overlay to the Canvas.  DisplayObject should be partially transparent.
		* @param underlay An optional DisplayObject that can be used as an underlay to the Canvas.
		*
		* @example The following code creates a Graffiti Canvas instance. 
		* <listing version="3.0" >
		* package {
		*
		*		import openfl.display.Sprite;
		*		import com.nocircleno.graffiti.GraffitiCanvas;
		*		import com.nocircleno.graffiti.tools.BrushTool;
		*		import com.nocircleno.graffiti.tools.BrushType;
		*		

		*		// create new instance of graffiti canvas, with a width and height of 400 and 10 history levels.
		*		// by default a Brush instance is created inside the GraffitiCanvas Class and assigned as the active tool.
		*		var canvas:GraffitiCanvas = new GraffitiCanvas(400, 400, 10);
		*		addChild(canvas);
		*				
		*		// create a new BrushTool instance, brush size of 8, brush color is Red, fully opaque, no blur and Brush type is Backward line.
		*		var angledBrush:BrushTool = new BrushTool(8, 0xFF0000, 1, 0, BrushType.BACKWARD_LINE);
		*				
		*		// assign the Brush as the active tool used by the Canvas
		*		canvas.activeTool = angledBrush;
		*				
		*			
		* }
		* </listing>
		* 
		*/
    public function new(canvasWidth : Int = 100, canvasHeight : Int = 100, numberHistoryLevels : Int = 0, overlay : DisplayObject = null, underlay : DisplayObject = null)
    {
        super();
        
        // set width and height
        _canvasWidth = canvasWidth;
        _canvasHeight = canvasHeight;
        
        // check values
        checkPropertyLimits();
        
        // init list to track what arrow keys are down
        _arrowKeysDownTacker = new Array<Bool>();
        _arrowKeysDownTacker[0] = false;  // LEFT KEY  
        _arrowKeysDownTacker[1] = false;  // UP KEY  
        _arrowKeysDownTacker[2] = false;  // RIGHT KEY  
        _arrowKeysDownTacker[3] = false;  // DOWN KEY  
        
        /////////////////////////////////////////////////
        // Create Default Tool, a Brush
        /////////////////////////////////////////////////
        _tool = new BrushTool(16, 0x000000, 1, 0, BrushType.DIAMOND);
        
        /////////////////////////////////////////////////
        // Create Canvas Assets
        /////////////////////////////////////////////////
        drawing_layer = new Sprite();
        drawing_layer.name = "drawing_layer";
        object_layer = new Sprite();
        object_layer.name = "object_layer";
        container = new Sprite();
        container.name = "container";
        
        _bmp = new BitmapData(_canvasWidth, _canvasHeight, true, 0x00FFFFFF);
        canvas = new Bitmap(_bmp, "auto", false);
        
        // add to display list
        addChild(container);
        container.addChild(canvas);
        container.addChild(drawing_layer);
        
        // if a overlay DisplayObject was passed, add it.
        if (overlay != null) {
            overlay_do = overlay;
            container.addChild(overlay_do);
        }  // if a underlay DisplayObject was passed, add it.  
        
        
        
        if (underlay != null) {
            underlay_do = underlay;
            container.addChildAt(underlay_do, 0);
        }  // add object layer above everything  
        
        
        
        container.addChild(object_layer);
        
        // add event listener
        object_layer.addEventListener(GraffitiObjectEvent.ENTER_EDIT, objectEventHandler, true, 0, true);
        object_layer.addEventListener(GraffitiObjectEvent.EXIT_EDIT, objectEventHandler, true, 0, true);
        
        // init object manager
        _objectManager = new GraffitiObjectManager();
        _objectManager.addEventListener(GraffitiObjectEvent.SELECT, objectEventHandler);
        _objectManager.addEventListener(GraffitiObjectEvent.DESELECT, objectEventHandler);
        _objectManager.addEventListener(GraffitiObjectEvent.DELETE, objectEventHandler);
        _objectManager.addEventListener(GraffitiObjectEvent.MOVE, objectEventHandler);
        
        // add event listener for mouse down
        this.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
        
        // listen for stage add
        this.addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
        
        // set scroll rect
        this.scrollRect = new Rectangle(0, 0, _canvasWidth, _canvasHeight);
        
        /////////////////////////////////////////////////
        // Initialize Drawing History
        /////////////////////////////////////////////////
        initHistory(numberHistoryLevels);
    }
    
    /**
		* The <code>setObjectData</code> method will create graffiti objects from xml.
		*
		* @param xml The object data in xml.
		* @param format The format of the xml, currently only supports Degrafa.
		*/
    public function setObjectData(xml : Xml, format : String) : Void{
        
        var graffitiObjects : Array<GraffitiObject>;
        
        if (format == FormatType.DEGRAFA) 
		{
            graffitiObjects = new Array<GraffitiObject>();//\\DegrafaConverter.from(xml);
			
			for (i in  0 ... graffitiObjects.length)
			{
				object_layer.addChild(graffitiObjects[i]);
				_objectManager.addObject(graffitiObjects[i]);
			}
			
		}
        _objectManager.deselectAll();
    }
    
    /**
		* The <code>getObjectData</code> method will convert all the graffiti objects to xml.
		*
		* @param format The format of the xml, currently only supports Degrafa.
		*
		* @return XML in the format specified
		*/
    public function getObjectData(format : String) : Xml{
        
        return getDataForObjects(_objectManager.objectList, format);
    }
    
    /**
		* The <code>getSelectedObjectData</code> method will convert the selected graffiti objects to xml.
		*
		* @param format The format of the xml, currently only supports Degrafa.
		*
		* @return XML in the format specified
		*/
    public function getSelectedObjectData(format : String) : Xml{
        
        var selectedObjectList : Array<GraffitiObject> = new Array<GraffitiObject>();
        
        for (graffitiObject/* AS3HX WARNING could not determine type for var: graffitiObject exp: EField(EIdent(_objectManager),objectList) type: null */ in _objectManager.objectList)
        {
            if (graffitiObject.selected) {
                selectedObjectList.push(graffitiObject);
            }
        }
        
        return getDataForObjects(selectedObjectList, format);
    }
    
    private function getDataForObjects(objectList : Array<GraffitiObject>, format : String) : Xml{
        
        var xml : Xml = Xml.parse('<root/>');
        
        if (format == FormatType.DEGRAFA)
		{
			//\\xml = DegrafaConverter.to(objectList);
        }
        
        return xml;
    }
    
    private function get_objectManager() : GraffitiObjectManager{
        return _objectManager;
    }
    
    /**
		* Control the canvas width.
		*
		* Important:
		* <ul>
		*	  <li>The canvas is resized from the upper left hand corner.</li>
		*	  <li>If you make the canvas width smaller, the drawing will get cropped on the right side.</li>
		*     <li>Changing the width of the canvas is NOT stored in the history.</li>
		* </ul>
		*/
    private function set_canvasWidth(w : Int) : Int{
        // set width
        _canvasWidth = w;
        
        // check value
        checkPropertyLimits();
        
        // rebuild the canvas with the new width
        resizeCanvas();
        return w;
    }
    
    private function get_canvasWidth() : Int{
        return _canvasWidth;
    }
    
    /**
		* Control the canvas height.
		*
		* Important:
		* <ul>
		*	  <li>The canvas is resized from the upper left hand corner.</li>
		*	  <li>If you make the canvas height smaller, the drawing will get cropped on the bottom.</li>
		*     <li>Changing the height of the canvas is NOT stored in the history.</li>
		* </ul>
		*/
    private function set_canvasHeight(h : Int) : Int{
        // set height
        _canvasHeight = h;
        
        // check value
        checkPropertyLimits();
        
        // rebuild the canvas with the new height
        resizeCanvas();
        return h;
    }
    
    private function get_canvasHeight() : Int{
        return _canvasHeight;
    }
    
    /**
		* Control the zoom state of the canvas from %100 (1) to the max zoom.
		*/
    private function set_zoom(z : Float) : Float{
        
        // check bounds
        if (z >= _minZoom && z <= _maxZoom) {
            
            // find view center point to zoom off us.
            var centerPoint : Point = new Point((Math.abs(container.x) + _canvasWidth / 2) / _zoom, (Math.abs(container.y) + _canvasHeight / 2) / _zoom);
            
            // store zoom level
            _zoom = z;
            
            // scale container
            container.scaleX = _zoom;
            container.scaleY = _zoom;
            
            // try and keep the same center focus
            container.x = (-(centerPoint.x) * _zoom) + _canvasWidth / 2;
            container.y = (-(centerPoint.y) * _zoom) + _canvasHeight / 2;
            
            // enfore bounds and make sure no part of the image is out out of bounds
            if (container.x > 0) {
                container.x = 0;
            }
            
            if (container.y > 0) {
                container.y = 0;
            }
            
            if (container.x + container.width < _canvasWidth) {
                container.x = _canvasWidth - container.width;
            }
            
            if (container.y + container.height < _canvasHeight) {
                container.y = _canvasHeight - container.height;
            }  // dispatch zoom event  
            
            
            
            dispatchEvent(new CanvasEvent(CanvasEvent.ZOOM, _zoom, _canvasWidth, _canvasHeight, getViewableRect()));
        }
        return z;
    }
    
    private function get_zoom() : Float{
        return _zoom;
    }
    
    /**
		* Minimum Zoom value.
		*/
    private function get_minZoom() : Float{
        return _minZoom;
    }
    
    /**
		* Maximum Zoom value.
		*/
    private function get_maxZoom() : Float{
        return _maxZoom;
    }
    
    /**
		* Control what Tool is used when the user interacts with the Canvas.
		*/
    private function set_activeTool(tool : ITool) : ITool{
        
        // set tool
        _tool = tool;
        
        // if tool isn't null, then check layer
        if (_tool != null) {
            
            // look to what layer this tool draws to
            if (_tool.layerType == LayerType.OBJECT_LAYER) {
                
                object_layer.mouseChildren = true;
                
                // make sure we turn off editing for any object on the canvas is the selection
                if (Std.is(_tool, SelectionTool) && _objectManager.areObjectsBeingEdited()) {
                    _objectManager.exitEditAll();
                }
            }
            else {
                object_layer.mouseChildren = false;
                _objectManager.deselectAll();
            }  // disable object layer  
        }
        else {
            object_layer.mouseChildren = false;
            _objectManager.deselectAll();
        }
        return tool;
    }
    
    private function get_activeTool() : ITool{
        return _tool;
    }
    
    /**
		* Display Object displayed above the drawing.
		*/
    private function set_overlay(displayObject : DisplayObject) : DisplayObject{
        
        // if overlay already exists remove it before adding new overlay
        if (overlay_do != null) {
            container.removeChild(overlay_do);
        }  // update overlay  
        
        
        
        overlay_do = displayObject;
        
        // add overlay if exists
        if (overlay_do != null) {
            container.addChildAt(overlay_do, container.numChildren - 1);
        }
        return displayObject;
    }
    
    /**
		* Display Object displayed under the drawing.
		*/
    private function set_underlay(displayObject : DisplayObject) : DisplayObject{
        
        // if underlay already exists remove it before adding new underlay
        if (underlay_do != null) {
            container.removeChild(underlay_do);
        }  // update underlay  
        
        
        
        underlay_do = displayObject;
        
        // add underlay if exists
        if (underlay_do != null) {
            container.addChildAt(underlay_do, 0);
        }
        return displayObject;
    }
    
    /**
		* Control when you can use the mouse to drag around the canvas.
		*/
    private function set_mouseDrag(drag : Bool) : Bool{
        
        if (drag) {
            _objectManager.deselectAll();
        }
        
        _mouseDrag = drag;
        return drag;
    }
    
    private function get_mouseDrag() : Bool{
        return _mouseDrag;
    }
    
    /**
		* Control if Canvas is enabled.
		*/
    private function set_canvasEnabled(en : Bool) : Bool{
        _canvasEnabled = en;
        this.mouseEnabled = en;
        this.mouseChildren = en;
        return en;
    }
    
    private function get_canvasEnabled() : Bool{
        return _canvasEnabled;
    }
    
    /**
		* Get the current number of saved history items.
		*/
    private function get_historyLength() : Int{
        return (_history != null) ? _history.length : 0;
    }
    
    /**
		* Get the maximum number of history items.
		*/
    private function get_maxHistoryLength() : Int{
        return _maxHistoryLength;
    }
    
    /**
		* Get the current history position.
		*/
    private function get_historyPosition() : Int{
        return _historyPosition;
    }
    
    
    /**
		* The <code>nextHistory</code> method will step forward and display the next item in 
		* the history.
		*
		* @see #prevHistory()
		* @see #historyLength
		* @see #historyPosition
		* @see #maxHistoryLength
		* @see #clearHistory()
		*/
    public function nextHistory() : Void{
        
        if (_history != null) {
            
            if (_historyPosition != _history.length - 1) {
                _historyPosition++;
                
                restoreFromHistory();
            }
        }
    }
    
    /**
		* The <code>prevHistory</code> method will step backwards and display the next item in 
		* the history.
		*
		* @see #prevHistory()
		* @see #historyLength
		* @see #historyPosition
		* @see #maxHistoryLength
		* @see #clearHistory()
		*/
    public function prevHistory() : Void{
        
        if (_history != null) {
            
            if (_historyPosition != 0) {
                _historyPosition--;
                
                restoreFromHistory();
            }
        }
    }
    
    /**
		* The <code>resetHistory</code> method will clear all history items
		* then add a history entry for the current state of the canvas.
		*
		* @see #prevHistory()
		* @see #historyLength
		* @see #historyPosition
		* @see #maxHistoryLength
		* @see #clearHistory()
		*/
    public function resetHistory() : Void{
        
        clearHistory();
        writeToHistory();
    }
    
    /**
		* The <code>clearHistory</code> method will clear all history items.
		* the Canvas.
		*
		* @see #prevHistory()
		* @see #historyLength
		* @see #historyPosition
		* @see #maxHistoryLength
		* @see #clearHistory()
		*/
    public function clearHistory() : Void{
        
        if (_history != null) {
            
            var i : Int;
            
            // kill stored bitmapdata objects
            for (i in 0..._history.length){
                _history[i].dispose();
            }  // create new vector  
            
            
            
            _history = new Array<CanvasHistoryPoint>();
            
            // reset history position
            _historyPosition = 0;
        }  // dispatch event for history length change  
        
        
        
        dispatchEvent(new Event(GraffitiCanvas.HISTORY_LENGTH_CHANGE));
    }
    
    /**
		* The <code>fill</code> method will flood fill an area of the drawing with the supplied color.
		*
		* @param point Point at which to flood fill with color.
		* @param color Color to fill with.
		* @param useEntireCanvas Set to true to use an overlaid or underlaid display object when filling.
		* @param useAdvancedFill Set to smooth out the fill.
		* @param smoothStrength The strength of the smoothing when using the advanced fill setting.
		*/
    public function fill(point : Point, color : Int, useEntireCanvas : Bool = false, useAdvancedFill : Bool = true, smoothStrength : Int = 8) : Void{
        
        // make sure point is within bitmap size
        if (_bmp.rect.containsPoint(point)) {
            
            // if a color is passed with no alpha component, then add it.
            if ((color >> 24) == 0) {
                
                // add alpha value to color value.
                color = 0xFF << 24 | color;
            }
            
            var snapshot1 : BitmapData;
            var snapshot2 : BitmapData;
            
            // get two snapshot copies
            if (useEntireCanvas) {
                
                // we do not want to include the object layer in the drawing capture
                //this.object_layer.visible = false;
                snapshot1 = cast((this.drawing(true, true, true, false)), BitmapData);
            }
            else {
                snapshot1 = cast((_bmp.clone()), BitmapData);
            }  // make another copy  
            
            
            
            snapshot2 = cast((snapshot1.clone()), BitmapData);
            
            // fill on point
            snapshot1.floodFill(point.x, point.y, color);
            
            // compare snapshots
            var compareResult : Dynamic = snapshot1.compare(snapshot2);
            
            // check to make sure compare result exists (snapshots are not the same).
            if (compareResult != 0) {
                
                var comp : BitmapData = cast((compareResult), BitmapData);
                var compAlpha : BitmapData = comp.clone();
                
                // get alpha value from color
                var alphaValue : Int = color >> 24 & 0x000000FF;
                var alphaNormalized : Float = alphaValue * 0.003921568627450980392156862745098;
                
                // only apply filter if advanced fill is set
                if (useAdvancedFill) {
                    
                    // apply glow to smoothout and expand the fill a little
                    comp.applyFilter(comp, comp.rect, new Point(0, 0), new GradientGlowFilter(0, 90, [color, color], [0, alphaNormalized], [0, 255], 2, 2, smoothStrength, BitmapFilterQuality.HIGH, BitmapFilterType.FULL, true));
                    
                    // we do not want to apply any alpha settings to this copy that will be used as an alpha mask with copy pixels
                    compAlpha.applyFilter(comp, comp.rect, new Point(0, 0), new GradientGlowFilter(0, 90, [color, color], [0, 0], [0, 255], 2, 2, smoothStrength, BitmapFilterQuality.HIGH, BitmapFilterType.FULL));
                }
                else {
                    
                    // change color of fill difference to desired color
                    var cTransform : ColorTransform = new ColorTransform(1, 1, 1, 0, 0, 0, 0, alphaValue);
                    cTransform.color = color;
                    comp.colorTransform(comp.rect, cTransform);
                }  // copy fill back into bitmap  
                
                
                
                _bmp.copyPixels(comp, comp.rect, new Point(0, 0), compAlpha, new Point(0, 0), true);
                
                // kill compare bitmapdata objects
                comp.dispose();
                compAlpha.dispose();
            }  // kill snapshot bitmapdata objects  
            
            
            
            snapshot1.dispose();
            snapshot2.dispose();
            
            // record to history if one is being recorded
            if (_maxHistoryLength != 0) {
                writeToHistory();
            }
        }
    }
    
    /**
		* The <code>getColorAtPoint</code> method will return the color at a specific point on the drawing.
		* If the point is out of bounds then 0 is returned.
		*
		* @param point Point to get color from.
		* @param useEntireCanvas A Boolean value that specifies whether to include any overlay or underlay display objects when reading the color at the point specified.
		*
		* @return Returns the color value at the point passed, returns 0 if point is outside of canvas dimensions.
		*/
    public function getColorAtPoint(point : Point, useEntireCanvas : Bool = false) : Int{
        
        var rColor : Int;
        
        // make sure point is within bitmap size
        if (_bmp.rect.containsPoint(point)) {
            
            if (useEntireCanvas) {
                
                // get snapshot
                var snapshot : BitmapData = cast((this.drawing()), BitmapData);
                
                // get color
                rColor = snapshot.getPixel32(point.x, point.y);
                
                // kill bitmapdata
                snapshot.dispose();
            }
            else {
                
                // get color
                rColor = _bmp.getPixel32(point.x, point.y);
            }
        }
        else {
            rColor = 0;
        }
        
        return rColor;
    }
    
    /**
		* The <code>getViewableRect</code> method will return a Rectangle defining the viewable area of the Canvas.
		* 
		* @return A Rectangle object that represents the viewable are of the Canvas.
		* If the canvas is zoomed all they way out then the dimensions of the Rectangle
		* are same as the Canvas width and height.
		*/
    public function getViewableRect() : Rectangle{
        
        var absX : Float = (container.x > 0.0) ? container.x : -container.x;
        var absY : Float = (container.y > 0.0) ? container.y : -container.y;
        
        return new Rectangle(absX / _zoom, absY / _zoom, _canvasWidth / _zoom, _canvasHeight / _zoom);
    }
    
    /**
		* The <code>setCanvasPos</code> method will change the position of the canvas.
		* 
		* @param pos Point to move canvas to.
		*/
    public function setCanvasPos(pos : Point) : Void{
        
        // try and keep the same center focus
        container.x = pos.x;
        container.y = pos.y;
        
        // enfore bounds and make sure no part of the image is out out of bounds
        if (container.x > 0) {
            container.x = 0;
        }
        
        if (container.y > 0) {
            container.y = 0;
        }
        
        if (container.x + container.width < _canvasWidth) {
            container.x = _canvasWidth - container.width;
        }
        
        if (container.y + container.height < _canvasHeight) {
            container.y = _canvasHeight - container.height;
        }
    }
    
    /**
		* The <code>clearCanvas</code> method will clear the Canvas.
		*/
    public function clearCanvas() : Void{
        
        // clear canvas
        _bmp.fillRect(new Rectangle(0, 0, _canvasWidth, _canvasHeight), 0x00FFFFFF);
        
        // delete all objects
        _objectManager.selectAll();
        _objectManager.deleteSelected();
        
        // record to history if one is being recorded
        if (_maxHistoryLength != 0) {
            writeToHistory();
        }
    }
    
    /**
		* The <code>drawing</code> method will return the bitmapdata object that captures
		* the drawn canvas including any overlay or underlay assets.
		*
		* @param transparentBg Specify if you want the image to have a transparent background.
		* @param includeOverlay Include the overlay display object with the image.
		* @param includeUnderlay Include the underlay display object with the image.
		* @param includeObjectLayer Include the object layer with the image.
		* 
		* @return A BitmapData object containing the entire canvas.
		*/
    public function drawing(transparentBg : Bool = false, includeOverlay : Bool = true, includeUnderlay : Bool = true, includeObjectLayer : Bool = true) : BitmapData{
        
        // make sure we deselect all objects before capturing the canvas.
        _objectManager.deselectAll();
        
        var canvasBmp : BitmapData;
        
        // set visibility
        if (overlay_do != null) {
            overlay_do.visible = includeOverlay;
        }
        
        if (underlay_do != null) {
            underlay_do.visible = includeUnderlay;
        }
        
        object_layer.visible = includeObjectLayer;
        
        if (!transparentBg) {
            canvasBmp = new BitmapData(_canvasWidth, _canvasHeight, false, 0xFFFFFFFF);
        }
        else {
            canvasBmp = new BitmapData(_canvasWidth, _canvasHeight, true, 0x00FFFFFF);
        }
        
        canvasBmp.draw(container);
        
        // turn all on
        if (overlay_do != null) {
            overlay_do.visible = true;
        }
        
        if (underlay_do != null) {
            underlay_do.visible = true;
        }
        
        object_layer.visible = true;
        
        return canvasBmp;
    }
    
    /**
		* The <code>drawToCanvas</code> method will draw a display object or bitmapdata object to the canvas.
		* This allows you to add an image that will be editable by the drawing engine.
		* 
		* @param asset Image to write to canvas. Object must IBitmapDrawable. This includes MovieClips, Sprites, Bitmaps, BitmapData.
		*/
    public function drawToCanvas(asset : Dynamic) : Void{
        
        if (Std.is(asset, IBitmapDrawable)) {
            
            _bmp.draw(cast((asset), IBitmapDrawable));
            
            // record to history if one is being recorded
            if (_maxHistoryLength != 0) {
                writeToHistory();
            }
        }
    }
    
    /**************************************************************************
			Method	: addToStageHandler()
			
			Purpose	: This method will assign a listener for keyboard shortcuts
					  to the stage.
					  
			Params	: e - Event Object
		***************************************************************************/
    private function addToStageHandler(e : Event) : Void{
        
        this.removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, keyboardShortcutHandler, false, 0, true);
        stage.addEventListener(KeyboardEvent.KEY_UP, keyboardShortcutHandler, false, 0, true);
    }
    
    /**************************************************************************
			Method	: keyboardShortcutHandler()
			
			Purpose	: This method will handles keyboard shortcuts.
					  
			Params	: e - KeyboardEvent Object
		***************************************************************************/
    private function keyboardShortcutHandler(e : KeyboardEvent) : Void{
        
        if (_canvasEnabled) {
            
            if (e.type == KeyboardEvent.KEY_UP) {
                
                if (e.keyCode == Keyboard.DELETE) {
                    
                    _objectManager.deleteSelected();
                }
                else {
                    
                    // record if the shift key is down
                    _keyboardShiftDown = e.shiftKey;
                    
                    if (e.keyCode == Keyboard.LEFT) {
                        _arrowKeysDownTacker[0] = false;
                    }
                    else if (e.keyCode == Keyboard.RIGHT) {
                        _arrowKeysDownTacker[2] = false;
                    }
                    else if (e.keyCode == Keyboard.UP) {
                        _arrowKeysDownTacker[1] = false;
                    }
                    else if (e.keyCode == Keyboard.DOWN) {
                        _arrowKeysDownTacker[3] = false;
                    }
                    
                    // if no arrow keys are down then stop the nudging show
                    if (!_arrowKeysDownTacker[0] && !_arrowKeysDownTacker[1] && !_arrowKeysDownTacker[2] && !_arrowKeysDownTacker[3]) {
                        
                        // clear timeout if it hasn't fired yet
                        if (_nudgeTimoutID != -1) {
                            as3hx.Compat.clearTimeout(_nudgeTimoutID);
                        }
                        
                        _nudgingObjects = false;
                        
                        stage.removeEventListener(Event.ENTER_FRAME, nudgeObjects);
                    }
                }
            } else if (e.type == KeyboardEvent.KEY_DOWN) {
                
                var arrowKeyPressed : Bool = false;
                
                // record if the shift key is down
                _keyboardShiftDown = e.shiftKey;
                
                // mark arrow key as down
                if (e.keyCode == Keyboard.LEFT) {
                    arrowKeyPressed = true;
                    _arrowKeysDownTacker[0] = true;
                }
                else if (e.keyCode == Keyboard.UP) {
                    arrowKeyPressed = true;
                    _arrowKeysDownTacker[1] = true;
                }
                else if (e.keyCode == Keyboard.RIGHT) {
                    arrowKeyPressed = true;
                    _arrowKeysDownTacker[2] = true;
                }
                else if (e.keyCode == Keyboard.DOWN) {
                    arrowKeyPressed = true;
                    _arrowKeysDownTacker[3] = true;
                }

                // start object nudging if not already doing it
                if (!_nudgingObjects && arrowKeyPressed) {
                    
                    // nudge
                    nudgeObjects(null);
                    
                    // set a short timeout before continually moving objects
                    _nudgeTimoutID = as3hx.Compat.setTimeout(enableContinuousNudging, 500);
                }
				
            }
			
        }
		
    }
    
    private function enableContinuousNudging() : Void{
        
        _nudgeTimoutID = -1;
        stage.addEventListener(Event.ENTER_FRAME, nudgeObjects, false, 0, true);
    }
    
    private function nudgeObjects(e : Event) : Void{
        
        _nudgingObjects = true;
        
        var xOffset : Int = 0;
        var yOffset : Int = 0;
        
        var nudgeAmount : Int;
        
        if (_keyboardShiftDown) {
            nudgeAmount = OBJECT_SHIFT_NUDGE_AMOUNT;
        }
        else {
            nudgeAmount = OBJECT_NUDGE_AMOUNT;
        }  // left arrow  
        
        
        
        if (_arrowKeysDownTacker[0]) {
            xOffset = -nudgeAmount;
        }
        // up arrow
        else if (_arrowKeysDownTacker[2]) {
            xOffset = nudgeAmount;
        }
        
        
        
        if (_arrowKeysDownTacker[1]) {
            yOffset = -nudgeAmount;
        }
        // move objects
        else if (_arrowKeysDownTacker[3]) {
            yOffset = nudgeAmount;
        }
        
        
        
        _objectManager.moveSelectedObjects(xOffset, yOffset);
    }
    
    /**************************************************************************
			Method	: objectEventHandler()
			
			Purpose	: This method will handle graffiti object events.
					  
			Params	: e - GraffitiObjectEvent Object
		***************************************************************************/
    private function objectEventHandler(e : GraffitiObjectEvent) : Void{
        
        var dispatch : Bool = true;
        
        if (e.type == GraffitiObjectEvent.DESELECT) {
            
            if (Std.is(e.graffitiObjects[0], TextObject)) {
                
                // if the text field has no text, then kill it
                if (cast((e.graffitiObjects[0]), TextObject).text == "") {
                    
                    if (object_layer.contains(e.graffitiObjects[0])) {
                        object_layer.removeChild(e.graffitiObjects[0]);
                    }
                    
                    dispatch = false;
                }
            }
        }
		
        else if (e.type == GraffitiObjectEvent.DELETE) {
            
            var numberObjects : Int = e.graffitiObjects.length;
            
            for (i in 0...numberObjects){
                object_layer.removeChild(e.graffitiObjects[i]);
            }
        }
        
        
        // stop event from rocking
        e.stopPropagation();
        
        // dispatch event if ok
        if (dispatch) {
            dispatchEvent(e.clone());
        }
		
    }
    
    /**************************************************************************
			Method	: checkPropertyLimits()
			
			Purpose	: This method will make sure canvas width, canvas height and
					  zoom level are within the bounds.
		***************************************************************************/
    private function checkPropertyLimits() : Void{
        
        // calculate max zoom to avoid bitmap display problems
        _maxZoom = Math.floor(Math.max(_canvasWidth, _canvasHeight));
        
        // check zoom to make sure if not greater then max zoom
        if (_zoom > _maxZoom) {
            this.zoom = _maxZoom;
        }
    }
    
    /**************************************************************************
			Method	: resizeCanvas()
			
			Purpose	: This method will resize the canvas assets.
		***************************************************************************/
    private function resizeCanvas() : Void{
        
        /////////////////////////////////////////////////
        // Create Bitmap
        /////////////////////////////////////////////////
        if (_bmp != null) {
            
            // make a copy of the canvas
            var bmpCopy : BitmapData = _bmp.clone();
            
            // kill current bitmap
            _bmp.dispose();
            
            // create new bitmapdata object with new width and height
            _bmp = new BitmapData(_canvasWidth, _canvasHeight, true, 0x00FFFFFF);
            
            // copy pixels back
            _bmp.copyPixels(bmpCopy, bmpCopy.rect, new Point(0, 0));
            
            // kill copy
            bmpCopy.dispose();
            
            // update canvas bitmapdata object
            canvas.bitmapData = _bmp;
        } 


		// update scroll rect  
         this.scrollRect = new Rectangle(0, 0, _canvasWidth, _canvasHeight);
    }
    
    /**************************************************************************
			Method	: initHistory()
			
			Purpose	: This method will initialize our drawing history.
			
			Params	: levels -- number of levels of history to keep.
		***************************************************************************/
    private function initHistory(levels : Int) : Void{
        
        _maxHistoryLength = levels;
        
        if (_maxHistoryLength != 0) {
            
            // create history vector
            _history = new Array<CanvasHistoryPoint>();
            
            // record blank canvas to history
            writeToHistory();
        }
    }
    
    /**************************************************************************
			Method	: restoreFromHistory()
			
			Purpose	: This method will restore the drawing to a store history
					  drawing.
		***************************************************************************/
    private function restoreFromHistory() : Void{
        
        var historyPoint : CanvasHistoryPoint = _history[_historyPosition];
        var historyBitmapData : BitmapData = historyPoint.bitmapData;
        var historyObjectData : Xml = historyPoint.objectData;
        
        // get history bitmap rectangle
        var historyRect : Rectangle = historyBitmapData.rect;
        
        // check to see if the dims of history bitmap and the current canas size don't match
        if (historyRect.width != _canvasWidth || historyRect.height != _canvasHeight) {
            
            // create a tempory bitmapdata object the size of the canvas width and height
            var temp : BitmapData = new BitmapData(_canvasWidth, _canvasHeight, true, 0x00FFFFFF);
            
            // merge new tempory and history bitmapdata objects
            temp.copyPixels(historyBitmapData, historyBitmapData.rect, new Point(0, 0));
            
            // copy pixels to canvas bitmapdata
            _bmp.copyPixels(temp, temp.rect, new Point(0, 0));
            
            // kill temp bitmapdata
            temp.dispose();
        }
        else {
            
            // restore bitmap from history
            _bmp.copyPixels(historyBitmapData, historyBitmapData.rect, new Point(0, 0));
        }  // restore objects from history  
        
        
        
        _objectManager.selectAll();
        _objectManager.deleteSelected();
        setObjectData(historyObjectData, FormatType.DEGRAFA);
    }
    
    /**************************************************************************
			Method	: writeToHistory()
			
			Purpose	: This method will record the current drawing to history.
		***************************************************************************/
    private function writeToHistory() : Void{
        
        var historyLength : Int = _history.length;
        
        // if the history position is not at the end then
        // we need to dispose of the top of the history queue.
        if (_historyPosition != historyLength - 1) {
            
            var i : Int;
            
            i = (historyLength - 1);
            while (i > Math.max(_historyPosition, 0)){
                _history[i].dispose();
                _history.splice(i, 1);
                --i;
            }
        }  // if we have reached the max history length  
        
        
        
        if (_history.length == _maxHistoryLength) {
            
            _history[0].dispose();
            _history.splice(0, 1);
        }  // write current drawing to history  
        
        
        
        _history.push(new CanvasHistoryPoint(_bmp.clone(), getObjectData(FormatType.DEGRAFA)));
        
        // set history index to end
        _historyPosition = _history.length - 1;
        
        // dispatch event for history length change
        dispatchEvent(new Event(GraffitiCanvas.HISTORY_LENGTH_CHANGE));
    }
    
    /**************************************************************************
			Method	: getGraffitiObjectsAtPoint()
			
			Purpose	: This method will return all objects at point passed.
			
			Params	: pt - Point Clicked on in object layer space.
		***************************************************************************/
    private function getGraffitiObjectsAtPoint(pt : Point) : Array<GraffitiObject>{
        
        pt = object_layer.localToGlobal(pt);
        
        var objects : Array<GraffitiObject> = new Array<GraffitiObject>();
        var numObjects : Int = object_layer.numChildren;
        var child : GraffitiObject;
        
        for (i in 0...numObjects){
            
            child = cast((object_layer.getChildAt(i)), GraffitiObject);
            
            if (child.hitTestPoint(pt.x, pt.y, true)) {
                objects.push(child);
            }
        }
        
        return objects;
    }
    
    /**************************************************************************
			Method	: mouseHandler()
			
			Purpose	: This method will handle the mouse events used for drawing.
			
			Params	: e -- MouseEvent object.
		***************************************************************************/
    private function mouseHandler(e : MouseEvent) : Void{
        
        if (_canvasEnabled && (_tool != null || _mouseDrag)) {
            
            if (e.type == MouseEvent.MOUSE_DOWN) {
                
                // if mousedrag is true then user can click and drag canvas, only used if zoomed in on canvas.
                if (_mouseDrag) {
                    
                    container.startDrag(false, new Rectangle(-(container.width - _canvasWidth), -(container.height - _canvasHeight), (container.width - _canvasWidth), (container.height - _canvasHeight)));
                    stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler, false, 0, true);
                    stage.addEventListener(MouseEvent.MOUSE_MOVE, dragEventUpdater, false, 0, true);
                }
                else {
                    
                    ////////////////////////////////////////////////////////////////////
                    // Adjust drawing layer depth based on Layer being drawing to
                    ////////////////////////////////////////////////////////////////////
                    if (_tool.layerType == LayerType.OBJECT_LAYER) {
                        container.setChildIndex(drawing_layer, container.numChildren - 1);
                    }
                    else {
                        container.setChildIndex(drawing_layer, 2);
                    }  ////////////////////////////////////////////////////////////////////    // Start Tool Operations    ////////////////////////////////////////////////////////////////////  
                    
                    
                    
                    
                    
                    
                    
                    if (_tool.renderType == ToolRenderType.SINGLE_CLICK || Std.is(_tool, SelectionTool)) {
                        
                        if (Std.is(_tool, FillBucketTool)) {
                            
                            fill(new Point(container.mouseX, container.mouseY), cast((_tool), FillBucketTool).fillColor, cast((_tool), FillBucketTool).useEntireCanvas, cast((_tool), FillBucketTool).useAdvancedFill, cast((_tool), FillBucketTool).smoothStrength);
                        }
                        else {
                            
                            // Get any objects under the mouse position.
                            var objs : Array<GraffitiObject> = getGraffitiObjectsAtPoint(new Point(object_layer.mouseX, object_layer.mouseY));
                            var selectedObjects : Array<GraffitiObject>;
                            var text : TextObject;
                            
                            // if no objects where click on...
                            if (objs.length == 0) {
                                
                                if (Std.is(_tool, TextTool)) {
                                    
                                    if (_objectManager.areObjectsSelected()) {
                                        
                                        _objectManager.deselectAll();
                                    }
                                    else {
                                        
                                        text = new TextObject(cast((_tool), TextTool).textSettings);
                                        text.x = container.mouseX;
                                        text.y = container.mouseY - (text.height / 2);
                                        object_layer.addChild(text);
                                        text.editing = true;
                                        
                                        _objectManager.deselectAll();
                                        _objectManager.addObject(text);
                                        
                                        // set the object as selection
                                        selectedObjects = new Array<GraffitiObject>();
                                        selectedObjects.push(text);
                                        
                                        _objectManager.addToSelection(text);
                                    }
                                }
                                // determine what was clicked on
                                else if (Std.is(_tool, SelectionTool)) {
                                    
                                    cast((_tool), SelectionTool).startSelectionPoint = new Point(container.mouseX, container.mouseY);
                                    stage.addEventListener(MouseEvent.MOUSE_MOVE, draw, false, 0, true);
                                    stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler, false, 0, true);
                                }
                            }
                            else {
                                
                                if (Std.is(_tool, TextTool)) {
                                    
                                    // get Text Reference
                                    if (Std.is(e.target, TextField)) {
                                        text = cast((e.target.parent), TextObject);
                                    }
                                    else {
                                        text = cast((e.target), TextObject);
                                    }
                                    
                                    if (!text.editing) {
                                        
                                        selectedObjects = new Array<GraffitiObject>();
                                        selectedObjects.push(text);
                                        
                                        _objectManager.setSelection(selectedObjects);
                                        
                                        text.editing = true;
                                    }
                                }
                                else if (Std.is(_tool, SelectionTool)) {
                                    
                                    cast((_tool), SelectionTool).startSelectionPoint = null;
                                    
                                    // pick the top object (highest depth)
                                    var go : GraffitiObject = objs[objs.length - 1];
                                    
                                    if (e.shiftKey) {
                                        
                                        if (go.selected) {
                                            _objectManager.removeFromSelection(go);
                                        }
                                        else {
                                            _objectManager.addToSelection(go);
                                        }
                                    }
                                    else {
                                        
                                        if (!go.selected) {
                                            _objectManager.deselectAll();
                                        }
                                        
                                        _objectManager.addToSelection(go);
                                        
                                        if (!go.editing) {
                                            //go.startDrag();
                                            _lastMousePosition.x = object_layer.mouseX;
                                            _lastMousePosition.y = object_layer.mouseY;
                                            stage.addEventListener(MouseEvent.MOUSE_MOVE, moveObjectHandler, false, 0, true);
                                        }
                                    }
                                }
                                
                                stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler, false, 0, true);
                            }
                        }
                    }
                    else {
                        
                        // select all if this tool draw to the object layer
                        if (_tool.layerType == LayerType.OBJECT_LAYER) {
                            _objectManager.deselectAll();
                        }
                        
                        if (_tool.renderType == ToolRenderType.CLICK_DRAG) {
                            _prevPoint = new Point(container.mouseX, container.mouseY);
                        }
                        
                        stage.addEventListener(MouseEvent.MOUSE_MOVE, draw, false, 0, true);
                        draw();
                        
                        stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler, false, 0, true);
                    }
                }
            }
            else if (e.type == MouseEvent.MOUSE_UP) {
                
                stopDrag();
                
                if (Std.is(_tool, SelectionTool)) {
                    
                    // if selection rectangle is not null then set selection by the rectangle
                    if (cast((_tool), SelectionTool).selectionRectangle != null) {
                        
                        // clean up
                        stage.removeEventListener(MouseEvent.MOUSE_MOVE, draw);
                        drawing_layer.graphics.clear();
                        
                        // store last point.
                        cast((_tool), SelectionTool).endSelectionPoint = new Point(container.mouseX, container.mouseY);
                        
                        // set selection by rectangle
                        _objectManager.setSelectionByRectangle(cast((_tool), SelectionTool).selectionRectangle);
                    }
                    else {
                        
                        stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveObjectHandler);
                    }  // prevPoint will be defined if in drawing mode  
                }
                // remove mouse up event
                else if (_prevPoint != null) {
                    
                    // if filters are present, this is a blur on a brush
                    // need to divide the blur value by zoom for better effect.
                    if (drawing_layer.filters.length > 0) {
                        var modBrushBlur : Float = cast((_tool), BrushTool).blur / _zoom;
                        drawing_layer.filters = [new BlurFilter(modBrushBlur, modBrushBlur, 2)];
                    }  // draw to object layer  
                    
                    
                    
                    if (_tool.layerType == LayerType.OBJECT_LAYER) {
                        
                        if (Std.is(_tool, BrushTool)) {
                            
                            var brushDef : BrushDefinition = cast((_tool), BrushTool).getBrushDefinition();
                            
                            var brushObject : BrushObject = new BrushObject(brushDef);
                            brushObject.name = "brush_object_" + Std.string(Date.now().getTime());
                            object_layer.addChild(brushObject);
                            brushObject.x = brushDef.position.x;
                            brushObject.y = brushDef.position.y;
                            
                            _objectManager.deselectAll();
                            _objectManager.addObject(brushObject);
                            
                            // set the object as selection
                            selectedObjects = new Array<GraffitiObject>();
                            selectedObjects.push(brushObject);
                        }
                        else if (Std.is(_tool, ShapeTool)) {
                            
                            var shapeDef : ShapeDefinition = cast((_tool), ShapeTool).getShapeDefinition();
                            
                            if (shapeDef != null) {
                                
                                var shapeObject : ShapeObject = new ShapeObject(shapeDef);
                                
                                shapeObject.name = "shape_object_" + Std.string(Date.now().getTime());
                                object_layer.addChild(shapeObject);
                                shapeObject.x = shapeDef.position.x;
                                shapeObject.y = shapeDef.position.y;
                                
                                _objectManager.deselectAll();
                                _objectManager.addObject(shapeObject);
                                
                                // set the object as selection
                                selectedObjects = new Array<GraffitiObject>();
                                selectedObjects.push(shapeObject);
                            }
                        }
                        else if (Std.is(_tool, LineTool)) {
                            
                            var lineDef : LineDefinition = cast((_tool), LineTool).getLineDefinition();
                            
                            if (lineDef != null) {
                                
                                var lineObject : LineObject = new LineObject(lineDef);
                                
                                // add line object to object layer
                                lineObject.name = "line_object_" + Std.string(Date.now().getTime());
                                object_layer.addChild(lineObject);
                                lineObject.x = lineDef.position.x;
                                lineObject.y = lineDef.position.y;
                                
                                _objectManager.deselectAll();
                                _objectManager.addObject(lineObject);
                                
                                // set the object as selection
                                selectedObjects = new Array<GraffitiObject>();
                                selectedObjects.push(lineObject);
                            }
                        }
                        
                        if (selectedObjects != null) {
                            _objectManager.setSelection(selectedObjects);
                        }

						// draw to bitmap  
                    }
                    else {
                        _bmp.draw(drawing_layer, new Matrix(), null, cast((_tool), BitmapTool).mode);
                    }

					// clear vectors from drawing space  
                    drawing_layer.graphics.clear();
                    
                    // reset tool data
                    cast((_tool), BitmapTool).resetTool();
                    
                    // clear filters if they exist
                    if (drawing_layer.filters.length > 0) {
                        drawing_layer.filters = [];
                    } 

					// record to history if one is being recorded  
                    if (_maxHistoryLength != 0) {
                        writeToHistory();
                    }


					// clear prev point  
                    _prevPoint = null;
                    
                    // remove drawing event
                    stage.removeEventListener(MouseEvent.MOUSE_MOVE, draw);
                }
                else {
                    // remove drag event dispatcher
                    stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragEventUpdater);
                }
                
				// remove mouse up event
                stage.removeEventListener(MouseEvent.MOUSE_UP, mouseHandler);
            }
        }
    }
    
    /**************************************************************************
			Method	: moveObjectHandler()
			
			Purpose	: This method will move all selected objects based on the
					  distance of the previous mouse movement.
			
			Params	: e -- MouseEvent object.
		***************************************************************************/
    private function moveObjectHandler(e : MouseEvent) : Void{
        
        _objectManager.moveSelectedObjects(object_layer.mouseX - _lastMousePosition.x, object_layer.mouseY - _lastMousePosition.y);
        
        _lastMousePosition.x = object_layer.mouseX;
        _lastMousePosition.y = object_layer.mouseY;
    }
    
    /**************************************************************************
			Method	: dragEventUpdater()
			
			Purpose	: This method will dispatch the DRAG event for the canvas.
			
			Params	: e -- MouseEvent object.
		***************************************************************************/
    private function dragEventUpdater(e : MouseEvent) : Void{
        
        // dispatch zoom event
        dispatchEvent(new CanvasEvent(CanvasEvent.DRAG, _zoom, _canvasWidth, _canvasHeight, getViewableRect()));
    }
    
    /**************************************************************************
			Method	: draw()
			
			Purpose	: This method will draw a new line.
			
			Params	: e -- MouseEvent object that can be null.
		***************************************************************************/
    private function draw(e : MouseEvent = null) : Void{
        
        if (Std.is(_tool, SelectionTool)) {
            
            cast((_tool), SelectionTool).endSelectionPoint = new Point(container.mouseX, container.mouseY);
            var selectionRectangle : Rectangle = cast((_tool), SelectionTool).selectionRectangle;
            
            drawing_layer.graphics.clear();
            drawing_layer.graphics.lineStyle(1, 0xFF0000, 1, true, LineScaleMode.NORMAL, CapsStyle.SQUARE, JointStyle.MITER);
            drawing_layer.graphics.drawRect(selectionRectangle.x, selectionRectangle.y, selectionRectangle.width, selectionRectangle.height);
        }
        else {
            
            var toolRef : BitmapTool = cast((_tool), BitmapTool);
            var nextPoint : Point = new Point(container.mouseX, container.mouseY);
            
            if (toolRef.renderType == ToolRenderType.CLICK_DRAG) {
                // clear vectors from drawing space
                drawing_layer.graphics.clear();
            }
            
            if (_prevPoint == null) {
                
                // apply tool
                toolRef.apply(drawing_layer, nextPoint);
            }
            else {
                
                ///////////////////////////////////////////////////////
                // Check to see if SHIFT is down to enforce limits
                // on the Line or Shape tools.
                ///////////////////////////////////////////////////////
                if (Std.is(toolRef, LineTool) && e != null) {
                    
                    // if shift then limit line to 90 degree angles
                    if (e.shiftKey) {
                        
                        // calculate abs x and y difference values
                        var xDiff : Float = nextPoint.x - _prevPoint.x;
                        var yDiff : Float = nextPoint.y - _prevPoint.y;
                        var absXDiff : Float = (xDiff > 0.0) ? xDiff : -xDiff;
                        var absYDiff : Float = (yDiff > 0.0) ? yDiff : -yDiff;
                        
                        // lock to 45, 135, 225, or 295 angle
                        if (xDiff > yDiff * .5 && xDiff * .5 < yDiff) {
                            
                            // take the lowest diff as the value to use
                            var finalOffSet : Float = (xDiff < yDiff) ? xDiff : yDiff;
                            
                            // determine the new x & y values to give us a 45 degree angle value
                            var xDiffRaw : Float = nextPoint.x - _prevPoint.x;
                            var yDiffRaw : Float = nextPoint.y - _prevPoint.y;
                            var xOffSet : Float = (xDiffRaw < 0) ? -finalOffSet : finalOffSet;
                            var yOffSet : Float = (yDiffRaw < 0) ? -finalOffSet : finalOffSet;
                            
                            // update next point to be on a 45 degree angle
                            nextPoint.x = _prevPoint.x + xOffSet;
                            nextPoint.y = _prevPoint.y + yOffSet;
                        }
						// lock line to 0 or 180 angle
                        else if (absXDiff < absYDiff) {
                            nextPoint.x = _prevPoint.x;
                        }
						// lock line to 90 or 270 angle
                        else {
                            nextPoint.y = _prevPoint.y;
                        }
                    }
                }
                else if (Std.is(toolRef, ShapeTool) && e != null) {
                    
                    // if shift then make RECTANGLE -> SQUARE or OVAL -> CIRCLE
                    if (e.shiftKey) {
                        
                        if (toolRef.type == ShapeType.OVAL) {
                            toolRef.type = ShapeType.CIRCLE;
                        }
                        else if (toolRef.type == ShapeType.RECTANGLE) {
                            toolRef.type = ShapeType.SQUARE;
                        }
                        
                        // set flag
                        _shiftKeyWasDown = true;
                    }
                    else {
                        
                        if (_shiftKeyWasDown) {
                            
                            // reset flag
                            _shiftKeyWasDown = false;
                            
                            // check to see if we need to switch shapes back
                            if (toolRef.type == ShapeType.CIRCLE) {
                                toolRef.type = ShapeType.OVAL;
                            }
                            else if (toolRef.type == ShapeType.SQUARE) {
                                toolRef.type = ShapeType.RECTANGLE;
                            }
                        }
                    }
                }
                
                // apply tool
                toolRef.apply(drawing_layer, _prevPoint, nextPoint);
            } 

			// if render type is continuous then write image to  
            if (_tool.renderType == ToolRenderType.CONTINUOUS) {
                
                // store prev point for next time
                _prevPoint = new Point(nextPoint.x, nextPoint.y);
                
                // erase modes need to be draw here and not on mouse up.
                if (toolRef.mode == ToolMode.ERASE) {
                    
                    // draw to bitmap
                    _bmp.draw(drawing_layer, new Matrix(), null, toolRef.mode);
                    
                    // clear vectors from drawing space
                    drawing_layer.graphics.clear();
                    
                    // clear objects
                    eraseObjectsAtPoint(nextPoint);
                    
                    // reset tool data
                    toolRef.resetTool();
                }
            }
        }

		// force screen update if event object is defined  
        if (e != null) {
            e.updateAfterEvent();
        }
    }
    
    private function eraseObjectsAtPoint(point : Point) : Void{
        
        _objectManager.setSelection(getGraffitiObjectsAtPoint(point));
        _objectManager.deleteSelected();
    }
}




class CanvasHistoryPoint
{
    public var bitmapData(get, never) : BitmapData;
    public var objectData(get, never) : Xml;

    
    private var _bitmapData : BitmapData;
    private var _objectData : Xml;
    
    public function new(bitmapData : BitmapData, objectData : Xml)
    {
        
        this._bitmapData = bitmapData;
        this._objectData = objectData;
    }
    
    private function get_bitmapData() : BitmapData{
        return _bitmapData;
    }
    
    private function get_objectData() : Xml{
        return _objectData;
    }
    
    public function dispose() : Void{
        
        _bitmapData.dispose();
        //System.disposeXML(_objectData);
    }
}