package jui.org
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import jui.org.events.ReleaseEvent;
	
	import jutils.org.util.DepthUtil;
	import jutils.org.util.DisposeUtil;
	
	[Event(name="release", type="jui.org.events.ReleaseEvent")]
	
	[Event(name="releaseOutSide", type="jui.org.events.ReleaseEvent")]
	
	public class JSprite extends Sprite implements IDispose
	{
		private var pressedTarget:DisplayObject;
		
		private var bounds:IntRectangle;
		
		private var foregroundChild:DisplayObject;
		private var backgroundChild:DisplayObject;
		
		protected var content:DisplayObjectContainer;
		
		public function JSprite()
		{
			super();
			
			init();
			initEvent();
		}
		
		
		
		
		//================================================================================================
		/*
		* 初始化函数
		*/
		//================================================================================================
		
		protected function init():void
		{
			bounds = new IntRectangle();
			
			content = new Sprite();
			addChild(content);
		}
		
		protected function uninit():void
		{
			pressedTarget = null;
			
			DisposeUtil.free(content);
			content = null;
		}
		
		protected function initEvent():void
		{
			addEventListener(MouseEvent.MOUSE_DOWN, __mouseDownHandler);
		}
		
		protected function removeEvent():void
		{
			if(stage) stage.removeEventListener(MouseEvent.MOUSE_UP, __mouseUpHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE, __removeFromStageHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN, __mouseDownHandler);
		}
		
		
		
		
		
		
		//================================================================================================
		/*
		* ReleaseEvent事件检测处理
		*/
		//================================================================================================
		
		private function __mouseDownHandler(e:MouseEvent):void
		{
			pressedTarget = e.target as DisplayObject;
			
			if(stage)
			{
				stage.addEventListener(MouseEvent.MOUSE_UP, __mouseUpHandler, false, 0, true);
				addEventListener(Event.REMOVED_FROM_STAGE, __removeFromStageHandler);
			}
		}
		
		private function __mouseUpHandler(e:MouseEvent):void
		{
			if(stage) stage.removeEventListener(MouseEvent.MOUSE_UP, __mouseUpHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE, __removeFromStageHandler);
			
			var isOutSide:Boolean = false;
			var target:DisplayObject = e.target as DisplayObject;
			
			if(!(this == target || JUtil.isAncestorDisplayObject(this, target)))
			{
				isOutSide = true;
			}
			
			dispatchEvent(new ReleaseEvent(ReleaseEvent.RELEASE, isOutSide));
			
			if(isOutSide)
			{
				dispatchEvent(new ReleaseEvent(ReleaseEvent.RELEASE_OUT_SIDE, isOutSide));
			}
		}
		
		private function __removeFromStageHandler(e:Event):void
		{
			if(stage) stage.removeEventListener(MouseEvent.MOUSE_UP, __mouseUpHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE, __removeFromStageHandler);
			
			pressedTarget = null;
		}
		
		
		
		
		
		//================================================================================================
		/*
		* 自定义辅助方法
		*/
		//================================================================================================
		
		public function getHighestIndex():int
		{
			if(foregroundChild == null) return numChildren;
			else return numChildren - 1;
		}
		
		public function getLowestIndex():int
		{
			if(backgroundChild == null) return 0;
			else return 1;
		}
		
		public function bringToTop(child:DisplayObject):void
		{
			if(child.parent == content && child != backgroundChild && child != foregroundChild)
			{
				DepthUtil.bringToTop(child);
				DepthUtil.bringToTop(foregroundChild);
			}
		}
		
		public function bringToBottom(child:DisplayObject):void
		{
			if(child.parent == content && child != backgroundChild && child != foregroundChild)
			{
				DepthUtil.bringToBottom(child);
				DepthUtil.bringToBottom(backgroundChild);
			}
		}
		
		
		
		
		
		//================================================================================================
		/*
		* 前景和背景设置
		*/
		//================================================================================================
		
		public function setForegroundChild(disChild:DisplayObject):void
		{
			if(foregroundChild != disChild)
			{
				DisposeUtil.free(foregroundChild);
				
				foregroundChild = disChild;
				
				if(disChild) addChild(disChild);
			}
		}
		
		public function setBackgroundChild(disChild:DisplayObject):void
		{
			if(backgroundChild != disChild)
			{
				DisposeUtil.free(backgroundChild);
				
				backgroundChild = disChild;
				
				if(disChild) addChild(disChild);
			}
		}
		
		
		
		
		
		
		
		
		//================================================================================================
		/*
		* 覆盖显示对象的方法
		*/
		//================================================================================================
		
		override public function get numChildren():int
		{
			return content.numChildren;
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			content.addChild(child);
			
			DepthUtil.bringToTop(foregroundChild);
			DepthUtil.bringToBottom(backgroundChild);
			
			return child;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return content.addChildAt(child, index);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			return content.removeChild(child);
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			return content.removeChildAt(index);
		}
		
		override public function getChildAt(index:int):DisplayObject
		{
			return content.getChildAt(index);
		}
		
		override public function getChildIndex(child:DisplayObject):int
		{
			return content.getChildIndex(child);
		}
		
		override public function setChildIndex(child:DisplayObject, index:int):void
		{
			return content.setChildIndex(child, index);
		}
		
		override public function getChildByName(name:String):DisplayObject
		{
			return content.getChildByName(name);
		}
		
		override public function contains(child:DisplayObject):Boolean
		{
			return content.contains(child);
		}
		
		override public function swapChildren(child1:DisplayObject, child2:DisplayObject):void
		{
			content.swapChildren(child1, child2);
		}
		
		override public function swapChildrenAt(index1:int, index2:int):void
		{
			content.swapChildrenAt(index1, index2);
		}
		
		override public function get x():Number
		{
			return bounds.x;
		}
		
		override public function set x(value:Number):void
		{
			bounds.x = value;
			super.x = bounds.x;
		}
		
		override public function get y():Number
		{
			return bounds.y;
		}
		
		override public function set y(value:Number):void
		{
			bounds.y = value;
			super.y = bounds.y;
		}
		
		override public function get width():Number
		{
			return bounds.width;
		}
		
		override public function set width(value:Number):void
		{
			setSizeWH(value, height);
		}
		
		override public function get height():Number
		{
			return bounds.height;
		}
		
		override public function set height(value:Number):void
		{
			setSizeWH(width, value);
		}
		
		public function setSizeWH(w:int, h:int):void
		{
			bounds.width = w;
			bounds.height = h;
		}
		
		
		
		//================================================================================================
		/*
		* 
		*/
		//================================================================================================
		
		
		
		
		
		
		//================================================================================================
		/*
		* 内存释放方法，IDispose接口
		*/
		//================================================================================================
		
		public function dispose():void
		{
			removeEvent();
			
			uninit();
		}
	}
}