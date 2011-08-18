package 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jcore.org.action.Action;
	import jcore.org.action.ActionLine;

	/**
	 * 舞台全局引用
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public class StageRef
	{
		private static var _stage:Stage;
		private static var _actionLine:ActionLine;
		
		public static function setup(stage:Stage):void
		{
			_stage = stage;
			
			_stage.stageFocusRect = false;
			_stage.align = StageAlign.TOP_LEFT;
			_stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_actionLine = new ActionLine(true);
		}
		
		public static function act(action:Action):void
		{
			_actionLine.act(action);
		}
		
		public static function get stageWidth():int
		{
			return _stage.stageWidth;
		}
		
		public static function get stageHeight():int
		{
			return _stage.stageHeight;
		}
		
		public static function get mouseX():Number
		{
			return _stage.mouseX;
		}
		
		public static function get mouseY():Number
		{
			return _stage.mouseY;
		}
		
		public static function getBounds(display:DisplayObject):Rectangle
		{
			return display.getBounds(_stage);
		}
		
		public static function getObjectsUnderPoint(point:Point):Array
		{
			return _stage.getObjectsUnderPoint(point);
		}
		
		public static function drawTo(bmd:BitmapData, dx:Number, dy:Number):void
		{
			var matrix:Matrix = new Matrix();
			matrix.translate(dx, dy);
			bmd.draw(_stage, matrix);
		}
		
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			_stage.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			_stage.removeEventListener(type, listener, useCapture);
		}
		
		public static function addChild(child:DisplayObject):DisplayObject
		{
			return _stage.addChild(child);
		}
		
		public static function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return _stage.addChildAt(child, index);
		}
		
		public static function removeChild(child:DisplayObject):DisplayObject
		{
			return _stage.removeChild(child);
		}
		
		public static function removeChildAt(index:int):DisplayObject
		{
			return _stage.removeChildAt(index);
		}
		
		public static function getChildIndex(child:DisplayObject):int
		{
			return _stage.getChildIndex(child);
		}
		
		public static function getChildAt(index:int):DisplayObject
		{
			return _stage.getChildAt(index);
		}
		
		public static function setChildAt(child:DisplayObject, index:int):void
		{
			_stage.setChildIndex(child, index);
		}
	}
}