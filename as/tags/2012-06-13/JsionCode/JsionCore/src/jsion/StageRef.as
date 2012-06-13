package jsion
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jsion.core.actions.*;
	

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
		
		/**
		 * 舞台对象
		 */		
		public static function get stage():Stage
		{
			return _stage;
		}
		
		/**
		 * 初始化安装
		 * @param stage 舞台对象
		 */		
		public static function setup(stage:Stage):void
		{
			_stage = stage;
			
			_stage.stageFocusRect = false;
			_stage.align = StageAlign.TOP_LEFT;
			_stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_actionLine = new ActionLine(true);
		}
		
		/**
		 * 插入Action动作对象
		 * @param action
		 */		
		public static function act(action:Action):void
		{
			_actionLine.act(action);
		}
		
		/**
		 * 当前帧率
		 */		
		public static function get fps():int
		{
			return _stage.frameRate;
		}
		
		/**
		 * 如果不能将焦点设置到目标，则会引发错误。
		 */		
		public static function get focus():InteractiveObject
		{
			return _stage.focus;
		}
		
		/**
		 * @private
		 * @param value
		 * 
		 */		
		public static function set focus(value:InteractiveObject):void
		{
			_stage.focus = value;
		}
		
		/**
		 * 舞台宽度
		 */		
		public static function get stageWidth():int
		{
			return _stage.stageWidth;
		}
		
		/**
		 * 舞台高度
		 */		
		public static function get stageHeight():int
		{
			return _stage.stageHeight;
		}
		
		/**
		 * 鼠标相对于舞台的X坐标
		 */		
		public static function get mouseX():Number
		{
			return _stage.mouseX;
		}
		
		/**
		 * 鼠标相对于舞台的Y坐标
		 */		
		public static function get mouseY():Number
		{
			return _stage.mouseY;
		}
		
		/**
		 * 强制FP在下次呈现时发送 render 事件
		 */		
		public static function invalidate():void
		{
			_stage.invalidate();
		}
		
		/**
		 * 获取指定显示对象相对于舞台的Rectangle范围
		 * @param display
		 */		
		public static function getBounds(display:DisplayObject):Rectangle
		{
			return display.getBounds(_stage);
		}
		
		/**
		 * 获取舞台中指定坐标下的所有显示对象
		 * @param point
		 */		
		public static function getObjectsUnderPoint(point:Point):Array
		{
			return _stage.getObjectsUnderPoint(point);
		}
		
		/**
		 * 舞台截图
		 * @param bmd
		 * @param dx
		 * @param dy
		 * 
		 */		
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
		
		/**
		 * 设置指定对象为当前焦点
		 * @param display
		 * 
		 */		
		public static function setFocus(display:InteractiveObject):void
		{
			_stage.focus = display;
		}
		
		/**
		 * 添加指定显示对象到舞台
		 * @param child 要添加的显示对象
		 */		
		public static function addChild(child:DisplayObject):DisplayObject
		{
			return _stage.addChild(child);
		}
		
		/**
		 * 将指定显示对象添加到舞台上，并设置为指定索引深度位置。
		 * @param child 要添加的显示对象
		 * @param index 要添加到的索引深度
		 */		
		public static function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return _stage.addChildAt(child, index);
		}
		
		/**
		 * 移除舞台的子显示对象
		 * @param child 要移除的显示对象
		 */		
		public static function removeChild(child:DisplayObject):DisplayObject
		{
			return _stage.removeChild(child);
		}
		
		/**
		 * 移除舞台上指定索引深度位置的子显示对象
		 * @param index 要移除的索引深度
		 * @return 移除的子显示对象
		 * 
		 */		
		public static function removeChildAt(index:int):DisplayObject
		{
			return _stage.removeChildAt(index);
		}
		
		/**
		 * 获取舞台中子显示对象的索引深度位置
		 * @param child 要获取索引尝试的子显示对象
		 * @return 索引深度
		 * 
		 */		
		public static function getChildIndex(child:DisplayObject):int
		{
			return _stage.getChildIndex(child);
		}
		
		/**
		 * 获取指定索引深度位置的子显示对象
		 * @param index
		 * @return 
		 * 
		 */		
		public static function getChildAt(index:int):DisplayObject
		{
			return _stage.getChildAt(index);
		}
		
		/**
		 * 设置舞台上指定的子显示对象的索引深度位置
		 * @param child 要设置索引深度位置的子显示对象
		 * @param index 要设置到的索引尝试位置
		 * 
		 */		
		public static function setChildAt(child:DisplayObject, index:int):void
		{
			_stage.setChildIndex(child, index);
		}
	}
}