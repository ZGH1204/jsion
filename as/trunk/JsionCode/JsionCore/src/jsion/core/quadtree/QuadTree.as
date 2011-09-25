package jsion.core.quadtree
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jsion.utils.*;
	
	public class QuadTree implements IDispose
	{
		private var _splitNum:int;
		private var _rect:Rectangle;
		private var _root:QuadNode;
		
		public function QuadTree(splitNum:int, rect:Rectangle)
		{
			_splitNum = splitNum;
			_rect = rect.clone();
			
			_root = new QuadNode();
			_root.hasChildren = true;
			_root.rect = _rect;
			
			createChild(_root);
		}
		
		private function createChild(node:QuadNode):void
		{
			if(//node == null || 
				node.rect.width <= (this._rect.width / Math.pow(2, this._splitNum)) || 
				node.rect.height <= (this._rect.height / Math.pow(2, this._splitNum)))
			{
				node.hasChildren = false;
				
				return;
			}
			
			for(var i:int = 0; i < node.childNodes.length; i++)
			{
				var child:QuadNode = new QuadNode();
				child.parentNode = node;
				child.rect = new Rectangle(node.rect.x + (i % 2) * node.rect.width / 2, 
										   node.rect.y + int( i > 1) * node.rect.height / 2, 
										   node.rect.width / 2, 
										   node.rect.height / 2);
				node.childNodes[i] = child;
				
				createChild(node.childNodes[i]);
			}
		}
		
		/**
		 * 添加对象到树中
		 * @param obj 包含坐标(x,y)属性和大小(width,height)属性的对象
		 * 
		 */		
		public function insert(obj:Object):void
		{
			var child:QuadNode = searchNode(obj.x, obj.y, _root);
			
			child.objects.push(obj);
		}
		
		/**
		 * 从树中删除对象
		 * @param obj 要删除的对象
		 */		
		public function remove(obj:Object):void
		{
			var child:QuadNode = searchNode(obj.x, obj.y, _root);
			
			ArrayUtil.remove(child.objects, obj);
		}
		
		/**
		 * 通过递归查找坐标对应节点
		 * @param x 横坐标
		 * @param y 纵坐标
		 * @param node 开始节点
		 * @return 节点
		 */		
		public function searchNode(x:Number, y:Number, node:QuadNode):QuadNode
		{
			if(node.hasChildren)
			{
				if(node.contains(x, y))
				{
					for each(var child:QuadNode in node.childNodes)
					{
						if(child.contains(x, y))
						{
							node = searchNode(x, y, child);
						}
					}
				}
			}
			
			return node;
		}
		
		/**
		 * 通过递归查找坐标对应节点
		 * @param point 坐标对象
		 * @param node 开始节点
		 * @return 节点
		 * 
		 */		
		public function searchNodeByPoint(point:Point, node:QuadNode):QuadNode
		{
			if(node.hasChildren)
			{
				if(node.containsPoint(point))
				{
					for each(var child:QuadNode in node.childNodes)
					{
						if(child.containsPoint(point))
						{
							node = searchNodeByPoint(point, child);
						}
					}
				}
			}
			
			return node;
		}
		
		/**
		 * 通过矩形区域，查找显示对象列表
		 * @param rect 矩形区域
		 * @param exact 是否精确查找
		 * @return 该区域的显示对象集合
		 * 
		 */		
		public function searchObjectsByRect(rect:Rectangle, exact:Boolean):Array
		{
			var list:Array = [];
			
			if(_root != null)
				queryAndAdd(list, rect, _root, exact);
			
			return list;
		}
		
		/**
		 * 递归遍历节点和子节点，查找区域对象
		 * @param list 区域对象结果列表
		 * @param rect 查找区域
		 * @param node 开始查找节点
		 * @param exact 是否精确查找
		 */		
		private function queryAndAdd(list:Array, rect:Rectangle, node:QuadNode, exact:Boolean):void
		{
			if(rect.intersects(node.rect) == false) return;
			
			if(node.hasChildren)
			{
				for each(var child:QuadNode in node.childNodes)
				{
					if(child.rect.intersects(rect))
					{
						queryAndAdd(list, rect, child, exact);
					}
				}
			}
			else
			{
				for each(var obj:* in node.objects)
				{
					if(exact)
					{
						var childRect:Rectangle = new Rectangle(obj.x, obj.y, obj.width, obj.height);
						if(childRect.intersects(rect))
						{
							list.push(obj);
						}
					}
					else
					{
						list.push(obj);
					}
				}
			}
		}
		
		public function dispose():void
		{
			DisposeUtil.free(_root);
			_root = null;
			
			_rect = null;
		}
	}
}