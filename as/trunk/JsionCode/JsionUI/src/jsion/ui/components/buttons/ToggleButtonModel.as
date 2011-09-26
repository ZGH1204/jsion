package jsion.ui.components.buttons
{
	public class ToggleButtonModel extends DefaultButtonModel
	{
		public function ToggleButtonModel()
		{
			super();
		}
		
		override public function set selected(value:Boolean):void
		{
			var g:ButtonGroup = group;
			
			if(g != null)
			{
				g.setSelected(this, value);
				
				value = g.isSelected(this);
			}
			
			super.selected = value;
		}
		
		override public function set pressed(value:Boolean):void
		{
			if(m_pressed == value || enabled == false) return;
			
			if(value == false && armed)
			{
				selected = !selected;
			}
			
			m_pressed = value;
			
			fireStateChanged();
			
			if(m_pressed == false && armed) fireActionEvent();
		}
	}
}