package jsion.tool.pngpacker.panes
{
	import jsion.tool.pngpacker.PNGPackerFrame;
	import jsion.tool.pngpacker.data.DirectionInfo;
	import jsion.utils.StringUtil;
	
	import org.aswing.JScrollPane;
	import org.aswing.border.TitledBorder;
	
	public class BottomPane extends JScrollPane
	{
		private var m_frame:PNGPackerFrame;
		
		private var m_info:DirectionInfo;
		
		public function BottomPane(frame:PNGPackerFrame)
		{
			m_frame = frame;
			
			super();
			
			setPreferredHeight(160);
			
			setBorderTitle();
		}
		
		private function setBorderTitle(actionName:String = null, dirName:String = null):void
		{
			if(StringUtil.isNullOrEmpty(actionName) || StringUtil.isNullOrEmpty(dirName))
			{
				setBorder(new TitledBorder(null, "帧列表", TitledBorder.TOP, TitledBorder.LEFT, 10));
			}
			else
			{
				setBorder(new TitledBorder(null, "帧列表：" + actionName + "-" + dirName, TitledBorder.TOP, TitledBorder.LEFT, 10));
			}
		}
		
		private function clear():void
		{
			if(m_info == null) return;
		}
		
		private function refresh():void
		{
			if(m_info)
			{
				setBorderTitle(m_info.action.name, m_info.name);
			}
			else
			{
				setBorderTitle();
			}
		}
		
		public function setDirInfo(dir:DirectionInfo = null):void
		{
			if(m_info != dir)
			{
				clear();
				
				m_info = dir;
				
				refresh();
			}
		}
	}
}