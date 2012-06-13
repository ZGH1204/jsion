package jsion.ui.components.buttons
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import jsion.*;
	import jsion.ui.BasicComponentUI;
	import jsion.ui.Component;
	import jsion.ui.DefaultConfigKeys;
	import jsion.ui.IComponentUI;
	import jsion.ui.IICON;
	import jsion.ui.UIUtil;
	import jsion.utils.DisposeUtil;
	
	public class BasicButtonUI extends BasicComponentUI
	{
		protected var textField:TextField;
		
		protected var viewRect:IntRectangle = new IntRectangle();
		protected var textRect:IntRectangle = new IntRectangle();
		protected var iconRect:IntRectangle = new IntRectangle();
		
		
		
		public function BasicButtonUI()
		{
			super();
		}
		
		override public function install(component:Component):void
		{
			installDefaults(component);
			
			installFilters(component);
			
			installIcon(component);
			
			installTextField(component);
		}
		
//		private function installDefaults(component:Component):void
//		{
//			var pp:String = getResourcesPrefix(component);
//			
//			LookAndFeel.installFonts(component, pp);
//			LookAndFeel.installColors(component, pp);
//			LookAndFeel.installBorderAndDecorators(component, pp);
//		}
		
		private function installFilters(component:Component):void
		{
			var pp:String = getResourcesPrefix(component);
			var btn:AbstractButton = AbstractButton(component);
			var ui:IComponentUI = btn.UI;
			
			btn.textFilters = ui.getInstance(pp + DefaultConfigKeys.BUTTON_TEXT_FILTERS) as Array;
			
			btn.upFilters = ui.getInstance(pp + DefaultConfigKeys.BUTTON_UP_FILTERS) as Array;
			btn.overFilters = ui.getInstance(pp + DefaultConfigKeys.BUTTON_OVER_FILTERS) as Array;
			btn.downFilters = ui.getInstance(pp + DefaultConfigKeys.BUTTON_DOWN_FILTERS) as Array;
			btn.disabledFilters = ui.getInstance(pp + DefaultConfigKeys.BUTTON_DISABLED_FILTERS) as Array;
			btn.selectedFilters = ui.getInstance(pp + DefaultConfigKeys.BUTTON_SELECTED_FILTERS) as Array;
			btn.overSelectedFilters = ui.getInstance(pp + DefaultConfigKeys.BUTTON_OVER_SELECTED_FILTERS) as Array;
			btn.downSelectedFilters = ui.getInstance(pp + DefaultConfigKeys.BUTTON_DOWN_SELECTED_FILTERS) as Array;
			btn.disabledSelectedFilters = ui.getInstance(pp + DefaultConfigKeys.BUTTON_DISABLED_SELECTED_FILTERS) as Array;
		}
		
		private function installIcon(component:Component):void
		{
			var pp:String = getResourcesPrefix(component);
			var ui:IComponentUI = component.UI;
			var btn:AbstractButton = AbstractButton(component);
			
			var ic:IICON = ui.getIcon(pp + DefaultConfigKeys.BUTTON_ICON);
			
			btn.icon = ic;
		}
		
		private function installTextField(component:Component):void
		{
			textField = new TextField();
			textField.wordWrap = false;
			textField.multiline = false;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.selectable = false;
			textField.mouseEnabled = false;
			textField.mouseWheelEnabled = false;
			
			component.addChild(textField);
		}
		
		override public function uninstall(component:Component):void
		{
			DisposeUtil.free(textField);
			textField = null;
			
			viewRect = null;
			textRect = null;
		}
		
		override public function paint(component:Component, bounds:IntRectangle):void
		{
			super.paint(component, bounds);
			
			paintTextAndIcon(component, bounds);
			
			paintFilters(component, bounds);
		}
		
		protected function paintTextAndIcon(component:Component, bounds:IntRectangle):void
		{
			var btn:AbstractButton = AbstractButton(component);
			var icn:IICON = btn.icon;
			
			viewRect.setRect(bounds);
			
			textRect.setRectXYWH(0, 0, 0, 0);
			iconRect.setRectXYWH(0, 0, 0, 0);
			
			var iconSize:IntDimension;
			
			if(icn) iconSize = new IntDimension(icn.iconWidth, icn.iconHeight);
			else iconSize = new IntDimension();
			
			
			var text:String = UIUtil.layoutTextAndBox(btn.text, btn.font, 
				btn.horizontalTextAlginment, 
				btn.verticalTextAlginment, 
				textRect, iconSize.width, iconSize.height, 
				btn.textHGap, btn.textVGap, btn.iconHGap, 
				btn.iconVGap, btn.iconDir, iconRect, viewRect);
			
			if(icn) icn.updateIcon(component, iconRect.x, iconRect.y);
			
			textField.x = textRect.x;
			textField.y = textRect.y;
			textField.text = text;
			btn.font.apply(textField);
			textField.textColor = btn.forecolor.getRGB();
			
			textField.filters = btn.textFilters;
		}
		
		private function paintFilters(component:Component, bounds:IntRectangle):void
		{
			var btn:AbstractButton = component as AbstractButton;
			var model:IButtonModel = btn.model;
			
			var filter:Array = btn.upFilters;
			
			var tmpFilter:Array;
			
			if(!model.enabled)
			{
				if(model.selected && btn.disabledSelectedFilters)
				{
					tmpFilter = btn.disabledSelectedFilters;
				}
				else
				{
					tmpFilter = btn.disabledFilters;
				}
			}
			else if(model.pressed)
			{
				if(model.selected && btn.downSelectedFilters)
				{
					tmpFilter = btn.downSelectedFilters;
				}
				else
				{
					tmpFilter = btn.downFilters;
				}
			}
			else if(model.rollOver)
			{
				if(model.selected && btn.overSelectedFilters)
				{
					tmpFilter = btn.overSelectedFilters;
				}
				else
				{
					tmpFilter = btn.overFilters;
				}
			}
			else if(model.selected)
			{
				tmpFilter = btn.selectedFilters;
			}
			
			if(tmpFilter != null)
			{
				filter = tmpFilter;
			}
			
			if(filter == null) filter = [];
			
			btn.filters = filter;
		}
		
		
		
		private function calcSize(btn:AbstractButton, textSize:IntDimension, backSize:IntDimension):IntDimension
		{
			var w:int;
			var h:int;
			
			if(btn.iconDir == CheckBox.CENTER || btn.iconDir == CheckBox.MIDDLE)
			{
				w = Math.max(textSize.width, backSize.width);
				h = Math.max(textSize.height, backSize.height);
			}
			else if(btn.iconDir == CheckBox.TOP || btn.iconDir == CheckBox.BOTTOM)
			{
				w = Math.max(textSize.width, backSize.width);
				
				h = textSize.height + backSize.height;
				h += btn.textVGap;
				h += btn.iconVGap;
			}
			else
			{
				w = textSize.width + backSize.width;
				w += btn.textHGap;
				w += btn.iconHGap;
				
				h = Math.max(textSize.height, backSize.height);
			}
			
			
			return new IntDimension(w, h);
		}
		
		override public function getPreferredSize(component:Component):IntDimension
		{
			var btn:AbstractButton = AbstractButton(component);
			var icn:IICON = btn.icon;
			
			var textSize:IntDimension = getTextSize(component);
			var iconSize:IntDimension;
			
			if(icn) iconSize = new IntDimension(icn.iconWidth, icn.iconHeight);
			else iconSize = new IntDimension();
			
			return calcSize(btn, textSize, iconSize);;
			//return new IntDimension(Math.max(textSize.width, backSize.width), Math.max(textSize.height, backSize.height));
		}
		
		override public function getMinimumSize(component:Component):IntDimension
		{
			var btn:AbstractButton = AbstractButton(component);
			var icn:IICON = btn.icon;
			
			var textSize:IntDimension = getTextSize(component);
			var iconSize:IntDimension;
			
			if(icn) iconSize = new IntDimension(icn.iconWidth, icn.iconHeight);
			else iconSize = new IntDimension();
			
			return calcSize(btn, textSize, iconSize);;
			//return new IntDimension(Math.max(textSize.width, backSize.width), Math.max(textSize.height, backSize.height));
		}
		
//		override public function getMaximumSize(component:Component):IntDimension
//		{
//			var backgroundDecorator:IGroundDecorator = component.backgroundDecorator;
//			
//			var textSize:IntDimension = getTextSize(component);
//			var backMax:IntDimension;
//			
//			if(backgroundDecorator) backMax = backgroundDecorator.getMaximumSize(component);
//			else backMax = IntDimension.createBigDimension();
//			
//			return new IntDimension(Math.max(textSize.width, backMax.width), Math.max(textSize.height, backMax.height));
//		}
		
		protected function getTextSize(component:Component):IntDimension
		{
			var btn:AbstractButton = AbstractButton(component);
			
			UIUtil.layoutText(btn.text, btn.font, 
				btn.horizontalTextAlginment, 
				btn.verticalTextAlginment, 
				viewRect, textRect);
			
			return textRect.getSize();
		}
		
		override public function dispose():void
		{
			DisposeUtil.free(textField);
			textField = null;
			
			viewRect = null;
			textRect = null;
			iconRect = null;
			
			super.dispose();
		}
	}
}