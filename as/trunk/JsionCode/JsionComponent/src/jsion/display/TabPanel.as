package jsion.display
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import jsion.comps.CompGlobal;
	import jsion.comps.Component;
	import jsion.comps.ToggleGroup;
	import jsion.utils.ArrayUtil;
	
	/**
	 * 标签面板组
	 * @author Jsion
	 * 
	 */	
	public class TabPanel extends Component
	{
		public static const ADDTAB:String = "addTab";
		public static const TABGAP:String = "tabGap";
		public static const TABALIGN:String = "tabAlign";
		public static const TABOFFSET:String = "tabOffset";
		public static const TABPOSTYPE:String = "tabPosType";
		
		
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
		
		private var m_freeBMD:Boolean;
		
		private var m_tabGap:int;
		
		private var m_tabAlign:String;
		
		private var m_tabOffset:int;
		
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
			
			m_group = new ToggleGroup();
			
			m_btnContainer = new Sprite();
			
			m_paneContainer = new Sprite();
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
		 * 添加标签和面板
		 * @param button 标签按钮
		 * @param paneClass 面板类
		 * 
		 */		
		public function addTab(button:ToggleButton, paneClass:Class):void
		{
			if(ArrayUtil.containsValue(m_buttons, button) || 
				button == null || 
				paneClass == null) return;
			
			m_group.addItem(button);
			m_buttons.push(button);
			m_paneClasses.push(paneClass);
			
			button.addEventListener(MouseEvent.CLICK, __buttonClickHandler);
			
			onPropertiesChanged(ADDTAB);
		}
		
		private function __buttonClickHandler(e:MouseEvent):void
		{
			
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
			if(isChanged(TABPOSTYPE))
			{
				if(m_tabPosType == UP)
				{
					m_btnContainer.y = 0;
					m_paneContainer.y = m_btnContainer.y + m_btnContainer.height;
				}
				else if(m_tabPosType == DOWN)
				{
					m_paneContainer.y = 0;
					m_btnContainer.y = m_height - m_btnContainer.height;
				}
				else if(m_tabPosType == LEFT)
				{
					m_btnContainer.x = 0;
					m_paneContainer.x = m_btnContainer.x + m_btnContainer.width;
				}
				else
				{
					m_paneContainer.x = 0;
					m_btnContainer.x = m_width - m_btnContainer.width;
				}
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


	}
} 