package jsion.tool.mapeditor.panes.materials
{
	import jsion.tool.mapeditor.MapFrame;
	
	import org.aswing.JTabbedPane;
	import org.aswing.border.TitledBorder;
	import org.aswing.event.ResizedEvent;
	
	public class MaterialsTabbed extends JTabbedPane
	{
		private var m_frame:MapFrame;
		
		private var m_tab1:MaterialsTab;
		
		public function MaterialsTabbed(frame:MapFrame)
		{
			m_frame = frame;
			
			super();
			
			
			m_tab1 = new MaterialsTab(m_frame);
			append(m_tab1, "建筑");
			
			
			addEventListener(ResizedEvent.RESIZED, __resizeHandler);
			
			
			setBorder(new TitledBorder(null, '素材列表', TitledBorder.TOP, TitledBorder.LEFT, 10));
		}
		
		private function __resizeHandler(e:ResizedEvent):void
		{
			trace("MaterialsTabbed Size：", width, height);
		}
		
		override public function setSizeWH(w:int, h:int):void
		{
			super.setSizeWH(w, h);
			
			var count:int = (h - 50) / 19;
			
			m_tab1.setListVisibleRowCount(count);
		}
	}
}