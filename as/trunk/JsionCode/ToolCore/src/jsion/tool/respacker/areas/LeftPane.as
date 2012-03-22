package jsion.tool.respacker.areas
{
	import jsion.IDispose;
	
	import org.aswing.JPanel;
	import org.aswing.JTree;
	import org.aswing.LayoutManager;
	import org.aswing.border.TitledBorder;
	import org.aswing.tree.DefaultTreeModel;
	
	public class LeftPane extends JPanel implements IDispose
	{
		private var m_tree:JTree;
		
		public function LeftPane(layout:LayoutManager=null)
		{
			super();
			
			setPreferredWidth(200);
			
			setBorder(new TitledBorder(null, "动作列表", TitledBorder.TOP, TitledBorder.LEFT, 10));
			
			m_tree = new JTree();
			
			append(m_tree);
		}
		
		public function setTreeModel(model:DefaultTreeModel):void
		{
			m_tree.setModel(model);
		}
		
		public function dispose():void
		{
		}
	}
}