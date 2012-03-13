package jsion.components
{
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import jsion.comps.ASColor;
	import jsion.comps.ASFont;
	import jsion.comps.CompGlobal;
	import jsion.comps.Component;
	import jsion.comps.Style;
	import jsion.utils.DisposeUtil;
	
	public class JLabel extends Component
	{
		public static const FONT:String = CompGlobal.FONT;
		
		public static const COLOR:String = CompGlobal.COLOR;
		
		public static const AUTO_SIZE:String = CompGlobal.AUTO_SIZE;
		
		public static const LABEL_FILTERS:String = CompGlobal.LBAEL_FILTERS;
		
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
			m_tf.text = m_text;
			
			var font:ASFont = getFont(FONT);
			if(font) font.apply(m_tf);
			
			var color:ASColor = getColor(COLOR);
			if(color) m_tf.textColor = color.getRGB();
			
			if(getBoolean(AUTO_SIZE))
			{
				m_tf.autoSize = TextFieldAutoSize.LEFT;
				width = m_tf.width;
				height = m_tf.height;
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