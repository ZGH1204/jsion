package jsion.tool.mapeditor.panes.materials
{
	import jsion.tool.mapeditor.MapFrame;
	
	import org.aswing.JList;
	import org.aswing.JPanel;
	import org.aswing.JScrollPane;
	import org.aswing.LayoutManager;
	
	public class MaterialsTab extends JPanel
	{
		private var m_frame:MapFrame;
		
		private var m_list:JList;
		
		private var m_scrollPane:JScrollPane;
		
		public function MaterialsTab(frame:MapFrame, layout:LayoutManager = null)
		{
			m_frame = frame;
			
			super(layout);
			
			m_list = new JList(["1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1"]);
			m_list.setVisibleCellWidth(190);
			m_list.setVisibleRowCount(10);
			m_scrollPane = new JScrollPane(m_list);
			append(m_scrollPane);
		}
		
		public function setListVisibleRowCount(count:int):void
		{
			m_list.setVisibleRowCount(count);
		}
	}
}