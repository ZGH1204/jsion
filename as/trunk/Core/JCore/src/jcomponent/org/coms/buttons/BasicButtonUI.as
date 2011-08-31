package jcomponent.org.coms.buttons
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import jcomponent.org.basic.BasicComponentUI;
	import jcomponent.org.basic.Component;
	import jcomponent.org.basic.DefaultConfigKeys;
	import jcomponent.org.basic.IComponentUI;
	import jcomponent.org.basic.IGroundDecorator;
	import jcomponent.org.basic.LookAndFeel;
	
	import jutils.org.util.DisposeUtil;
	import jutils.org.util.StringUtil;
	
	public class BasicButtonUI extends BasicComponentUI
	{
		protected var textField:TextField;
		
		protected var viewRect:IntRectangle = new IntRectangle();
		protected var textRect:IntRectangle = new IntRectangle();
		
		public function BasicButtonUI()
		{
			super();
		}
		
		override public function install(component:Component):void
		{
			installDefaults(component);
			
			installFilters(component);
			
			installTextField(component);
		}
		
		private function installDefaults(component:Component):void
		{
			var pp:String = getResourcesPrefix(component);
			
			LookAndFeel.installFonts(component, pp);
			LookAndFeel.installColors(component, pp);
			LookAndFeel.installBorderAndDecorators(component, pp);
		}
		
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
			
			paintText(component, bounds);
			
			paintFilters(component, bounds);
		}
		
		protected function paintText(component:Component, bounds:IntRectangle):void
		{
			var btn:AbstractButton = AbstractButton(component);
			
			viewRect.setRect(bounds);
			
			textRect.x = textRect.y = textRect.width = textRect.height = 0;
			
			var text:String = JUtil.layoutText(btn.text, btn.font, 
				btn.horizontalTextAlginment, 
				btn.verticalTextAlginment, 
				viewRect, textRect);
			
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
			
			btn.content.filters = filter;
		}
		
		override public function getPreferredSize(component:Component):IntDimension
		{
			var backgroundDecorator:IGroundDecorator = component.backgroundDecorator;
			
			var textSize:IntDimension = getTextSize(component);
			var backSize:IntDimension;
			
			if(backgroundDecorator) backSize = backgroundDecorator.getPreferredSize(component);
			else backSize = new IntDimension();
			
			return new IntDimension(Math.max(textSize.width, backSize.width), Math.max(textSize.height, backSize.height));
		}
		
		override public function getMinimumSize(component:Component):IntDimension
		{
			var backgroundDecorator:IGroundDecorator = component.backgroundDecorator;
			
			var textSize:IntDimension = getTextSize(component);
			var backSize:IntDimension;
			
			if(backgroundDecorator) backSize = backgroundDecorator.getMinimumSize(component);
			else backSize = new IntDimension();
			
			return new IntDimension(Math.max(textSize.width, backSize.width), Math.max(textSize.height, backSize.height));
		}
		
		override public function getMaximumSize(component:Component):IntDimension
		{
			var backgroundDecorator:IGroundDecorator = component.backgroundDecorator;
			
			var textSize:IntDimension = getTextSize(component);
			var backMax:IntDimension;
			
			if(backgroundDecorator) backMax = backgroundDecorator.getMaximumSize(component);
			else backMax = IntDimension.createBigDimension();
			
			return new IntDimension(Math.max(textSize.width, backMax.width), Math.max(textSize.height, backMax.height));
		}
		
		protected function getTextSize(component:Component):IntDimension
		{
			var btn:AbstractButton = AbstractButton(component);
			
			JUtil.layoutText(btn.text, btn.font, 
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
			
			super.dispose();
		}
	}
}