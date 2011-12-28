package jsion.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	import jsion.comps.CompGlobal;
	import jsion.utils.DisposeUtil;
	
	public class JFrame extends JWindow
	{
		public static const BACKGROUND:String = CompGlobal.BACKGROUND;
		
		public static const HGAP:String = CompGlobal.HGAP;
		
		public static const LEFT:String = CompGlobal.LEFT;
		
		public static const RIGHT:String = CompGlobal.RIGHT;
		
		public static const CENTER:String = CompGlobal.CENTER;
		
		
		public static const VGAP:String = CompGlobal.VGAP;
		
		public static const TOP:String = CompGlobal.TOP;
		
		public static const BOTTOM:String = CompGlobal.BOTTOM;
		
		public static const MIDDLE:String = CompGlobal.MIDDLE;
		
		
		public static const UP_IMG:String = CompGlobal.UP_IMG;
		public static const OVER_IMG:String = CompGlobal.OVER_IMG;
		public static const DOWN_IMG:String = CompGlobal.DOWN_IMG;
		public static const DISABLED_IMG:String = CompGlobal.DISABLED_IMG;
		
		public static const UP_FILTERS:String = CompGlobal.UP_FILTERS;
		public static const OVER_FILTERS:String = CompGlobal.OVER_FILTERS;
		public static const DOWN_FILTERS:String = CompGlobal.DOWN_FILTERS;
		public static const DISABLED_FILTERS:String = CompGlobal.DISABLED_FILTERS;
		
		public static const LABEL_UP_FILTERS:String = CompGlobal.LABEL_UP_FILTERS;
		public static const LABEL_OVER_FILTERS:String = CompGlobal.LABEL_OVER_FILTERS;
		public static const LABEL_DOWN_FILTERS:String = CompGlobal.LABEL_DOWN_FILTERS;
		public static const LABEL_DISABLED_FILTERS:String = CompGlobal.LABEL_DISABLED_FILTERS;
		
		public static const HALIGN:String = CompGlobal.HALIGN;
		
		public static const VALIGN:String = CompGlobal.VALIGN;
		
		
		
		private var m_content:Sprite;
		
		private var m_contentOffsetX:Number;
		
		private var m_contentOffsetY:Number;
		
		
		public function JFrame(title:String="", container:DisplayObjectContainer=null, xPos:Number=0, yPos:Number=0)
		{
			m_contentOffsetX = 0;
			m_contentOffsetY = 0;
			
			super(title, container, xPos, yPos);
		}
		
		public function get content():Sprite
		{
			return m_content;
		}

		public function get contentOffsetX():Number
		{
			return m_contentOffsetX;
		}
		
		public function set contentOffsetX(value:Number):void
		{
			if(m_contentOffsetX != value)
			{
				m_contentOffsetX = value;
				
				invalidate();
			}
		}
		
		public function get contentOffsetY():Number
		{
			return m_contentOffsetY;
		}
		
		public function set contentOffsetY(value:Number):void
		{
			if(m_contentOffsetY != value)
			{
				m_contentOffsetY = value;
				
				invalidate();
			}
		}
		
		public function addToContent(child:DisplayObject):void
		{
			m_content.addChild(child);
		}
		
		override protected function addChildren():void
		{
			super.addChildren();
			
			m_content = new Sprite();
			addChild(m_content);
		}
		
		override public function draw():void
		{
			super.draw();
			
			m_content.x = m_contentOffsetX;
			
			if(titleBar.y < 0 && Math.abs(titleBar.y) > titleBar.realHeight)
			{
				m_content.y = m_contentOffsetY;
			}
			else
			{
				m_content.y = m_contentOffsetY + titleBar.y + titleBar.realHeight;
			}
		}
		
		override public function dispose():void
		{
			DisposeUtil.freeChildren(m_content);
			DisposeUtil.free(m_content);
			m_content = null;
			
			super.dispose();
		}
	}
}