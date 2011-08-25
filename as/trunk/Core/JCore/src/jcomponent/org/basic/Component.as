package jcomponent.org.basic
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Component extends Sprite implements IDispose
	{
		private var m_enableCustomEvent:Boolean;
		
		private var m_bounds:IntRectangle;
		
		private var m_mask:Shape;
		
		private var m_ui:IComponentUI;
		
		private var m_waiteRender:Boolean;
		
		private var m_enabled:Boolean;
		
		public function Component()
		{
			m_bounds = new IntRectangle();
			
			m_mask = new Shape();
			m_mask.graphics.beginFill(0);
			m_mask.graphics.drawRect(0, 0, 1, 1);
			m_mask.graphics.endFill();
			
			enabled = true;
			
			addChild(m_mask);
			mask = m_mask;
			
			if(isOnStage())
			{
				initialize();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);
			}
		}
		
		private function __addToStageHandler(e:Event):void
		{
			initialize();
		}
		
		private function initialize():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);
			
			invalidate();
		}
		
		public function invalidate():void
		{
			if(stage && m_waiteRender)
			{
				stage.addEventListener(Event.RENDER, __renderHandler);
				stage.invalidate();
				m_waiteRender = true;
			}
		}
		
		private function __renderHandler(e:Event):void
		{
			stage.removeEventListener(Event.RENDER, __renderHandler);
			m_waiteRender = false;
			
			paint();
		}
		
		protected function paint():void
		{
			
		}
		
		public function get bounds():IntRectangle
		{
			return m_bounds;
		}
		
		public function set bounds(value:IntRectangle):void
		{
			if(m_bounds != value && value != null && !value.equals(m_bounds))
			{
				m_bounds = value;
			}
		}
		
		public function get UI():IComponentUI
		{
			return m_ui;
		}
		
		public function set UI(value:IComponentUI):void
		{
			if(m_ui != value)
			{
				if(m_ui) m_ui.uninstall(this);
				
				m_ui = value;
				
				if(m_ui) m_ui.install(this);
			}
		}
		
		public function get enabled():Boolean
		{
			return m_enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			m_enabled = value;
			
			if(m_enableCustomEvent)
			{
				super.mouseEnabled = false;
				super.mouseChildren = false;
			}
			else
			{
				super.mouseEnabled = value;
				super.mouseChildren = value;
			}
		}
		
		public function isOnStage():Boolean
		{
			return stage != null;
		}
		
		public function isShowing():Boolean
		{
			return isOnStage() && visible;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		override public function get mouseEnabled():Boolean
		{
			if(m_enableCustomEvent) return false;
			
			return super.mouseEnabled;
		}
		
		override public function set mouseEnabled(value:Boolean):void
		{
			if(m_enableCustomEvent) return;
			
			super.mouseEnabled = value;
		}
		
		override public function get mouseChildren():Boolean
		{
			if(m_enableCustomEvent) return false;
			
			return super.mouseChildren;
		}
		
		override public function set mouseChildren(value:Boolean):void
		{
			if(m_enableCustomEvent) return;
			
			super.mouseChildren = value;
		}
		
		private function get xPos():Number
		{
			return super.x;
		}
		
		private function set xPos(value:Number):void
		{
			super.x = value;
		}
		
		override public function get x():Number
		{
			return bounds.x;
		}
		
		override public function set x(value:Number):void
		{
			bounds.x = value;
			xPos = value;
		}
		
		private function get yPos():Number
		{
			return super.y;
		}
		
		private function set yPos(value:Number):void
		{
			super.y = value;
		}
		
		override public function get y():Number
		{
			return bounds.y;
		}
		
		override public function set y(value:Number):void
		{
			bounds.y;
			yPos = value;
		}
		
		public function setLocationXY(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
			bounds.x = x;
			bounds.y = y;
		}
		
		public function setLocation(pos:IntPoint):void
		{
			setLocationXY(pos.x, pos.y);
		}
		
		public function dispose():void
		{
			
		}
	}
}