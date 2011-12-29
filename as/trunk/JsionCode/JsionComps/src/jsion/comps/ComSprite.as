package jsion.comps
{
	import flash.display.DisplayObject;
	
	import jsion.core.ddrop.DDropMgr;
	import jsion.core.ddrop.IDragDrop;
	
	
	public class ComSprite extends BasicSprite implements IDragDrop
	{
		private var m_enableDrag:Boolean;
		
		
		
		public function ComSprite()
		{
			super();
		}
		
		public function get dragGroup():String
		{
			return null;
		}
		
		public function get enableDrag():Boolean
		{
			return m_enableDrag;
		}
		
		public function set enableDrag(value:Boolean):void
		{
			if(m_enableDrag != value)
			{
				if(m_enableDrag) DDropMgr.unregisteDrag(this);
				
				m_enableDrag = value;
				
				if(m_enableDrag) DDropMgr.registeDrag(this, dragGroup);
			}
		}
		
		
		//==============================================		IDragDrop member		==============================================
		
		public function get isClickDrag():Boolean
		{
			return false;
		}
		
		public function get lockCenter():Boolean
		{
			return false;
		}
		
		public function set lockCenter(value:Boolean):void
		{
		}
		
		public function get transData():*
		{
			return null;
		}
		
		public function get reviseInStage():Boolean
		{
			return true;
		}
		
		public function get freeDragingIcon():Boolean
		{
			return false;
		}
		
		public function get dragingIcon():DisplayObject
		{
			return this;
		}
		
		public function startDragCallback():void
		{
		}
		
		public function dragingCallback():void
		{
		}
		
		public function dropCallback():void
		{
		}
		
		public function dropHitCallback(dragger:IDragDrop, data:*):void
		{
		}
		
		//==============================================		IDragDrop member		==============================================
		
		
		override public function dispose():void
		{
			DDropMgr.unregisteDrag(this);
			
			super.dispose();
		}
	}
}