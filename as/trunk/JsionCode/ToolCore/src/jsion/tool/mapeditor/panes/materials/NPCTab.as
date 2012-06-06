package jsion.tool.mapeditor.panes.materials
{
	import flash.filesystem.File;
	
	import jsion.tool.mapeditor.MapFrame;
	import jsion.tool.mgrs.FileMgr;
	
	import org.aswing.LayoutManager;
	
	public class NPCTab extends MaterialsTab
	{
		private static const NPCRoot:String = "npcs";
		
		private var m_listData:Array;
		
		public function NPCTab(frame:MapFrame, layout:LayoutManager=null)
		{
			super(frame, layout);
		}
		
		override public function refreshListData():void
		{
			if(tabbed == null) return;
			
			var file:File = new File(m_mapRoot);
			
			file = file.resolvePath(NPCRoot);
			
			if(file.exists == false) file.createDirectory();
			
			var list:Array = FileMgr.getAllChildFiles(file);
			
			m_listData = [];
			
			var repStr:String = file.nativePath + "\\"
			
			for each(var f:File in list)
			{
				m_listData.push(f.nativePath.replace(repStr, ""));
			}
			
			m_list.setListData(m_listData);
		}
	}
}