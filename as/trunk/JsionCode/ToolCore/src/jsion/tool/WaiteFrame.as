package jsion.tool
{
	
	import org.aswing.ASColor;
	import org.aswing.BorderLayout;
	import org.aswing.Box;
	import org.aswing.BoxLayout;
	import org.aswing.JLabel;
	
	public class WaiteFrame extends BaseFrame
	{
		private static var m_frame:WaiteFrame;
		
		private var m_label:JLabel;
		
		private var m_panel:Box;
		
		public function WaiteFrame()
		{
			super(ToolGlobal.window, true);
			
			setSizeWH(200, 80);
			
			m_panel = new Box(BoxLayout.X_AXIS);
			m_content.append(m_panel);
			
			m_label = new JLabel();
			
			m_label.setForeground(new ASColor(0xFFF600));
			
			m_panel.append(m_label);
			
			setResizable(false);
		}
		
		public function setMsg(msg:String):void
		{
			if(m_label)
			{
				m_label.setText(msg);
				m_label.pack();
			}
		}
		
		public static function show(msg:String):void
		{
			if(m_frame) m_frame.closeReleased();
			
			m_frame = new WaiteFrame();
			m_frame.setMsg(msg);
			m_frame.show();
		}
		
		public static function close():void
		{
			if(m_frame) m_frame.closeReleased();
			m_frame = null;
		}
	}
}