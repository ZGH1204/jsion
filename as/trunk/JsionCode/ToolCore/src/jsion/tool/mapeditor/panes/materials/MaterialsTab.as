package jsion.tool.mapeditor.panes.materials
{
	import jsion.tool.mapeditor.MapFrame;
	
	import org.aswing.JList;
	import org.aswing.JPanel;
	import org.aswing.JScrollPane;
	import org.aswing.LayoutManager;
	
	public class MaterialsTab extends JPanel
	{
		protected var m_frame:MapFrame;
		
		protected var m_list:JList;
		
		private var m_scrollPane:JScrollPane;
		
		public var tabbed:MaterialsTabbed;
		
		protected var m_mapRoot:String;
		
		public function MaterialsTab(frame:MapFrame, layout:LayoutManager = null)
		{
			m_frame = frame;
			
			super(layout);
			
			m_list = new JList();
			m_list.setVisibleCellWidth(190);
			m_list.setVisibleRowCount(10);
			m_scrollPane = new JScrollPane(m_list);
			append(m_scrollPane);
		}
		
		public function setMapRoot(r:String):void
		{
			m_mapRoot = r;
			
			refreshListData();
		}
		
		public function refreshListData():void
		{
		}
		
		public function setListVisibleRowCount(count:int):void
		{
			m_list.setVisibleRowCount(count);
		}
	}
}