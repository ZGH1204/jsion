package jcomponent.org.coms.buttons
{
	import jcomponent.org.basic.Component;
	import jcomponent.org.basic.IComponentUI;

	public class CheckBoxBackground extends ButtonImageBackground
	{
		public function CheckBoxBackground(freeBitmapData:Boolean=false)
		{
			super(freeBitmapData);
		}
		
		override protected function updateStateView(component:Component, ui:IComponentUI, bounds:IntRectangle):void
		{
			stateView.update(null);
			
			stateView.updateTrigger(bounds.getSize());
		}
	}
}