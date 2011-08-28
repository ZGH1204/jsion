package jcomponent.org.coms.buttons
{
	import flash.display.DisplayObject;
	
	import jcomponent.org.basic.BasicGroundDecorator;
	import jcomponent.org.basic.Component;
	import jcomponent.org.basic.IComponentUI;
	
	import jutils.org.util.DisposeUtil;
	
	public class ButtonImageBackground extends BasicGroundDecorator
	{
		private var stateView:ButtonStateView;
		
		private var setuped:Boolean;
		
		public function ButtonImageBackground()
		{
			setuped = false;
			stateView = new ButtonStateView();
		}
		
		protected function setup(ui:IComponentUI):void
		{
			setuped = true;
			
			//TODO: 取得UI图片资源
		}
		
		override public function updateDecorator(component:Component, ui:IComponentUI, bounds:IntRectangle):void
		{
			if(!setuped) setup(ui);
			
			var btn:AbstractButton = component as AbstractButton;
			
			var model:DefaultButtonModel = btn.model;
			
			stateView.enabled = model.enabled;
			stateView.downed = model.pressed;
			stateView.selected = model.selected;
			stateView.overed = model.rollOver;
			stateView.defaulted = true;
			
			updateState(bounds);
		}
		
		protected function updateState(bounds:IntRectangle):void
		{
			stateView.update(null);
		}
		
		override public function getDisplay(component:Component):DisplayObject
		{
			return stateView;
		}
		
		override public function dispose():void
		{
			DisposeUtil.free(stateView);
			stateView = null;
			
			super.dispose();
		}
	}
}