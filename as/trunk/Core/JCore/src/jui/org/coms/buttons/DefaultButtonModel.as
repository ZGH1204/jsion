package jui.org.coms.buttons
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import jui.org.ButtonGroup;
	import jui.org.IButtonModel;
	import jui.org.events.InteractiveEvent;
	import jui.org.events.JEvent;
	
	public class DefaultButtonModel extends EventDispatcher implements IButtonModel
	{
		protected var group:ButtonGroup;
		protected var enabled:Boolean;
		protected var rollOver:Boolean;
		protected var armed:Boolean;
		protected var pressed:Boolean;
		protected var selected:Boolean;
		
		public function DefaultButtonModel()
		{
			enabled = true;
			rollOver = false;
			armed = false;
			pressed = false;
			selected = false;
		}
		
		public function addStateListener(listener:Function, priority:int=0, useWeakReference:Boolean=false):void
		{
			addEventListener(InteractiveEvent.STATE_CHANGED, listener, false, priority);
		}
		
		public function removeStateListener(listener:Function):void
		{
			removeEventListener(InteractiveEvent.STATE_CHANGED, listener);
		}
		
		public function addActionListener(listener:Function, priority:int=0, useWeakReference:Boolean=false):void
		{
			addEventListener(JEvent.ACT, listener, false, priority);
		}
		
		public function removeActionListener(listener:Function):void
		{
			removeEventListener(JEvent.ACT, listener);
		}
		
		public function addSelectionListener(listener:Function, priority:int=0, useWeakReference:Boolean=false):void
		{
			addEventListener(InteractiveEvent.SELECTION_CHANGED, listener, false, priority);
		}
		
		public function removeSelectionListener(listener:Function):void
		{
			removeEventListener(InteractiveEvent.SELECTION_CHANGED, listener);
		}
		
		public function isEnabled():Boolean
		{
			return enabled;
		}
		
		public function isRollOver():Boolean
		{
			return rollOver;
		}
		
		public function isArmed():Boolean
		{
			return armed;
		}
		
		public function isPressed():Boolean
		{
			return pressed;
		}
		
		public function isSelected():Boolean
		{
			return selected;
		}
		
		public function setEnabled(b:Boolean):void
		{
			if(isEnabled() == b)
			{
				return;
			}
			
			enabled = b;
			
			if (!b)
			{
				pressed = false;
				armed = false;
			}
			
			fireStateChanged();
		}
		
		public function setRollOver(b:Boolean):void
		{
			if((isRollOver() == b) || !isEnabled())
			{
				return;
			}
			
			rollOver = b;
			
			fireStateChanged();
		}
		
		public function setArmed(b:Boolean):void
		{
			if((isArmed() == b) || !isEnabled())
			{
				return;
			}
			
			armed = b;
			
			fireStateChanged();
		}
		
		public function setPressed(b:Boolean):void
		{
			if((isPressed() == b) || !isEnabled())
			{
				return;
			}
			
			pressed = b;
			
			if(!isPressed() && isArmed())
			{
				fireActionEvent();
			}
			
			fireStateChanged();
		}
		
		public function setSelected(b:Boolean):void
		{
			if (isSelected() == b)
			{
				return;
			}
			
			selected = b;
			
			fireStateChanged();
			
			fireSelectionChanged();
		}
		
		public function getGroup():ButtonGroup
		{
			return group;
		}
		
		public function setGroup(group:ButtonGroup):void
		{
			this.group = group;
		}
		
		protected function fireActionEvent():void
		{
			dispatchEvent(new JEvent(JEvent.ACT));
		}
		
		protected function fireStateChanged():void
		{
			dispatchEvent(new InteractiveEvent(InteractiveEvent.STATE_CHANGED));
		}
		
		protected function fireSelectionChanged():void
		{
			dispatchEvent(new InteractiveEvent(InteractiveEvent.SELECTION_CHANGED));
		}
	}
}