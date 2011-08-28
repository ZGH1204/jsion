package jcomponent.org.basic
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import jcomponent.org.events.ReleaseEvent;
	
	public class JSprite extends Sprite implements IDispose
	{
		public function JSprite()
		{
			super();
			
			addEventListener(MouseEvent.MOUSE_DOWN, __jSpriteMouseDownListener);
		}
		
		
		private var pressedTarget:DisplayObject;
		
		private function __jSpriteMouseDownListener(e:MouseEvent):void
		{
			pressedTarget = e.target as DisplayObject;
			
			if(stage)
			{
				stage.addEventListener(MouseEvent.MOUSE_UP, __jStageMouseUpListener, false, 0, true);
				addEventListener(Event.REMOVED_FROM_STAGE, __jStageRemovedFrom);
			}
		}
		
		private function __jStageMouseUpListener(e:MouseEvent):void
		{
			if(stage) stage.removeEventListener(MouseEvent.MOUSE_UP, __jStageMouseUpListener);
			
			var isOutSide:Boolean = false;
			var target:DisplayObject = e.target as DisplayObject;
			
			if(!(this == target || JUtil.isAncestorDisplayObject(this, target)))
			{
				isOutSide = true;
			}
			
			dispatchEvent(new ReleaseEvent(ReleaseEvent.RELEASE, isOutSide, e));
			
			if(isOutSide)
			{
				dispatchEvent(new ReleaseEvent(ReleaseEvent.RELEASE_OUT_SIDE, isOutSide, e));
			}
			
			pressedTarget = null;
		}
		
		private function __jStageRemovedFrom(e:Event):void
		{
			pressedTarget = null;
			if(stage) stage.removeEventListener(MouseEvent.MOUSE_UP, __jStageMouseUpListener);
		}
		
		public function dispose():void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, __jStageRemovedFrom);
			
			pressedTarget = null;
		}
	}
}