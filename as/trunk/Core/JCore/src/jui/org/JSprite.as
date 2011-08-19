package jui.org
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import jui.org.events.ReleaseEvent;
	
	[Event(name="release", type="jui.org.events.ReleaseEvent")]
	
	[Event(name="releaseOutSide", type="jui.org.events.ReleaseEvent")]
	public class JSprite extends Sprite implements IDispose
	{
		protected var pressedTarget:DisplayObject;
		
		public function JSprite()
		{
			super();
			addEventListener(MouseEvent.MOUSE_DOWN, __jSpriteMouseDownListener);
		}
		
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
		
		public function dispose():void
		{
			if(stage) stage.removeEventListener(MouseEvent.MOUSE_UP, __jStageMouseUpHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN, __jSpriteMouseDownListener);
			removeEventListener(Event.REMOVED_FROM_STAGE, __jStageRemoveFromHandler);
			
			pressedTarget = null;
		}
	}
}