package jsion.tool.textcompress
{
	import jsion.tool.BaseFrame;
	import jsion.tool.ToolGlobal;
	
	import org.aswing.BorderLayout;
	import org.aswing.FlowLayout;
	import org.aswing.JPanel;
	import org.aswing.border.TitledBorder;
	
	public class TextCompressFrame extends BaseFrame
	{
		private var m_panel:JPanel;
		
		public function TextCompressFrame()
		{
			super(ToolGlobal.window);
			
			m_content.setLayout(new BorderLayout(1,1));
			
			m_panel = new JPanel(new FlowLayout(FlowLayout.CENTER));
			m_panel.setBorder(new TitledBorder(null, "拖入文件进行压缩", TitledBorder.TOP, TitledBorder.LEFT, 10));
			m_content.append(m_panel);
			
			setSizeWH(300, 200);
		}
	}
}