package jsion.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import jsion.comps.CompGlobal;
	import jsion.comps.Component;
	import jsion.utils.ArrayUtil;
	import jsion.utils.DepthUtil;
	
	public class JTabPane extends Component
	{
		public static const BACKGROUND:String = CompGlobal.BACKGROUND;
		
		public static const TOP:String = CompGlobal.TOP;
		public static const MIDDLE:String = CompGlobal.MIDDLE;//dir属性不适用
		public static const BOTTOM:String = CompGlobal.BOTTOM;
		
		public static const LEFT:String = CompGlobal.LEFT;
		public static const CENTER:String = CompGlobal.CENTER;//dir属性不适用
		public static const RIGHT:String = CompGlobal.RIGHT;
		
		private var m_tabs:Array;
		
		private var m_tabBtns:Array;
		
		private var m_tabPanes:Array;
		
		private var m_background:DisplayObject;
		
		private var m_btnBox:Component;
		
		private var m_paneContainer:Sprite;
		
		private var m_group:JToggleButtonGroup;
		
		
		
		private var m_currentIndex:int;
		
		private var m_hAlign:String;
		private var m_vAlign:String;
		
		private var m_btnSpacing:Number;
		
		private var m_offsetX:Number;
		private var m_offsetY:Number;
		
		private var m_padding:Number;
		
		
		
		private var m_dir:String;
		
		private var m_curTabPane:DisplayObject;
		
		public function JTabPane(dir:String = TOP, container:DisplayObjectContainer=null, xPos:Number=0, yPos:Number=0)
		{
			m_dir = dir;
			
			m_vAlign = TOP;
			m_hAlign = LEFT;
			
			m_currentIndex = -1;
			
			m_padding = 0;
			m_btnSpacing = 0;
			
			m_offsetX = 0;
			m_offsetY = 0;
			
			m_tabs = [];
			
			m_tabBtns = [];
			
			m_tabPanes = [];
			
			m_group = new JToggleButtonGroup();
			
			super(container, xPos, yPos);
		}
		
		public function get padding():Number
		{
			return m_padding;
		}
		
		public function set padding(value:Number):void
		{
			if(m_padding != value)
			{
				m_padding = value;
				
				invalidate();
			}
		}
		
		public function get hAlign():String
		{
			return m_hAlign;
		}
		
		public function set hAlign(value:String):void
		{
			if(m_hAlign != value)
			{
				m_hAlign = value;
				
				invalidate();
			}
		}
		
		public function get vAlign():String
		{
			return m_vAlign;
		}
		
		public function set vAlign(value:String):void
		{
			if(m_vAlign != value)
			{
				m_vAlign = value;
				
				invalidate();
			}
		}
		
		public function get btnSpacing():Number
		{
			return m_btnSpacing;
		}
		
		public function set btnSpacing(value:Number):void
		{
			if(m_btnSpacing != value)
			{
				m_btnSpacing = value;
				
				invalidate();
			}
		}
		
		public function get offsetX():Number
		{
			return m_offsetX;
		}
		
		public function set offsetX(value:Number):void
		{
			if(m_offsetX != value)
			{
				m_offsetX = value;
				
				invalidate();
			}
		}
		
		public function get offsetY():Number
		{
			return m_offsetY;
		}
		
		public function set offsetY(value:Number):void
		{
			if(m_offsetY != value)
			{
				m_offsetY = value;
				
				invalidate();
			}
		}
		public function get currentIndex():int
		{
			return m_currentIndex;
		}
		
		public function set currentIndex(value:int):void
		{
			if(m_currentIndex != value && value >= 0)
			{
				m_currentIndex = value;
				
				m_group.selected = m_tabBtns[m_currentIndex];
				
				var tab:ITab = m_tabs[m_currentIndex] as ITab;
				
				var content:DisplayObject;
				
				if(m_tabPanes[m_currentIndex] == null)
				{
					content = tab.getTabPane();
					m_tabPanes[m_currentIndex] = content;
				}
				else
				{
					content = m_tabPanes[m_currentIndex]
				}
				
				if(m_curTabPane) m_curTabPane.parent.removeChild(m_curTabPane);
				
				m_curTabPane = content;
				m_paneContainer.addChild(m_curTabPane);
				safeDrawAtOnceByDisplay(m_curTabPane);
				
				tab.onShowPane();
			}
		}
		
		public function setActiveTab(index:int):void
		{
			currentIndex = index;
		}
		
		public function addTab(tab:ITab):void
		{
			if(tab == null) return;
			
			var index:int = ArrayUtil.push(m_tabs, tab);
			
			if(index > -1)
			{
				var btn:JToggleButton = tab.getTabButton();
				btn.drawAtOnce();
				btn.pack();
				m_group.add(btn);
				m_tabBtns.push(btn);
				m_tabPanes.push(null);
				m_btnBox.addChild(btn);
				
				btn.addEventListener(MouseEvent.CLICK, __clickHandler);
			}
		}
		
		private function __clickHandler(e:MouseEvent):void
		{
			currentIndex = m_tabBtns.indexOf(e.currentTarget);
		}
		
		override protected function addChildren():void
		{
			m_paneContainer = new Sprite();
			addChild(m_paneContainer);
			
			if(m_dir == LEFT || m_dir == RIGHT)
			{
				m_btnBox = new JVBox();
			}
			else
			{
				m_btnBox = new JHBox();
			}
			addChild(m_btnBox);
		}
		
		override public function draw():void
		{
			if(m_background == null)
			{
				m_background = getDisplayObject(BACKGROUND);
				addChild(m_background);
				DepthUtil.bringToBottom(m_background);
				safeDrawAtOnceByDisplay(m_background);
			}
			
			drawButtonBox();
			
			updatePosition();
			
			if(m_background)
			{
				m_background.width = realWidth;
				m_background.height = realHeight;
				safeDrawAtOnceByDisplay(m_background);
			}
			
			super.draw();
		}
		
		private function drawButtonBox():void
		{
			if(m_dir == LEFT || m_dir == RIGHT)
			{
				JVBox(m_btnBox).spacing = m_btnSpacing;
				
				if(m_dir == LEFT)
				{
					JVBox(m_btnBox).align = JVBox.RIGHT;
				}
				else
				{
					JVBox(m_btnBox).align = JVBox.LEFT;
				}
			}
			else
			{
				JHBox(m_btnBox).spacing = m_btnSpacing;
				
				if(m_dir == BOTTOM)
				{
					JHBox(m_btnBox).align = JHBox.TOP;
				}
				else
				{
					JHBox(m_btnBox).align = JHBox.BOTTOM;
				}
			}
			
			m_btnBox.drawAtOnce();
		}
		
		private function updatePosition():void
		{
			if(m_dir == LEFT || m_dir == RIGHT)
			{
				if(m_vAlign == BOTTOM)
				{
					m_btnBox.y = realHeight - m_btnBox.realHeight - m_offsetY;
				}
				else if(m_vAlign == MIDDLE)
				{
					m_btnBox.y = (realHeight - m_btnBox.realHeight) / 2 + m_offsetY;
				}
				else
				{
					m_btnBox.y = m_offsetY;
				}
				
				if(m_dir == LEFT)
				{
					m_btnBox.x = m_offsetX;
					m_paneContainer.x = m_btnBox.x + m_btnBox.realWidth + m_padding;
					m_paneContainer.y = m_offsetY;
				}
				else
				{
					m_btnBox.x = realWidth - m_btnBox.realWidth - m_offsetX;
					m_paneContainer.x = 0;
					m_paneContainer.y = m_offsetY;
				}
			}
			else
			{
				m_btnBox.drawAtOnce();
				
				if(m_hAlign == RIGHT)
				{
					m_btnBox.x = realWidth - m_btnBox.realWidth - m_offsetX;
				}
				else if(m_hAlign == CENTER)
				{
					m_btnBox.x = (realWidth - m_btnBox.realWidth) / 2 + m_offsetX;
				}
				else
				{
					m_btnBox.x = m_offsetX;
				}
				
				if(m_dir == BOTTOM)
				{
					m_btnBox.y = realHeight - m_btnBox.realHeight - m_offsetY;
					m_paneContainer.x = m_offsetX;
					m_paneContainer.y = 0;
				}
				else
				{
					m_btnBox.y = m_offsetY;
					m_paneContainer.x = m_offsetX;
					m_paneContainer.y = m_btnBox.y + m_btnBox.realHeight + m_padding;
				}
			}
		}
	}
}