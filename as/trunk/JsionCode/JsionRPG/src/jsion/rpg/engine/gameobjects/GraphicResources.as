package jsion.rpg.engine.gameobjects
{
	import flash.display.BitmapData;
	
	import jsion.utils.ArrayUtil;

	public class GraphicResources implements IDispose
	{
		public static const MIRROR:String = '_mirror';
		
		/**
		 * 位图
		 */ 
		public var bitmapData:BitmapData;
		
		/**
		 * 镜像位图
		 */
		public var bitmapDataMirror:BitmapData;
		
		/**
		 * 播放帧率
		 */		
		public var fps:Number = 0;
		
		
		protected var m_frameWidth:int;
		
		protected var m_frameHeight:int;
		
		protected var m_hFrameTotal:int;
		
		protected var m_vRowTotal:int;
		
		protected var m_lineFrameTotals:Array;
		
		protected var m_needMirror:Boolean;
		
		public function GraphicResources()
		{
		}
		
		public function get frameWidth():int
		{
			return m_frameWidth;
		}
		
		public function get frameHeight():int
		{
			return m_frameHeight;
		}
		
		public function get hFrameTotal():int
		{
			return m_hFrameTotal;
		}
		
		public function get vRowTotal():int
		{
			return m_vRowTotal;
		}
		
		public function get lineFrameTotals():Array
		{
			return m_lineFrameTotals;
		}
		
		public function set lineFrameTotals(value:Array):void
		{
			m_lineFrameTotals = ArrayUtil.clone(value);
		}
		
		public function getFrameTotal(line:int):int
		{
			if(m_lineFrameTotals == null || line >= m_lineFrameTotals.length || m_lineFrameTotals[line] == null)
				return m_hFrameTotal;
			
			return m_lineFrameTotals[line];
		}
		
		public function dispose():void
		{
		}
	}
}