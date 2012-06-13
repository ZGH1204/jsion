package jsion.tool
{
	import org.aswing.UIDefaults;
	import org.aswing.plaf.InsetsUIResource;
	import org.aswing.plaf.basic.BasicLookAndFeel;
	
	public class ToolLookAndFeel extends BasicLookAndFeel
	{
		public function ToolLookAndFeel()
		{
			super();
		}
		
		override protected function initComponentDefaults(table:UIDefaults):void
		{
			super.initComponentDefaults(table);
			
			table.putDefaults([
				"TabbedPane.contentMargin", new InsetsUIResource(0, 0, 0, 0)
			]);
		}
	}
}