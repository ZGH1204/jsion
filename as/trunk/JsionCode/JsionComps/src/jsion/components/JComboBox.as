package jsion.components
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import jsion.comps.CompGlobal;
	import jsion.comps.Component;
	import jsion.comps.events.UIEvent;
	import jsion.utils.DisposeUtil;
	
	public class JComboBox extends Component
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
		
		public static const UP:String = CompGlobal.UP;
		public static const DOWN:String = CompGlobal.DOWN;
		
		private var m_labelButton:JButton;
		
		private var m_selectedItem:JListItem;
		
		private var m_list:JList;
		
		private var m_dir:String;
		
		
		private var m_listOffsetX:Number;
		private var m_listOffsetY:Number;
		private var m_listWidth:Number;
		private var m_listHeight:Number;
		
		public function JComboBox(dir:String = DOWN, container:DisplayObjectContainer=null, xPos:Number=0, yPos:Number=0)
		{
			m_dir = dir;
			
			m_listWidth = 120;
			m_listHeight = 150;
			
			m_listOffsetX = 0;
			m_listOffsetY = 1;
			
			super(container, xPos, yPos);
		}
		
		public function get dir():String
		{
			return m_dir;
		}
		
		public function set dir(value:String):void
		{
			if(m_dir != value)
			{
				m_dir = value;
				
				invalidate();
			}
		}
		
		public function get listOffsetX():Number
		{
			return m_listOffsetX;
		}
		
		public function set listOffsetX(value:Number):void
		{
			if(m_listOffsetX != value)
			{
				m_listOffsetX = value;
				
				invalidate();
			}
		}
		
		public function get listOffsetY():Number
		{
			return m_listOffsetY;
		}
		
		public function set listOffsetY(value:Number):void
		{
			if(m_listOffsetY != value)
			{
				m_listOffsetY = value;
				
				invalidate();
			}
		}
		
		public function get listWidth():Number
		{
			return m_listWidth;
		}
		
		public function set listWidth(value:Number):void
		{
			if(m_listWidth != value)
			{
				m_listWidth = value;
				
				invalidate()
			}
		}
		
		public function get listHeight():Number
		{
			return m_listHeight;
		}
		
		public function set listHeight(value:Number):void
		{
			if(m_listHeight != value)
			{
				m_listHeight = value;
				
				invalidate();
			}
		}
		
		override public function setStyle(key:String, value:*, freeBMD:Boolean=true):Object
		{
			invalidate();
			return m_labelButton.setStyle(key, value, freeBMD);
		}
		
		public function setLabelStyle(key:String, value:*, freeBMD:Boolean = true):Object
		{
			invalidate();
			return m_labelButton.setLabelStyle(key, value, freeBMD);
		}
		
		public function setListStyle(key:String, value:*, freeBMD:Boolean = true):Object
		{
			invalidate();
			return m_list.setStyle(key, value, freeBMD);
		}
		
		public function setListUpStyle(key:String, value:*, freeBMD:Boolean = true):Object
		{
			invalidate();
			return m_list.setUpOrLeftStyle(key, value, freeBMD);
		}
		
		public function setListDownStyle(key:String, value:*, freeBMD:Boolean = true):Object
		{
			invalidate();
			return m_list.setDownOrRightStyle(key, value, freeBMD);
		}
		
		public function setListBarStyle(key:String, value:*, freeBMD:Boolean = true):Object
		{
			invalidate();
			return m_list.setBarStyle(key, value, freeBMD);
		}
		
		public function addItem(item:JListItem):void
		{
			m_list.addItem(item);
			invalidate();
		}
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			
			m_labelButton.enabled = value;
			m_list.enabled = value;
		}
		
		override protected function addChildren():void
		{
			m_labelButton = new JButton();
			addChild(m_labelButton);
			
			m_list = new JList();
		}
		
		override protected function initEvents():void
		{
			m_labelButton.addEventListener(MouseEvent.CLICK, __clickHandler);
			m_list.addEventListener(UIEvent.SELECTED, __selectedHandler);
		}
		
		private function __clickHandler(e:MouseEvent):void
		{
			if(contains(m_list))
			{
				removeList();
			}
			else
			{
				addList()
			}
		}
		
		private function __selectedHandler(e:UIEvent):void
		{
			if(m_list.selectedItem)
			{
				m_labelButton.label = m_list.selectedItem.selectedLabel;
			}
			
			m_selectedItem = m_list.selectedItem;
			
			dispatchEvent(new UIEvent(UIEvent.SELECTED));
			
			removeList();
		}
		
		public function get selectedItem():JListItem
		{
			return m_selectedItem;
		}
		
		public function set selectedItem(item:JListItem):void
		{
			m_list.selectedItem = item;
		}
		
		public function get selectedIndex():int
		{
			return m_list.selectedIndex;
		}
		
		public function set selectedIndex(value:int):void
		{
			m_list.selectedIndex = value;
		}
		
		private function addList():void
		{
			if(contains(m_list) == false)
			{
				addChild(m_list);
			}
		}
		
		private function removeList():void
		{
			if(contains(m_list))
			{
				removeChild(m_list);
			}
		}
		
		override public function draw():void
		{
			removeList();
			
			if(m_list.selectedItem)
			{
				m_labelButton.label = m_list.selectedItem.selectedLabel;
			}
			
			m_labelButton.drawAtOnce();
			
			m_labelButton.width = realWidth;
			m_labelButton.height = realHeight;
			m_labelButton.drawAtOnce();
			
			m_list.width = m_listWidth;
			m_list.height = m_listHeight;
			
			m_list.drawAtOnce();
			
			if(m_dir == UP)
			{
				m_list.x = m_listOffsetX;
				m_list.y = -m_list.realHeight - m_listOffsetY;
			}
			else
			{
				m_list.x = m_listOffsetX;
				m_list.y = m_labelButton.realHeight + m_listOffsetY;
			}
			
			super.draw();
		}
		
		override public function dispose():void
		{
			if(m_labelButton) m_labelButton.removeEventListener(MouseEvent.CLICK, __clickHandler);
			if(m_list) m_list.removeEventListener(UIEvent.SELECTED, __selectedHandler);
			
			DisposeUtil.free(m_labelButton);
			m_labelButton = null;
			
			DisposeUtil.free(m_list);
			m_list = null;
			
			m_selectedItem = null;
			
			super.dispose();
		}
	}
}