package jsion.tool.respacker.areas
{
	import jsion.IDispose;
	
	import org.aswing.JPanel;
	import org.aswing.LayoutManager;
	import org.aswing.SoftBoxLayout;
	import org.aswing.border.TitledBorder;
	
	public class BottomPane extends JPanel implements IDispose
	{
		public function BottomPane(layout:LayoutManager=null)
		{
			super(new SoftBoxLayout(SoftBoxLayout.Y_AXIS));
			
			setPreferredHeight(170);
			
			setBorder(new TitledBorder(null, "帧列表", TitledBorder.TOP, TitledBorder.LEFT, 10));
		}
		
		public function dispose():void
		{
		}
	}
}