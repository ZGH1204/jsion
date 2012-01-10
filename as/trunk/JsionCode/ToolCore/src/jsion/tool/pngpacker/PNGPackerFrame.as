package jsion.tool.pngpacker
{
	import jsion.tool.BaseFrame;
	
	import org.aswing.BorderLayout;
	import org.aswing.Container;
	import org.aswing.JPanel;
	import org.aswing.JTree;
	import org.aswing.SoftBoxLayout;
	import org.aswing.border.TitledBorder;
	import org.aswing.event.TreeSelectionEvent;
	import org.aswing.tree.DefaultMutableTreeNode;
	import org.aswing.tree.DefaultTreeModel;
	import org.aswing.tree.TreeModel;
	import org.aswing.tree.TreePath;
	
	public class PNGPackerFrame extends BaseFrame
	{
		protected var m_topPanel:JPanel;
		
		protected var m_leftPanel:JPanel;
		
		protected var m_mainPanel:Container;
		
		protected var m_bottomPanel:JPanel;
		
		private var m_tree:JTree;
		
		private var m_toolBox:ToolBox;
		
		public function PNGPackerFrame(owner:*=null, modal:Boolean=false)
		{
			m_title = "资源打包器";
			
			super(owner, modal);
			
			setSizeWH(850, 500);
			
			show();
			
			configUI();
			
			initTop();
			
			initLeft();
		}
		
		private function configUI(): void
		{
			m_content.setLayout(new BorderLayout(1,1));
			
			m_topPanel = new JPanel(new SoftBoxLayout(SoftBoxLayout.Y_AXIS));
			m_leftPanel = new JPanel(new SoftBoxLayout(SoftBoxLayout.Y_AXIS, 5));
			m_bottomPanel = new JPanel(new SoftBoxLayout(SoftBoxLayout.Y_AXIS, 5));
			m_mainPanel = new Container();
			m_mainPanel.setLayout(new BorderLayout(1,1));
			
			m_leftPanel.setBorder(new TitledBorder(null, "动作列表", TitledBorder.TOP, TitledBorder.LEFT, 10));
			m_bottomPanel.setBorder(new TitledBorder(null, "帧列表", TitledBorder.TOP, TitledBorder.LEFT, 10));
			
			m_topPanel.setPreferredHeight(30);
			m_bottomPanel.setPreferredHeight(120);
			m_leftPanel.setPreferredWidth(200);
			
			m_content.append(m_topPanel, BorderLayout.NORTH);
			m_content.append(m_leftPanel, BorderLayout.WEST);
			m_content.append(m_mainPanel, BorderLayout.CENTER);
			m_mainPanel.append(m_bottomPanel, BorderLayout.SOUTH);
		}
		
		private function initTop():void
		{
			m_toolBox = new ToolBox(this);
			m_topPanel.append(m_toolBox);
		}
		
		private function initLeft():void
		{
			m_tree = new JTree();
			var root:DefaultMutableTreeNode = new DefaultMutableTreeNode("无");
			var model:DefaultTreeModel = new DefaultTreeModel(root);
			
			var f:DefaultMutableTreeNode = new DefaultMutableTreeNode("sdfsdf");
			root.append(f);
			trace(root.isLeaf());
			
			m_tree.setModel(model);
			m_leftPanel.append(m_tree);
			
			m_tree.addEventListener(TreeSelectionEvent.TREE_SELECTION_CHANGED, __treeSelectionHandler);
		}
		
		private function __treeSelectionHandler(e:TreeSelectionEvent):void
		{
			trace(m_tree.getSelectionPath().getLastPathComponent().getUserObject());
		}
	}
}