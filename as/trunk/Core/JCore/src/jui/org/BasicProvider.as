package jui.org
{
	public class BasicProvider extends ResourceProvider
	{
		public function BasicProvider()
		{
			super();
		}
		
		override public function getDefaults():UIDefaults
		{
			var table:UIDefaults = new UIDefaults();
			
			initClassDefaults(table);
			initSystemColorDefaults(table);
			initSystemFontDefaults(table);
			initComponentDefaults(table);
			
			return table;
		}
		
		protected function initClassDefaults(table:UIDefaults):void
		{
			
		}
		
		protected function initSystemColorDefaults(table:UIDefaults):void
		{
			
		}
		
		protected function initSystemFontDefaults(table:UIDefaults):void
		{
			
		}
		
		protected function initComponentDefaults(table:UIDefaults):void
		{
			
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}