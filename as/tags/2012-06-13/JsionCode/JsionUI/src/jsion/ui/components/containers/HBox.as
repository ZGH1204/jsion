package jsion.ui.components.containers
{
	import flash.display.DisplayObject;
	
	import jsion.ui.layouts.HBoxLayout;
	
	public class HBox extends AbstractBox
	{
		public function HBox(gap:int = 0, prefix:String = null, id:String=null)
		{
			super(prefix, id);
			
			m_gap = gap;
			
			this.layout = new HBoxLayout();
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
	}
}