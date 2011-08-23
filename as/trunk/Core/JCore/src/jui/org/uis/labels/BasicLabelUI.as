package jui.org.uis.labels
{
	import flash.filters.BlurFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import jui.org.Component;
	import jui.org.Graphics2D;
	import jui.org.Icon;
	import jui.org.JFont;
	import jui.org.LabelUtil;
	import jui.org.ResourceProvider;
	import jui.org.coms.labels.Label;
	import jui.org.uis.BaseComponentUI;
	
	import jutils.org.util.StringUtil;
	
	public class BasicLabelUI extends BaseComponentUI
	{
		protected var label:Label;
		protected var textField:TextField;
		
		public function BasicLabelUI()
		{
			super();
		}
		
		protected function getPrefix():String
		{
			return "Label.";
		}
		
		override public function installUI(component:Component):void
		{
			label = Label(component);
			
			installDefaults(label);
			installComponents(label);
		}
		
		override public function uninstallUI(component:Component):void
		{
			uninstallDefaults(label);
			uninstallComponents(label);
		}
		
		
		
		
		
		
		
		
		
		
		private function installDefaults(l:Label):void
		{
			var pp:String = getPrefix();
			
			ResourceProvider.installCorlorsAndFonts(l, pp);
			ResourceProvider.installBorderAndBFProvider(l, pp);
		}
		
		private function uninstallDefaults(l:Label):void
		{
			ResourceProvider.uninstallBorderAndBFProvider(l);
		}
		
		private function installComponents(l:Label):void
		{
			textField = new TextField();
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.selectable = false;
			textField.mouseEnabled = false;
			textField.mouseWheelEnabled = false;
			l.addChild(textField);
			l.setFontValidated(false);
		}
		
		protected function uninstallComponents(b:Label):void
		{
			b.removeChild(textField);
		}
		
		
		private static var viewRect : IntRectangle = new IntRectangle();
		private static var textRect : IntRectangle = new IntRectangle();
		private static var iconRect : IntRectangle = new IntRectangle();
		
		override public function paint(component:Component, graphics:Graphics2D, bound:IntRectangle):void
		{
			super.paint(component, graphics, bound);
			
			var l:Label = Label(component);
			
			viewRect.setRect(bound);
			
			textRect.x = textRect.y = textRect.width = textRect.height = 0;
			iconRect.x = iconRect.y = iconRect.width = iconRect.height = 0;
			
			var text:String = LabelUtil.layoutAndComputeLabel(component, 
				l.getText(), 
				l.getFont(), 
				l.getIcon(), 
				l.getVerticalIconAlignment(), 
				l.getHorizontalIconAlignment(), 
				l.getVerticalTextPosition(), 
				l.getHorizontalTextPosition(), 
				viewRect, 
				iconRect, 
				textRect, 
				StringUtil.isNullOrEmpty(l.getText()) ? 0 : l.getIconTextGap());
			
			paintIcon(l, graphics, iconRect);
			
			if(StringUtil.isNotNullOrEmpty(text))
			{
				textField.visible = true;
				paintText(l, textRect, text);
			}
			else
			{
				textField.text = "";
				textField.visible = false;
			}
			
			textField.selectable = l.isSelectable();
			textField.mouseEnabled = l.isSelectable();
		}
		
		
		protected function paintIcon(lb:Label, graphics:Graphics2D, rect:IntRectangle):void
		{
			var icon : Icon = lb.getIcon();
			var tmpIcon : Icon = null;
			
			var icons : Array = getIcons();
			for (var i : int = 0; i < icons.length; i++)
			{
				var ico : Icon = icons[i];
				setIconVisible(ico, false);
			}
			
			if (icon == null)
			{
				return;
			}
			
			if (!lb.isEnabled())
			{
				tmpIcon = lb.getDisabledIcon();
			}
			
			if (tmpIcon != null)
			{
				icon = tmpIcon;
			}
			
			setIconVisible(icon, true);
			
			icon.updateIcon(lb, graphics, rect.x, rect.y);
		}
		
		private function setIconVisible(ic:Icon, visible:Boolean):void
		{
			if (ic.getDisplay(label) != null)
			{
				ic.getDisplay(label).visible = visible;
			}
		}
		
		protected function getIcons() : Array
		{
			var arr : Array = new Array();
			if (label.getIcon() != null)
			{
				arr.push(label.getIcon());
			}
			
			if (label.getDisabledIcon() != null)
			{
				arr.push(label.getDisabledIcon());
			}
			
			return arr;
		}
		
		protected function paintText(lb:Label, rect:IntRectangle, text:String):void
		{
			var font : JFont = lb.getFont();
			
			if (textField.text != text) {
				textField.text = text;
			}
			
			if (!lb.isFontValidated()) {
				JUtil.applyTextFont(textField, font);
				lb.setFontValidated(true);
			}
			
			JUtil.applyTextColor(textField, lb.getForeground());
			textField.x = textRect.x;
			textField.y = textRect.y;
			
			if (!lb.isEnabled())
			{
				lb.filters = [new BlurFilter(2, 2, 2)];
			}
			else
			{
				lb.filters = null;
			}
			
			textField.filters = label.getTextFilters();
		}
		
		
		protected function getLabelPreferredSize(l:Label, ic:Icon, text:String):IntDimension
		{
			viewRect.setRectXYWH(0, 0, 100000, 100000);
			textRect.x = textRect.y = textRect.width = textRect.height = 0;
			iconRect.x = iconRect.y = iconRect.width = iconRect.height = 0;
			
			LabelUtil.layoutAndComputeLabel(l, 
				l.getText(), 
				l.getFont(), 
				getIconToLayout(), 
				l.getVerticalIconAlignment(), 
				l.getHorizontalIconAlignment(), 
				l.getVerticalTextPosition(), 
				l.getHorizontalTextPosition(), 
				viewRect, 
				iconRect, 
				textRect, 
				StringUtil.isNullOrEmpty(l.getText()) ? 0 : l.getIconTextGap());
			
			
			var size : IntDimension;
			
			if (ic == null)
			{
				size = textRect.getSize();
			}
			else if (l.getText() == null || l.getText() == "")
			{
				size = iconRect.getSize();
			}
			else
			{
				var r : IntRectangle = iconRect.union(textRect);
				size = r.getSize();
			}
			
			size = l.getInsets().getOutsideSize(size);
			
			return size;
		}
		
		protected function getIconToLayout():Icon
		{
			return label.getIcon();
		}
		
		override public function getPreferredSize(c : Component):IntDimension
		{
			var b:Label = Label(c);
			
			return getLabelPreferredSize(b, getIconToLayout(), b.getText());
		}
		
		
		override public function dispose():void
		{
			
			
			super.dispose();
		}
	}
}