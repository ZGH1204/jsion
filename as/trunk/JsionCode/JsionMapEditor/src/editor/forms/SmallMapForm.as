package editor.forms
{
	import editor.leftviews.SmallMap;
	
	import org.aswing.Container;

	public class SmallMapForm extends BaseEditorForm
	{
		protected var smallMap:SmallMap;
		
		public function SmallMapForm(owner:JsionMapEditor, smallMap:SmallMap)
		{
			mytitle = "小地图";
			this.smallMap = smallMap;
			super(owner);
		}
		
		override protected function init():void
		{
			setResizable(false);
			
			setClosable(false);
			
			var pane:Container = getContentPane();
			
			pane.append(smallMap);
			
			var rltWidth:int = JsionEditor.mapConfig.SmallMapWidth + smallMap.getInsets().left + smallMap.getInsets().right + 1;
			var rltHeight:int = JsionEditor.mapConfig.MapHeight * (JsionEditor.mapConfig.SmallMapWidth / JsionEditor.mapConfig.MapWidth) + smallMap.getInsets().top + smallMap.getInsets().bottom + 2;
			
			rltHeight = rltHeight + getInsets().top + getInsets().bottom + getTitleBar().getMinimizeHeight();
			
			setSizeWH(rltWidth + getInsets().left + getInsets().right, rltHeight);
			
			setLocationXY((mapEditor.Window.width - rltWidth) / 2, (mapEditor.Window.height - rltHeight) / 2);
		}
		
		public function removeSmallMap():void
		{
			if(smallMap)
			{
				var pane:Container = getContentPane();
				
				pane.remove(smallMap);
			}
		}
		
		override public function dispose():void
		{
			smallMap = null;
			
			super.dispose();
		}
	}
}