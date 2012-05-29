package jsion.display
{
	public class ComboBox extends LabelButton
	{
		private var m_listView:List;
		
		public function ComboBox()
		{
			super();
		}
		
		override public function beginChanges():void
		{
			m_listView.beginChanges();
			
			super.beginChanges();
		}
		
		override public function commitChanges():void
		{
			m_listView.commitChanges();
			
			super.commitChanges();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			m_listView = new List();
			m_listView.visible = false;
		}
		
		override protected function addChildren():void
		{
			super.addChildren();
			
			addChild(m_listView);
		}
		
		override protected function onProppertiesUpdate():void
		{
			super.onProppertiesUpdate();
			
			m_listView.x = 0;
			m_listView.y = m_height;
		}
	}
}