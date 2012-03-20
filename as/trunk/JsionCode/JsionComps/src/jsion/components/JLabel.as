package jsion.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
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
		
		public function JLabel(text:String = "", container:DisplayObjectContainer=null, xPos:Number=0, yPos:Number=0)
		{
			m_text = text;
			
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
			width = 20;
			height = 18;
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
			
			m_tf.text = m_text;
			
			var font:ASFont = getFont(FONT);
			if(font) font.apply(m_tf);
			
			var color:ASColor = getColor(COLOR);
			if(color) m_tf.textColor = color.getRGB();
			
			if(getBoolean(AUTO_SIZE))
			{
				m_tf.autoSize = TextFieldAutoSize.LEFT;
				if(width <= 0) width = m_tf.width;
				if(height <= 0) height = m_tf.height;
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
		
		public function get textField():TextField
		{
			return m_tf;
		}
		
		override public function dispose():void
		{
			DisposeUtil.free(m_tf);
			m_tf = null;
			
			super.dispose();
		}
	}
}