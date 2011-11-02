package editor.forms
{
	import editor.events.LibTabEvent;
	import editor.forms.movieparts.MovieInfoForm;
	import editor.forms.movieparts.RendererForm;
	import editor.rightviews.ResourcePreviewer;
	import editor.rightviews.ResourceTabbed;
	
	import flash.display.BitmapData;
	
	import jsion.utils.PathUtil;
	
	import org.aswing.BorderLayout;
	import org.aswing.Container;
	import org.aswing.JPanel;
	import org.aswing.SoftBoxLayout;

	public class MovieEditorForm extends BaseEditorForm
	{
		protected var c:Container;
		
		protected var leftContainer:JPanel;
		
		protected var mainContainer:JPanel;
		
		protected var previewer:ResourcePreviewer;
		
		protected var resourceTabbed:ResourceTabbed;
		
		protected var movieInfoForm:MovieInfoForm;
		
		public var rendererForm:RendererForm;
		
		public var renderInfos:HashMap;
		
		public function MovieEditorForm(owner:JsionMapEditor)
		{
			mytitle = "序列图配置器";
			WinWidth = 680;
			WinHeight = 481;
			renderInfos = JsionEditor.surfaceRenderInfo;
			super(owner, true);
		}
		
		override protected function init():void
		{
			c = new Container();
			c.setOpaque(true);
			c.setLayout(new BorderLayout(2, 2));
			
			setResizable(false);
			
			c.setSizeWH(WinWidth, WinHeight);
			
			
			var w:Number = c.width;// + Padding * 2;
			var h:Number = c.height;// + Padding * 2;
			
			setLocationXY((mapEditor.Window.width - w) / 2, (mapEditor.Window.height - h) / 2);
			
			setSizeWH(w, h);
			
			getContentPane().append(c);
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			leftContainer = new JPanel(new SoftBoxLayout(SoftBoxLayout.Y_AXIS, Padding));
			leftContainer.setPreferredWidth(170);
			c.append(leftContainer, BorderLayout.WEST);
			
			
			mainContainer = new JPanel(new SoftBoxLayout(SoftBoxLayout.Y_AXIS, Padding));
			c.append(mainContainer, BorderLayout.CENTER);
			
			
			
			previewer = new ResourcePreviewer(170, 179);
			leftContainer.append(previewer);
			
			resourceTabbed = new ResourceTabbed(mapEditor, previewer);
			leftContainer.append(resourceTabbed);
			
			
			
			
			
			
			
			
			
			
			
			
			rendererForm = new RendererForm(this, 489, 307);
			mainContainer.append(rendererForm);
			
			movieInfoForm = new MovieInfoForm(this);
			mainContainer.append(movieInfoForm);
		}
		
		override protected function initEvent():void
		{
			resourceTabbed.buildingsTab.addEventListener(LibTabEvent.SELECT_FILE, __buildingSelectHandler, false, 0, true);
			resourceTabbed.npcsTab.addEventListener(LibTabEvent.SELECT_FILE, __npcSelectHandler, false, 0, true);
			resourceTabbed.surfaceTab.addEventListener(LibTabEvent.SELECT_FILE, __surfaceSelectHandler, false, 0, true);
		}
		
		private function __buildingSelectHandler(e:LibTabEvent):void
		{
			renderInfos = JsionEditor.buildingRenderInfo;
			
			var path:String = PathUtil.combinPath(JsionEditor.MAP_BUILDINGS_DIR, e.filename);
			
			onSelect(path, e.filename, e.obj as BitmapData);
		}
		
		private function __npcSelectHandler(e:LibTabEvent):void
		{
			renderInfos = JsionEditor.npcRenderInfo;
			
			var path:String = PathUtil.combinPath(JsionEditor.MAP_NPCS_DIR, e.filename);
			
			onSelect(path, e.filename, e.obj as BitmapData);
		}
		
		private function __surfaceSelectHandler(e:LibTabEvent):void
		{
			renderInfos = JsionEditor.surfaceRenderInfo;
			
			var path:String = PathUtil.combinPath(JsionEditor.MAP_SURFACES_DIR, e.filename);
			
			onSelect(path, e.filename, e.obj as BitmapData);
		}
		
		private function onSelect(path:String, filename:String, bmd:BitmapData):void
		{
			movieInfoForm.updateInfo(path, filename, bmd);
		}
	}
}