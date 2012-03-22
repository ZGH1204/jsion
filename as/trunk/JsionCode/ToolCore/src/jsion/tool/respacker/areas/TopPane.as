package jsion.tool.respacker.areas
{
	import jsion.IDispose;
	
	import org.aswing.JPanel;
	import org.aswing.LayoutManager;
	import org.aswing.SoftBoxLayout;
	
	public class TopPane extends JPanel implements IDispose
	{
		public function TopPane(layout:LayoutManager=null)
		{
			super(new SoftBoxLayout(SoftBoxLayout.Y_AXIS));
			
			setPreferredHeight(30);
		}
		
		public function dispose():void
		{
		}
	}
}