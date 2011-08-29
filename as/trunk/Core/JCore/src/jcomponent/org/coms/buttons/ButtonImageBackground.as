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
		private var stateView:ButtonStateView;
		
		private var setuped:Boolean;
		
		public function ButtonImageBackground(freeBitmapData:Boolean = false)
		{
			setuped = false;
			stateView = new ButtonStateView(freeBitmapData);
			stateView.mouseEnabled = false;
		}
		
		public function setup(ui:IComponentUI):void
		{
			if(setuped) return;
			
			setuped = true;
			
			//TODO: 取得UI图片资源
			stateView.setUpImage(getAsset(ui, DefaultConfigKeys.BUTTON_UP_IMAGE, DefaultConfigKeys.BUTTON_UP_INSETS));
			stateView.setOverImage(getAsset(ui, DefaultConfigKeys.BUTTON_OVER_IMAGE, DefaultConfigKeys.BUTTON_OVER_INSETS));
			stateView.setDownImage(getAsset(ui, DefaultConfigKeys.BUTTON_DOWN_IMAGE, DefaultConfigKeys.BUTTON_DOWN_INSETS));
			stateView.setDisabledImage(getAsset(ui, DefaultConfigKeys.BUTTON_DISABLED_IMAGE, DefaultConfigKeys.BUTTON_DISABLED_INSETS));
			stateView.setSelectedImage(getAsset(ui, DefaultConfigKeys.BUTTON_SELECTED_IMAGE, DefaultConfigKeys.BUTTON_SELECTED_INSETS));
			stateView.setOverSelectedImage(getAsset(ui, DefaultConfigKeys.BUTTON_OVER_SELECTED_IMAGE, DefaultConfigKeys.BUTTON_OVER_SELECTED_INSETS));
			stateView.setDownSelectedImage(getAsset(ui, DefaultConfigKeys.BUTTON_DOWN_SELECTED_IMAGE, DefaultConfigKeys.BUTTON_DOWN_SELECTED_INSETS));
			stateView.setDisabledSelectedImage(getAsset(ui, DefaultConfigKeys.BUTTON_DISABLED_SELECTED_IMAGE, DefaultConfigKeys.BUTTON_DISABLED_SELECTED_INSETS));
		}
		
		protected function getAsset(ui:IComponentUI, extName:String, insetsName:String):DisplayObject
		{
			var pp:String = ui.getResourcesPrefix();
			
			return ui.getDisplayObject(pp + extName);
		}
		
		override public function updateDecorator(component:Component, ui:IComponentUI, bounds:IntRectangle):void
		{
			var btn:AbstractButton = component as AbstractButton;
			
			var model:DefaultButtonModel = btn.model;
			
			stateView.enabled = model.enabled;
			stateView.downed = model.pressed;
			stateView.selected = model.selected;
			stateView.overed = model.rollOver;
			
			stateView.update(bounds.getSize());
		}
		
		override public function getDisplay(component:Component):DisplayObject
		{
			return stateView;
		}
		
		public function getPreferredSize(component:Component):IntDimension
		{
			return stateView.getPreferredSize(component);
		}
		
		public function getMinimumSize(component:Component):IntDimension
		{
			return stateView.getMinimumSize(component);
		}
		
		public function getMaximumSize(component:Component):IntDimension
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