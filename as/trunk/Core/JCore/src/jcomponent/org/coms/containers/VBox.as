package jcomponent.org.coms.containers
{
	import flash.display.DisplayObject;
	
	import jcomponent.org.basic.layouts.VBoxLayout;
	
	public class VBox extends AbstractBox
	{
		public function VBox(gap:int = 0, prefix:String = null, id:String=null)
		{
			m_gap = gap;
			
			super(prefix, id);
			
			layout = new VBoxLayout();
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

	}
}