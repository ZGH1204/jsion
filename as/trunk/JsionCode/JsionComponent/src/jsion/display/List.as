package jsion.display
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import jsion.comps.Component;
	import jsion.utils.ArrayUtil;
	import jsion.utils.DisposeUtil;

	/**
	 * 显示对象垂直排列列表，有垂直滚动条。
	 * @author Jsion
	 * 
	 */	
	public class List extends ScrollPanel
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
		 * ScrollBar 对象发生变更
		 */		
		public static const SCROLLBAR:String = ScrollPanel.SCROLLBAR;
		
		/**
		 * 滚动面板背景发生变更
		 */		
		public static const BACKGROUND:String = ScrollPanel.BACKGROUND;
		
		/**
		 * 滚动范围与背景显示对象的间隙
		 */		
		public static const BGGAP:String = ScrollPanel.BGGAP;
		
		/**
		 * 水平左边对齐，当type等于VERTICAL时有效。
		 */		
		public static const LEFT:String = Box.LEFT;
		
		/**
		 * 水平右边对齐，当type等于VERTICAL时有效。
		 */		
		public static const RIGHT:String = Box.RIGHT;
		
		/**
		 * 水平居中对齐，当type等于VERTICAL时有效。
		 */		
		public static const CENTER:String = Box.CENTER;
		
		/**
		 * 添加列表项
		 */		
		public static const ADDITEM:String = "addItem";
		/**
		 * 移除列表项
		 */		
		public static const REMOVEITEM:String = "addItem";
		
		/**
		 * 列表项偏移量
		 */		
		public static const OFFSET:String = "offset";
		
		
		
		private var m_list:Array;
		
		private var m_container:Box;
		
		private var m_itemGap:int;
		
		public function List(scrollType:int = 2)
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
			if(isChanged(OFFSET) || isChanged(ADDITEM) || isChanged(REMOVEITEM) || isChanged(SCROLLVIEW))
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
		 * 不支持 scrollPos 属性。
		 */		
		override public function get scrollPos():int
		{
			throw new Error("不支持 scrollPos 属性。");
		}
		
		/**
		 * @private
		 */		
		override public function set scrollPos(value:int):void
		{
			throw new Error("不支持 scrollPos 属性。");
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
		 * 移除所有的显示列表项，不对列表项进行释放操作。
		 */		
		public function removeAll():Array
		{
			var lst:Array = ArrayUtil.clone(m_list);
			
			beginChanges();
			
			while(m_list.length > 0)
			{
				removeItemAt(m_list.length - 1);
			}
			
			commitChanges();
			
			return lst;
		}
		
		/**
		 * 移除所有的显示列表项，并对列表项进行释放。
		 */		
		public function clear():void
		{
			DisposeUtil.free(m_list);
			
			onPropertiesChanged(REMOVEITEM);
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
		 * 获取或设置子显示对象的对齐方式。
		 * 可能的值为：List.LEFT、List.CENTER、List.RIGHT；
		 */		
		public function get align():String
		{
			return m_container.align;
		}
		
		/** @private */		
		public function set align(value:String):void
		{
			m_container.align = value;
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
		
		/**
		 * 列表项的x坐标偏移量
		 */		
		public function get itemOffsetX():int
		{
			return m_container.offsetX;
		}
		
		/** @private */
		public function set itemOffsetX(value:int):void
		{
			if(m_container.offsetX != value)
			{
				m_container.offsetX = value;
				
				onPropertiesChanged(OFFSET);
			}
		}
		
		/**
		 * 列表项的y坐标偏移量
		 */		
		public function get itemOffsetY():int
		{
			return m_container.offsetY;
		}
		
		/** @private */
		public function set itemOffsetY(value:int):void
		{
			if(m_container.offsetY != value)
			{
				m_container.offsetY = value;
				
				onPropertiesChanged(OFFSET);
			}
		}
	}
}