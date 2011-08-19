package jui.org
{
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	import jui.org.events.ClickCountEvent;
	import jui.org.events.JEvent;
	
	[Event(name="shown", type="jui.org.events.JEvent")]
	[Event(name="hidden", type="jui.org.events.JEvent")]
	[Event(name="clickCount", type="jui.org.events.ClickCountEvent")]
	public class Component extends JSprite
	{
		public static const MAX_CLICK_INTERVAL:int = 400;
		
		protected var bounds:IntRectangle;
		
		public function Component()
		{
			super();
			
			bounds = new IntRectangle();
			
			addEventListener(MouseEvent.CLICK, __mouseClickHandler);
		}
		
		
		
		
		
		public function setAlpha(alpha:Number):void
		{
			this.alpha = alpha;
		}
		
		public function getAlpha():Number
		{
			return alpha;
		}
		
		public function getMousePosition():IntPoint
		{
			return new IntPoint(mouseX, mouseY);
		}
		
		protected function set d_visible(value:Boolean):void
		{
			super.visible = value;
		}
		
		protected function get d_visible():Boolean
		{
			return super.visible;
		}
		
		override public function set visible(value:Boolean):void
		{
			setVisible(value);
		}
		
		public function setVisible(v:Boolean):void
		{
			if(v != d_visible)
			{
				d_visible = v;
				
				if(v)
				{
					dispatchEvent(new JEvent(JEvent.SHOWN));
				}
				else
				{
					dispatchEvent(new JEvent(JEvent.HIDDEN));
				}
			}
		}
		
		
		
		private var lastClickTime:int;
		private var _lastClickPoint:IntPoint;
		private var clickCount:int;
		protected function __mouseClickHandler(e:MouseEvent):void
		{
			var time:int = getTimer();
			
			var mousePoint:IntPoint = new IntPoint(StageRef.mouseX, StageRef.mouseY);
			
			if(mousePoint.equals(_lastClickPoint) && ((time - lastClickTime) < MAX_CLICK_INTERVAL))
			{
				clickCount++;
			}
			else
			{
				clickCount = 1;
			}
			
			lastClickTime = time;
			dispatchEvent(new ClickCountEvent(ClickCountEvent.CLICK_COUNT, clickCount));
			_lastClickPoint = mousePoint;
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			removeEventListener(MouseEvent.CLICK, __mouseClickHandler);
		}
	}
}