package jsion.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import jsion.comps.CompGlobal;
	import jsion.comps.Component;
	import jsion.comps.events.UIEvent;
	import jsion.utils.DepthUtil;
	import jsion.utils.DisposeUtil;
	
	public class JScrollPane extends Component
	{
		public static const BACKGROUND:String = CompGlobal.BACKGROUND;
		
		public static const UP_IMG:String = CompGlobal.UP_IMG;
		public static const OVER_IMG:String = CompGlobal.OVER_IMG;
		public static const DOWN_IMG:String = CompGlobal.DOWN_IMG;
		public static const DISABLED_IMG:String = CompGlobal.DISABLED_IMG;
		
		public static const UP_FILTERS:String = CompGlobal.UP_FILTERS;
		public static const OVER_FILTERS:String = CompGlobal.OVER_FILTERS;
		public static const DOWN_FILTERS:String = CompGlobal.DOWN_FILTERS;
		public static const DISABLED_FILTERS:String = CompGlobal.DISABLED_FILTERS;
		
		public static const OFFSET_X:String = CompGlobal.OFFSET_X;
		public static const OFFSET_Y:String = CompGlobal.OFFSET_Y;
		
		private var m_background:DisplayObject;
		
		private var m_panel:JPanel;
		
		private var m_view:DisplayObject;
		
		private var m_vScroll:JVScrollBar;
		
		public function JScrollPane(container:DisplayObjectContainer=null, xPos:Number=0, yPos:Number=0)
		{
			super(container, xPos, yPos);
		}
		
		public function setUpOrLeftStyle(key:String, value:*, freeBMD:Boolean = true):void
		{
			m_vScroll.setUpOrLeftStyle(key, value, freeBMD);
		}
		
		public function setDownOrRightStyle(key:String, value:*, freeBMD:Boolean = true):void
		{
			m_vScroll.setDownOrRightStyle(key, value, freeBMD);
		}
		
		public function setBarStyle(key:String, value:*, freeBMD:Boolean = true):void
		{
			m_vScroll.setBarStyle(key, value, freeBMD);
		}
		
		public function get view():DisplayObject
		{
			return m_view;
		}
		
		public function set view(value:DisplayObject):void
		{
			if(m_view != value)
			{
				if(m_view && m_view.parent) m_view.parent.removeChild(m_view);
				
				m_view = value;
				
				invalidate();
			}
		}
		
		public function get scrollValue():Number
		{
			return m_vScroll.scrollValue;
		}
		
		public function set scrollValue(value:Number):void
		{
			m_vScroll.scrollValue = value;
		}
		
		override protected function addChildren():void
		{
			m_panel = new JPanel();
			addChild(m_panel);
			
			m_vScroll = new JVScrollBar();
			addChild(m_vScroll);
		}
		
		override protected function initEvents():void
		{
			addEventListener(MouseEvent.MOUSE_WHEEL, __wheelHandler);
			m_vScroll.addEventListener(UIEvent.CHANGE, __changeHandler);
		}
		
		private function __wheelHandler(e:MouseEvent):void
		{
			if(e.delta > 0)
			{
				m_vScroll.scrollWheelUpOrLeft();
			}
			else
			{
				m_vScroll.scrollWheelDownOrRight();
			}
		}
		
		private function __changeHandler(e:UIEvent):void
		{
			if(m_view) m_view.y = -m_vScroll.scrollValue;
		}
		
		override public function draw():void
		{
			if(m_background == null)
			{
				m_background = getDisplayObject(BACKGROUND);
				addChild(m_background);
				DepthUtil.bringToBottom(m_background);
			}
			
			if(m_view)
			{
				m_panel.addChild(m_view);
				
				m_vScroll.viewSize = m_view.height;
			}
			else
			{
				m_vScroll.viewSize = 0;
			}
			
			m_vScroll.scrollSize = realHeight - 2 * getNumber(OFFSET_Y);
			m_vScroll.drawAtOnce();
			
			m_vScroll.x = realWidth - m_vScroll.realWidth - getNumber(OFFSET_X);
			m_vScroll.y = getNumber(OFFSET_Y);
			
			m_panel.x = getNumber(OFFSET_X);
			m_panel.y = getNumber(OFFSET_Y);
			
			m_panel.width = realWidth - m_vScroll.realWidth - 2 * getNumber(OFFSET_X);
			m_panel.height = realHeight - 2 * getNumber(OFFSET_Y);
			
			if(m_background)
			{
				m_background.width = realWidth;
				m_background.height = realHeight;
			}
			
			super.draw();
		}
		
		override public function dispose():void
		{
			removeEventListener(MouseEvent.MOUSE_WHEEL, __wheelHandler);
			if(m_vScroll) m_vScroll.removeEventListener(UIEvent.CHANGE, __changeHandler);
			
			DisposeUtil.free(m_view);
			m_view = null;
			
			DisposeUtil.free(m_panel);
			m_panel = null;
			
			DisposeUtil.free(m_vScroll);
			m_vScroll = null;
			
			m_background = null;
			
			super.dispose();
		}
	}
}