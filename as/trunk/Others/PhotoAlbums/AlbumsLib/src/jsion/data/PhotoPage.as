package jsion.data
{
	import com.utils.StringHelper;

	public class PhotoPage
	{
		public var text:String = "";
		public var font:String = "";
		public var size:int;
		public var color:uint;
		public var bold:Boolean;
		public var italic:Boolean;
		public var textX:int;
		public var textY:int;
		public var link:String = "";
		public var enableClick:Boolean;
		public var enableScroll:Boolean;
		public var enableScale:Boolean;
		
		public var isPreface:Boolean;
		public var prefacePic:String;
		public var prefacePicX:int;
		public var prefacePicY:int;
		public var prefacePicWidth:int;
		public var prefacePicHeight:int;
		public var prefacePicSpacing:int;
		public var firstPicX:int;
		public var firstPicY:int;
		public var direction:String;//H水平,V垂直
		
		public var closeBtnPaddingX:int;
		public var closeBtnPaddingY:int;
		
		private var _containerX:int;

		public function get containerX():int
		{
			return _containerX;
		}

		public function set containerX(value:int):void
		{
			_containerX = value;
		}

		public var containerY:int;
		
		public var thumbnail:String = "";
		public var thumbnailX:int;
		public var thumbnailY:int;
		
		public var topPic:String = "";
		public var middlePic:String = "";
		public var bottomPic:String = "";
		
		public var picWidth:int;
		public var picHeight:int;
		
		public var picX:int;
		public var picY:int;
		
		public var topPicX:int;
		public var topPicY:int;
		public var topPicRotate:int;
		
		public var middlePicX:int;
		public var middlePicY:int;
		public var middlePicRotate:int;
		
		public var bottomPicX:int;
		public var bottomPicY:int;
		public var bottomPicRotate:int;
		
		public var showMiddleExtend1:Boolean;
		public var middlePicX1:int;
		public var middlePicY1:int;
		public var middlePicRotate1:int;
		
		public var showMiddleExtend2:Boolean;
		public var middlePicX2:int;
		public var middlePicY2:int;
		public var middlePicRotate2:int;
		
		
		
		//与相册共有属性
		public var author:String = "";
		public var photoRoot:String = "";
		
		public var authorFont:String = "";
		public var authorSize:int;
		public var authorColor:uint;
		public var authorBold:Boolean;
		public var authorItalic:Boolean;
		
		
		
		
		public function slovePath(path:String):String
		{
			if(StringHelper.isNullOrEmpty(path)) return "";
			return (photoRoot + path);
		}
	}
}