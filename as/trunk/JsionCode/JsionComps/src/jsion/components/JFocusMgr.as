package jsion.components
{
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	
	import jsion.utils.ArrayUtil;
	import jsion.utils.InstanceUtil;

	public class JFocusMgr
	{
		private var m_stage:Stage;
		
		private var m_list:Array;
		
		public function JFocusMgr()
		{
			m_list = [];
		}
		
		public function setup(stage:Stage):void
		{
			m_stage = stage;
			m_stage.focus = m_stage;
		}
		
		public function setFocusIn(focuser:JFocusRoot):void
		{
			var index:int = m_list.indexOf(focuser);
			
			if(index != -1)
			{
				if(index != (m_list.length - 1))
				{
					ArrayUtil.remove(m_list, focuser);
					m_list.push(focuser);
				}
			}
			else
			{
				m_list.push(focuser);
			}
			
			m_stage.focus = focuser;
		}
		
		public function setFocusOut(focuser:JFocusRoot):void
		{
			var index:int = m_list.indexOf(focuser);
			
			if(index != -1)
			{
				ArrayUtil.remove(m_list, focuser);
			}
			
			if(m_list.length != 0) m_stage.focus = m_list[m_list.length - 1] as InteractiveObject;
			else m_stage.focus = m_stage;
		}
		
		public static function get Instance():JFocusMgr
		{
			return InstanceUtil.createSingletion(JFocusMgr) as JFocusMgr;
		}
	}
}