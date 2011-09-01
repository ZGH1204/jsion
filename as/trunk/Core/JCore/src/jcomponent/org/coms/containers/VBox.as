package jcomponent.org.coms.containers
{
	import flash.display.DisplayObject;
	
	import jcomponent.org.basic.Container;
	import jcomponent.org.basic.layouts.ILayoutManager;
	import jcomponent.org.basic.layouts.VBoxLayout;
	
	import jutils.org.util.DisposeUtil;
	
	public class VBox extends Container
	{
		protected var layout:ILayoutManager;
		
		protected var m_gap:int;
		
		public function VBox(gap:int = 0, id:String=null)
		{
			super(null, id);
			
			m_gap = gap;
			
			layout = new VBoxLayout(gap);
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			invalidate();
			
			if(child != mask)
			{
				if(height == 0)
				{
					setSizeWH(Math.max(child.width, width), height + child.height);
				}
				else
				{
					setSizeWH(Math.max(child.width, width), height + child.height + m_gap);
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