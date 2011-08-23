package jui.org
{
	import flash.display.DisplayObject;
	
	import jui.org.layouts.EmptyLayout;
	
	import jutils.org.util.ArrayUtil;
	import jutils.org.util.DisposeUtil;

	public class Container extends Component
	{
		protected var autoFreeChildren:Boolean;
		
		protected var children:Array;
		protected var layout:ILayoutManager;
		
		private var drawChildrenTransparentTrigger:Boolean;
		
		public function Container()
		{
			super();
			
			setName("Container");
			
			autoFreeChildren = true;
			
			drawChildrenTransparentTrigger = true;
			
			children = new Array();
			
			layout = new EmptyLayout();
		}
		
		public function isAutoFreeChildren():Boolean
		{
			return autoFreeChildren;
		}
		
		public function setAutoFreeChildren(value:Boolean):void
		{
			autoFreeChildren = value;
		}
		
		public function isChildrenDrawTransparentTrigger():Boolean
		{
			return drawChildrenTransparentTrigger;
		}
		
		public function setChildrenDrawTransparentTrigger(b:Boolean):void
		{
			if(b != drawChildrenTransparentTrigger)
			{
				drawChildrenTransparentTrigger = b;
				repaint();
				checkDrawTransparentTrigger();
			}
		}
		
		override internal function checkDrawTransparentTrigger():void
		{
			super.checkDrawTransparentTrigger();
			
			for each(var c:Component in children)
			{
				c.checkDrawTransparentTrigger();
			}
		}
		
		
		
		
		
		//=======================================
		/*
		* Container's layout.
		*/
		//=======================================
		
		public function setLayout(layout:ILayoutManager):void
		{
			this.layout = layout;
			
			revalidate();
		}
		
		public function getLayout():ILayoutManager
		{
			return layout;
		}
		
		override public function invalidate():void
		{
			layout.invalidateLayout(this);
			super.invalidate();
		}
		
		public function doLayout():void
		{
			if(isVisible())
			{
				layout.layoutContainer(this);
			}
		}
		
		
		override protected function countMinimumSize():IntDimension
		{
			var size:IntDimension = null;
			if(ui != null)
			{
				size = ui.getMinimumSize(this);
			}
			
			if(size == null)
			{
				size = layout.minimumLayoutSize(this);
			}
			
			if(size == null)
			{//this should never happen
				size = super.countMinimumSize();
			}
			
			return size;
		}
		
		override protected function countMaximumSize():IntDimension
		{
			var size:IntDimension = null;
			if(ui != null)
			{
				size = ui.getMaximumSize(this);
			}
			
			if(size == null)
			{
				size = layout.maximumLayoutSize(this);
			}
			
			if(size == null)
			{//this should never happen
				size = super.countMaximumSize();
			}
			
			return size;
		}
		
		override protected function countPreferredSize():IntDimension
		{
			var size:IntDimension = null;
			if(ui != null)
			{
				size = ui.getPreferredSize(this);
			}
			
			if(size == null)
			{
				size = layout.preferredLayoutSize(this);
			}
			
			if(size == null)
			{//this should never happen
				size = super.countPreferredSize();
			}
			
			return size;
		}
		
		override internal function validate():void
		{
			if(!validated)
			{
				doLayout();
				
				for(var i:int = 0; i < children.length; i++)
				{
					children[i].validate();
				}
				
				validated = true;
			}
		}
		
		
		public function getComponent(index:int):Component
		{
			if(index < 0 || index >= children.length)
			{
				throw new RangeError("Index out of container children bounds!!!");
			}
			
			return children[index];
		}
		
		public function append(com:Component, constraints:Object = null):void
		{
			insertImp(-1, com, constraints);
		}
		
		public function appendAll(...components):void
		{
			for each(var i:* in components)
			{
				var com:Component = i as Component;
				
				if(com != null)
				{
					append(com);
				}
			}
		}
		
		public function reAppendChildren():void
		{
			var chs:Array = children.concat();
			
			removeAll();
			
			for(var i:int = 0; i < chs.length; i++)
			{
				append(chs[i]);
			}
			
			revalidate();
		}
		
		public function insert(index:int, component:Component, constraints:Object = null):void
		{
			insertImp(index, component, constraints);
		}
		
		public function insertAll(index:int, ...components):void
		{
			for each(var item:* in components)
			{
				var component:Component = item as Component;
				
				if(component != null)
				{
					insert(index, component);
					
					index++;
				}
			}
		}
		
		protected function insertImp(index:int, component:Component, constraints:Object = null):void
		{
			if(index > getComponentCount())
			{
				throw new RangeError("illegal component position when insert component to container");
			}
			
			if(component is Container)
			{
				for(var cn:Container = this; cn != null; cn = cn.getParent())
				{
					if (cn == component)
					{
						throw new ArgumentError("adding container's parent to itself");
					}
				}
			}
			
			if(component.getParent() != null)
			{
				component.removeFromContainer();
			}
			
			component.container = this;
			
			component.checkDrawTransparentTrigger();
			
			if(index < 0)
			{
				children.push(component);
				
				super.addChild(component);
			}
			else
			{
				addChildAt(component, getChildIndexWithComponentIndex(index));
				ArrayUtil.insert(children, component, index);
			}
			
			layout.addLayoutComponent(component, (constraints == null) ? component.getConstraints() : constraints);
			
			if (validated)
			{
				revalidate();
			}
			else
			{
				invalidatePreferSizeCaches();
			}
		}
		
		protected function getChildIndexWithComponentIndex(index:int):int
		{
			var count:int = getComponentCount();
			
			if(index < 0 || index > count)
			{
				throw new RangeError("Out of index counting bounds, it should be >=0 and <= component count!");
			}
			
			if(index == count)
			{
				return getHighestIndexUnderForeground();
			}
			else
			{
				return getChildIndex(getComponent(index));
			}
		}
		
		protected function getComponentIndexWithChildIndex(index:int):int
		{
			var count:int = numChildren;
			
			if(index < 0 || index > count)
			{
				throw new RangeError("Out of index counting bounds, it should be >=0 and <= numChildren!");
			}
			
			if(index == count)
			{
				return getComponentCount();
			}
			else
			{
				var aboveCount:int = 0;
				
				for(var i:int=index; i<count; i++)
				{
					if(getChildAt(i) is Component)
					{
						aboveCount++;
					}
				}
				return getComponentCount() - aboveCount;
			}
		}
		
		
		
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			checkChildRemoval(child);
			return super.addChild(child);
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
				
				if(c.getParent() != null)
				{
					throw new ArgumentError("You should call insert(remove) method to add(remove) a component child!");
				}
			}
		}
		
		public function getIndex(component:Component):int
		{
			var n:int = children.length;
			
			for(var i:int=0; i<n; i++)
			{
				if(component == children[i])
				{
					return i;
				}
			}
			
			return -1;
		}
		
		public function getComponentCount():int
		{
			return children.length;
		}
		
		public function remove(component:Component):Component
		{
			var i:int = getIndex(component);
			
			if(i >= 0)
			{
				return removeAt(i);
			}
			
			return null;
		}
		
		public function removeAt(i:int):Component
		{
			return removeAtImp(i);
		}
		
		protected function removeAtImp(i:int):Component
		{
			if(i < 0) return null;
			
			var comp:Component = children[i];
			
			if(comp != null)
			{
				children.splice(i, 1);
				super.removeChild(comp);
				comp.container = null;
				layout.removeLayoutComponent(comp);
				
				if (validated)
				{
					revalidate();
				}
				else
				{
					invalidatePreferSizeCaches();
				}
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
		
		public function removeAllAndFree():void
		{
			while(children.length > 0)
			{
				var child:* = removeAt(children.length - 1);
				
				DisposeUtil.free(child);
			}
		}
		
		override public function dispose():void
		{
			if(autoFreeChildren) removeAllAndFree();
			else removeAll();
			children = null;
			
			DisposeUtil.free(layout);
			layout = null;
			
			super.dispose();
		}
	}
}