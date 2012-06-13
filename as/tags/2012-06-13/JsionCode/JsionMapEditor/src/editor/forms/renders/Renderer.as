package editor.forms.renders
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import jsion.rpg.engine.EngineGlobal;
	import jsion.utils.ArrayUtil;
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
			EngineGlobal.Timer = getTimer();
			
			m_bmd.lock();
			m_bmd.fillRect(m_bmd.rect, 0);//0x64000000);
			for each(var render:Render in m_renders)
			{
				render.render(m_bmd);
			}
			m_bmd.unlock();
		}
		
		public function addRender(render:Render):void
		{
			if(render)
			{
				render.renderer = this;
				ArrayUtil.push(m_renders, render);
			}
		}
	}
}