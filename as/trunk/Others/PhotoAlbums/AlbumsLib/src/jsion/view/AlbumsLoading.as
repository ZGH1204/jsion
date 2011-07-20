package jsion.view
{
	import com.StageReference;
	import com.interfaces.IDispose;
	import com.utils.DisposeHelper;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import jsion.AlbumsMgr;
	import jsion.BitmapDataMgr;
	import jsion.controls.Renderer;
	import jsion.data.Loading;
	
	public class AlbumsLoading extends Sprite implements IDispose
	{
		private var _loading:Loading;
		
		private var _bg:Background;
		private var _percentText:TextField;
		
		private var _progressContainer:Sprite;
		private var _progressBarBg:Bitmap;
		private var _progressBar:Bitmap;
		
		private var _animationRenderer:Renderer;

		public function get loading():Loading
		{
			return _loading;
		}

		public function set loading(value:Loading):void
		{
			_loading = value;
			if(_loading == null) return;
			
			initialize();
			initBackground();
			initContainer();
			initProgressBar();
			initAnimation();
			initTextField();
		}
		
		private function initialize():void
		{
			if(_loading.drawColor)
			{
				graphics.clear();
				graphics.beginFill(_loading.backColor, _loading.backColorAlpha);
				graphics.drawRect(0, 0, StageReference.stage.stageWidth, StageReference.stage.stageHeight);
				graphics.endFill();
			}
		}
		
		private function initBackground():void
		{
			if(_loading.showBack)
			{
				DisposeHelper.dispose(_bg);
				_bg = new Background(StageReference.stage.stageWidth, StageReference.stage.stageHeight);
				addChild(_bg);
			}
		}
		
		private function initContainer():void
		{
			if(_loading.showProgress)
			{
				DisposeHelper.dispose(_progressContainer);
				_progressContainer = new Sprite();
				_progressContainer.x = _loading.progressX;
				_progressContainer.y = _loading.progressY;
				addChild(_progressContainer);
			}
		}
		
		private function initProgressBar():void
		{
			if(_loading.showProgress && _progressContainer)
			{
				var bmd:BitmapData;
				bmd = BitmapDataMgr.Instance.getBitmapData(_loading.slovePath(_loading.progressBarBg));
				if(bmd) _progressBarBg = new Bitmap(bmd);
				if(_progressBarBg) _progressContainer.addChild(_progressBarBg);
				
				bmd = BitmapDataMgr.Instance.getBitmapData(_loading.slovePath(_loading.progressBar));
				if(bmd) _progressBar = new Bitmap(bmd, PixelSnapping.AUTO, true);
				if(_progressBar)
				{
					_progressBar.x = _loading.progressBarX;
					_progressBar.y = _loading.progressBarY;
					_progressBar.width = 1;
					_progressContainer.addChild(_progressBar);
				}
			}
		}
		
		private function initAnimation():void
		{
			if(_loading.showAnimation)
			{
				DisposeHelper.dispose(_animationRenderer);
				_animationRenderer = new Renderer(_loading.animationWidth, _loading.animationHeight, _loading.frameInterval, true);
				_animationRenderer.sourceBmd = BitmapDataMgr.Instance.getBitmapData(_loading.slovePath(_loading.animationPic));
				_animationRenderer.x = _loading.animationX;
				_animationRenderer.y = _loading.animationY;
				addChild(_animationRenderer);
			}
		}
		
		private function initTextField():void
		{
			if(_loading.showPercentNum)
			{
				DisposeHelper.dispose(_percentText);
				_percentText = AlbumsMgr.createTextField("0", _loading.percentFont, _loading.percentSize, _loading.percentColor, _loading.percentBold, _loading.percentItalic, _loading.percentX, _loading.percentY);
				addChild(_percentText);
			}
		}
		
		
		
		public function AlbumsLoading()
		{
		}
		
		public function get percent():int
		{
			if(_loading.showPercentNum && _percentText)
			{
				return int(_percentText.text);
			}
			return 0;
		}
		
		public function set percent(value:int):void
		{
			if(_loading.showPercentNum && _percentText) _percentText.text = String(value);
			if(_loading.showProgress && _progressContainer && _progressBar && value != 0)
			{
				_progressBar.width = _loading.progressBarWidth * value / 100;
			}
		}
		
		public function dispose():void
		{
			DisposeHelper.dispose(_bg);
			_bg = null;
			
			DisposeHelper.dispose(_percentText);
			_percentText = null;
			
			DisposeHelper.dispose(_progressContainer);
			_progressContainer = null;
			
			DisposeHelper.dispose(_progressBarBg);
			_progressBarBg = null;
			
			DisposeHelper.dispose(_progressBar);
			_progressBar = null;
			
			DisposeHelper.dispose(_animationRenderer);
			_animationRenderer = null;
			
			_loading = null;
			
			if(parent) parent.removeChild(this);
		}
	}
}