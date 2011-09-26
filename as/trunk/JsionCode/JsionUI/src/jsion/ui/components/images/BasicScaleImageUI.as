package jsion.ui.components.images
{
	import jsion.ui.BasicComponentUI;
	
	public class BasicScaleImageUI extends BasicComponentUI
	{
		public static const TOP_LEFT:int = AbstractImage.TOP_LEFT;
		
		public static const TOP_CENTER:int = AbstractImage.TOP_CENTER;
		
		public static const TOP_RIGHT:int = AbstractImage.TOP_RIGHT;
		
		public static const MIDDLE_LEFT:int = AbstractImage.MIDDLE_LEFT;
		
		public static const MIDDLE_CENTER:int = AbstractImage.MIDDLE_CENTER;
		
		public static const MIDDLE_RIGHT:int = AbstractImage.MIDDLE_RIGHT;
		
		public static const BOTTOM_LEFT:int = AbstractImage.BOTTOM_LEFT;
		
		public static const BOTTOM_CENTER:int = AbstractImage.BOTTOM_CENTER;
		
		public static const BOTTOM_RIGHT:int = AbstractImage.BOTTOM_RIGHT;
		
		public function BasicScaleImageUI()
		{
			super();
		}
		
		
		
		public function getGridRect(s:IntDimension, insets:Insets, part:int):IntRectangle
		{
			var r:IntRectangle = new IntRectangle();
			
			if(part == TOP_LEFT)
			{
				r.width = insets.left;
				r.height = insets.top;
			}
			else if(part == TOP_CENTER)
			{
				r.x = insets.left;
				r.width = s.width - insets.left;
				r.width -= insets.right;
				r.height = insets.top;
			}
			else if(part == TOP_RIGHT)
			{
				r.x = s.width - insets.right;
				r.width = insets.right;
				r.height = insets.top;
			}
			else if(part == MIDDLE_LEFT)
			{
				r.y = insets.top;
				r.width = insets.left;
				r.height = s.height - insets.top;
				r.height -= insets.bottom;
			}
			else if(part == MIDDLE_CENTER)
			{
				r.x = insets.left;
				r.y = insets.top;
				r.width = s.width - insets.left;
				r.width -= insets.right;
				r.height = s.height - insets.top;
				r.height -= insets.bottom;
			}
			else if(part == MIDDLE_RIGHT)
			{
				r.x = s.width - insets.right;
				r.y = insets.top;
				r.width = insets.right;
				r.height = s.height - insets.top;
				r.height -= insets.bottom;
			}
			else if(part == BOTTOM_LEFT)
			{
				r.y = s.height - insets.bottom;
				r.width = insets.left;
				r.height = insets.bottom;
			}
			else if(part == BOTTOM_CENTER)
			{
				r.x = insets.left;
				r.y = s.height - insets.bottom;
				r.width = s.width - insets.left;
				r.width -= insets.right;
				r.height = insets.bottom;
			}
			else if(part == BOTTOM_RIGHT)
			{
				r.x = s.width - insets.right;
				r.y = s.height - insets.bottom;
				r.width = insets.right;
				r.height = insets.bottom;
			}
			
			return r;
		}
	}
}