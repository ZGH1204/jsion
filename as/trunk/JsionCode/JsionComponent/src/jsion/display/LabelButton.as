package jsion.display
{
	import flash.geom.Rectangle;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	
	import jsion.comps.CompGlobal;
	import jsion.comps.CompUtil;
	import jsion.comps.Component;
	import jsion.utils.StringUtil;

	/**
	 * 支持文字显示的图片按钮。支持滤镜。
	 * 使用 jsion.display.Image 可支持九宫格缩放。
	 * @see jsion.display.Image
	 * @author Jsion
	 * 
	 */	
	public class LabelButton extends Button
	{
		public static const LABELALIGN:String = "labelAlign";
		public static const LABELFILTERS:String = "labelFilters";
//		public static const LABELOFFSET:String = "labelOffset";
		
		/**
		 * 水平左边对齐，用于 hAlign 属性。
		 */		
		public static const LEFT:String = CompGlobal.LEFT;
		
		/**
		 * 水平右边对齐，用于 hAlign 属性。
		 */		
		public static const RIGHT:String = CompGlobal.RIGHT;
		
		/**
		 * 水平居中对齐，用于 hAlign 属性。
		 */		
		public static const CENTER:String = CompGlobal.CENTER;
		
		/**
		 * 垂直顶边对齐，用于 vAlign 属性。
		 */		
		public static const TOP:String = CompGlobal.TOP;
		
		/**
		 * 垂直底边对齐，用于 vAlign 属性。
		 */		
		public static const BOTTOM:String = CompGlobal.BOTTOM;
		
		/**
		 * 垂直居中对齐，用于 vAlign 属性。
		 */		
		public static const MIDDLE:String = CompGlobal.MIDDLE;
		
		
		private var m_text:String;
		private var m_textColor:uint;
		
		/** @private */
		protected var m_label:Label;
		/** @private */
		protected var m_labelChange:Boolean;
		
		/** @private */
		protected var m_hAlign:String;
		/** @private */
		protected var m_hOffset:int;
		/** @private */
		protected var m_vAlign:String;
		/** @private */
		protected var m_vOffset:int;
		
		/** @private */
		protected var m_labelCurFilters:Array;
		
		private var m_labelUpFilters:Array;
		private var m_labelOverFilters:Array;
		private var m_labelDownFilters:Array;
		private var m_labelDisableFilters:Array;
		
//		private var m_labelOffsetX:Number = 0;
//		private var m_labelOffsetY:Number = 0;
//		private var m_labelOverOffsetX:Number = 0;
//		private var m_labelOverOffsetY:Number = 0;
//		private var m_labelDownOffsetX:Number = 0;
//		private var m_labelDownOffsetY:Number = 0;
		
		/** @private */
		protected var m_rect:Rectangle;
		
		public function LabelButton()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function initialize():void
		{
			super.initialize();
			
			m_rect = new Rectangle();
			
			m_label = new Label();
			
			m_labelChange = false;
			
			m_hAlign = CENTER;
			m_vAlign = MIDDLE;
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function addChildren():void
		{
			super.addChildren();
			
			addChild(m_label);
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function beginChanges():void
		{
			m_label.beginChanges();
			super.beginChanges();
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function commitChanges():void
		{
			m_label.commitChanges();
			super.commitChanges();
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function onProppertiesUpdate():void
		{
			updateLabel();
			
			if(StringUtil.isNullOrEmpty(m_text) == false || m_labelChange)
			{
				validateSize();
			}
			
			if(m_labelChange || m_stateChange || 
				m_changeProperties.containsKey(LABELALIGN) || 
				m_changeProperties.containsKey(WIDTH) || 
				m_changeProperties.containsKey(HEIGHT) || 
				m_changeProperties.containsKey(OFFSET))
			{
				updateLabelPos();
			}
			
			if(m_changeProperties.containsKey(LABELFILTERS) || m_stateChange)
			{
				updateLabelFilters();
			}
			
			super.onProppertiesUpdate();
		}
		
		/**
		 * 更新要显示的文本字符串到 Label 对象上
		 */		
		protected function updateLabel():void
		{
			m_label.textColor = m_textColor;
			
			m_label.text = m_text;
		}
		
		/**
		 * 检查并更新按钮文本是否大于按钮本身
		 */		
		protected function validateSize():void
		{
			if(m_width < m_label.width)
			{
				m_width = m_label.width;
				
				m_changeProperties.put(Component.WIDTH, true);
			}
			
			if(m_height < m_label.height)
			{
				m_height = m_label.height;
				
				m_changeProperties.put(Component.HEIGHT, true);
			}
		}
		
		/**
		 * 更新文本位置
		 */		
		protected function updateLabelPos():void
		{
			m_label.x = m_label.y = 0;
			
			m_rect.width = m_label.width;
			m_rect.height = m_label.height;
			
			CompUtil.layoutPosition(width, height, m_hAlign, m_hOffset, m_vAlign, m_vOffset, m_rect);
			
			if(model.pressed)
			{
				m_rect.x += m_downOffsetX;
				m_rect.y += m_downOffsetY;
			}
			else if(model.rollOver)
			{
				m_rect.x += m_overOffsetX;
				m_rect.y += m_overOffsetY;
			}
			else
			{
				m_rect.x += m_offsetX;
				m_rect.y += m_offsetY;
			}
			
			m_label.x = m_rect.x;
			m_label.y = m_rect.y;
		}
		
		/**
		 * 根据按钮状态更新文本滤镜
		 */		
		protected function updateLabelFilters():void
		{
			var filters:Array;
			var tmpFilters:Array;
			
			filters = m_labelUpFilters;
			
			if(model.enabled == false)
			{
				tmpFilters = m_labelDisableFilters;
			}
			else if(model.pressed)
			{
				tmpFilters = m_labelDownFilters;
			}
			else if(model.rollOver)
			{
				tmpFilters = m_labelOverFilters;
			}
			
			if(tmpFilters != null)
			{
				filters = tmpFilters;
			}
			
			if(filters != m_labelCurFilters)
			{
				m_labelCurFilters = filters;
			}
			
			m_label.filters = m_labelCurFilters;
		}
		
		//==========================	Label组件属性	==========================
		
		/**
		 * @copy jsion.display.Label#text
		 */		
		public function get label():String
		{
			return m_text;
		}
		
		/** @private */
		public function set label(value:String):void
		{
			if(m_text != value && StringUtil.isNotNullOrEmpty(value))
			{
				m_text = value;
				
				m_labelChange = true;
				
				invalidate();
			}
		}
		
		/**
		 * @copy jsion.display.Label#textColor
		 */		
		public function get labelColor():uint
		{
			return m_textColor;
		}
		
		/** @private */
		public function set labelColor(value:uint):void
		{
			if(m_textColor != value)
			{
				m_textColor = value;
				
				m_labelChange = true;
				
				invalidate();
			}
		}
		
		/**
		 * @copy jsion.display.Label#html
		 */		
		public function get html():Boolean
		{
			return m_label.html;
		}
		
		/** @private */
		public function set html(value:Boolean):void
		{
			if(m_label.html != value)
			{
				m_label.html = value;
				
				m_labelChange = true;
				
				invalidate();
			}
		}
		
		/**
		 * @copy jsion.display.Label#embedFonts
		 */		
		public function get embedFonts():Boolean
		{
			return m_label.embedFonts;
		}
		
		/** @private */
		public function set embedFonts(value:Boolean):void
		{
			if(m_label.embedFonts != value)
			{
				m_label.embedFonts = value;
				
				m_labelChange = true;
				
				invalidate();
			}
		}
		
		/**
		 * @copy jsion.display.Label#textFormat
		 */		
		public function get textFormat():TextFormat
		{
			return m_label.textFormat;
		}
		
		/** @private */
		public function set textFormat(value:TextFormat):void
		{
			m_label.textFormat = value;
			
			m_labelChange = true;
			
			invalidate();
		}
		
		/**
		 * @copy jsion.display.Label#styleSheet
		 */		
		public function get styleSheet():StyleSheet
		{
			return m_label.styleSheet;
		}
		
		/** @private */
		public function set styleSheet(value:StyleSheet):void
		{
			m_label.styleSheet = value;
			
			m_labelChange = true;
			
			invalidate();
		}
		
		/**
		 * @copy jsion.display.Label#parseCSS()
		 */		
		public function parseCSS(cssText:String):StyleSheet
		{
			var style:StyleSheet = m_label.parseCSS(cssText);
			
			m_labelChange = true;
			
			invalidate();
			
			return style;
		}
		
		
		//==========================	Label组件属性	==========================

		/**
		 * 获取或设置水平偏移量
		 */		
		public function get hOffset():int
		{
			return m_hOffset;
		}
		
		/** @private */
		public function set hOffset(value:int):void
		{
			if(m_hOffset != value)
			{
				m_hOffset = value;
				
				onPropertiesChanged(LABELALIGN);
			}
		}

		/**
		 * 获取或设置水平对齐方式
		 * @default jsion.display.LabelButton.CENTER
		 * @see jsion.display.LabelButton#vAlign
		 * @throws Error 水平对齐方式错误。
		 */		
		public function get hAlign():String
		{
			return m_hAlign;
		}
		
		/** @private */
		public function set hAlign(value:String):void
		{
			if(m_hAlign != value)
			{
				if(value == LEFT || value == RIGHT || value == CENTER)
				{
					throw new Error("水平对齐方式错误。");
					return;
				}
				
				m_hAlign = value;
				
				onPropertiesChanged(LABELALIGN);
			}
		}

		/**
		 * 获取或设置垂直偏移量
		 */		
		public function get vOffset():int
		{
			return m_vOffset;
		}
		
		/** @private */
		public function set vOffset(value:int):void
		{
			if(m_vOffset != value)
			{
				m_vOffset = value;
				
				onPropertiesChanged(LABELALIGN);
			}
		}
		
		/**
		 * 获取或设置垂直对齐方式
		 * @default jsion.display.LabelButton.MIDDLE
		 * @see jsion.display.LabelButton#hAlign
		 * @throws Error 垂直对齐方式错误。
		 */		
		public function get vAlign():String
		{
			return m_vAlign;
		}
		
		/** @private */
		public function set vAlign(value:String):void
		{
			if(m_vAlign != value)
			{
				if(value == TOP || value == BOTTOM || value == MIDDLE)
				{
					throw new Error("垂直对齐方式错误。");
					return;
				}
				
				m_vAlign = value;
				
				onPropertiesChanged(LABELALIGN);
			}
		}
		
		/**
		 * 按钮弹起时 Label 对象的滤镜对象
		 */		
		public function get labelUpFilters():Array
		{
			return m_labelUpFilters;
		}
		
		/** @private */
		public function set labelUpFilters(value:Array):void
		{
			if(m_labelUpFilters != value)
			{
				m_labelUpFilters = value;
				
				onPropertiesChanged(LABELFILTERS);
			}
		}
		
		/**
		 * 按钮鼠标经过时 Label 对象的滤镜对象
		 */		
		public function get labelOverFilters():Array
		{
			return m_labelOverFilters;
		}
		
		/** @private */
		public function set labelOverFilters(value:Array):void
		{
			if(m_labelOverFilters != value)
			{
				m_labelOverFilters = value;
				
				onPropertiesChanged(LABELFILTERS);
			}
		}
		
		/**
		 * 按钮按下时 Label 对象的滤镜对象
		 */		
		public function get labelDownFilters():Array
		{
			return m_labelDownFilters;
		}
		
		/** @private */
		public function set labelDownFilters(value:Array):void
		{
			if(m_labelDownFilters != value)
			{
				m_labelDownFilters = value;
				
				onPropertiesChanged(LABELFILTERS);
			}
		}
		
		/**
		 * 按钮禁用时 Label 对象的滤镜对象
		 */		
		public function get labelDisableFilters():Array
		{
			return m_labelDisableFilters;
		}
		
		/** @private */
		public function set labelDisableFilters(value:Array):void
		{
			if(m_labelDisableFilters != value)
			{
				m_labelDisableFilters = value;
				
				onPropertiesChanged(LABELFILTERS);
			}
		}
		
//		/**
//		 * 按钮文本的x坐标偏移量
//		 */		
//		public function get labelOffsetX():Number
//		{
//			return m_labelOffsetX;
//		}
//		
//		/** @private */
//		public function set labelOffsetX(value:Number):void
//		{
//			if(m_labelOffsetX != value)
//			{
//				m_labelOffsetX = value;
//				
//				onPropertiesChanged(LABELOFFSET);
//			}
//		}
//		
//		/**
//		 * 按钮文本的y坐标偏移量
//		 */		
//		public function get labelOffsetY():Number
//		{
//			return m_labelOffsetY;
//		}
//		
//		/** @private */
//		public function set labelOffsetY(value:Number):void
//		{
//			if(m_labelOffsetY != value)
//			{
//				m_labelOffsetY = value;
//				
//				onPropertiesChanged(LABELOFFSET);
//			}
//		}
//
//		/**
//		 * 按钮鼠标经过时文本的x坐标偏移量
//		 */		
//		public function get labelOverOffsetX():Number
//		{
//			return m_labelOverOffsetX;
//		}
//		
//		/** @private */
//		public function set labelOverOffsetX(value:Number):void
//		{
//			if(m_labelOverOffsetX != value)
//			{
//				m_labelOverOffsetX = value;
//				
//				onPropertiesChanged(LABELOFFSET);
//			}
//		}
//		
//		/**
//		 * 按钮鼠标经过时文本的y坐标偏移量
//		 */		
//		public function get labelOverOffsetY():Number
//		{
//			return m_labelOverOffsetY;
//		}
//		
//		/** @private */
//		public function set labelOverOffsetY(value:Number):void
//		{
//			if(m_labelOverOffsetY != value)
//			{
//				m_labelOverOffsetY = value;
//				
//				onPropertiesChanged(LABELOFFSET);
//			}
//		}
//		
//		/**
//		 * 按钮按下经过时文本的x坐标偏移量
//		 */		
//		public function get labelDownOffsetX():Number
//		{
//			return m_labelDownOffsetX;
//		}
//		
//		/** @private */
//		public function set labelDownOffsetX(value:Number):void
//		{
//			if(m_labelDownOffsetX != value)
//			{
//				m_labelDownOffsetX = value;
//				
//				onPropertiesChanged(LABELOFFSET);
//			}
//		}
//		
//		/**
//		 * 按钮按下经过时文本的y坐标偏移量
//		 */		
//		public function get labelDownOffsetY():Number
//		{
//			return m_labelDownOffsetY;
//		}
//		
//		/** @private */
//		public function set labelDownOffsetY(value:Number):void
//		{
//			if(m_labelDownOffsetY != value)
//			{
//				m_labelDownOffsetY = value;
//				
//				onPropertiesChanged(LABELOFFSET);
//			}
//		}
		
		
		/**
		 * @inheritDoc
		 */		
		override public function dispose():void
		{
			m_label = null;
			m_labelUpFilters = null;
			m_labelOverFilters = null;
			m_labelDownFilters = null;
			m_labelDisableFilters = null;
			m_labelCurFilters = null;
			m_rect = null;
			
			super.dispose();
		}
	}
}