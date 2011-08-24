package jui.org.coms.buttons
{
	import flash.display.DisplayObject;
	
	import jui.org.Component;
	import jui.org.DefaultUI;
	import jui.org.DefaultsProviderBase;
	import jui.org.Graphics2D;
	import jui.org.IButtonModel;
	import jui.org.ICanUpdateProvider;
	import jui.org.IComponentUI;
	import jui.org.IUIResource;
	
	import jutils.org.util.DisposeUtil;
	import jui.org.uis.buttons.ButtonStateObject;
	
	public class DefaultButtonBackground extends DefaultsProviderBase implements ICanUpdateProvider, IUIResource
	{
		protected var stateAsset:ButtonStateObject;
		protected var setuped:Boolean;
		protected var fixedPrefix:String;
		
		public function DefaultButtonBackground()
		{
			super();
			
			setuped = false;
			this.fixedPrefix = fixedPrefix;
			stateAsset = new ButtonStateObject();
		}
		
		public function getStateAsset():ButtonStateObject
		{
			return stateAsset;
		}
		
		protected function getPropertyPrefix():String
		{
			if(fixedPrefix != null)
			{
				return fixedPrefix;
			}
			
			return DefaultUI.ButtonResourcePrefix;
		}
		
		private function getAsset(ui:IComponentUI, extName:String):DisplayObject
		{
			var pp:String = getPropertyPrefix();
			
			return ui.getInstance(pp + extName) as DisplayObject;
		}
		
		protected function setupAssets(ui:IComponentUI):void
		{
			stateAsset.setDefaultButtonImage(getAsset(ui, DefaultUI.ButtonDefaultButtonDefaultImage));
			stateAsset.setDefaultImage(getAsset(ui, DefaultUI.ButtonDefaultImage));
			stateAsset.setPressedImage(getAsset(ui, DefaultUI.ButtonPressedImage));
			stateAsset.setPressedSelectedImage(getAsset(ui, DefaultUI.ButtonPressedSelectedImage));
			stateAsset.setDisabledImage(getAsset(ui, DefaultUI.ButtonDisabledImage));
			stateAsset.setSelectedImage(getAsset(ui, DefaultUI.ButtonSelectedImage));
			stateAsset.setDisabledSelectedImage(getAsset(ui, DefaultUI.ButtonDisabledSelectedImage));
			stateAsset.setRolloverImage(getAsset(ui, DefaultUI.ButtonRolloverImage));
			stateAsset.setRolloverSelectedImage(getAsset(ui, DefaultUI.ButtonRolloverSelectedImage));
		}
		
		public function update(component:Component, graphics:Graphics2D, bound:IntRectangle):void
		{
			if(!setuped)
			{
				setupAssets(getDefaultsOwner(component));
				setuped = true;
			}
			
			var button:AbstractButton = AbstractButton(component);
			var model:IButtonModel = button.getModel();
			
			stateAsset.setEnabled(model.isEnabled());
			stateAsset.setPressed(model.isPressed() && model.isArmed());
			stateAsset.setSelected(model.isSelected());
			stateAsset.setRollovered(button.isRollOverEnabled() && model.isRollOver());
			stateAsset.setDefaultButton(button is Button && Button(button).isDefaultButton());
			stateAsset.updateRepresent(bound);
		}
		
		public function getDisplay(component:Component):DisplayObject
		{
			return stateAsset;
		}
		
		public function dispose():void
		{
			DisposeUtil.free(stateAsset);
			stateAsset = null;
		}
	}
}