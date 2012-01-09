package jsion.tool.pngpacker
{
	import jsion.tool.BaseFrame;
	
	import org.aswing.Container;
	
	public class PNGPackerFrame extends BaseFrame
	{
		public function PNGPackerFrame(owner:*=null, modal:Boolean=false)
		{
			super(owner, modal);
			
			setSizeWH(850, 500);
			
			show();
			
			configUI();
		}
		
		private function configUI(): void
		{
			var content:Container = getContentPane();
		}
	}
}