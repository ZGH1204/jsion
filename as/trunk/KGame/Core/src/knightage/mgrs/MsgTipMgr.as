package knightage.mgrs
{
	import flash.display.Sprite;
	
	import jsion.comps.UIMgr;
	import jsion.utils.DisposeUtil;

	public class MsgTipMgr
	{
		private static var m_cartoon:MessageTipAsset;
		
		public function MsgTipMgr()
		{
		}
		
		public static function setup():void
		{
			var sprite:Sprite = new Sprite();
			
			UIMgr.addMsgTip(sprite);
			
			sprite.parent.mouseEnabled = false;
			sprite.parent.mouseChildren = false;
			
			DisposeUtil.free(sprite);
			sprite = null;
		}
		
		private static function initialize():void
		{
			m_cartoon = new MessageTipAsset();
			m_cartoon.mouseChildren = false;
			m_cartoon.mouseEnabled = false;
			m_cartoon.tip_mc.mouseChildren = false;
			m_cartoon.tip_mc.mouseEnabled = false;
			m_cartoon.tip_mc.tip_txt.mouseEnabled = false;
			
			m_cartoon.addFrameScript(m_cartoon.totalFrames - 1, end);
		}
		
		private static function end():void
		{
			//m_cartoon.gotoAndStop(m_cartoon.totalFrames);
			
			m_cartoon.addFrameScript(m_cartoon.totalFrames - 1, null);
			
			hide();
		}
		
		
		
		private static function setContent(t:String):void
		{
			m_cartoon.tip_mc.tip_txt.text = t;
		}
		
		public static function show(msg:String,replaced:Boolean = true):void
		{
			if(replaced)
			{
				if(m_cartoon == null)
				{
					initialize();
					
					UIMgr.addMsgTip(m_cartoon);
					
					setCenter();
				}
				
				m_cartoon.gotoAndPlay(1);
				setContent(msg);
			}
			else if(m_cartoon == null)
			{
				initialize();
				
				UIMgr.addMsgTip(m_cartoon);
				
				setCenter();
				
				m_cartoon.gotoAndPlay(1);
				setContent(msg);
			}
		}
		
		private static function setCenter():void
		{
			if(m_cartoon)
			{
				m_cartoon.x = Config.GameWidth / 2;
				m_cartoon.y = Config.GameHeight / 3;
			}
		}
		
		public static function hide():void
		{
			DisposeUtil.free(m_cartoon);
			m_cartoon = null;
		}
	}
}