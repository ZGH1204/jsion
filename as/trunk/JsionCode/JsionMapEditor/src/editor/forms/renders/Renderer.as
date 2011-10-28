package editor.forms.renders
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	import jsion.utils.JUtil;
	
	public class Renderer extends Bitmap
	{
		protected var m_bmd:BitmapData;
		
		protected var m_renders:Array;
		
		public function Renderer(w:int, h:int)
		{
			m_renders = [];
			
			m_bmd = new BitmapData(w, h);
			
			super(m_bmd);
			
			JUtil.addEnterFrame(__enterFrameHandler);
		}
		
		private function __enterFrameHandler(e:Event):void
		{
			//for each(var render:Render in m_ren
	}
}