package knightage.hall
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import jsion.IDispose;
	import jsion.ddrop.DDropMgr;
	import jsion.ddrop.IDragDrop;
	import jsion.utils.DisposeUtil;
	
	import knightage.hall.build.BuildSprite;
	import knightage.hall.build.BuildType;
	import knightage.hall.build.BuildView;
	import knightage.mgrs.MsgTipMgr;
	
	public class HallView extends Sprite implements IDragDrop, IDispose
	{
		private var m_background:Bitmap;
		
		private var m_minXPos:int;
		
		private var m_buildList:Array;
		
		public function HallView()
		{
			super();
			
			initialized();
		}
		
		private function initialized():void
		{
			// TODO Auto Generated method stub
			
			DDropMgr.registeDrag(this);
			
			m_background = new Bitmap(new HallBackgroundAsset(0, 0));
			
			addChild(m_background);
			
			m_minXPos = -(m_background.width - Config.GameWidth);
			
			m_buildList = [];
			
			for(var i:int = 1; i <= BuildType.Count; i++)
			{
				var buildView:BuildSprite = new BuildSprite(i);
				
				addChild(buildView);
				
				m_buildList.push(buildView);
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
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
			return false;
		}
		
		public function get freeDragingIcon():Boolean
		{
			return false;
		}
		
		public function get dragingIcon():DisplayObject
		{
			return this;
		}
		
		public function groupDragCallback(dragger:IDragDrop, data:*):void
		{
		}
		
		public function groupDropCallback(dragger:IDragDrop, data:*):void
		{
		}
		
		public function startDragCallback():void
		{
		}
		
		public function dragingCallback():void
		{
			y = 0;
			
			if(x > 0)
			{
				x = 0;
			}
			else if(x < m_minXPos)
			{
				x = m_minXPos;
			}
		}
		
		public function dropCallback():void
		{
		}
		
		public function dropHitCallback(dragger:IDragDrop, data:*):void
		{
		}
		
		public function dispose():void
		{
			DDropMgr.unregisteDrag(this);
			
			DisposeUtil.free(m_buildList);
			m_buildList = null;
			
			DisposeUtil.free(m_background);
			m_background = null;
		}
	}
}