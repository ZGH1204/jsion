package jsion.rpg.editor
{
	import jsion.rpg.datas.MapInfo;
	import jsion.rpg.editor.centers.MapShower;

	public class EditorGlobal
	{
		private static var m_mapInfo:MapInfo;
		
		public function get mapInfo():MapInfo
		{
			return m_mapInfo;
		}
		
		public function set mapInfo(value:MapInfo):void
		{
			m_mapInfo = value;
		}
		
		public static var mainEditor:MainEditor;
	}
}