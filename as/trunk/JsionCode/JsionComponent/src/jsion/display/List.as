package jsion.display
{
	import flash.display.DisplayObject;
	
	import jsion.utils.ArrayUtil;

	/**
	 * 显示对象垂直排列列表，带滚动条。
	 * @author Jsion
	 * 
	 */	
	public class List extends ScrollPanel
	{
		public static const ADDITEM:String = "addItem";
		
		private var m_list:Array;
		
		private var m_container:Box;
		
		private var m_itemGap:int;
		
		public function List(scrollType:int=VERTICAL)
		{
			super(scrollType);
		}
		
		override public function beginChanges():void
		{
			m_container.beginChanges();
			
			super.beginChanges();
		}
		
		override public function commitChanges():void
		{
			m_container.commitChanges();
			
			super.commitChanges();
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function initialize():void
		{
			super.initialize();
			
			m_list = [];
			
			m_container = new Box(Box.VERTICAL);
			m_scrollView = m_container;
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function addChildren():void
		{
			super.addChildren();
			
			addChild(m_container);
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function onProppertiesUpdate():void
		{
			if(isChanged(ADDITEM) || isChanged(SCROLLVIEW))
			{
				m_container.beginChanges();
				
				for each(var button:DisplayObject in m_list)
				{
					m_container.addChild(button);
				}
				
				m_container.commitChanges();
				
				if(m_scrollType == VERTICAL)
				{
					m_scrollBar.viewSize = m_container.height;
				}
				else
				{
					m_scrollBar.viewSize = m_container.width;
				}
				
				m_changeProperties.put(SCROLLVIEW, true);
			}
			
			super.onProppertiesUpdate();
		}
		
		/**
		 * 不支持 scrollView 属性。
		 */		
		override public function get scrollView():DisplayObject
		{
			throw new Error("不支持 scrollView 属性。");
		}
		
		/**
		 * @private
		 */		
		override public function set scrollView(value:DisplayObject):void
		{
			throw new Error("不支持 scrollView 属性。");
		}
		
		/**
		 * 添加显示列表项
		 */		
		public function addItem(item:DisplayObject):void
		{
			ArrayUtil.push(m_list, item);
			
			onPropertiesChanged(ADDITEM);
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function dispose():void
		{
			ArrayUtil.removeAll(m_list);
			m_list = null;
			
			m_container = null;
			
			m_scrollView = null;
			
			super.dispose();
		}

		/**
		 * 列表项之间的间隔
		 */		
		public function get itemGap():int
		{
			return m_itemGap;
		}

		/**
		 * @private
		 */		
		public function set itemGap(value:int):void
		{
			if(m_itemGap != value)
			{
				m_itemGap = value;
				
				m_container.gap = value;
				
				onPropertiesChanged(SCROLLVIEW);
			}
		}
	}
}