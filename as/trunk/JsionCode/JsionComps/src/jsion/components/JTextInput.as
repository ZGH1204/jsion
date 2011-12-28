package jsion.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import jsion.IntRectangle;
	import jsion.comps.CompGlobal;
	import jsion.comps.CompUtil;
	import jsion.comps.Component;
	import jsion.utils.DepthUtil;
	import jsion.utils.DisposeUtil;
	
	public class JTextInput extends Component
	{
		public static const BACKGROUND:String = CompGlobal.BACKGROUND;
		
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
		
		private var m_tf:TextField;
		
		public function JTextInput(container:DisplayObjectContainer=null, xPos:Number=0, yPos:Number=0)
		{
			super(container, xPos, yPos);
		}
		
		override protected function initResources():void
		{
			setStyle(HALIGN, LEFT);
			setStyle(VALIGN, MIDDLE);
		}
		
		override protected function addChildren():void
		{
			m_tf = new TextField();
			m_tf.type = TextFieldType.INPUT;
			m_tf.wordWrap = false;
			m_tf.multiline = false;
			m_tf.width = 80;
			m_tf.height = 25;
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
		
		override public function dispose():void
		{
			DisposeUtil.free(m_tf);
			m_tf = null;
			
			m_background = null;
			
			super.dispose();
		}
	}
}