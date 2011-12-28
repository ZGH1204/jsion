package jsion.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import jsion.IntRectangle;
	import jsion.comps.CompGlobal;
	import jsion.comps.CompUtil;
	import jsion.comps.Component;
	import jsion.utils.DepthUtil;
	import jsion.utils.DisposeUtil;
	
	public class JTitleBar extends Component
	{
		public static const FONT:String = CompGlobal.FONT;
		
		public static const COLOR:String = CompGlobal.COLOR;
		
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
		
		
		private var m_window:JWindow;
		
		private var m_background:DisplayObject;
		
		private var m_title:String;
		
		private var m_label:JLabel;
		
		public function JTitleBar(window:JWindow, container:DisplayObjectContainer=null, xPos:Number=0, yPos:Number=0)
		{
			m_window = window;
			
			m_title = "";
			
			super(container, xPos, yPos);
		}
		
		public function setLabelStyle(key:String, value:*, freeBMD:Boolean = true):Object
		{
			invalidate();
			return m_label.setStyle(key, value, freeBMD);
		}
		
		public function get title():String
		{
			return m_title;
		}
		
		public function set title(value:String):void
		{
			if(m_title != value)
			{
				m_title = value;
				
				if(m_title == null) m_title = "";
				
				invalidate();
			}
		}
		
		override public function set width(value:Number):void
		{
			if(m_width != value)
			{
				m_window.invalidate();
			}
			
			super.width = value;
		}
		
		override public function set height(value:Number):void
		{
			if(m_height != value)
			{
				m_window.invalidate();
			}
			
			super.height = value;
		}
		
		override public function setSize(w:Number, h:Number):void
		{
			if(m_width != w || m_height != h)
			{
				m_window.invalidate();
			}
			
			super.setSize(w, h);
		}
		
		override protected function initResources():void
		{
			setStyle(HALIGN, CENTER);
			setStyle(VALIGN, MIDDLE);
		}
		
		override protected function addChildren():void
		{
			m_label = new JLabel();
			addChild(m_label);
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
			
			m_label.text = m_title;
			
			m_label.drawAtOnce();
			
			var hAlign:String = getString(HALIGN);
			var hGap:Number = getNumber(HGAP);
			var vAlign:String = getString(VALIGN);
			var vGap:Number = getNumber(VGAP);
			
			var rect:IntRectangle = new IntRectangle();
			rect.width = m_label.realWidth;
			rect.height = m_label.realHeight;
			CompUtil.layoutPosition(realWidth, realHeight, hAlign, hGap, vAlign, vGap, rect);
			
			m_label.move(rect.x, rect.y);
			
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
			DisposeUtil.free(m_label);
			m_label = null;
			
			m_window = null;
			m_background = null;
			
			super.dispose();
		}
	}
}