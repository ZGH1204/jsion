package road.v.core
{
	public class GraphItem extends DVBase
	{
        protected var _emphasized:Boolean = false;
        protected var _index:uint;
        
		public function GraphItem()
		{
		}
		
		
		public function get index():uint
		{
			return _index;
		}
		
		public function set index(value:uint):void
		{
			_index = value;
		}
		
		public function normalize():void
		{
			if(!_emphasized) return;
			
			_emphasized = false;
			validateAll();
			doNormalize();
		}
		
		public function emphasize():void
		{
			if(_emphasized) return;
			
			_emphasized = true;
			validateAll();
			doEmphasize();
		}
		
		protected function doEmphasize():void
		{
			
		}
		
		protected function doNormalize():void
		{
			
		}
	}
}