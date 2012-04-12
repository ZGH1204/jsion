package jsion.utils
{
	import flash.display.*;

	/**
	 * 深度工具
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 *
	 */	
	public final class DepthUtil
	{
		/**
		 * 判断显示对象是否在其容器的最顶层
		 * @param display
		 */
		static public function isTop(display:DisplayObject): Boolean
		{
			if(display == null) return false;

			var container:DisplayObjectContainer = display.parent;
			if (container == null)
			{
				return true;
			}
			return container.numChildren-1 == container.getChildIndex(display);
		}

		/**
		 * 判断显示对象是否在其容器的最底层
		 * @param display
		 */
		static public function isBottom(display:DisplayObject): Boolean
		{
			if(display == null) return false;

			var container:DisplayObjectContainer = display.parent;
			if (container == null)
			{
				return true;
			}
			return container.getChildIndex(display) == 0;
		}

		/**
		 * dis1对象是否是dis2对象上面的第一个对象
		 *
		 * @param dis1
		 * @param dis2
		 */
		static public function isJustAbove(dis1:DisplayObject, dis2:DisplayObject): Boolean
		{
			return isJustBelow(dis2, dis1);
		}

		/**
		 * dis1对象是否是dis2对象下面的第一个对象
		 *
		 * @param dis1
		 * @param dis2
		 */
		static public function isJustBelow(dis1:DisplayObject, dis2:DisplayObject): Boolean
		{
			if(dis1 == null || dis2 == null)
			{
				throw new ArgumentError("dis1和dis2都不能为null.");
				return false;
			}

			var container:DisplayObjectContainer = dis1.parent;
			if (container == null)
			{
				return false;
			}
			if (dis2.parent != container)
			{
				return false;
			}
			return container.getChildIndex(dis1) == container.getChildIndex(dis2)-1;
		}

		/**
		 * dis1对象是否在dis2对象上面
		 * @param dis1
		 * @param dis2
		 * @return
		 *
		 */		
		static public function isAbove(dis1:DisplayObject, dis2:DisplayObject): Boolean
		{
			return isBelow(dis2, dis1);
		}

		/**
		 * dis1对象是否在dis2对象下面
		 * @param dis1
		 * @param dis2
		 * @return
		 *
		 */		
		static public function isBelow(dis1:DisplayObject, dis2:DisplayObject):Boolean
		{
			if(dis1 == null || dis2 == null)
			{
				throw new ArgumentError("dis1和dis2都不能为null.");
				return false;
			}

			var container:DisplayObjectContainer = getContainerByUnion(dis1, dis2);
			
			if(container == null) return false;
			
			if(dis1.parent == dis2.parent)
			{
				return dis1.parent.getChildIndex(dis1) < dis2.parent.getChildIndex(dis2);
			}
			else if(dis1.parent.contains(dis2.parent))
			{
				return dis1.parent.getChildIndex(dis1) < dis1.parent.getChildIndex(dis2.parent);
			}
			else if(dis2.parent.contains(dis1.parent))
			{
				return dis2.parent.getChildIndex(dis1) < dis2.parent.getChildIndex(dis1.parent);
			}
			else
			{
				var disList:Array = [null, null];
				
				for(var i:int = 0; i < container.numChildren; i++)
				{
					var child:DisplayObjectContainer = container.getChildAt(i) as DisplayObjectContainer;
					
					if(child == null) continue;
	
					if(child.contains(dis1))
					{
						disList[0] = child;
					}
					else if(child.contains(dis2))
					{
						disList[1] = child;
					}
	
					if(disList[0] != null && disList[1] != null) break;
				}
	
				dis1 = disList[0] as DisplayObject;
				dis2 = disList[1] as DisplayObject;
				
				return container.getChildIndex(dis1) < container.getChildIndex(dis2);
			}

		}

		/**
		 * 返回包含dis1和dis2对象的最小容器对象
		 * @param dis1
		 * @param dis2
		 * @return 没有同时包含dis1和dis2对象的容器时返回null
		 *
		 */		
		static private function getContainerByUnion(dis1:DisplayObject, dis2:DisplayObject):DisplayObjectContainer
		{
			if(dis1 == null || dis2 == null) return null;
			
			var dis1Depth:int = getDepth(dis1);
			var dis2Depth:int = getDepth(dis2);

			
			var parent:DisplayObjectContainer;
			
			if(dis1Depth > dis2Depth)
			{
				parent = dis1.parent;
				
				while(parent != null)
				{
					if(parent.contains(dis2))
					{
						return parent;
					}
					parent = parent.parent;
				}
			}
			else
			{
				parent = dis2.parent;
				
				while(parent != null)
				{
					if(parent.contains(dis1))
					{
						return parent;
					}
					parent = parent.parent;
				}
			}

			return null;
		}
		
		/**
		 * 获取显示对象相对于舞台的显示列表层级 在舞台上时层级为0 未显示的为-1
		 * @param dis 要显示层级的显示对象
		 * @return 以舞台为基础从0开始的层级数 即舞台为0
		 */		
		static public function getDepth(dis:DisplayObject):int
		{
			if(dis.parent == null) return -1;
			
			var index:int = 0;
			
			var parent:DisplayObjectContainer = dis.parent
			
			while(true)
			{
				if(parent is Stage)
				{
					return index;
				}
				else
				{
					index += 1;
					parent = parent.parent;
				}
			}
			
			return index;
		}

		/**
		 * 将显示对象提升到最顶层
		 * @param display
		 */
		static public function bringToTop(display:DisplayObject): void
		{
			if(display == null) return;

			var container:DisplayObjectContainer = display.parent;
			if (container == null)
			{
				return;
			}
			if (container.getChildIndex(display) != container.numChildren-1)
			{
				container.setChildIndex(display, container.numChildren-1);
			}
		}

		/**
		 * 将显示对象提升到最底层
		 * @param display
		 */
		static public function bringToBottom(display:DisplayObject): void
		{
			if(display == null) return;

			var container:DisplayObjectContainer = display.parent;
			if (container == null)
			{
				return;
			}
			if (container.getChildIndex(display) != 0)
			{
				container.setChildIndex(display, 0);
			}
		}
	}
}

