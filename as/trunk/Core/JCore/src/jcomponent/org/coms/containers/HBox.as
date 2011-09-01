package jcomponent.org.coms.containers
{
	import flash.display.DisplayObject;
	
	import jcomponent.org.basic.Container;
	import jcomponent.org.basic.layouts.HBoxLayout;
	import jcomponent.org.basic.layouts.ILayoutManager;
	
	import jutils.org.util.DisposeUtil;
	
	public class HBox extends Container
	{
		protected var layout:ILayoutManager;
		
		protected var m_gap:int;
		
		public function HBox(gap:int = 0, id:String=null)
		{
			super(null, id);
			
			m_gap = gap;
			
			this.layout = new HBoxLayout(gap);
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			invalidate();
			
			if(mask != child)
			{
				if(width == 0)
				{
					setSizeWH(child.width + width, Math.max(height, child.height));
				}
				else
				{
					setSizeWH(child.width + width + m_gap, Math.max(height, child.height));
				}
			}
			
			return super.addChild(child);
		}
		
		override public function paint():void
		{
			if(layout) layout.layoutContainer(this);
			
			super.paint();
		}
		
		override public function dispose():void
		{
			DisposeUtil.free(layout);
			layout = null;
			
			super.dispose();
		}
	}
}