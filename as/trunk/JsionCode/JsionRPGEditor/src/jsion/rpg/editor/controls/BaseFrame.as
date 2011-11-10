package jsion.rpg.editor.controls
{
	import jsion.rpg.editor.EditorGlobal;
	
	import org.aswing.JFrame;
	
	public class BaseFrame extends JFrame
	{
		protected var m_title:String;
		
		protected var m_modal:Boolean;
		
		protected var m_frameWidth:int;
		
		protected var m_frameHeight:int;
		
		public function BaseFrame()
		{
			configFrame();
			
			super(EditorGlobal.mainEditor, m_title, m_modal);
			
			setSizeWH(m_frameWidth, m_frameHeight);
			
			initialize();
		}
		
		protected function configFrame():void
		{
			m_frameWidth = 200;
			m_frameHeight = 80;
		}
		
		protected function initialize():void
		{
		}
	}
}