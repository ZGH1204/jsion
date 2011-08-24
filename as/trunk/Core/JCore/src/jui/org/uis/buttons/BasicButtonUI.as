package jui.org.uis.buttons
{
	import flash.text.TextField;
	
	import jui.org.Component;
	import jui.org.DefaultUI;
	import jui.org.Graphics2D;
	import jui.org.IButtonModel;
	import jui.org.IUIResource;
	import jui.org.Icon;
	import jui.org.JColor;
	import jui.org.JFont;
	import jui.org.LabelUtil;
	import jui.org.ResourceProvider;
	import jui.org.coms.buttons.AbstractButton;
	import jui.org.events.JEvent;
	import jui.org.uis.BaseComponentUI;
	
	import jutils.org.util.StringUtil;
	
	public class BasicButtonUI extends BaseComponentUI
	{
		protected var button:AbstractButton;
		protected var textField:TextField;
		
		public function BasicButtonUI()
		{
			super();
		}
		
		protected function isAssetBackgroundEnabled():Boolean
		{
			return true;
		}
		
		protected function getPrefix():String
		{
			return DefaultUI.ButtonResourcePrefix;
		}
		
		override public function installUI(component:Component):void
		{
			button = AbstractButton(component);
			
			installDefaults(button);
			installComponents(button);
			installListeners(button);
		}
		
		override public function uninstallUI(component:Component):void
		{
			button = AbstractButton(component);
			uninstallDefaults(button);
			uninstallComponents(button);
			uninstallListeners(button);
		}
		
		protected function installDefaults(b:AbstractButton):void
		{
			var pp:String = getPrefix();
			
			if(!b.isShiftOffsetSet())
			{
				b.setShiftOffset(getInt(pp + DefaultUI.ButtonTextShiftOffset));
				b.setShiftOffsetSet(false);
			}
			
			if(b.getMargin() is IUIResource)
			{
				b.setMargin(getInsets(pp + DefaultUI.ButtonMargin));
			}
			
			ResourceProvider.installCorlorsAndFonts(b, pp);
			ResourceProvider.installBorderAndBFProvider(b, pp);
			
			button.mouseChildren = false;
			
			if(b.getTextFilters() is IUIResource)
			{
				b.setTextFilters(getInstance(pp + DefaultUI.ButtonTextFilters));
			}
		}
		
		protected function uninstallDefaults(b:AbstractButton):void
		{
			ResourceProvider.uninstallBorderAndBFProvider(b);
		}
		
		protected function installComponents(b:AbstractButton):void
		{
			textField = JUtil.createLabel(b, "label");
			
			b.setFontValidated(false);
		}
		
		protected function uninstallComponents(b:AbstractButton):void
		{
			b.removeChild(textField);
		}
		
		protected function installListeners(b:AbstractButton):void{
			b.addStateListener(__stateListener);
			//b.addEventListener(FocusKeyEvent.FOCUS_KEY_DOWN, __onKeyDown);
			//b.addEventListener(FocusKeyEvent.FOCUS_KEY_UP, __onKeyUp);
		}
		
		protected function uninstallListeners(b:AbstractButton):void{
			b.removeStateListener(__stateListener);
			//b.removeEventListener(FocusKeyEvent.FOCUS_KEY_DOWN, __onKeyDown);
			//b.removeEventListener(FocusKeyEvent.FOCUS_KEY_UP, __onKeyUp);
		}
		
		protected function getTextShiftOffset():int
		{
			return button.getShiftOffset();
		}
		
		protected function getIconToLayout():Icon
		{
			return button.getIcon();
		}
		
		
		override public function refreshStyleProperties():void
		{
			installDefaults(button);
			button.repaint();
			button.revalidate();
		}
		
		
		private static var viewRect:IntRectangle = new IntRectangle();
		private static var textRect:IntRectangle = new IntRectangle();
		private static var iconRect:IntRectangle = new IntRectangle();    

		
		
		override public function paint(component:Component, graphics:Graphics2D, bound:IntRectangle):void
		{
			super.paint(component, graphics, bound);
			
			var b:AbstractButton = AbstractButton(component);
			
			var insets:Insets = b.getMargin();
			
			if(insets != null)
			{
				bound = insets.getInsideBounds(bound);
			}
			
			viewRect.setRect(bound);
			
			textRect.x = textRect.y = textRect.width = textRect.height = 0;
			iconRect.x = iconRect.y = iconRect.width = iconRect.height = 0;
			
			// layout the text and icon
			var text:String = LabelUtil.layoutAndComputeLabel(component, 
				b.getDisplayText(), component.getFont(), getIconToLayout(), 
				b.getVerticalAlignment(), b.getHorizontalAlignment(),
				b.getVerticalTextPosition(), b.getHorizontalTextPosition(),
				viewRect, iconRect, textRect, 
				b.getDisplayText() == null ? 0 : b.getIconTextGap());
			
			paintIcon(b, graphics, iconRect);
			
			paintText(b, textRect, text);
		}
		
		override protected function paintBackGround(c:Component, g:Graphics2D, b:IntRectangle):void
		{
			//do nothing here, let background decorator to paint the background
		}
		
		
		protected function paintIcon(b:AbstractButton, g:Graphics2D, iconRect:IntRectangle):void
		{
			var model:IButtonModel = b.getModel();
			var icon:Icon = b.getIcon();
			var tmpIcon:Icon = null;
			
			var icons:Array = getIcons();
			
			for(var i:int=0; i<icons.length; i++)
			{
				var ico:Icon = icons[i];
				setIconVisible(ico, false);
			}
			
			if(icon == null)
			{
				return;
			}
			
			if(!model.isEnabled())
			{
				if(model.isSelected())
				{
					tmpIcon = b.getDisabledSelectedIcon();
				}
				else
				{
					tmpIcon = b.getDisabledIcon();
				}
			}
			else if(model.isPressed() && model.isArmed())
			{
				tmpIcon = b.getPressedIcon();
			}
			else if(b.isRollOverEnabled() && model.isRollOver())
			{
				if(model.isSelected())
				{
					tmpIcon = b.getRollOverSelectedIcon();
				}
				else
				{
					tmpIcon = b.getRollOverIcon();
				}
			}
			else if(model.isSelected())
			{
				tmpIcon = b.getSelectedIcon();
			}
			
			if(tmpIcon != null)
			{
				icon = tmpIcon;
			}
			
			setIconVisible(icon, true);
			
			if(model.isPressed() && model.isArmed())
			{
				icon.updateIcon(b, g, iconRect.x + getTextShiftOffset(),
					iconRect.y + getTextShiftOffset());
			}
			else
			{
				icon.updateIcon(b, g, iconRect.x, iconRect.y);
			}
		}
		
		protected function paintText(b:AbstractButton, textRect:IntRectangle, text:String):void
		{
			if (StringUtil.isNotNullOrEmpty(text))
			{
				textField.visible = true;
				
				if(b.getModel().isArmed() || b.getModel().isSelected())
				{
					textRect.x += getTextShiftOffset();
					textRect.y += getTextShiftOffset();
				}
				
				paintTextImp(b, textRect, text);
			}
			else
			{
				textField.text = "";
				textField.visible = false;
			}
		}
		
		protected function paintTextImp(b:AbstractButton, textRect:IntRectangle, text:String):void
		{
			b.bringToTopUnderForeground(textField);
			
			var font:JFont = b.getFont();
			
			if(textField.text != text)
			{
				textField.text = text;
			}
			
			if(!b.isFontValidated())
			{
				JUtil.applyTextFont(textField, font);
				b.setFontValidated(true);
			}
			
			JUtil.applyTextColor(textField, getTextPaintColor(b));
			
			textField.x = textRect.x;
			textField.y = textRect.y;
			
//			if(b.getMnemonicIndex() >= 0)
//			{
//				textField.setTextFormat(
//					new TextFormat(null, null, null, null, null, true), 
//					b.getMnemonicIndex());
//			}
			
			textField.filters = b.getTextFilters();
		}
		
		protected function setIconVisible(icon:Icon, visible:Boolean):void
		{
			if(icon.getDisplay(button) != null)
			{
				icon.getDisplay(button).visible = visible;
			}
		}
		
		protected function getIcons():Array
		{
			var arr:Array = new Array();
			
			if(button.getIcon() != null)
			{
				arr.push(button.getIcon());
			}
			
			if(button.getDisabledIcon() != null)
			{
				arr.push(button.getDisabledIcon());
			}
			
			if(button.getSelectedIcon() != null)
			{
				arr.push(button.getSelectedIcon());
			}
			
			if(button.getDisabledSelectedIcon() != null)
			{
				arr.push(button.getDisabledSelectedIcon());
			}
			
			if(button.getRollOverIcon() != null)
			{
				arr.push(button.getRollOverIcon());
			}
			
			if(button.getRollOverSelectedIcon() != null)
			{
				arr.push(button.getRollOverSelectedIcon());
			}
			
			if(button.getPressedIcon() != null)
			{
				arr.push(button.getPressedIcon());
			}
			
			return arr;
		}
		
		protected function getTextPaintColor(b:AbstractButton):JColor
		{
			if(b.isEnabled())
			{
				return b.getForeground();
			}
			else
			{
				return JUtil.getDisabledColor(b);
			}
		}
		
		protected function getButtonPreferredSize(b:AbstractButton, icon:Icon, text:String):IntDimension
		{
			viewRect.setRectXYWH(0, 0, 100000, 100000);
			
			textRect.x = textRect.y = textRect.width = textRect.height = 0;
			iconRect.x = iconRect.y = iconRect.width = iconRect.height = 0;
			
			LabelUtil.layoutAndComputeLabel(b, 
				text, b.getFont(), icon, 
				b.getVerticalAlignment(), b.getHorizontalAlignment(),
				b.getVerticalTextPosition(), b.getHorizontalTextPosition(),
				viewRect, iconRect, textRect, 
				b.getDisplayText() == null ? 0 : b.getIconTextGap()
			);
			
			/* The preferred size of the button is the size of 
			* the text and icon rectangles plus the buttons insets.
			*/
			var size:IntDimension;
			
			if(icon == null)
			{
				size = textRect.getSize();
			}
			else if(StringUtil.isNullOrEmpty(b.getDisplayText()))
			{
				size = iconRect.getSize();
			}
			else
			{
				var r:IntRectangle = iconRect.union(textRect);
				
				size = r.getSize();
			}
			
			size = b.getInsets().getOutsideSize(size);
			
			if(b.getMargin() != null)
			{
				size = b.getMargin().getOutsideSize(size);
			}
			
			return size;
		}
		
		protected function getButtonMinimumSize(b:AbstractButton, icon:Icon, text:String):IntDimension
		{
			var size:IntDimension = b.getInsets().getOutsideSize();
			
			if(b.getMargin() != null)
			{
				size = b.getMargin().getOutsideSize(size);
			}
			
			return size;
		}
		
		override public function getPreferredSize(c:Component):IntDimension
		{
			var b:AbstractButton = AbstractButton(c);
			return getButtonPreferredSize(b, getIconToLayout(), b.getDisplayText());
		}
		
		override public function getMinimumSize(c:Component):IntDimension{
			var b:AbstractButton = AbstractButton(c);
			return getButtonMinimumSize(b, getIconToLayout(), b.getDisplayText());
		}
		
		private function __stateListener(e:JEvent):void
		{
			button.repaint();
		}
	}
}