package jsion.rpg.editor.controls
{
	import flash.events.Event;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import jsion.rpg.RPGGlobal;
	import jsion.rpg.datas.MapInfo;
	import jsion.rpg.editor.EditorGlobal;
	import jsion.utils.StringUtil;
	
	import org.aswing.AbstractButton;
	import org.aswing.ButtonGroup;
	import org.aswing.JLabel;
	import org.aswing.JPanel;
	import org.aswing.JRadioButton;
	import org.aswing.JTextField;
	import org.aswing.SoftBoxLayout;
	import org.aswing.ext.Form;

	public class FileNewFrame extends BaseFrame
	{
		protected var m_form:Form;
		
		private var mapidTxt:JTextField;
		
		private var mapWidthTxt:JTextField;
		private var mapHeightTxt:JTextField;
		
		private var smallWidthTxt:JTextField;
		
		private var tileWidthTxt:JTextField;
		private var tileHeightTxt:JTextField;
		
		private var wayTileWidthTxt:JTextField;
		private var wayTileHeightTxt:JTextField;
		
		private var codeType_PNG:JRadioButton;
		private var codeType_JPG:JRadioButton;
		
		
		public function FileNewFrame()
		{
			super();
		}
		
		override protected function configFrame():void
		{
			super.configFrame();
			
			m_title = "新建";
			m_frameWidth = 305;
			m_frameHeight = 235;
		}
		
		override protected function initialize():void
		{
			m_form = new Form();
			m_form.setVGap(5);
			m_container.append(m_form);
			
			var pane:JPanel;
			
			mapidTxt = new JTextField("未命名地图", 19);
			m_form.addRow(new JLabel("地图ＩＤ："), mapidTxt);
			
			mapWidthTxt = new JTextField("2000", 7);
			mapWidthTxt.getTextField().background = true;
			mapWidthTxt.getTextField().backgroundColor = 0xFFFFFF;
			setTextAlignCenter(mapWidthTxt);
			mapHeightTxt = new JTextField("2000", 7);
			mapHeightTxt.getTextField().background = true;
			mapHeightTxt.getTextField().backgroundColor = 0xFFFFFF;
			setTextAlignCenter(mapHeightTxt);
			pane = new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS));
			pane.appendAll(mapWidthTxt, new JLabel("px * "), mapHeightTxt, new JLabel("px"));
			m_form.addRow(new JLabel("地图大小："), pane);
			
			smallWidthTxt = new JTextField("200", 17);
			smallWidthTxt.getTextField().background = true;
			smallWidthTxt.getTextField().backgroundColor = 0xFFFFFF;
			setTextAlignCenter(smallWidthTxt);
			pane = new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS));
			pane.appendAll(smallWidthTxt, new JLabel(" px"));
			m_form.addRow(new JLabel("缩略宽度："), pane);
			
			tileWidthTxt = new JTextField("200", 7);
			tileWidthTxt.getTextField().background = true;
			tileWidthTxt.getTextField().backgroundColor = 0xFFFFFF;
			setTextAlignCenter(tileWidthTxt);
			tileHeightTxt = new JTextField("200", 7);
			tileHeightTxt.getTextField().background = true;
			tileHeightTxt.getTextField().backgroundColor = 0xFFFFFF;
			setTextAlignCenter(tileHeightTxt);
			pane = new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS));
			pane.appendAll(tileWidthTxt, new JLabel("px * "), tileHeightTxt, new JLabel("px"));
			m_form.addRow(new JLabel("Tile大小："), pane);
			
			wayTileWidthTxt = new JTextField("50", 7);
			setTextAlignCenter(wayTileWidthTxt);
			wayTileWidthTxt.getTextField().background = true;
			wayTileWidthTxt.getTextField().backgroundColor = 0xFFFFFF;
			wayTileHeightTxt = new JTextField("50", 7);
			setTextAlignCenter(wayTileHeightTxt);
			wayTileHeightTxt.getTextField().background = true;
			wayTileHeightTxt.getTextField().backgroundColor = 0xFFFFFF;
			pane = new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS));
			pane.appendAll(wayTileWidthTxt, new JLabel("px * "), wayTileHeightTxt, new JLabel("px"));
			m_form.addRow(new JLabel("碰撞格子："), pane);
			
			codeType_PNG = new JRadioButton("PNG");
			codeType_PNG.setHorizontalAlignment(AbstractButton.LEFT);
			codeType_PNG.setPreferredWidth(80);
			codeType_JPG = new JRadioButton("JPG");
			codeType_JPG.setHorizontalAlignment(AbstractButton.LEFT);
			codeType_JPG.setPreferredWidth(60);
			codeType_JPG.setSelected(true);
			var gp:ButtonGroup = new ButtonGroup();
			gp.appendAll(codeType_PNG, codeType_JPG);
			pane = new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS));
			pane.appendAll(codeType_PNG, codeType_JPG);
			m_form.addRow(new JLabel("编码类型："), pane);
			
			createOKAndCancelBtn();
		}
		
		override protected function onSubmit(e:Event):void
		{
			var mapInfo:MapInfo = new MapInfo();
			
			mapInfo.id = StringUtil.trim(mapidTxt.getText());
			mapInfo.width = int(mapWidthTxt.getText());
			mapInfo.height = int(mapHeightTxt.getText());
			mapInfo.tileWidth = int(tileWidthTxt.getText());
			mapInfo.tileHeight = int(tileHeightTxt.getText());
			mapInfo.hitTileWidth = int(wayTileWidthTxt.getText());
			mapInfo.hitTileHeight = int(wayTileHeightTxt.getText());
			mapInfo.smallMapWidth = int(smallWidthTxt.getText());
			
			
			if(StringUtil.isNullOrEmpty(mapInfo.id) ||
				mapInfo.width <= 0 ||
				mapInfo.height <= 0 ||
				mapInfo.tileWidth <= 0 ||
				mapInfo.tileHeight <= 0 ||
				mapInfo.hitTileWidth <= 0 ||
				mapInfo.hitTileHeight <= 0 ||
				mapInfo.smallMapWidth <= 0)
			{
				return;
			}
			
			EditorGlobal.mapInfo = mapInfo;
			
			super.onSubmit(e);
		}
		
		private function setTextAlignCenter(txt:JTextField):void
		{
			txt.setTextFormat(new TextFormat(null, null, null, null, null, null, null, null, TextFormatAlign.CENTER));
		}
	}
}