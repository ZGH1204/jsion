package jsion.core.ddrop
{
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public interface IDragDrop extends IEventDispatcher
	{
		function get x():Number;
		function set x(value:Number):void;
		
		function get y():Number;
		function set y(value:Number):void;
		
		function get width():Number;
		function get height():Number;
		
		function contains(child:DisplayObject):Boolean;
		
		function localToGlobal(point:Point):Point;
		function globalToLocal(point:Point):Point;
		
		/**
		 * 是否为鼠标点击时拖动,false表示鼠标按下时拖动.
		 */		
		function get isClickDrag():Boolean;
		
		/**
		 * 是否锁定到中心位置
		 */		
		function get lockCenter():Boolean;
		/** @private */
		function set lockCenter(value:Boolean):void;
		
		/**
		 * 拖动时传递的数据
		 */		
		function get transData():*;
		
		/**
		 * 当鼠标移出屏幕释放时是否修正拖动时的显示对象鼠标下的坐标到舞台内
		 * 以便下次可以拖动
		 */		
		function get reviseInStage():Boolean;
		
		/**
		 * 是否对拖动时的显示对象进行内存释放
		 */		
		function get freeDragingIcon():Boolean;
		
		/**
		 * 拖动时的显示对象
		 */		
		function get dragingIcon():DisplayObject;
		
		/**
		 * 组内除正在拖动对象外的所有对象在拖动对象释放后的回调
		 * @param dragger 拖动对象
		 * @param data 传递数据
		 * 
		 */		
		function groupDragCallback(dragger:IDragDrop, data:*):void;
		
		/**
		 * 组内除正在拖动对象外的所有对象在拖动对象开始拖动时的回调
		 * @param dragger 拖动对象
		 * @param data 传递数据
		 * 
		 */		
		function groupDropCallback(dragger:IDragDrop, data:*):void;
		
		/**
		 * 开始拖动时的回调
		 */		
		function startDragCallback():void;
		
		/**
		 * 拖动时的回调
		 */		
		function dragingCallback():void;
		
		/**
		 * 释放后的回调
		 */		
		function dropCallback():void;
		
		/**
		 * 拖动释放后被碰撞时的回调
		 * @param dragger 拖动对象
		 * @param data 传递数据
		 */		
		function dropHitCallback(dragger:IDragDrop, data:*):void;
	}
}