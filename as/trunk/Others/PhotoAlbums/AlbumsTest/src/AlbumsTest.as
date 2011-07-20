package
{
	import com.LibSetup;
	import com.interfaces.ILoader;
	import com.loader.DisplayLoader;
	import com.loader.LoaderCollection;
	import com.managers.CacheManager;
	import com.utils.DisposeHelper;
	import com.utils.GraphicsHelper;
	import com.utils.MatrixHelper;
	import com.utils.MetricHelper;
	import com.utils.StringHelper;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Security;
	import flash.utils.Dictionary;
	
	import jsion.AlbumsMgr;
	import jsion.BitmapDataMgr;
	import jsion.GlobalMgr;
	import jsion.PageFlipClass;
	import jsion.data.Albums;
	import jsion.data.PhotoPage;
	import jsion.loaders.AlbumsConfigLoader;
	import jsion.loaders.ConfigLoader;
	import jsion.loaders.PlayerConfigLoader;
	import jsion.view.AlbumsFlip;
	
	[SWF(width="1000", height="620", frameRate="25")]
	public class AlbumsTest extends Sprite
	{
		private var _dragLayer:DisplayObjectContainer;
		private var _configLoaderList:LoaderCollection;
		
		private var _albumConfig:AlbumsConfigLoader;
		private var _playerConfig:PlayerConfigLoader;
		
		public function AlbumsTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			init();
		}
		
		private function init():void
		{
			_dragLayer = new Sprite();
			GraphicsHelper.drawRect(stage.stageWidth, stage.stageHeight, _dragLayer, 0x0, 1);
			addChild(_dragLayer);
			
			var loader:ConfigLoader = new ConfigLoader();
			loader.loadAsync(callback);
		}
		
		private function callback(loader:ConfigLoader):void
		{
			if(loader.isSuccess)
			{
				LibSetup.setup(stage, _dragLayer, true, new Dictionary(), loader.xmlData);
				
				var xl:XMLList = loader.xmlData.POLICY_FILES..file;
				for each(var xml:XML in xl)
				{
					Security.loadPolicyFile(String(xml.@value));
				}
				
				_configLoaderList = new LoaderCollection();
				
				_albumConfig = new AlbumsConfigLoader(String(loader.xmlData.@albumsConfig));
				_playerConfig = new PlayerConfigLoader(String(loader.xmlData.@playerConfig));
				
				_configLoaderList.addLoader(_albumConfig, 50);
				_configLoaderList.addLoader(_playerConfig, 50);
				
				_configLoaderList.startLoad(configListLoadCallback);
			}
		}
		
		private function configListLoadCallback():void
		{
			var albumsXml:XML, playerXml:XML;
			
			if(_albumConfig.isSuccess)
			{
				albumsXml = _albumConfig.xmlData;
			}
			
			if(_playerConfig.isSuccess)
			{
				playerXml = _playerConfig.xmlData;
			}
			
			GlobalMgr.Instance.setup(this, albumsXml, playerXml, _dragLayer);
			
			GlobalMgr.Instance.createAlbumFlipAndPlayer(AlbumsMgr.Instance.current);
			
			DisposeHelper.dispose(_configLoaderList);
			_configLoaderList = null;
		}
	}
}