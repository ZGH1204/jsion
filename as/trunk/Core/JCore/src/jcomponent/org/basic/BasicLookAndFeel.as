package jcomponent.org.basic
{
	public class BasicLookAndFeel extends LookAndFeel
	{
		public function BasicLookAndFeel()
		{
			super();
		}
		
		override public function getResources():IUIResources
		{
			var table:IUIResources = new UIResources();
			
			var list:Array;
			
			list = [];
			initClassResources(list);
			table.putResources(list);
			
			list = [];
			initColorResources(list);
			table.putResources(list);
			
			list = [];
			initFontResources(list);
			table.putResources(list);
			
			list = [];
			initComponentResources(list);
			table.putResources(list);
			
			return table;
		}
		
		protected function initClassResources(list:Array):void
		{
			
		}
		
		protected function initColorResources(list:Array):void
		{
			
		}
		
		protected function initFontResources(list:Array):void
		{
			
		}
		
		protected function initComponentResources(list:Array):void
		{
			
		}
	}
}