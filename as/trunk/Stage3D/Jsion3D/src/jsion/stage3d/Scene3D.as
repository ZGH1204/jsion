package jsion.stage3d
{
	import flash.events.EventDispatcher;
	
	import jsion.IDispose;
	
	public class Scene3D extends EventDispatcher implements IDispose
	{
		protected var m_viewWidth:Number;
		protected var m_viewHeight:Number;
		
		public function Scene3D(vwidth:Number, vheight:Number)
		{
			super();
			
			m_viewWidth = vwidth;
			m_viewHeight = vheight;
		}
		
		public function dispose():void
		{
		}
	}
}