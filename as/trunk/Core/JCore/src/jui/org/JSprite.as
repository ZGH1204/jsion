package jui.org
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import jui.org.events.ReleaseEvent;
	
	import jutils.org.util.DisposeUtil;
	
	[Event(name="release", type="jui.org.events.ReleaseEvent")]
	
	[Event(name="releaseOutSide", type="jui.org.events.ReleaseEvent")]
	
	public class JSprite extends Sprite implements IDispose
	{
		protected var foregroundChild:DisplayObject;
		protected var backgroundChild:DisplayObject;
		
		protected var maskRect:IntRectangle;
		protected var maskShape:Shape;
		
		public function JSprite()
		{
			super();
			
			checkCreateMaskShape();
			
			setMasked();
			
			addEventListener(MouseEvent.MOUSE_DOWN, __jSpriteMouseDownListener);
		}
		
		
		
		
		
		
		private function checkCreateMaskShape():void
		{
			if(maskRect == null)
			{
				maskRect = new IntRectangle();
			}
			
			if(maskShape == null)
			{
				maskShape = new Shape();
				maskShape.graphics.beginFill(0);
				maskShape.graphics.drawRect(0, 0, 1, 1);
				maskShape.graphics.endFill();
			}
		}
		
		private function setMasked():void
		{
			if(maskShape.parent != this)
			{
				d_addChild(maskShape);
				mask = maskShape;
			}
			setMaskRect(maskRect);
		}
		
		public function setMaskRect(rect:IntRectangle):void
		{
			if(maskShape)
			{
				maskShape.x = rect.x;
				maskShape.y = rect.y;
				maskShape.width = rect.width;
				maskShape.height = rect.height;
			}
			
			maskRect.setRect(rect);
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		protected function d_addChild(child:DisplayObject):DisplayObject
		{
			
			return super.addChild(child);
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			if(child == null) return null;
			
			var dis:DisplayObject = d_addChild(child);
			if(foregroundChild) swapChildren(child, foregroundChild);
			return dis;
		}
		
		public function isChild(dis:DisplayObject):Boolean
		{
			return (dis && dis.parent == this);
		}
		
		protected function getForegroundChild():DisplayObject
		{
			return foregroundChild;
		}
		
		protected function setForegroundChild(child:DisplayObject = null):void
		{
			if(child != foregroundChild)
			{
				if(foregroundChild != null)
				{
					removeChild(foregroundChild);
				}
				
				foregroundChild = child;
				
				if(child != null)
				{
					addChild(child);
				}
			}
		}
		
		protected function getBackgroundChild():DisplayObject
		{
			return backgroundChild;
		}
		
		protected function setBackgroundChild(child:DisplayObject = null):void
		{
			if(child != backgroundChild)
			{
				if(backgroundChild != null)
				{
					removeChild(backgroundChild);
				}
				
				backgroundChild = child;
				
				if(child != null)
				{
					addChildAt(child, 0);
				}
			}
		}
		
		public function getHighestIndexUnderForeground():int
		{
			if(foregroundChild == null)
			{
				return numChildren;
			}
			else
			{
				return numChildren - 1;
			}
		}
		
		public function getLowestIndexAboveBackground():int
		{
			if(backgroundChild == null)
			{
				return 0;
			}
			else
			{
				return 1;
			}
		}
		
		public function bringToTopUnderForeground(child:DisplayObject):void
		{
			var index:int = numChildren - 1;
			
			if(foregroundChild && child != foregroundChild)
			{
				index = numChildren - 2;
			}
			
			setChildIndex(child, index);
		}
		
		public function bringToBottomAboveBackground(child:DisplayObject):void
		{
			var index:int = 0;
			
			if(backgroundChild && child != backgroundChild)
			{
				index = 1;
			}
			
			setChildIndex(child, index);
		}
		
		
		
		
		
		
		//=======================================
		/*
		* Dispatch ReleaseEvent.RELEASE | ReleaseEvent.RELEASE_OUT_SIDE event.
		*/
		//=======================================
		
		protected var pressedTarget:DisplayObject;
		
		protected function __jSpriteMouseDownListener(e:MouseEvent):void
		{
			pressedTarget = e.target as DisplayObject;
			
			if(stage)
			{
				stage.addEventListener(MouseEvent.MOUSE_UP, __jStageMouseUpHandler);
				addEventListener(Event.REMOVED_FROM_STAGE, __jStageRemoveFromHandler);
			}
		}
		
		protected function __jStageMouseUpHandler(e:MouseEvent):void
		{
			if(stage) stage.removeEventListener(MouseEvent.MOUSE_UP, __jStageMouseUpHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE, __jStageRemoveFromHandler);
			
			var isOutSide:Boolean = false;
			var target:DisplayObject = e.target as DisplayObject;
			
			if(!(this == target || JUtil.isAncestorDisplayObject(this, target)))
			{
				isOutSide = true;
			}
			
			dispatchEvent(new ReleaseEvent(ReleaseEvent.RELEASE, pressedTarget, isOutSide, e));
			
			if(isOutSide)
			{
				dispatchEvent(new ReleaseEvent(ReleaseEvent.RELEASE_OUT_SIDE, pressedTarget, isOutSide, e));
			}
			
			pressedTarget = null;
		}
		
		protected function __jStageRemoveFromHandler(e:Event):void
		{
			if(stage) stage.removeEventListener(MouseEvent.MOUSE_UP, __jStageMouseUpHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE, __jStageRemoveFromHandler);
			
			pressedTarget = null;
		}
		
		
		
		
		//=======================================
		/*
		* Implement IDispose interface.
		*/
		//=======================================
		
		public function dispose():void
		{
			if(stage) stage.removeEventListener(MouseEvent.MOUSE_UP, __jStageMouseUpHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN, __jSpriteMouseDownListener);
			removeEventListener(Event.REMOVED_FROM_STAGE, __jStageRemoveFromHandler);
			
			pressedTarget = null;
			
			DisposeUtil.free(foregroundChild);
			foregroundChild = null;
			
			DisposeUtil.free(backgroundChild);
			backgroundChild = null;
			
			maskRect = null;
			DisposeUtil.free(maskShape);
			maskShape = null;
		}
		
		override public function toString():String
		{
			var p:DisplayObject = this;
			var str:String = p.name;
			while(p.parent != null)
			{
				var name:String = (p.parent == p.stage ? "Stage" : p.parent.name);
				p = p.parent;
				str = name + "." + str;
			}
			return str;
		}
	}
}