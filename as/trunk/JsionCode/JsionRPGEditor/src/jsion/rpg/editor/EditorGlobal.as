package jsion.rpg.editor
{
	import jsion.rpg.datas.MapInfo;
	import jsion.rpg.editor.centers.MapShower;
	import jsion.rpg.editor.controls.ConfirmBox;
	import jsion.rpg.editor.controls.MsgBox;

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
		
		
		
		
		
		
		
		
		
		
		
		
		public static function alert(msg:String, title:String = "信息"):void
		{
			new MsgBox(msg, title).show();
		}
		
		public static function confirm(msg:String, title:String = "提示", callback:Function = null):void
		{
			new ConfirmBox(msg, title, callback);
		}
	}
}