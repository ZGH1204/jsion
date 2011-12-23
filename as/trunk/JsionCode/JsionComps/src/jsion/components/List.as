package jsion.components
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import jsion.comps.CompGlobal;
	import jsion.comps.events.UIEvent;
	import jsion.utils.ArrayUtil;
	import jsion.utils.DisposeUtil;
	
	[Event(name="selected", type="jsion.comps.events.UIEvent")]
	public class List extends ScrollPane
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
		
		private var m_items:Array;
		
		private var m_selectedItem:ListItem;
		
		private var m_scrollToSelected:Boolean;
		
		public function List(container:DisplayObjectContainer=null, xPos:Number=0, yPos:Number=0)
		{
			m_items = [];
			
			super(container, xPos, yPos);
		}
		
		public function get selectedItem():ListItem
		{
			return m_selectedItem;
		}
		
		public function set selectedItem(value:ListItem):void
		{
			if(m_selectedItem != value)
			{
				if(m_selectedItem) m_selectedItem.selected = false;
				
				m_selectedItem = value;
				
				if(m_selectedItem) m_selectedItem.selected = true;
				
				dispatchEvent(new UIEvent(UIEvent.SELECTED));
			}
		}
		
		public function get selectedIndex():int
		{
			return m_items.indexOf(m_selectedItem);
		}
		
		public function set selectedIndex(value:int):void
		{
			if(value < 0 || value >= m_items.length) return;
			
			selectedItem = m_items[value];
		}
		
		public function scrollToSelected():void
		{
			m_scrollToSelected = true;
			
			invalidate();
		}
		
		public function addItem(item:ListItem):void
		{
			if(ArrayUtil.containsValue(m_items, item)) return;
			
			m_items.push(item);
			VBox(view).addChild(item);
			
			item.addEventListener(MouseEvent.CLICK, __itemClickHandler);
			
			invalidate();
		}
		
		public function removeItem(item:ListItem):void
		{
			if(ArrayUtil.containsValue(m_items, item) == false) return;
			
			ArrayUtil.remove(m_items, item);
			VBox(view).removeChild(item);
			
			item.removeEventListener(MouseEvent.CLICK, __itemClickHandler);
			
			invalidate();
		}
		
		public function removeAt(index:int):void
		{
			if(index < 0 || index >= m_items.length) return;
			
			var item:ListItem = ArrayUtil.removeAt(m_items, index) as ListItem;
			VBox(view).removeChildAt(index);
			
			if(item) item.removeEventListener(MouseEvent.CLICK, __itemClickHandler);
			
			invalidate();
		}
		
		private function __itemClickHandler(e:MouseEvent):void
		{
			selectedItem = ListItem(e.currentTarget);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			view = new VBox();
		}
		
		override public function draw():void
		{
			for each(var item:ListItem in m_items)
			{
				item.drawAtOnce();
			}
			
			VBox(view).drawAtOnce();
			
			super.draw();
			
			if(m_scrollToSelected)
			{
				if(m_selectedItem == null)
				{
					scrollValue = 0;
					return;
				}
				
				scrollValue = m_selectedItem.y + m_selectedItem.realHeight / 2 - realHeight / 2;
				
				m_scrollToSelected = false;
			}
		}
		
		override public function dispose():void
		{
			for each(var item:ListItem in m_items)
			{
				if(item) item.removeEventListener(MouseEvent.CLICK, __itemClickHandler);
			}
			
			DisposeUtil.free(m_items);
			m_items = null;
			
			m_selectedItem = null;
			
			super.dispose();
		}
	}
}