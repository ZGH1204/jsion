package jui.org.defres
{
	import jui.org.IUIResource;
	
	public class InsetsUIResource extends Insets implements IUIResource
	{
		public function InsetsUIResource(top:int=0, left:int=0, bottom:int=0, right:int=0)
		{
			super(top, left, bottom, right);
		}
		
		public function createInsetsResource(insets:Insets):InsetsUIResource
		{
			return new InsetsUIResource(insets.top, insets.left, insets.bottom, insets.right);
		}
	}
}