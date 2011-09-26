package jsion.ui
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import jsion.ui.events.ReleaseEvent;
	
	public class JSprite extends Sprite implements IDispose
	{
		public function JSprite()
		{
			super();
			
			addEventListener(MouseEvent.CLICK, __clickHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, __jSpriteMouseDownListener);
		}
		
		public function isOnStage():Boolean
		{
			return stage != null;
		}
		
		public function isShowing():Boolean
		{
			return isOnStage() && visible;
		}
		
		
		private var m_stopPropagation:Boolean = false;
		
		public function get stopPropagation():Boolean
		{
			return m_stopPropagation;
		}
		
		public function set stopPropagation(value:Boolean):void
		{
			m_stopPropagation = value;
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
			
			if(!(this == target || UIUtil.isAncestorDisplayObject(this, target)))
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
		
		private function __clickHandler(e:MouseEvent):void
		{
			if(m_stopPropagation) e.stopPropagation();
		}
		
		private function __jStageRemovedFrom(e:Event):void
		{
			pressedTarget = null;
			if(stage) stage.removeEventListener(MouseEvent.MOUSE_UP, __jStageMouseUpListener);
		}
		
		public function dispose():void
		{
			removeEventListener(MouseEvent.CLICK, __clickHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN, __jSpriteMouseDownListener);
			removeEventListener(Event.REMOVED_FROM_STAGE, __jStageRemovedFrom);
			StageRef.removeEventListener(MouseEvent.MOUSE_UP, __jStageMouseUpListener);
			
			pressedTarget = null;
		}
	}
}