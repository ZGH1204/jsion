package jcore.org.ddrop
{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;

	public interface IDragDrop extends IEventDispatcher
	{
		function get x():Number;
		function set x(value:Number):void;
		
		function get y():Number;
		function set y(value:Number):void;
		
		function localToGlobal(point:Point):Point;
		function globalToLocal(point:Point):Point;
		
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
		 * 手动时的显示对象
		 */		
		function get dragingIcon():DisplayObject;
		
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
		function dropHitCallback(dragger:Object, data:*):void;
	}
}