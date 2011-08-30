package jcomponent.org.coms.buttons
{
	import flash.display.DisplayObject;
	
	import jcomponent.org.basic.BasicGroundDecorator;
	import jcomponent.org.basic.Component;
	import jcomponent.org.basic.DefaultConfigKeys;
	import jcomponent.org.basic.IComponentUI;
	
	import jutils.org.util.DisposeUtil;
	
	public class ButtonImageBackground extends BasicGroundDecorator
	{
		protected var stateView:ButtonStateView;
		
		private var setuped:Boolean;
		
		public function ButtonImageBackground(freeBitmapData:Boolean = false)
		{
			setuped = false;
			
			init(freeBitmapData);
		}
		
		protected function init(freeBitmapData:Boolean):void
		{
			stateView = new ButtonStateView(freeBitmapData);
			stateView.mouseEnabled = false;
		}
		
		override public function getSize():IntDimension
		{
			return stateView.getSize();
		}
		
		override public function setLocation(x:int, y:int):void
		{
			stateView.x = x;
			stateView.y = y;
		}
		
		override public function setup(component:Component, ui:IComponentUI):void
		{
			if(setuped) return;
			
			setuped = true;
			
			//TODO: 取得UI图片资源
			stateView.setUpImage(getAsset(component, ui, DefaultConfigKeys.BUTTON_UP_IMAGE, DefaultConfigKeys.BUTTON_UP_INSETS));
			stateView.setOverImage(getAsset(component, ui, DefaultConfigKeys.BUTTON_OVER_IMAGE, DefaultConfigKeys.BUTTON_OVER_INSETS));
			stateView.setDownImage(getAsset(component, ui, DefaultConfigKeys.BUTTON_DOWN_IMAGE, DefaultConfigKeys.BUTTON_DOWN_INSETS));
			stateView.setDisabledImage(getAsset(component, ui, DefaultConfigKeys.BUTTON_DISABLED_IMAGE, DefaultConfigKeys.BUTTON_DISABLED_INSETS));
			stateView.setSelectedImage(getAsset(component, ui, DefaultConfigKeys.BUTTON_SELECTED_IMAGE, DefaultConfigKeys.BUTTON_SELECTED_INSETS));
			stateView.setOverSelectedImage(getAsset(component, ui, DefaultConfigKeys.BUTTON_OVER_SELECTED_IMAGE, DefaultConfigKeys.BUTTON_OVER_SELECTED_INSETS));
			stateView.setDownSelectedImage(getAsset(component, ui, DefaultConfigKeys.BUTTON_DOWN_SELECTED_IMAGE, DefaultConfigKeys.BUTTON_DOWN_SELECTED_INSETS));
			stateView.setDisabledSelectedImage(getAsset(component, ui, DefaultConfigKeys.BUTTON_DISABLED_SELECTED_IMAGE, DefaultConfigKeys.BUTTON_DISABLED_SELECTED_INSETS));
		}
		
		protected function getAsset(component:Component, ui:IComponentUI, extName:String, insetsName:String):DisplayObject
		{
			var pp:String = ui.getResourcesPrefix(component);
			
			return ui.getDisplayObject(pp + extName);
		}
		
		override public function updateDecorator(component:Component, ui:IComponentUI, bounds:IntRectangle):void
		{
			var btn:AbstractButton = component as AbstractButton;
			
			var model:IButtonModel = btn.model;
			
			stateView.enabled = model.enabled;
			stateView.downed = model.pressed;
			stateView.selected = model.selected;
			stateView.overed = model.rollOver;
			
			updateStateView(component, ui, bounds);
		}
		
		protected function updateStateView(component:Component, ui:IComponentUI, bounds:IntRectangle):void
		{
			var s:IntDimension = bounds.getSize();
			stateView.update(s);
			stateView.updateTrigger(s);
		}
		
		override public function getDisplay(component:Component):DisplayObject
		{
			return stateView;
		}
		
		override public function getPreferredSize(component:Component):IntDimension
		{
			return stateView.getPreferredSize(component);
		}
		
		override public function getMinimumSize(component:Component):IntDimension
		{
			return stateView.getMinimumSize(component);
		}
		
		override public function getMaximumSize(component:Component):IntDimension
		{
			return stateView.getMaximumSize(component);
		}
		
		override public function dispose():void
		{
			DisposeUtil.free(stateView);
			stateView = null;
			
			super.dispose();
		}
	}
}