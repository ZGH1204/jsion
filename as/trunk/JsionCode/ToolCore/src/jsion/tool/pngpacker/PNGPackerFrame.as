package jsion.tool.pngpacker
{
	import jsion.tool.BaseFrame;
	import jsion.tool.pngpacker.data.ActionInfo;
	import jsion.tool.pngpacker.data.DirectionInfo;
	import jsion.tool.pngpacker.data.PackerModel;
	
	import org.aswing.BorderLayout;
	import org.aswing.Component;
	import org.aswing.Container;
	import org.aswing.FlowLayout;
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
		
		protected var m_renderPanel:JPanel;
		
		protected var m_bottomPanel:JPanel;
		
		private var m_tree:JTree;
		
		private var m_toolBox:ToolBox;
		
		private var m_packerData:PackerModel;
		
		private var m_currentDirInfo:DirectionInfo;
		
		public function PNGPackerFrame(owner:*=null, modal:Boolean=false)
		{
			m_title = "资源打包器";
			
			super(owner, modal);
			
			setSizeWH(850, 500);
			
			m_packerData = new PackerModel();
			
			configUI();
			
			initTop();
			
			initLeft();
			
			initBottom();
		}
		
		public function get packerData():PackerModel
		{
			return m_packerData;
		}
		
		public function get currentDirInfo():DirectionInfo
		{
			return m_currentDirInfo;
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
			m_bottomPanel.setPreferredHeight(160);
			m_leftPanel.setPreferredWidth(200);
			
			m_content.append(m_topPanel, BorderLayout.NORTH);
			m_content.append(m_leftPanel, BorderLayout.WEST);
			m_content.append(m_mainPanel, BorderLayout.CENTER);
			m_mainPanel.append(m_bottomPanel, BorderLayout.SOUTH);
			
			m_renderPanel = new JPanel(new FlowLayout(FlowLayout.CENTER));
			m_renderPanel.setBorder(new TitledBorder(null, "预览", TitledBorder.TOP, TitledBorder.LEFT, 10));
			m_mainPanel.append(m_renderPanel, BorderLayout.CENTER);
		}
		
		private function initTop():void
		{
			m_toolBox = new ToolBox(this);
			m_topPanel.append(m_toolBox);
		}
		
		private function initLeft():void
		{
			m_tree = new JTree();
			
			m_tree.setModel(m_packerData.model);
			
			m_leftPanel.append(m_tree);
			
			m_tree.addEventListener(TreeSelectionEvent.TREE_SELECTION_CHANGED, __treeSelectionHandler);
		}
		
		private function initBottom():void
		{
			
		}
		
		private function __treeSelectionHandler(e:TreeSelectionEvent):void
		{
			var path:TreePath = e.getPath();
			
			if(path == null || path.getLastPathComponent() == null) return;
			
			var treeNode:DefaultMutableTreeNode = path.getLastPathComponent();
			
			if(treeNode == m_packerData.root || treeNode.isLeaf() == false) return;
			
			var list:Array = m_packerData.getPath(treeNode);
			
			if(list) setCurrent(list[0] as ActionInfo, list[1] as DirectionInfo);
		}
		
		private function setCurrent(actionInfo:ActionInfo, dirInfo:DirectionInfo):void
		{
			m_bottomPanel.setBorder(new TitledBorder(null, "帧列表：" + actionInfo.name + "-" + dirInfo.name, TitledBorder.TOP, TitledBorder.LEFT, 10));
			
			m_currentDirInfo = dirInfo;
		}
		
		public function setSelected(actionInfo:ActionInfo, dirInfo:DirectionInfo):void
		{
			m_tree.collapsePath(new TreePath([m_packerData.root]));
			m_tree.expandPath(new TreePath([m_packerData.root]));
			
			m_tree.collapsePath(new TreePath([m_packerData.root, actionInfo.node]));
			m_tree.expandPath(new TreePath([m_packerData.root, actionInfo.node]));
			m_tree.setSelectionPath(new TreePath([dirInfo.node]));
		}
		
		public function refreshTree():void
		{
			var list:Array = m_packerData.getAllActions();
			
			for each(var aInfo:ActionInfo in list)
			{
				if(m_tree.isExpanded(new TreePath([m_packerData.root, aInfo.node])))
				{
					m_tree.collapsePath(new TreePath([m_packerData.root, aInfo.node]));
					m_tree.expandPath(new TreePath([m_packerData.root, aInfo.node]));
				}
				else
				{
					m_tree.expandPath(new TreePath([m_packerData.root, aInfo.node]));
					m_tree.collapsePath(new TreePath([m_packerData.root, aInfo.node]));
				}
			}
			
			//m_tree.collapsePath(new TreePath([m_packerData.root]));
		}
	}
}