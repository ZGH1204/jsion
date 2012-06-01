package jsion.display
{
	import flash.display.DisplayObject;
	
	import jsion.comps.CompGlobal;
	import jsion.comps.Component;
	import jsion.utils.ArrayUtil;
	
	/**
	 * 水平或垂直排列容器
	 * @author Jsion
	 */	
	public class Box extends Component
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
		 * 水平左边对齐，当type等于VERTICAL时有效。
		 */		
		public static const LEFT:String = CompGlobal.LEFT;
		
		/**
		 * 水平右边对齐，当type等于VERTICAL时有效。
		 */		
		public static const RIGHT:String = CompGlobal.RIGHT;
		
		/**
		 * 水平居中对齐，当type等于VERTICAL时有效。
		 */		
		public static const CENTER:String = CompGlobal.CENTER;
		
		/**
		 * 垂直顶边对齐，当type等于HORIZONTAL时有效。
		 */		
		public static const TOP:String = CompGlobal.TOP;
		
		/**
		 * 垂直底边对齐，当type等于HORIZONTAL时有效。
		 */		
		public static const BOTTOM:String = CompGlobal.BOTTOM;
		
		/**
		 * 垂直居中对齐，当type等于HORIZONTAL时有效。
		 */		
		public static const MIDDLE:String = CompGlobal.MIDDLE;
		
		/**
		 * 水平方式排列
		 */		
		public static const HORIZONTAL:int = 1;
		
		/**
		 * 垂直方式排列
		 */		
		public static const VERTICAL:int = 2;
		
		private var m_gap:int;
		
		private var m_type:int;
		
		private var m_align:String;
		
		private var m_changed:Boolean;
		
		private var m_maxValue:int;
		
		public function Box(type:int = 2)
		{
			m_type = type;
			
			super();
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function initialize():void
		{
			super.initialize();
			
			if(m_type == HORIZONTAL)
			{
				m_align = TOP;
			}
			else
			{
				m_align = LEFT;
			}
			
			m_changed = false;
		}

		/**
		 * 相邻子显示对象间的排列间隙
		 */		
		public function get gap():int
		{
			return m_gap;
		}
		
		/** @private */		
		public function set gap(value:int):void
		{
			if(m_gap != value)
			{
				m_gap = value;
				
				m_changed = true;
				
				invalidate();
			}
		}
		
		/**
		 * 获取或设置子显示对象的排列方式
		 * 可能的值为：Box.HORIZONTAL、Box.VERTICAL。
		 * 此属性会自动设置align属性对应的默认对齐方式。
		 * 当type等于Box.HORIZONTAL时，默认值为：Box.TOP；
		 * 当type等于Box.VERTICAL时，默认值为：Box.LEFT。
		 */		
		public function get type():int
		{
			return m_type;
		}
		
		/** @private */		
		public function set type(value:int):void
		{
			if(m_type != value && (value == HORIZONTAL || value == VERTICAL))
			{
				m_type = value;
				
				if(m_type == HORIZONTAL && (m_align == LEFT || m_align == CENTER || m_align == RIGHT))
				{
					m_align = TOP;
				}
				else if(m_type == VERTICAL && (m_align == TOP || m_align == MIDDLE || m_align == BOTTOM))
				{
					m_align = LEFT;
				}
				
				m_changed = true;
				
				invalidate();
			}
		}
		
		/**
		 * 获取或设置子显示对象的对齐方式。
		 * 当type等于Box.HORIZONTAL时，可能的值为：Box.TOP、Box.MIDDLE、Box.BOTTOM；
		 * 当type等于Box.VERTICAL时，可能的值为：Box.LEFT、Box.CENTER、Box.RIGHT；
		 */		
		public function get align():String
		{
			return m_align;
		}
		
		/** @private */		
		public function set align(value:String):void
		{
			if(m_align != value)
			{
				if(m_type == HORIZONTAL)
				{
					if(m_align == TOP || m_align == MIDDLE || m_align == BOTTOM)
					{
						m_align = value;
						
						m_changed = true;
						
						invalidate();
					}
				}
				else
				{
					if(m_align == LEFT || m_align == CENTER || m_align == RIGHT)
					{
						m_align = value;
						
						m_changed = true;
						
						invalidate();
					}
				}
			}
		}
		
		/**
		 * 不支持设置宽度
		 * @throws Error 不支持设置宽度。
		 */		
		override public function set width(value:Number):void
		{
			throw new Error("Box 对象不支持设置宽度属性。");
		}
		
		/**
		 * 不支持设置高度
		 * @throws Error 不支持设置高度。
		 */		
		override public function set height(value:Number):void
		{
			throw new Error("Box 对象不支持设置高度属性。");
		}
		
		/**
		 * 按排列顺序获取对应的子显示对象
		 * @param index 从零开始听排列顺序索引
		 */		
		public function getIndex(index:int):DisplayObject
		{
			if(index < 0 || index >= children.length) return null;
			
			return children[index];
		}
		
		/**
		 * 变更子显示对象的排列顺序
		 * @param child 要变更排列顺序的子显示对象
		 * @param index 要变量到的从零开始的排列顺序索引
		 */		
		public function changeIndex(child:DisplayObject, index:int):void
		{
			if(ArrayUtil.containsValue(children, child))
			{
				ArrayUtil.remove(children, child);
				ArrayUtil.insert(children, child, index);
				m_changed = true;
				invalidate();
			}
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			super.addChild(child);
			
			if(child)
			{
				m_changed = true;
				
				invalidate();
			}
			
			return child;
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			super.addChildAt(child, index);
			
			if(child)
			{
				m_changed = true;
				
				invalidate();
			}
			
			return child;
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			super.removeChild(child);
			
			if(child)
			{
				m_changed = true;
				
				invalidate();
			}
			
			return child;
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function removeChildAt(index:int):DisplayObject
		{
			var child:DisplayObject = super.removeChildAt(index);
			
			super.removeChildAt(index);
			
			if(child)
			{
				m_changed = true;
				
				invalidate();
			}
			
			return child;
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function onProppertiesUpdate():void
		{
			super.onProppertiesUpdate();
			
			var i:int;
			var pos:int = 0;
			var child:DisplayObject;
			var list:Array = children;
			
			if(m_changed)
			{
				m_maxValue = 0;
				m_changed = false;
				
				if(m_type == HORIZONTAL)
				{
					for(i = 0; i < list.length; i++)
					{
						child = list[i];
						
						child.x = pos + m_gap * i;
						child.y = 0;
						
						pos += child.width;
						
						m_maxValue = Math.max(m_maxValue, child.height);
					}
					
					if(m_align == MIDDLE)
					{
						for(i = 0; i < list.length; i++)
						{
							child = list[i];
							
							child.y = (m_maxValue - child.height) / 2;
						}
					}
					else if(m_align == BOTTOM)
					{
						for(i = 0; i < list.length; i++)
						{
							child = list[i];
							
							child.y = m_maxValue - child.height;
						}
					}
					
					if(child) m_width = child.x + child.width;
					else m_width = 0;
					
					m_height = m_maxValue;
				}
				else
				{
					for(i = 0; i < list.length; i++)
					{
						child = list[i];
						
						child.x = 0;
						child.y = pos + m_gap * i;
						
						pos += child.height;
						
						m_maxValue = Math.max(m_maxValue, child.width);
					}
					
					if(m_align == CENTER)
					{
						for(i = 0; i < list.length; i++)
						{
							child = list[i];
							
							child.x = (m_maxValue - child.width) / 2;
						}
					}
					else if(m_align == RIGHT)
					{
						for(i = 0; i < list.length; i++)
						{
							child = list[i];
							
							child.x = m_maxValue - child.width;
						}
					}
					
					if(child) m_height = child.y + child.height;
					else m_height = 0;
					
					m_width = m_maxValue;
				}
			}
		}
	}
}