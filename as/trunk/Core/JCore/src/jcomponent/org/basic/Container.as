package jcomponent.org.basic
{
	import flash.display.DisplayObject;
	
	import jcomponent.org.basic.layouts.ILayoutManager;
	
	import jutils.org.util.ArrayUtil;
	import jutils.org.util.DisposeUtil;

	public class Container extends Component
	{
		protected var layout:ILayoutManager;
		
		protected var children:Array = [];
		
		public function Container(prefix:String = null, id:String=null)
		{
			super(prefix, id);
		}
		
		override public function paint():void
		{
			if(layout) layout.layoutContainer(this);
			
			super.paint();
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			if(child is Component) insert(child as Component);
			else super.addChild(child);
			
			return child;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			if(child is Component) insert(child as Component, null, index);
			else super.addChildAt(child, index);
			
			return child;
		}
		
		public function insert(component:Component, constraints:Object=null, index:int = -1):void
		{
			if(index > getComponentCount())
			{
				throw new RangeError("Illegal component position when insert comp to container");
				return;
			}
			
			if(component is Container)
			{
				for(var cn:Container = this; cn != null; cn = cn.getContainer())
				{
					if (cn == component)
					{
						throw new ArgumentError("Adding container's parent to itself!");
						return;
					}
				}
			}
			
			if(component.getContainer() != null)
			{
				component.removeFromContainer();
			}
			
			component.container = this;
			
			if(index < 0)
			{
				children.push(component);
				super.addChild(component);
			}
			else
			{
				ArrayUtil.insert(children, component, index);
				super.addChildAt(component, index);
			}
			
			invalidate();
		}
		
		public function remove(component:Component):Component
		{
			var i:int = getIndex(component);
			
			if(i >= 0) return removeAt(i);
			
			return null;
		}
		
		public function removeAt(index:int):Component
		{
			if(index < 0) return null;
			
			var comp:Component = children[index] as Component;
			
			if(comp != null)
			{
				children.splice(index, 1);
				super.removeChild(comp);
				comp.container = null;
				//layout.removeLayoutComponent(com);
				//dispatchEvent(new ContainerEvent(ContainerEvent.COM_REMOVED, this, com));
				
				invalidate();
			}
			
			return comp;
		}
		
		public function removeAll():void
		{
			while(children.length > 0)
			{
				removeAt(children.length - 1);
			}
		}
		
		public function getIndex(component:Component):int
		{
			return children.indexOf(component);
		}
		
		public function getComponentCount():int
		{
			return children.length;
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			checkChildRemoval(child);
			
			return super.removeChild(child);
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			checkChildRemoval(getChildAt(index));
			
			return super.removeChildAt(index);
		}
		
		private function checkChildRemoval(child:DisplayObject):void
		{
			if(child is Component)
			{
				var c:Component = child as Component;
				
				if(c.getContainer() != null)
				{
					throw new ArgumentError("You should call remove method to remove a component child!");
				}
			}
		}
		
		override public function dispose():void
		{
			DisposeUtil.free(layout);
			layout = null;
			
			
			removeAll();
			
			super.dispose();
		}
	}
}