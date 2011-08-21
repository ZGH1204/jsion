package jui.org.defres
{
	import jui.org.IUIResource;
	import jui.org.JColor;
	
	public class JColorUIResource extends JColor implements IUIResource
	{
		public function JColorUIResource(rgb:uint=0x000000, alpha:Number=1)
		{
			super(rgb, alpha);
		}
		
		public static function createResourceColor(color:JColor):JColorUIResource
		{
			return new JColorUIResource(color.getRGB(), color.getAlpha());
		}
	}
}