package jui.org
{
	import flash.events.Event;
	
	import jutils.org.util.InstanceUtil;

	public class RepaintMgr
	{
		private var validating:Boolean;
		private var waitingRender:Boolean;
		private var validates:HashSet;
		private var repaints:HashSet;
		
		public function RepaintMgr()
		{
			validates = new HashSet();
			repaints = new HashSet();
		}
		
		public function addRepaint(component:Component):void
		{
			repaints.add(component);
			
			if(validating) return;
			
			renderLater();
		}
		
		public function addValidate(component:Component):void
		{
			var root:Component = component.getParentRoot();
			
			if(root == null) return;
			
			addValidateRoot(root);
		}
		
		public function addValidateRoot(component:Component):void
		{
			validates.add(component);
			
			renderLater();
		}
		
		private function renderLater():void
		{
			if(waitingRender) return;
			StageRef.addEventListener(Event.RENDER, __renderHandler);
			StageRef.invalidate();
			waitingRender = true;
		}
		
		private function __renderHandler(e:Event):void
		{
			StageRef.removeEventListener(Event.RENDER, __renderHandler);
			
			var component:Component;
			var components:Array;
			
			components = validates.toArray();
			validates.clear();
			
			validating = true;
			waitingRender = false;
			
			while(components.length > 0)
			{
				component = components.shift() as Component;
				
				try
				{
					component.validate();
				}
				catch(err:Error)
				{
					trace(err.getStackTrace());
				}
			}
			
			validating = false;
			
			
			components = repaints.toArray();
			repaints.clear();
			
			while(components.length > 0)
			{
				component = components.shift() as Component;
				
				try
				{
					component.paintComponent();
				}
				catch(err:Error)
				{
					trace(err.getStackTrace());
				}
			}
			
			GC.collect();
		}
		
		public static function get Instance():RepaintMgr
		{
			return InstanceUtil.createSingletion(RepaintMgr);
		}
	}
}