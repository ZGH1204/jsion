package editor
{
	import org.aswing.JPanel;
	import org.aswing.LayoutManager;
	import org.aswing.geom.IntDimension;
	
	public class JPanel2 extends JPanel
	{
		public function JPanel2(layout:LayoutManager=null)
		{
			super(layout);
		}
		
		override public function setSize(newSize:org.aswing.geom.IntDimension):void
		{
			super.setSize(newSize);
		}
	}
}