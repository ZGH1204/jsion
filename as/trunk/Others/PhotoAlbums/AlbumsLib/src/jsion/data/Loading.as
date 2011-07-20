package jsion.data
{
	import com.utils.StringHelper;

	public class Loading
	{
		public var backColor:uint;
		public var backColorAlpha:Number = 1;
		public var backPic:String = "";
		public var backLayerOut:String = "tile";
		public var drawColor:Boolean;
		public var showBack:Boolean;
		public var showPercentNum:Boolean;
		public var showAnimation:Boolean;
		public var showProgress:Boolean;
		public var  photoRoot:String = "";
		
		public var percentX:int;
		public var percentY:int;
		public var percentFont:String = "";
		public var percentSize:int;
		public var percentColor:uint;
		public var percentBold:Boolean;
		public var percentItalic:Boolean;
		
		public var animationX:int;
		public var animationY:int;
		public var animationPic:String = "";
		public var animationWidth:int;
		public var animationHeight:int;
		public var frameInterval:int;
		
		public var progressX:int;
		public var progressY:int;
		public var progressBarBg:String = "";
		public var progressBar:String = "";
		public var progressBarX:int;
		public var progressBarY:int;
		public var progressBarWidth:int;
		
		
		
		public function slovePath(path:String):String
		{
			if(StringHelper.isNullOrEmpty(path)) return "";
			return (photoRoot + path)
		}
	}
}