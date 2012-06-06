package jsion.tool.mapeditor.panes.materials
{
	import jsion.tool.mapeditor.MapFrame;
	
	import org.aswing.JTabbedPane;
	import org.aswing.border.TitledBorder;
	import org.aswing.event.ResizedEvent;
	
	public class MaterialsTabbed extends JTabbedPane
	{
		private var m_frame:MapFrame;
		
		private var m_npcTab:NPCTab;
		
		private var m_mapRoot:String;
		
		public function MaterialsTabbed(frame:MapFrame)
		{
			m_frame = frame;
			
			super();
			
			
			m_npcTab = new NPCTab(m_frame);
			m_npcTab.tabbed = this;
			append(m_npcTab, "NPC");
			
			
			setBorder(new TitledBorder(null, '素材列表', TitledBorder.TOP, TitledBorder.LEFT, 10));
		}
		
		public function setMapRoot(r:String):void
		{
			m_mapRoot = r;
			
			m_npcTab.setMapRoot(r);
		}

		override public function setSizeWH(w:int, h:int):void
		{
			super.setSizeWH(w, h);
			
			var count:int = (h - 50) / 19;
			
			m_npcTab.setListVisibleRowCount(count);
		}
	}
}