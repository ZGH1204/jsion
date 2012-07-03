package jsion.display
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import jsion.comps.CompGlobal;
	import jsion.comps.Component;
	import jsion.comps.ToggleGroup;
	import jsion.events.DisplayEvent;
	import jsion.utils.ArrayUtil;
	import jsion.utils.DisposeUtil;
	
	/**
	 * 面板被创建时发生,事件数据为被创建的面板对象引用。
	 * @eventType jsion.events.DisplayEvent
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 */	
	[Event(name="panelCreated", type="jsion.events.DisplayEvent")]
	
	/**
	 * 当开启 autoFreePanel 属性，在上一个面板被释放前发生，事件数据为即将被释放的面板对象引用。
	 * @eventType jsion.events.DisplayEvent
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 */	
	[Event(name="panelFree", type="jsion.events.DisplayEvent")]
	
	/**
	 * 当前选中的标签面板变更时发生，事件数据为变更后的面板对象引用。
	 * @eventType jsion.events.DisplayEvent
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 */	
	[Event(name="panelActiveChanged", type="jsion.events.DisplayEvent")]
	
	/**
	 * 标签面板组。
	 * 当标签按钮在上面，靠左对齐时，可以不设置宽度和高度；其他的都需要设置其宽度和高度。
	 * 支持 jsion.display.ITabPanel 回调接口。
	 * @see jsion.display.ITabPanel
	 * @author Jsion
	 */	
	public class TabPanel extends Component
	{
		/**
		 * 宽度属性变更
		 */		
		public static const WIDTH:String = Component.WIDTH;
		/**
		 * 高度属性变更
		 */		
		public static const HEIGHT:String = Component.HEIGHT;
		/**
		 * 增加标签、面板。
		 */		
		public static const ADDTAB:String = "addTab";
		/**
		 * 标签按钮间隔发生变更
		 */		
		public static const TABGAP:String = "tabGap";
		/**
		 * 标签按钮对齐方式发生变更
		 */		
		public static const TABALIGN:String = "tabAlign";
		/**
		 * 标签按钮共同偏移量发生变更
		 */		
		public static const TABOFFSET:String = "tabOffset";
		/**
		 * 标签按钮显示方位发生变更
		 */		
		public static const TABPOSTYPE:String = "tabPosType";
		/**
		 * 面板相对于标签按钮的偏移量发生变更
		 */		
		public static const PANEOFFSET:String = "paneOffset";
		
		
		/**
		 * 上边，用于构造函数参数。
		 */		
		public static const UP:String = CompGlobal.UP;
		
		/**
		 * 下边，用于构造函数参数。
		 */		
		public static const DOWN:String = CompGlobal.DOWN;
		
		/**
		 * 左边/水平左边对齐，用于构造函数参数、tabAlign 属性。
		 */		
		public static const LEFT:String = CompGlobal.LEFT;
		
		/**
		 * 右边/水平右边对齐，用于构造函数参数、tabAlign 属性。
		 */		
		public static const RIGHT:String = CompGlobal.RIGHT;
		
		/**
		 * 水平居中对齐，用于 tabAlign 属性。
		 */		
		public static const CENTER:String = CompGlobal.CENTER;
		
		/**
		 * 垂直顶部对齐，用于 tabAlign 属性
		 */		
		public static const TOP:String = CompGlobal.TOP;
		
		/**
		 * 垂直底部对齐，用于 tabAlign 属性
		 */		
		public static const BOTTOM:String = CompGlobal.BOTTOM;
		
		/**
		 * 垂直中间对齐，用于 tabAlign 属性
		 */		
		public static const MIDDLE:String = CompGlobal.MIDDLE;
		
		private var m_tabPosType:String;
		
		private var m_group:ToggleGroup;
		
		private var m_buttons:Array;
		
		private var m_paneClasses:Array;
		
		private var m_panels:Array;
		
		private var m_btnContainer:Sprite;
		
		private var m_paneContainer:Sprite;
		
		private var m_tabGap:int;
		
		private var m_tabAlign:String;
		
		private var m_tabOffset:int;
		
		private var m_paneOffset:int;
		
		private var m_curPane:DisplayObject;
		
		private var m_autoFreePane:Boolean;
		
		private var m_selectedIndex:int;
		
		public function TabPanel(tabPosType:String = "up")
		{
			m_tabPosType = tabPosType;
			
			if(m_tabPosType == UP || m_tabPosType == DOWN)
			{
				m_tabAlign = LEFT;
			}
			else
			{
				m_tabAlign = TOP;
			}
			
			super();
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function initialize():void
		{
			super.initialize();
			
			m_panels = [];
			m_buttons = [];
			m_paneClasses = [];
			
			m_selectedIndex = -1;
			
			m_autoFreePane = false;
			
			m_group = new ToggleGroup();
			
			m_btnContainer = new Sprite();
			
			m_paneContainer = new Sprite();
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function initEvents():void
		{
			super.initEvents();
			
			m_group.addEventListener(DisplayEvent.SELECT_CHANGED, __tabSelectedChangeHandler);
		}
		
		private function __tabSelectedChangeHandler(e:DisplayEvent):void
		{
			if(m_selectedIndex == m_group.selectedIndex) return;
			
			var btn:ToggleButton = m_group.selected;
			
			m_selectedIndex = m_group.selectedIndex;
			
			if(m_panels[m_selectedIndex] == null)
			{
				m_panels[m_selectedIndex] = new m_paneClasses[m_selectedIndex]();
				
				dispatchEvent(new DisplayEvent(DisplayEvent.PANEL_CREATED, m_panels[m_selectedIndex]));
			}
			
			if(m_curPane)
			{
				if(m_curPane is ITabPanel) ITabPanel(m_curPane).hidePanel();
				
				if(m_autoFreePane)
				{
					var index:int = m_panels.indexOf(m_curPane);
					
					if(index < m_panels.length && index >= 0)
					{
						m_panels[index] = null;
					}
					
					dispatchEvent(new DisplayEvent(DisplayEvent.PANEL_FREE, m_curPane));
					
					DisposeUtil.free(m_curPane);
				}
				else
				{
					if(m_curPane.parent) m_curPane.parent.removeChild(m_curPane);
				}
			}
			
			m_curPane = m_panels[m_selectedIndex] as DisplayObject;
			
			if(m_curPane)
			{
				if(m_curPane is ITabPanel) ITabPanel(m_curPane).showPanel();
				
				m_paneContainer.addChild(m_curPane);
			}
			
			dispatchEvent(new DisplayEvent(DisplayEvent.PANEL_ACTIVE_CHANGED, m_curPane));
		}
		
		/**
		 * 通过标签按钮的索引位置设置活动面板。
		 * @param index 要设置为活动面板的标签按钮的索引位置
		 */		
		public function setActive(index:int):void
		{
			m_group.selectedIndex = index;
		}
		
		/**
		 * 添加标签和面板
		 * @param button 标签按钮 ToggleButton 对象。
		 * @param paneClass 面板类，可以实现 ITabPanel 接口以使用面板显示回调。
		 * @see jsion.display.ITabPanel
		 */		
		public function addTab(button:ToggleButton, paneClass:Class):void
		{
			if(ArrayUtil.containsValue(m_buttons, button) || 
				button == null || 
				paneClass == null) return;
			
			m_buttons.push(button);
			m_paneClasses.push(paneClass);
			m_panels.push(null);
			m_group.addItem(button);
			
			onPropertiesChanged(ADDTAB);
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function addChildren():void
		{
			super.addChildren();
			
			addChild(m_paneContainer);
			
			addChild(m_btnContainer);
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function onProppertiesUpdate():void
		{
			super.onProppertiesUpdate();
			
			updateTabButtonView();
			
			updateTabButtonPos();
			
			updateTabButtonAlign();
			
			updateTabAndPanePos();
		}
		
		private function updateTabButtonView():void
		{
			if(isChanged(ADDTAB))
			{
				for(var i:int = 0; i < m_buttons.length; i++)
				{
					var btn:ToggleButton = m_buttons[i] as ToggleButton;
					m_btnContainer.addChild(btn);
				}
			}
		}
		
		private function updateTabButtonPos():void
		{
			if(isChanged(ADDTAB) || isChanged(TABGAP) || isChanged(TABPOSTYPE))
			{
				var btn:ToggleButton;
				var i:int = 0, pos:int = 0;
				
				if(m_tabPosType == UP || m_tabPosType == DOWN)
				{
					for(i = 0; i < m_buttons.length; i++)
					{
						btn = m_buttons[i] as ToggleButton;
						btn.x = pos + i * m_tabGap;
						btn.y = 0;
						
						pos += btn.width;
					}
				}
				else
				{
					for(i = 0; i < m_buttons.length; i++)
					{
						btn = m_buttons[i] as ToggleButton;
						btn.x = 0;
						btn.y = pos + i * m_tabGap;
						
						pos += btn.height;
					}
				}
			}
		}
		
		private function updateTabButtonAlign():void
		{
			if(isChanged(ADDTAB) || isChanged(TABPOSTYPE) || isChanged(TABALIGN) || isChanged(TABOFFSET))
			{
				if(m_tabPosType == UP || m_tabPosType == DOWN)
				{
					if(m_tabAlign == LEFT)
					{
						m_btnContainer.x = m_tabOffset;
					}
					else if(m_tabAlign == RIGHT)
					{
						m_btnContainer.x = m_width - m_btnContainer.width - m_tabOffset;
					}
					else
					{
						m_btnContainer.x = (m_width - m_btnContainer.width) / 2 + m_tabOffset;
					}
					
					m_paneContainer.x = 0;
				}
				else
				{
					if(m_tabAlign == TOP)
					{
						m_btnContainer.y = m_tabOffset;
					}
					else if(m_tabAlign == BOTTOM)
					{
						m_btnContainer.y = m_height - m_btnContainer.height - m_tabOffset;
					}
					else
					{
						m_btnContainer.y = (m_height - m_btnContainer.height) / 2 + m_tabOffset;
					}
					
					m_paneContainer.y = 0;
				}
			}
		}
		
		private function updateTabAndPanePos():void
		{
			if(m_tabPosType == UP)
			{
				m_btnContainer.y = 0;
				m_paneContainer.y = m_btnContainer.y + m_btnContainer.height + m_paneOffset;
			}
			else if(m_tabPosType == DOWN)
			{
				m_paneContainer.y = m_paneOffset;
				m_btnContainer.y = m_height - m_btnContainer.height;
			}
			else if(m_tabPosType == LEFT)
			{
				m_btnContainer.x = 0;
				m_paneContainer.x = m_btnContainer.x + m_btnContainer.width + m_paneOffset;
			}
			else
			{
				m_paneContainer.x = m_paneOffset;
				m_btnContainer.x = m_width - m_btnContainer.width;
			}
		}

		/**
		 * 标签按钮的方位类型
		 */		
		public function get tabPosType():String
		{
			return m_tabPosType;
		}
		
		/**
		 * 当前活动标签的索引位置
		 */		
		public function get selectedIndex():int
		{
			return m_selectedIndex;
		}

		/**
		 * 指示如果显示对象为Bitmap,被释放时是否释放 bitmapData 对象。默认为 false 。
		 */		
		public function get freeBMD():Boolean
		{
			return m_freeBMD;
		}
		
		/** @private */
		public function set freeBMD(value:Boolean):void
		{
			m_freeBMD = value;
		}

		/**
		 * 标签按钮的间距
		 */		
		public function get tabGap():int
		{
			return m_tabGap;
		}
		
		/** @private */
		public function set tabGap(value:int):void
		{
			if(m_tabGap != value)
			{
				m_tabGap = value;
				
				onPropertiesChanged(TABGAP);
			}
		}
		
		/**
		 * 标签按钮的对齐方式，受 tabPosType 属性影响。
		 * 可能的值有：
		 * <ul>
		 * 	<li>TabPanel.LEFT</li>
		 * 	<li>TabPanel.RIGHT</li>
		 * 	<li>TabPanel.CENTER</li>
		 * 	<li>TabPanel.TOP</li>
		 * 	<li>TabPanel.BOTTOM</li>
		 * 	<li>TabPanel.MIDDLE</li>
		 * </ul>
		 * <p>如果 tabPosType 属性为 UP 或 DOWN 时，此属性可能的值为：TabPanel.LEFT、TabPanel.RIGHT、TabPanel.CENTER</p>
		 * <p>如果 tabPosType 属性为 LEFT 或 RIGHT 时，此属性可能的值为：TabPanel.TOP、TabPanel.BOTTOM、TabPanel.MIDDLE</p>
		 */
		public function get tabAlign():String
		{
			return m_tabAlign;
		}
		
		/** @private */
		public function set tabAlign(value:String):void
		{
			if(m_tabAlign != value)
			{
				if(m_tabPosType == UP || m_tabPosType == DOWN)
				{
					if(value == LEFT || value == RIGHT || value == CENTER)
					{
						m_tabAlign = value;
						
						onPropertiesChanged(TABALIGN);
					}
				}
				else
				{
					if(value == TOP || value == BOTTOM || value == MIDDLE)
					{
						m_tabAlign = value;
						
						onPropertiesChanged(TABALIGN);
					}
				}
			}
		}

		/**
		 * 标签按钮的整体偏移量
		 */		
		public function get tabOffset():int
		{
			return m_tabOffset;
		}
		
		/** @private */
		public function set tabOffset(value:int):void
		{
			if(m_tabOffset != value)
			{
				m_tabOffset = value;
				
				onPropertiesChanged(TABOFFSET);
			}
		}

		/**
		 * 指示是否在切换到其他面板时释放上一个面板。
		 */		
		public function get autoFreePanel():Boolean
		{
			return m_autoFreePane;
		}
		
		/** @private */
		public function set autoFreePanel(value:Boolean):void
		{
			m_autoFreePane = value;
			
			if(m_autoFreePane)
			{
				var temp:DisplayObject;
				
				for(var i:int = 0; i < m_panels.length; i++)
				{
					if(m_selectedIndex == i) continue;
					
					temp = m_panels[i];
					DisposeUtil.free(temp, m_freeBMD);
					m_panels[i] = null;
				}
			}
		}

		/**
		 * 设置面板相对于标签按钮的偏移量
		 */		
		public function get paneOffset():int
		{
			return m_paneOffset;
		}
		
		/** @private */
		public function set paneOffset(value:int):void
		{
			if(m_paneOffset != value)
			{
				m_paneOffset = value;
				
				onPropertiesChanged(PANEOFFSET);
			}
		}
		
		/**
		 * 当前激活的标签索引
		 */		
		public function get activedIndex():int
		{
			return m_group.selectedIndex;
		}
		
		/**
		 * 当前激活的标签按钮对象
		 */		
		public function get activedTab():ToggleButton
		{
			return m_group.selected;
		}
		
		/**
		 * 当前激活的标签面板
		 */		
		public function get activedPanel():DisplayObject
		{
			return m_curPane;
		}
		
		/**
		 * 标签按钮数组，此数组为克隆数组。
		 */		
		public function get tabButtons():Array
		{
			return ArrayUtil.clone(m_buttons);
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function dispose():void
		{
			DisposeUtil.free(m_group);
			m_group = null;
			
			for each(var obj:Object in m_panels)
			{
				DisposeUtil.free(obj, m_freeBMD);
			}
			
			ArrayUtil.removeAll(m_panels);
			m_panels = null;
			
			ArrayUtil.removeAll(m_paneClasses);
			m_paneClasses = null;
			
			DisposeUtil.free(m_buttons);
			m_buttons = null;
			
			DisposeUtil.free(m_btnContainer);
			m_btnContainer = null;
			
			DisposeUtil.free(m_paneContainer);
			m_paneContainer = null;
			
			super.dispose();
		}
	}
} 