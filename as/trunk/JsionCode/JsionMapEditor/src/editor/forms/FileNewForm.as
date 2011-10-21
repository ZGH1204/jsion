package editor.forms
{
	import editor.JsionEditorWin;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import org.aswing.JButton;
	import org.aswing.JLabel;
	import org.aswing.JPanel;
	import org.aswing.JTextField;
	import org.aswing.SoftBoxLayout;
	import org.aswing.ext.Form;
	
	public class FileNewForm extends JsionEditorWin
	{
		private static const FormW:int = 300;
		
		private static const FormH:int = 200;
		
		/**
		 * 间距
		 */ 
		private static const Padding:uint=5;
		
		
		private var mapidTxt:JTextField;
		
		private var mapWidthTxt:JTextField;
		private var mapHeightTxt:JTextField;
		
		private var smallWidthTxt:JTextField;
		private var smallHeightTxt:JTextField;
		
		private var tileWidthTxt:JTextField;
		private var tileHeightTxt:JTextField;
		
		private var outputDirTxt:JTextField;
		private var browserBtn:JButton;
		
		public function FileNewForm(owner:JsionMapEditor)
		{
			mytitle = "新建";
			super(owner, true);
		}
		
		override protected function init():void
		{
			main = new JPanel(new SoftBoxLayout(SoftBoxLayout.Y_AXIS, Padding));
			
			box = new Form();
			//_box.setSizeWH(FormW, 100);
			
			var pane:JPanel;
			
			mapidTxt = new JTextField(JsionEditor.mapid, 19);
			box.addRow(new JLabel("地图ＩＤ："), mapidTxt);
			
			mapWidthTxt = new JTextField(String(JsionEditor.MAP_WIDTH), 7);
			mapWidthTxt.setTextFormat(new TextFormat(null, null, null, null, null, null, null, null, TextFormatAlign.CENTER));
			mapHeightTxt = new JTextField(String(JsionEditor.MAP_HEIGHT), 7);
			mapHeightTxt.setTextFormat(new TextFormat(null, null, null, null, null, null, null, null, TextFormatAlign.CENTER));
			pane = new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS));
			pane.appendAll(mapWidthTxt, new JLabel("px * "), mapHeightTxt, new JLabel("px"));
			box.addRow(new JLabel("地图大小："), pane);
			
			smallWidthTxt = new JTextField(String(JsionEditor.SMALL_MAP_WIDTH), 7);
			smallWidthTxt.setTextFormat(new TextFormat(null, null, null, null, null, null, null, null, TextFormatAlign.CENTER));
			smallHeightTxt = new JTextField(String(JsionEditor.SMALL_MAP_HEIGHT), 7);
			smallHeightTxt.setTextFormat(new TextFormat(null, null, null, null, null, null, null, null, TextFormatAlign.CENTER));
			pane = new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS));
			pane.appendAll(smallWidthTxt, new JLabel("px * "), smallHeightTxt, new JLabel("px"));
			box.addRow(new JLabel("缩略地图："), pane);
			
			tileWidthTxt = new JTextField(String(JsionEditor.TILE_WIDTH), 7);
			tileWidthTxt.setTextFormat(new TextFormat(null, null, null, null, null, null, null, null, TextFormatAlign.CENTER));
			tileHeightTxt = new JTextField(String(JsionEditor.TILE_HEIGHT), 7);
			tileHeightTxt.setTextFormat(new TextFormat(null, null, null, null, null, null, null, null, TextFormatAlign.CENTER));
			pane = new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS));
			pane.appendAll(tileWidthTxt, new JLabel("px * "), tileHeightTxt, new JLabel("px"));
			box.addRow(new JLabel("Tile大小："), pane);
			
			browserBtn = new JButton("浏览");
			browserBtn.addActionListener(__browserClickHandler);
			outputDirTxt = new JTextField(JsionEditor.MAP_OUTPUT_ROOT, 16);
			pane = new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS));
			pane.appendAll(outputDirTxt, browserBtn);
			box.addRow(new JLabel("输出目录："), pane);
			
			
			
			main.append(new JPanel());
			main.append(box);
			main.setSizeWH(FormW, FormH);
			
			
			
			super.init();
		}
		
		private function __browserClickHandler(e:Event):void
		{
			var file:File = new File();
			file.browseForDirectory("请选择输出目录");
			file.addEventListener(Event.SELECT, __browserSelectHandler);
		}
		
		private function __browserSelectHandler(e:Event):void
		{
			File(e.currentTarget).removeEventListener(Event.SELECT, __browserSelectHandler);
			outputDirTxt.setText(File(e.target).nativePath);
		}
		
		override protected function onSubmit(e:Event):void
		{
			JsionEditor.MAP_NEWED_OPENED = true;
			JsionEditor.MAP_OUTPUT_ROOT = outputDirTxt.getText();
			JsionEditor.mapid = mapidTxt.getText();
			JsionEditor.MAP_WIDTH = int(mapWidthTxt.getText());
			JsionEditor.MAP_HEIGHT = int(mapHeightTxt.getText());
			JsionEditor.SMALL_MAP_WIDTH = int(smallWidthTxt.getText());
			JsionEditor.SMALL_MAP_HEIGHT = int(smallHeightTxt.getText());
			JsionEditor.TILE_WIDTH = int(tileWidthTxt.getText());
			JsionEditor.TILE_HEIGHT = int(tileHeightTxt.getText());
			
			super.onSubmit(e);
		}
	}
}