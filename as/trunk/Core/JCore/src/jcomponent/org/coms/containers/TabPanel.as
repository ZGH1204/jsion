package jcomponent.org.coms.containers
{
	import flash.display.DisplayObject;
	
	import jcomponent.org.basic.Component;
	import jcomponent.org.basic.Container;
	import jcomponent.org.basic.DefaultConfigKeys;
	import jcomponent.org.basic.UIConstants;
	import jcomponent.org.coms.buttons.AbstractButton;
	import jcomponent.org.coms.buttons.ButtonGroup;
	
	public class TabPanel extends Container
	{
		public static const TOP:int = UIConstants.TOP;
		public static const MIDDLE:int = UIConstants.MIDDLE;//tabsDir属性不适用
		public static const BOTTOM:int = UIConstants.BOTTOM;
		
		public static const LEFT:int = UIConstants.LEFT;
		public static const CENTER:int = UIConstants.CENTER;//tabsDir属性不适用
		public static const RIGHT:int = UIConstants.RIGHT;
		
		protected var tabsList:Array = [];
		
		protected var tabBtnsList:Array = [];
		
		protected var panelsList:Array = [];
		
		protected var btnGround:ButtonGroup;
		
		protected var tabContainer:AbstractBox;
		
		protected var panelContainer:Container;
		
		protected var m_tabsDir:int;
		
		protected var m_tabsHGap:int;
		protected var m_tabsVGap:int;
		
		protected var m_tabsHAlign:int;
		protected var m_tabsVAlign:int;
		
		protected var m_tabsSplitGap:int;
		
		protected var m_tabAndPanelGap:int;
		
		public function TabPanel(tabDir:int = TOP, prefix:String=null, id:String=null)
		{
			m_tabsDir = tabDir;
			
			if(m_tabsDir == BOTTOM)
			{
				tabsHAlign = LEFT;
				tabsVAlign = TOP;
			}
			else if(m_tabsDir == LEFT)
			{
				tabsHAlign = RIGHT;
				tabsVAlign = TOP;
			}
			else if(m_tabsDir == RIGHT)
			{
				tabsHAlign = LEFT;
				tabsVAlign = TOP;
			}
			else
			{
				tabsHAlign = LEFT;
				tabsVAlign = BOTTOM;
			}
			
			init();
			
			super(prefix, id);
		}
		
		protected function init():void
		{
			layout = new TabPanelLayout();
			
			btnGround = new ButtonGroup();
			
			if(m_tabsDir == LEFT || m_tabsDir == RIGHT)
			{
				tabContainer = new VBox(m_tabsSplitGap);
			}
			else
			{
				tabContainer = new HBox(m_tabsSplitGap);
			}
			addChild(tabContainer);
			
			panelContainer = new Container();
			addChild(panelContainer);
		}
		
		override public function getUIDefaultBasicClass():Class
		{
			return BasicTabPanelUI;
		}
		
		override protected function getUIDefaultClassID():String
		{
			return DefaultConfigKeys.TabPanel_UI;
		}
		
		public function getTabContainerSize():IntDimension
		{
			if(tabContainer) return tabContainer.getSize();
			
			return new IntDimension();
		}
		
		public function setTabContainerLocation(xPos:int, yPos:int):void
		{
			if(tabContainer)
			{
				tabContainer.x = xPos;
				tabContainer.y = yPos;
			}
		}
		
		//TODO: 在加入Tab时需要计算对应的PanelContainer的最小Size，扣除间隔后的值。或者做个设置Panel大小（Size）的方法。
		public function getPanelContainerSize():IntDimension
		{
			if(panelContainer) return panelContainer.getSize();
			
			return new IntDimension();
		}
		
		public function setPanelContainerLocation(xPos:int, yPos:int):void
		{
			if(panelContainer)
			{
				panelContainer.x = xPos;
				panelContainer.y = yPos;
			}
		}
		
		internal var pSize:IntDimension = new IntDimension();
		
		public function addTab(tab:ITab):void
		{
			tabsList.push(tab);
			
			var tabBtn:AbstractButton = tab.getTabButton();
			tabBtnsList.push(tab.getTabButton());
			btnGround.append(tabBtn);
			tabContainer.addChild(tabBtn);
			
			var dis:DisplayObject = tab.getTabContent();
			panelsList.push(dis);
			panelContainer.addChild(dis);
			
			pSize.width = Math.max(pSize.width, dis.width);
			pSize.height = Math.max(pSize.height, dis.height);
		}
		
		public function get tabsDir():int
		{
			return m_tabsDir;
		}
		
		public function get tabsHAlign():int
		{
			return m_tabsHAlign;
		}
		
		public function set tabsHAlign(value:int):void
		{
			if(m_tabsHAlign != value)
			{
				m_tabsHAlign = value;
				
				if(tabsDir == LEFT || tabsDir == RIGHT) tabContainer.hAlign = m_tabsHAlign;
				else invalidate();
			}
		}
		
		public function get tabsVAlign():int
		{
			return m_tabsVAlign;
		}
		
		public function set tabsVAlign(value:int):void
		{
			if(m_tabsVAlign != value)
			{
				m_tabsVAlign = value;
				
				if(tabsDir == TOP || tabsDir == BOTTOM) tabContainer.vAlign = m_tabsVAlign;
				else invalidate();
			}
		}
		
		public function get tabsHGap():int
		{
			return m_tabsHGap;
		}
		
		public function set tabsHGap(value:int):void
		{
			if(m_tabsHGap != value)
			{
				m_tabsHGap = value;
				
				if(tabsDir == TOP || tabsDir == BOTTOM) tabContainer.gap = m_tabsHGap;
				else invalidate();
			}
		}
		
		public function get tabsVGap():int
		{
			return m_tabsVGap;
		}
		
		public function set tabsVGap(value:int):void
		{
			if(m_tabsVGap != value)
			{
				m_tabsVGap = value;
				
				if(tabsDir == LEFT || tabsDir == RIGHT) tabContainer.gap = m_tabsVGap;
				else invalidate();
			}
		}

		public function get tabsSplitGap():int
		{
			return m_tabsSplitGap;
		}

		public function set tabsSplitGap(value:int):void
		{
			if(m_tabsSplitGap != value)
			{
				m_tabsSplitGap = value;
				
				tabContainer.gap = m_tabsSplitGap;
			}
		}

		public function get tabAndPanelGap():int
		{
			return m_tabAndPanelGap;
		}

		public function set tabAndPanelGap(value:int):void
		{
			if(m_tabAndPanelGap != value)
			{
				m_tabAndPanelGap = value;
				
				invalidate();
			}
		}
	}
}