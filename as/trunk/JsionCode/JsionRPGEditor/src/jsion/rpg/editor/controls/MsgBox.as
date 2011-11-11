package jsion.rpg.editor.controls
{
	import org.aswing.FlowLayout;
	import org.aswing.JLabel;
	import org.aswing.JPanel;
	import org.aswing.JTextArea;
	import org.aswing.SoftBoxLayout;

	public class MsgBox extends BaseFrame
	{
		public static const ERROR:int = 1;
		
		public static const LEFT_MARGIN:int = 15;
		public static const RIGHT_MARGIN:int = 15;
		public static const TOP_MARGIN:int = 38;
		public static const BOTTOM_MARGIN:int = 47;
		
		protected var m_msg:String;
		protected var m_msgTitle:String;
		protected var m_type:int;
		protected var m_textField:JLabel;
		
		public function MsgBox(msg:String, title:String = "消息", type:int = ERROR)
		{
			m_msg = msg;
			m_msgTitle = title;
			m_type = type;
			
			super();
		}
		
		override protected function configFrame():void
		{
			super.configFrame();
			
			m_title = m_msgTitle;
		}
		
		override protected function initialize():void
		{
			m_textField = new JLabel();
			
			m_textField.setText(m_msg);
			
			m_textField.pack();
			
			if(m_textField.width > (m_frameWidth - LEFT_MARGIN - RIGHT_MARGIN)) m_frameWidth = m_textField.width + LEFT_MARGIN + RIGHT_MARGIN;
			
			if(m_textField.height > 20) m_frameHeight = m_textField.height + TOP_MARGIN + BOTTOM_MARGIN;
			
			setSizeWH(m_frameWidth, m_frameHeight);
			
			
			var jpanle:JPanel = new JPanel(new FlowLayout(FlowLayout.CENTER, 10, 5));
			jpanle.append(m_textField);
			m_container.append(jpanle);
			
			createOKBtn();
		}
	}
}