package jsion.rpg.editor.controls
{
	import flash.events.Event;

	public class ConfirmBox extends MsgBox
	{
		protected var m_callback:Function;
		
		public function ConfirmBox(msg:String, title:String = "消息", callback:Function = null, type:int = ERROR)
		{
			m_callback = callback;
			
			super(msg, title, type);
		}
		
		override protected function onSubmit(e:Event):void
		{
			if(m_callback != null) m_callback(true);
			
			super.onSubmit(e);
		}
		
		override protected function onCancle(e:Event):void
		{
			if(m_callback != null) m_callback(false);
			
			super.onCancle(e);
		}
	}
}