package jsion.tool.respacker
{
	import jsion.IDispose;
	
	import org.aswing.FlowLayout;
	import org.aswing.JButton;
	import org.aswing.JPanel;
	import org.aswing.LoadIcon;
	
	public class ToolBox extends JPanel implements IDispose
	{
		public var newActionBtn:JButton;
		public var delActionBtn:JButton;
		
		public function ToolBox()
		{
			super(new FlowLayout(FlowLayout.LEFT, 3, 3));
			
			newActionBtn = new JButton("添加", new LoadIcon("assets/NewPackage.png"));
			newActionBtn.setToolTipText("添加一个动作的方向");
			append(newActionBtn);
			
			delActionBtn = new JButton("删除", new LoadIcon("assets/NewPackage.png"));
			delActionBtn.setToolTipText("删除一个动作的方向");
			delActionBtn.setEnabled(false);
			append(delActionBtn);
		}
		
		public function dispose():void
		{
		}
	}
}