package jsion.display
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import jsion.utils.ArrayUtil;

	/**
	 * 显示对象垂直排列列表，带滚动条。
	 * @author Jsion
	 * 
	 */	
	public class List extends ScrollPanel
	{
		/**
		 * 添加列表项
		 */		
		public static const ADDITEM:String = "addItem";
		/**
		 * 移除列表项
		 */		
		public static const REMOVEITEM:String = "addItem";
		
		private var m_list:Array;
		
		private var m_container:Box;
		
		private var m_itemGap:int;
		
		public function List(scrollType:int=VERTICAL)
		{
			super(scrollType);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function beginChanges():void
		{
			m_container.beginChanges();
			
			super.beginChanges();
		}
		
		/**
		 * @inheritDoc
		 */
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
		override protected function onProppertiesUpdate():void
		{
			if(isChanged(ADDITEM) || isChanged(REMOVEITEM) || isChanged(SCROLLVIEW))
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
		 * 不支持此方法，请使用 addItem() 方法。
		 * @param child 不支持
		 * 
		 */		
		override public function addToContent(child:DisplayObject):void
		{
			throw new Error("不支持此方法，请使用 addItem() 方法。");
		}
		
		/**
		 * 不支持此方法，请使用 addItemAt() 方法。
		 * @param child 不支持
		 * @param index 不支持
		 */		
		override public function addToContentAt(child:DisplayObject, index:int):void
		{
			throw new Error("不支持此方法，请使用 addItemAt() 方法。");
		}
		
		/**
		 * 不支持此方法，请使用 removeItem() 方法。
		 * @param child 不支持
		 */		
		override public function removeFromContent(child:DisplayObject):void
		{
			throw new Error("不支持此方法，请使用 removeItem() 方法。");
		}
		
		/**
		 * 不支持此方法，请使用 removeItemAt() 方法。
		 * @param index 不支持
		 */		
		override public function removeFromContentAt(index:int):DisplayObject
		{
			throw new Error("不支持此方法，请使用 removeItemAt() 方法。");
		}
		
		/**
		 * 添加显示列表项
		 * @param child 要加入列表的子显示对象
		 */		
		public function addItem(item:DisplayObject):void
		{
			ArrayUtil.push(m_list, item);
			
			onPropertiesChanged(ADDITEM);
		}
		
		/**
		 * 添加显示列表项到指定索引位置
		 * @param child 要加入列表的子显示对象
		 * @param index 要加入的子显示对象的索引位置
		 */		
		public function addItemAt(item:DisplayObject, index:int):void
		{
			ArrayUtil.insert(m_list, item, index);
			
			onPropertiesChanged(ADDITEM);
		}
		
		/**
		 * 移除显示列表项
		 * @param child 要移除的子显示对象
		 */		
		public function removeItem(item:DisplayObject):void
		{
			ArrayUtil.remove(m_list, item);
			
			if(item && item.parent)
			{
				item.parent.removeChild(item);
			}
			
			onPropertiesChanged(REMOVEITEM);
		}
		
		/**
		 * 移除指定索引位置的显示列表项
		 * @param index 要移除的显示列表项的索引位置
		 */		
		public function removeItemAt(index:int):DisplayObject
		{
			if(index < 0 || index >= m_list.length) return null;
			
			var item:DisplayObject = m_list[index];
			
			ArrayUtil.remove(m_list, item);
			
			if(item && item.parent)
			{
				item.parent.removeChild(item);
			}
			
			onPropertiesChanged(REMOVEITEM);
			
			return item;
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

		/** @private */
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