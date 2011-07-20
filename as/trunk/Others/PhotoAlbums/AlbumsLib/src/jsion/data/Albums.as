package jsion.data
{
	import com.utils.StringHelper;

	public class Albums extends PhotoPage
	{
		public var albumsWidth:int;
		public var albumsHeight:int;
		
		public var name:String = "";
		public var nameFont:String = "";
		public var nameSize:int;
		public var nameColor:uint;
		public var nameBold:Boolean;
		public var nameItalic:Boolean;
		public var nameX:int;
		public var nameY:int;
		
		public var enableMusic:Boolean;
		public var musicListIndex:int;
		public var playSkinIndex:int;
		public var enableSetPlayerPos:Boolean;
		public var playerX:int;
		public var playerY:int;
		
		public var description:String = "";
		public var dscptFont:String = "";
		public var dscptSize:int;
		public var dscptColor:uint;
		public var dscptBold:Boolean;
		public var dscptItalic:Boolean;
		public var dscptX:int;
		public var dscptY:int;
		
		public var prePageBtn:String = "";
		public var prePageBtnOver:String = "";
		public var prePageBtnX:int;
		public var prePageBtnY:int;
		
		public var nextPageBtn:String = "";
		public var nextPageBtnOver:String = "";
		public var nextPageBtnX:int;
		public var nextPageBtnY:int;
		
		public var selectAlbumsBtn:String = "";
		public var selectAlbumsBtnOver:String = "";
		public var selectAlbumsBtnX:int;
		public var selectAlbumsBtnY:int;
		
		public var closeBtn:String = "";
		public var closeBtnOver:String = "";
		
		public var indexCloseBtnPX:int;
		public var indexCloseBtnPY:int;
		
		public var authorX:int;
		public var authorY:int;
		
		public var directoryText:String = "";
		public var directoryBtn:String = "";
		public var directoryBtnOver:String = "";
		public var directoryBtnX:int;
		public var directoryBtnY:int;
		public var directoryFont:String = "";
		public var directorySize:int;
		public var directoryColor:uint;
		public var directoryBold:Boolean;
		public var directoryItalic:Boolean;
		
		public var coverBtnText:String = "";
		public var coverBtn:String = "";
		public var coverBtnOver:String = "";
		public var coverBtnX:int;
		public var coverBtnY:int;
		public var coverBtnFont:String = "";
		public var coverBtnSize:int;
		public var coverBtnColor:uint;
		public var coverBtnBold:Boolean;
		public var coverBtnItalic:Boolean;
		
		public var backcBtnText:String = "";
		public var backcBtn:String = "";
		public var backcBtnOver:String = "";
		public var backcBtnX:int;
		public var backcBtnY:int;
		public var backcBtnFont:String = "";
		public var backcBtnSize:int;
		public var backcBtnColor:uint;
		public var backcBtnBold:Boolean;
		public var backcBtnItalic:Boolean;
		
		public var printName:String = "";
		public var printFont:String = "";
		public var printSize:int;
		public var printColor:uint;
		public var printBold:Boolean;
		public var printItalic:Boolean;
		public var printUrl:String = "";
		public var printPage:String = "";
		public var printPageOver:String = "";
		public var printPageX:int;
		public var printPageY:int;
		
		public var commentsName:String = "";
		public var commentsFont:String = "";
		public var commentsSize:int;
		public var commentsColor:uint;
		public var commentsBold:Boolean;
		public var commentsItalic:Boolean;
		public var commentsUrl:String = "";
		public var commentsPage:String = "";
		public var commentsPageOver:String = "";
		public var commentsPageX:int;
		public var commentsPageY:int;
		
		public var albumListBg:String = "";
		public var listContainerX:int;
		public var listContainerY:int;
		public var albumListCoverPic:String = "";
		public var albumListCoverPicX:int;
		public var albumListCoverPicY:int;
		public var listContainerWidth:int;
		public var listContainerHeight:int;
		
		public var photoListBg:String = "";
		public var photoListX:int;
		public var photoListY:int;
		public var photoLeftListX:int;
		public var photoLeftListY:int;
		public var photoRightListX:int;
		public var photoRightListY:int;
		public var photoListWidth:int;
		public var photoListHeight:int;
		public var photoPageNumberX:int;
		public var photoPageNumberY:int;
		public var photoCols:int;
		public var photoRows:int;
		
		public var photoPageNumberBg:String = "";
		public var photoPageNumberBgOver:String = "";
		public var photoPageNumberFont:String;
		public var photoPageNumberSize:int;
		public var photoPageNumberColor:uint;
		public var photoPageNumberBold:Boolean;
		public var photoPageNumberItalic:Boolean;
		public var thumbnailWidth:int;
		public var thumbnailHeight:int;
		public var thumbnailSpacing:int;
		public var doublePhotoList:Boolean;
		
		public var itemWidth:int;
		public var itemHeight:int;
		public var itemSpacing:int;
		public var cols:int;
		public var rows:int;
		public var pageNumberBtn:String = "";
		public var pageNumberBtnOver:String = "";
		public var pageNumberX:int;
		public var pageNumberY:int;
		public var pageNumberSpacing:int;
		public var pageNumberFont:String = "";
		public var pageNumberSize:int;
		public var pageNumberColor:uint;
		public var pageNumberBold:Boolean;
		public var pageNumberItalic:Boolean;
		
		public var photoError:String = "";
		
		public var stageBackColor:uint;
		public var stageBackground:String="";
		public var stageBgX:int;
		public var stageBgY:int;
		public var layerOut:String = "";
		
		public var pageWidth:int;
		public var pageHeight:int;
		
		public var background:String = "";
		public var x:int;
		public var y:int;
		
		public var coverPage:String = "";
		public var coverPageX:int;
		public var coverPageY:int;
		
		public var backcPage:String = "";
		public var backcPageX:int;
		public var backcPageY:int;
		
		public var leftPage:String = "";
		public var leftPageX:int;
		public var leftPageY:int;
		
		public var rightPage:String = "";
		public var rightPageX:int;
		public var rightPageY:int;
		
		
		
		public var listTitle:String = "选择相册";
		public var listTitleX:int;
		public var listTitleY:int;
		public var listTitleFont:String = "";
		public var listTitleSize:int;
		public var listTitleColor:uint;
		public var listTitleBold:Boolean;
		public var listTitleItalic:Boolean;
		
		
		
		//非配置文件属性
		
		public var loading:Loading;
		public var cover:CoverPage;
		public var backc:BackcPage;
		
		public var photoPageList:Vector.<PhotoPage> = new Vector.<PhotoPage>;
		
		
		
		
		
		override public function slovePath(path:String):String
		{
			if(StringHelper.isNullOrEmpty(path)) return "";
			return (photoRoot + path);
		}
	}
}