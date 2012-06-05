package jsion.tool.mapeditor.panes.materials
{
	import flash.filesystem.File;
	
	import jsion.tool.mapeditor.MapFrame;
	import jsion.tool.mgrs.FileMgr;
	
	import org.aswing.LayoutManager;
	
	public class NPCTab extends MaterialsTab
	{
		private static const NPCRoot:String = "npcs";
		
		public function NPCTab(frame:MapFrame, layout:LayoutManager=null)
		{
			super(frame, layout);
		}
		
		override public function refreshListData():void
		{
//			if(tabbed == null) return;
//			
//			var mr:String = tabbed.mapRoot;
//			
//			var file:File = new File(mr);
//			
//			file = file.resolvePath(NPCRoot);
//			
//			if(file.exists == false) file.createDirectory();
//			
//			var list:Array = FileMgr.getAllChildFiles(file);
//			
//			var listData:Array = [];
//			
//			for each(var f:File in list)
//			{
//				listData.push(f.nativePath.replace(file.nativePath, ""));
//			}
//			
//			m_list.setListData(listData);
		}
	}
}