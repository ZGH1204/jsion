package jui.org.coms.buttons
{
	import flash.display.DisplayObject;
	
	import jui.org.Component;
	import jui.org.IButtonModel;
	import jui.org.Icon;
	import jui.org.UIConstants;
	import jui.org.defres.ArrayUIResource;
	
	import jutils.org.util.StringUtil;
	
	public class AbstractButton extends Component
	{
		public static const CENTER:int  = UIConstants.CENTER;
		
		public static const TOP:int     = UIConstants.TOP;
		
		public static const LEFT:int    = UIConstants.LEFT;
		
		public static const BOTTOM:int  = UIConstants.BOTTOM;
		
		public static const RIGHT:int   = UIConstants.RIGHT;
		
		public static const HORIZONTAL:int = UIConstants.HORIZONTAL;
		
		public static const VERTICAL:int   = UIConstants.VERTICAL;
		
		
		
		protected var model:IButtonModel;
		
		private var text:String;
		private var displayText:String;
		
		private var mnemonic:int;
		private var mnemonicIndex:int;
		private var mnemonicEnabled:Boolean;
		private var margin:Insets;
		private var defaultMargin:Insets;
		
		// Button icons
		private var       defaultIcon:Icon;
		private var       pressedIcon:Icon;
		private var       disabledIcon:Icon;
		
		private var       selectedIcon:Icon;
		private var       disabledSelectedIcon:Icon;
		
		private var       rolloverIcon:Icon;
		private var       rolloverSelectedIcon:Icon;
		
		// Display properties
		private var    rolloverEnabled:Boolean;
		
		// Icon/Label Alignment
		private var        verticalAlignment:int;
		private var        horizontalAlignment:int;
		
		private var        verticalTextPosition:int;
		private var        horizontalTextPosition:int;
		
		private var        iconTextGap:int;	
		private var        shiftOffset:int = 0;
		private var        shiftOffsetSet:Boolean=false;
		
		private var        textFilters:Array;
		
		public function AbstractButton(text:String = "", icon:Icon = null)
		{
			super();
			setName("AbstractButton");
			
			rolloverEnabled = true;
			
			verticalAlignment = CENTER;
			horizontalAlignment = CENTER;
			verticalTextPosition = CENTER;
			horizontalTextPosition = LEFT;
			
			textFilters = new ArrayUIResource();
			
			iconTextGap = 2;
			mnemonicEnabled = true;
			this.text = text;
			this.analyzeMnemonic();
			this.defaultIcon = icon;
			//setText(text);
			//setIcon(icon);
			initSelfHandlers();
			updateUI();
			installIcon(defaultIcon);
		}
		
		protected function installIcon(icon:Icon):void
		{
			if(icon != null && icon.getDisplay(this) != null)
			{
				addChild(icon.getDisplay(this));
			}
		}
		
		protected function uninstallIcon(icon:Icon):void
		{
			var iconDis:DisplayObject = (icon == null ? null : icon.getDisplay(this));
			
			if(iconDis != null && isChild(iconDis)){
				removeChild(icon.getDisplay(this));
			}
		}
		
		private function analyzeMnemonic():void{
			displayText = text;
			mnemonic = -1;
			mnemonicIndex = -1;
			
			if(text == null)
			{
				return;
			}
			
			if(!mnemonicEnabled)
			{
				return;
			}
			
			var mi:int = text.indexOf("&");
			var mc:String = "";
			var found:Boolean = false;
			
			while(mi >= 0)
			{
				if((mi + 1) < text.length)
				{
					mc = text.charAt(mi + 1);
					
					if(StringUtil.isLetter(mc))
					{
						found = true;
						break;
					}
				}
				else
				{
					break;
				}
				
				mi = text.indexOf("&", mi + 1);
			}
			
			if(found)
			{
				displayText = text.substring(0, mi) + "[" + text.substring(mi + 1) + "]";
				mnemonic = mc.toUpperCase().charCodeAt(0);
				mnemonicIndex = mi;
			}
		}
		
		private function initSelfHandlers():void
		{
			
		}
	}
}