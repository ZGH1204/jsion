package jsion.tool.respacker.areas
{
	import jsion.IDispose;
	
	import org.aswing.FlowLayout;
	import org.aswing.JPanel;
	import org.aswing.LayoutManager;
	import org.aswing.border.TitledBorder;
	
	public class RenderPane extends JPanel implements IDispose
	{
		public function RenderPane(layout:LayoutManager=null)
		{
			super(new FlowLayout(FlowLayout.CENTER));
			
			setBorder(new TitledBorder(null, "预览", TitledBorder.TOP, TitledBorder.LEFT, 10));
		}
		
		public function dispose():void
		{
		}
	}
}