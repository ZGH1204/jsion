package jsion.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import jsion.IntRectangle;
	import jsion.comps.ASColor;
	import jsion.comps.ASFont;
	import jsion.comps.CompGlobal;
	import jsion.comps.CompUtil;
	import jsion.comps.Component;
	import jsion.comps.Style;
	import jsion.utils.DepthUtil;
	import jsion.utils.DisposeUtil;
	
	public class JLabel extends Component
	{
		public static const BACKGROUND:String = CompGlobal.BACKGROUND;
		
		public static const FONT:String = CompGlobal.FONT;
		
		public static const COLOR:String = CompGlobal.COLOR;
		
		public static const AUTO_SIZE:String = CompGlobal.AUTO_SIZE;
		
		public static const LABEL_FILTERS:String = CompGlobal.LBAEL_FILTERS;
		
		
		public static const HALIGN:String = CompGlobal.HALIGN;
		
		public static const HGAP:String = CompGlobal.HGAP;
		
		public static const LEFT:String = CompGlobal.LEFT;
		
		public static const RIGHT:String = CompGlobal.RIGHT;
		
		public static const CENTER:String = CompGlobal.CENTER;
		
		
		public static const VALIGN:String = CompGlobal.VALIGN;
		
		public static const VGAP:String = CompGlobal.VGAP;
		
		public static const TOP:String = CompGlobal.TOP;
		
		public static const BOTTOM:String = CompGlobal.BOTTOM;
		
		public static const MIDDLE:String = CompGlobal.MIDDLE;
		
		
		private var m_background:DisplayObject;
		
		private var m_text:String;
		
		private var m_tf:TextField;
		
		private var m_html:Boolean;
		
		private var m_style:StyleSheet;
		
		public function JLabel(text:String = "", container:DisplayObjectContainer=null, xPos:Number=0, yPos:Number=0)
		{
			m_text = text;
			
			m_html = false;
			
			super(container, xPos, yPos);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			mouseEnabled = false;
			mouseEnabled = false;
		}
		
		override protected function initResources():void
		{
			setStyle(AUTO_SIZE, true);
			setStyle(HALIGN, CENTER);
			setStyle(VALIGN, MIDDLE);
		}
		
		override protected function addChildren():void
		{
//			width = 20;
//			height = 18;
			m_tf = new TextField();
			m_tf.width = width;
			m_tf.height = height;
			m_tf.embedFonts = Style.embedFonts;
			m_tf.selectable = false;
			m_tf.mouseEnabled = false;
			Style.DEFAULT_FONT.apply(m_tf);
			m_tf.text = m_text;
			addChild(m_tf);
		}
		
		override public function draw():void
		{
			if(m_background == null)
			{
				m_background = getDisplayObject(BACKGROUND);
				addChild(m_background);
				DepthUtil.bringToBottom(m_background);
				safeDrawAtOnceByDisplay(m_background);
				
				if(m_background)
				{
					if(m_width <= 0) m_width = m_background.width;
					if(m_height <= 0) m_height = m_background.height;
				}
			}
			
			if(m_tf.styleSheet != null) m_tf.styleSheet = null;
			
			var font:ASFont = getFont(FONT);
			if(font) font.apply(m_tf);
			
			var color:ASColor = getColor(COLOR);
			if(color) m_tf.textColor = color.getRGB();
			
			if(m_html)
			{
				m_tf.htmlText = m_text;
			}
			else
			{
				m_tf.text = m_text;
			}
			
			if(getBoolean(AUTO_SIZE))
			{
				m_tf.autoSize = TextFieldAutoSize.LEFT;
				if(width <= 0 || width < m_tf.width) width = m_tf.width;
				if(height <= 0 || height < m_tf.height) height = m_tf.height;
			}
			else
			{
				m_tf.autoSize = TextFieldAutoSize.NONE;
				m_tf.width = width;
				m_tf.height = height;
			}
			
			var list:Array = getArray(LABEL_FILTERS);
			
			if(list)
			{
				m_tf.filters = list;
			}
			
			if(m_style != null) m_tf.styleSheet = m_style;
			
			var hAlign:String = getString(HALIGN);
			var vAlign:String = getString(VALIGN);
			var hGap:Number = getNumber(HGAP);
			var vGap:Number = getNumber(VGAP);
			
			if(hAlign == CENTER)
			{
				m_tf.width = realWidth - 2 * hGap;
			}
			else
			{
				m_tf.width = realWidth - hGap;
			}
			
			if(vAlign == MIDDLE)
			{
				m_tf.height = realHeight - 2 * vGap;
			}
			else
			{
				m_tf.height = realHeight - vGap;
			}
			
			m_tf.x = m_tf.y = 0;
			
			var rect:IntRectangle = new IntRectangle();
			rect.width = m_tf.width;
			rect.height = m_tf.height;
			
			CompUtil.layoutPosition(realWidth, realHeight, hAlign, hGap, vAlign, vGap, rect);
			
			m_tf.x = rect.x;
			m_tf.y = rect.y;
			
			if(m_background)
			{
				m_background.width = realWidth;
				m_background.height = realHeight;
				safeDrawAtOnceByDisplay(m_background);
			}
			
			
			super.draw();
		}
		
		public function get html():Boolean
		{
			return m_html;
		}
		
		public function set html(value:Boolean):void
		{
			if(m_html != value)
			{
				m_html = value;
				
				invalidate();
			}
		}

		public function get text():String
		{
			return m_text;
		}
		
		public function set text(value:String):void
		{
			if(m_text != value)
			{
				m_text = value;
				
				if(m_text == null) m_text = "";
				
				invalidate();
			}
		}
		
		public function get style():StyleSheet
		{
			return m_style;
		}
		
		public function set style(value:StyleSheet):void
		{
			m_style = value;
			
			invalidate();
		}

		public function get textField():TextField
		{
			return m_tf;
		}
		
		public function parseCSS(cssText:String):void
		{
			if(m_style == null)
			{
				m_style = new StyleSheet();
			}
			
			
			m_style..parseCSS(cssText);
			
			invalidate();
		}
		
		override public function dispose():void
		{
			if(m_tf) m_tf.styleSheet = null;
			
			DisposeUtil.free(m_tf);
			m_tf = null;
			
			m_style = null;
			
			super.dispose();
		}


	}
}