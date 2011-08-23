package jui.org.coms.labels
{
	import flash.display.DisplayObject;
	
	import jui.org.Component;
	import jui.org.DefaultUI;
	import jui.org.Icon;
	import jui.org.UIConstants;
	import jui.org.uis.labels.BasicLabelUI;
	
	public class Label extends Component
	{
		public static const CENTER:int  = UIConstants.CENTER;
		
		public static const TOP:int     = UIConstants.TOP;
		
		public static const LEFT:int    = UIConstants.LEFT;
		
		public static const BOTTOM:int  = UIConstants.BOTTOM;
		
		public static const RIGHT:int   = UIConstants.RIGHT;
		
		public static const HORIZONTAL:int = UIConstants.HORIZONTAL;
		
		public static const VERTICAL:int   = UIConstants.VERTICAL;
		
		/**
		 * 图标
		 */		
		protected var icon:Icon;
		
		/**
		 * 禁用状态的图标
		 */		
		private var disabledIcon:Icon;
		
		/**
		 * 图标垂直位置
		 */		
		private var verticalIconAlignment:int;
		
		/**
		 * 图标水平位置
		 */		
		private var horizontalIconAlignment:int;
		
		/**
		 * 文本
		 */		
		protected var text:String;
		
		/**
		 * 文本垂直位置
		 */		
		protected var verticalTextPosition:int;
		
		/**
		 * 文本水平位置
		 */		
		protected var horizontalTextPosition:int;
		
		/**
		 * 图标和文本之间的间距
		 */		
		protected var iconTextGap:int;
		
		/**
		 * 文本滤镜
		 */		
		private var textFilters:Array;
		
		/**
		 * 是否可选
		 */		
		protected var selectable:Boolean;
		
		public function Label(text:String = "", icon:Icon = null, horizontalAlignment:int = UIConstants.CENTER)
		{
			super();
			setName("Label");
			
			verticalIconAlignment = CENTER;
			horizontalAlignment = CENTER;
			verticalTextPosition = LEFT;
			
			this.text = text;
			this.icon = icon;
			this.horizontalIconAlignment = horizontalAlignment;
			
			iconTextGap = 4;
			
			selectable = false;
			
			updateUI();
		}
		
		public function getIcon():Icon
		{
			return icon;
		}
		
		public function setIcon(value:Icon):void
		{
			if(icon != value)
			{
				uninstallIcon(icon);
				icon = value;
				installIcon(icon);
				repaint();
				invalidate();
			}
		}
		
		public function getDisabledIcon():Icon
		{
			return disabledIcon;
		}
		
		public function setDisabledIcon(value:Icon):void
		{
			var old:Icon = disabledIcon;
			disabledIcon = value;
			if(disabledIcon != old)
			{
				uninstallIcon(old);
				installIcon(disabledIcon);
				
				repaint();
				invalidate();
			}
		}
		
		public function getVerticalIconAlignment():int
		{
			return verticalIconAlignment;
		}
		
		public function setVerticalIconAlignment(value:int):void
		{
			if(verticalIconAlignment != value)
			{
				verticalIconAlignment = value;
				repaint();
			}
		}
		
		public function getHorizontalIconAlignment():int
		{
			return horizontalIconAlignment;
		}
		
		public function setHorizontalIconAlignment(value:int):void
		{
			if(horizontalIconAlignment != value)
			{
				horizontalIconAlignment = value;
				repaint();
			}
		}
		
		public function getText():String
		{
			return text;
		}
		
		public function setText(value:String):void
		{
			if(text != value)
			{
				text = value;
				repaint();
				invalidate();
			}
		}
		
		public function getVerticalTextPosition():int
		{
			return verticalTextPosition;
		}
		
		public function setVerticalTextPosition(value:int):void
		{
			if(verticalTextPosition != value)
			{
				verticalTextPosition = value;
				repaint();
			}
		}
		
		public function getHorizontalTextPosition():int
		{
			return horizontalTextPosition;
		}
		
		public function setHorizontalTextPosition(value:int):void
		{
			if(horizontalTextPosition != value)
			{
				horizontalTextPosition = value;
				repaint();
			}
		}
		
		public function getIconTextGap():int
		{
			return iconTextGap;
		}
		
		public function setIconTextGap(value:int):void
		{
			if(iconTextGap != value)
			{
				iconTextGap = value;
				repaint();
				invalidate();
			}
		}
		
		public function getTextFilters():Array
		{
			return textFilters;
		}
		
		public function setTextFilters(filters:Array):void
		{
			textFilters = filters;
			repaint();
		}
		
		public function isSelectable():Boolean
		{
			return selectable;
		}
		
		public function setSelectable(value:Boolean):void
		{
			selectable = value;
		}
		
		
		
		
		protected function installIcon(ic:Icon):void
		{
			if(ic != null && ic.getDisplay(this) != null)
			{
				addChild(ic.getDisplay(this));
			}
		}
		
		protected function uninstallIcon(ic:Icon):void
		{
			var iconDisplay:DisplayObject = (ic == null ? null : ic.getDisplay(this));
			
			if(iconDisplay != null && isChild(iconDisplay))
			{
				removeChild(iconDisplay);
			}
		}
		
		
		override public function getDefaultBasicUIClass():Class
		{
			return BasicLabelUI;
		}
		
		
		override protected function getDefaultUIClassID():String
		{
			return DefaultUI.LabelUI;
		}
		
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}