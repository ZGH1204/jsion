package jsion.tool.uieditor
{
	import jsion.tool.BaseFrame;
	import jsion.tool.ToolGlobal;
	
	import org.aswing.BorderLayout;
	
	public class UIEditorFrame extends BaseFrame
	{
		public function UIEditorFrame()
		{
			m_title = "UI编辑器";
			
			super(ToolGlobal.window);
			
			m_content.setLayout(new BorderLayout(1,1));
			
			setMinimumWidth(700);
			setMinimumHeight(450);
			setSizeWH(700, 450);
			
		}
	}
}