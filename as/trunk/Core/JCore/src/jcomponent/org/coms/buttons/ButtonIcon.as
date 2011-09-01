package jcomponent.org.coms.buttons
{
	import flash.display.DisplayObject;
	
	import jcomponent.org.basic.Component;
	import jcomponent.org.basic.DefaultConfigKeys;
	import jcomponent.org.basic.IComponentUI;
	import jcomponent.org.basic.IICON;
	
	import jutils.org.util.DisposeUtil;
	
	public class ButtonIcon implements IICON
	{
		protected var stateView:ButtonStateView;
		
		private var setuped:Boolean;
		
		public function ButtonIcon(freeBitmapData:Boolean = false)
		{
			setuped = false;
			
			init(freeBitmapData);
		}
		
		protected function init(freeBitmapData:Boolean):void
		{
			stateView = new ButtonStateView(freeBitmapData);
			stateView.mouseEnabled = false;
		}
		
		protected function checkSetup(component:Component):void
		{
			if(setuped) return;
			
			setuped = true;
			
			setup(component);
		}
		
		protected function setup(component:Component):void
		{
			var ui:IComponentUI = component.UI;
			
			//TODO: 取得UI图片资源
			stateView.setUpImage(getAsset(component, ui, DefaultConfigKeys.BUTTON_ICON_UP_IMAGE));
			stateView.setOverImage(getAsset(component, ui, DefaultConfigKeys.BUTTON_ICON_OVER_IMAGE));
			stateView.setDownImage(getAsset(component, ui, DefaultConfigKeys.BUTTON_ICON_DOWN_IMAGE));
			stateView.setDisabledImage(getAsset(component, ui, DefaultConfigKeys.BUTTON_ICON_DISABLED_IMAGE));
			stateView.setSelectedImage(getAsset(component, ui, DefaultConfigKeys.BUTTON_ICON_SELECTED_IMAGE));
			stateView.setOverSelectedImage(getAsset(component, ui, DefaultConfigKeys.BUTTON_ICON_OVER_SELECTED_IMAGE));
			stateView.setDownSelectedImage(getAsset(component, ui, DefaultConfigKeys.BUTTON_ICON_DOWN_SELECTED_IMAGE));
			stateView.setDisabledSelectedImage(getAsset(component, ui, DefaultConfigKeys.BUTTON_ICON_DISABLED_SELECTED_IMAGE));
		}
		
		protected function getAsset(component:Component, ui:IComponentUI, extName:String):DisplayObject
		{
			var pp:String = ui.getResourcesPrefix(component);
			
			return ui.getDisplayObject(pp + extName);
		}
		
		public function get iconWidth():int
		{
			return stateView.width;
		}
		
		public function get iconHeight():int
		{
			return stateView.height;
		}
		
		public function updateIcon(component:Component, x:int, y:int):void
		{
			checkSetup(component);
			
			var btn:AbstractButton = component as AbstractButton;
			
			var model:IButtonModel = btn.model;
			
			stateView.enabled = model.enabled;
			stateView.downed = model.pressed;
			stateView.selected = model.selected;
			stateView.overed = model.rollOver;
			
			stateView.x = x;
			stateView.y = y;
			
			stateView.update();
		}
		
		public function getDisplay(component:Component):DisplayObject
		{
			checkSetup(component);
			
			return stateView;
		}
		
		public function dispose():void
		{
			DisposeUtil.free(stateView);
			stateView = null;
		}
	}
}