package jsion.data
{
	import com.utils.StringHelper;

	public class PlayerSkin
	{
		public var playerX:int;
		public var playerY:int;
		
		public var titleX:int;
		public var titleY:int;
		public var titleTextX:int;
		public var titleTextY:int;
		public var titleStep:int;
		public var titleScrollWidth:int;
		public var titleScrollHeight:int;
		public var titleBg:String = "";
		public var titleBgX:int;
		public var titleBgY:int;
		
		public var titleFont:String = "";
		public var titleSize:int;
		public var titleColor:uint;
		public var titleBold:Boolean;
		public var titleItalic:Boolean;
		
		public var preTrackBtn:String = "";
		public var preTrackBtnOver:String = "";
		public var preTrackBtnX:int;
		public var preTrackBtnY:int;
		
		public var nextTrackBtn:String = "";
		public var nextTrackBtnOver:String = "";
		public var nextTrackBtnX:int;
		public var nextTrackBtnY:int;
		
		public var playBtn:String = "";
		public var playBtnOver:String = "";
		public var pauseBtn:String = "";
		public var pauseBtnOver:String = "";
		public var playBtnX:int;
		public var playBtnY:int;
		
		public var stopBtn:String = "";
		public var stopBtnOver:String = "";
		public var stopBtnX:int;
		public var stopBtnY:int;
		
		public var muteBtn:String = "";
		public var muteBtnOver:String = "";
		public var unMuteBtn:String = "";
		public var unMuteBtnOver:String = "";
		public var muteBtnX:int;
		public var muteBtnY:int;
		
		
		public var skinRoot:String = "";
		
		
		public function slovePath(path:String):String
		{
			if(StringHelper.isNullOrEmpty(path)) return "";
			return (skinRoot + path);
		}
	}
}