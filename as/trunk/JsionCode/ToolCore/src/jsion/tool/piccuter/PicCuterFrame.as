package jsion.tool.piccuter
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import jsion.Constant;
	import jsion.core.encoders.JPGEncoder;
	import jsion.core.encoders.PNGEncoder;
	import jsion.tool.BaseFrame;
	import jsion.tool.ToolGlobal;
	import jsion.tool.mgrs.FileMgr;
	import jsion.utils.DisposeUtil;
	import jsion.utils.ScaleUtil;
	import jsion.utils.StringUtil;
	
	import mx.controls.Alert;
	
	import org.aswing.AbstractButton;
	import org.aswing.ButtonGroup;
	import org.aswing.JButton;
	import org.aswing.JLabel;
	import org.aswing.JPanel;
	import org.aswing.JProgressBar;
	import org.aswing.JRadioButton;
	import org.aswing.JTextField;
	import org.aswing.SoftBoxLayout;
	import org.aswing.event.AWEvent;
	
	public class PicCuterFrame extends BaseFrame
	{
		public static const PNG_EXT:String = ".png";
		public static const JPG_EXT:String = ".jpg";
		
		/**
		 * 图片文件路径存放显示
		 */		
		private var m_picPathTxt:JTextField;
		
		/**
		 * 浏览选择图片文件
		 */		
		private var m_browserBtn:JButton;
		
		/**
		 * 输出路径存放显示
		 */		
		private var m_outPathTxt:JTextField;
		
		/**
		 * 输出路径选择
		 */		
		private var m_outBrowserBtn:JButton;
		
		/**
		 * 输出PNG编码图片文件
		 */		
		private var m_pngRadio:JRadioButton;
		
		/**
		 * 输出JPG编码图片文件
		 */		
		private var m_jpgRadio:JRadioButton;
		
		/**
		 * 切割宽度
		 */		
		private var m_tileWidthTxt:JTextField;
		
		/**
		 * 切割高度
		 */		
		private var m_tileHeightTxt:JTextField;
		
		/**
		 * 切割进度
		 */		
		private var m_progressbar:JProgressBar;
		
		/**
		 * 预览所选择的图片
		 */		
		private var m_preview:JPanel;
		
		/**
		 * 图片加载预览
		 */		
		private var m_loader:Loader;
		
		/**
		 * 图片数据
		 */		
		private var m_bitmapData:BitmapData;
		
		/**
		 * 是否正在切割图片
		 */		
		private var m_cuting:Boolean;
		
		/**
		 * 定时器 用于显示切割进度
		 */		
		private var m_timer:Timer;
		
		/**
		 * 正在切割时的临时数据
		 */		
		private var m_cutData:CutData;
		
		public function PicCuterFrame(modal:Boolean=false)
		{
			m_title = "图片切割";
			
			super(ToolGlobal.window, modal);
			
			setResizable(false);
			
			setSizeWH(405, 455);
			
			m_content.setLayout(new SoftBoxLayout(SoftBoxLayout.Y_AXIS, 5));
			
			
			buildForm();
			
			
			m_picPathTxt = new JTextField("", 25);
			m_picPathTxt.setEditable(false);
			
			m_browserBtn = new JButton("浏览");
			m_browserBtn.addActionListener(openFileHandler);
			
			m_box.addRow(new JLabel("选择图片："), m_picPathTxt, m_browserBtn);
			
			
			
			m_outPathTxt = new JTextField(File.desktopDirectory.resolvePath("tiles").nativePath, 12);
			m_outPathTxt.setEditable(false);
			
			m_outBrowserBtn = new JButton("选择");
			m_outBrowserBtn.addActionListener(selectOutPathHandler);
			
			m_box.addRow(new JLabel("输出目录："), m_outPathTxt, m_outBrowserBtn);
			
			
			
			
			
			m_tileWidthTxt = new JTextField("", 9);
			m_tileWidthTxt.getTextField().defaultTextFormat = new TextFormat(null, null, null, null, null, null, null, null, TextFormatAlign.CENTER);
			m_tileWidthTxt.setText("100");
			m_tileWidthTxt.setRestrict("0-9");
			
			m_tileHeightTxt = new JTextField("", 9);
			m_tileHeightTxt.getTextField().defaultTextFormat = new TextFormat(null, null, null, null, null, null, null, null, TextFormatAlign.CENTER);
			m_tileHeightTxt.setText("100");
			m_tileHeightTxt.setRestrict("0-9");
			
			pane = new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS));
			pane.appendAll(m_tileWidthTxt, new JLabel("px    *    "), m_tileHeightTxt, new JLabel("px"));
			
			m_box.addRow(new JLabel("切割大小："), pane);
			
			
			
			
			m_pngRadio = new JRadioButton("PNG");
			m_pngRadio.setHorizontalAlignment(AbstractButton.LEFT);
			m_pngRadio.setPreferredWidth(135);
			
			m_jpgRadio = new JRadioButton("JPG");
			m_jpgRadio.setHorizontalAlignment(AbstractButton.LEFT);
			m_jpgRadio.setPreferredWidth(145);
			m_jpgRadio.setSelected(true);
			
			var group:ButtonGroup = new ButtonGroup();
			group.appendAll(m_pngRadio, m_jpgRadio);
			
			var pane:JPanel = new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS));
			pane.appendAll(m_pngRadio, m_jpgRadio);
			
			m_box.addRow(new JLabel("输出编码："), pane);
			
			
			
			buildFormButton();
			
			
			
			m_progressbar = new JProgressBar(JProgressBar.HORIZONTAL);
			m_content.append(m_progressbar);
			
			m_preview = new JPanel();
			m_preview.setPreferredHeight(240);
			m_content.append(m_preview);
		}
		
		private function openFileHandler(e:AWEvent):void
		{
			FileMgr.openBrowse(openPicCallback, [new FileFilter("支持的图片文件", "*.png;*.jpg")]);
		}
		
		private function openPicCallback(file:File):void
		{
			if(m_picPathTxt)
			{
				m_picPathTxt.setText(file.nativePath);
			
				loadPic(file);
			}
		}
		
		private function loadPic(file:File):void
		{
			if(file.exists == false)
			{
				Alert.show("图片文件不存在!", "提示");
				return;
			}
			
			if(m_loader)
			{
				m_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, __loadCompleteHandler);
				m_loader.unloadAndStop();
				DisposeUtil.free(m_loader);
				m_loader = null;
			}
			
			m_bitmapData = null;
			
			var bytes:ByteArray = new ByteArray();
			
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.READ);
			fs.readBytes(bytes);
			fs.close();
			
			m_loader = new Loader();
			m_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, __loadCompleteHandler);
			m_loader.loadBytes(bytes);
			
			m_preview.addChild(m_loader);
		}
		
		private function __loadCompleteHandler(e:Event):void
		{
			e.currentTarget.removeEventListener(Event.COMPLETE, __loadCompleteHandler);
			
			var scale:Number = ScaleUtil.calcScaleFullSize(m_loader.width, m_loader.height, m_preview.width, m_preview.height);
			
			m_loader.width *= scale;
			m_loader.height *= scale;
			
			m_loader.x = (m_preview.width - m_loader.width) / 2;
			m_loader.y = (m_preview.height - m_loader.height) / 2;
			
			m_bitmapData = Bitmap(m_loader.content).bitmapData;
		}
		
		private function selectOutPathHandler(e:AWEvent):void
		{
			FileMgr.directoryBrowse(selectOutputCallback);
		}
		
		private function selectOutputCallback(file:File):void
		{
			if(m_outPathTxt) m_outPathTxt.setText(file.nativePath);
		}
		
		
		
		override public function closeReleased():void
		{
			if(m_cuting) return;
			
			super.closeReleased();
		}
		
		override protected function onSubmit(e:Event):void
		{
			if(m_cuting)
			{
				Alert.show("正在进行切割!", "提示");
				return;
			}
			
			if(m_bitmapData == null)
			{
				Alert.show("请选择图片后再进行切割!", "提示");
				return;
			}
			
			if(StringUtil.isNullOrEmpty(m_outPathTxt.getText()))
			{
				Alert.show("请选择输出目录!", "提示");
				return;
			}
			
			if(int(m_tileWidthTxt.getText()) <= 0 || int(m_tileHeightTxt.getText()) <= 0)
			{
				Alert.show("切割的宽度和高度都不能为零!", "提示");
				return;
			}
			
			m_cutData = new CutData();
			
			m_cutData.tileWidth = int(m_tileWidthTxt.getText());
			m_cutData.tileHeight = int(m_tileHeightTxt.getText());
			m_cutData.tileRect.x = m_cutData.tileRect.y = 0;
			m_cutData.tileRect.width = m_cutData.tileWidth;
			m_cutData.tileRect.height = m_cutData.tileHeight;
			m_cutData.tileX = m_cutData.tileY = 0;
			m_cutData.tileMaxX = Math.ceil(m_bitmapData.width / m_cutData.tileWidth);
			m_cutData.tileMaxY = Math.ceil(m_bitmapData.height / m_cutData.tileHeight);
			m_cutData.outDirectory = new File(m_outPathTxt.getText());
			m_cutData.extension = m_pngRadio.isSelected() ? PNG_EXT : JPG_EXT;
			
			m_cutData.outDirectory.deleteDirectory(true);
			m_cutData.outDirectory.createDirectory();
			
			m_cuting = true;
			
			m_timer = new Timer(10);
			m_timer.addEventListener(TimerEvent.TIMER, cutFile);
			m_timer.start();
			
			setButtonsEnabled(false);
			setPNGAndJPGEnabled(false);
			setTileSizeEditable(false);
		}
		
		private function cutFile(e:TimerEvent):void
		{
			m_cutData.updateTileRect();
			
			var bmd:BitmapData = new BitmapData(m_cutData.tileWidth, m_cutData.tileHeight, true, 0);
			bmd.copyPixels(m_bitmapData, m_cutData.tileRect, Constant.ZeroPoint);
			
			m_cutData.saveBitmapData(bmd);
			
			if(m_cutData.finished)
			{
				m_timer.stop();
				m_timer.removeEventListener(TimerEvent.TIMER, cutFile);
				m_progressbar.setValue(100);
				setButtonsEnabled(true);
				setPNGAndJPGEnabled(true);
				setTileSizeEditable(true);
				
				Alert.show("图片切割完成", "提示");
				
				m_timer = null;
				m_cuting = false;
				m_cutData.tileRect = null;
				m_cutData.outDirectory = null;
				m_cutData = null;
				
				super.onSubmit(null);
				
				return;
			}
			
			m_progressbar.setValue(int(100 * (m_cutData.tileY * m_cutData.tileMaxX + m_cutData.tileX) / (m_cutData.tileMaxX * m_cutData.tileMaxY)));
		}
		
		public function setButtonsEnabled(b:Boolean):void
		{
			m_browserBtn.setEnabled(b);
			m_outBrowserBtn.setEnabled(b);
			m_pngRadio.setEnabled(b);
			m_jpgRadio.setEnabled(b);
			m_okBtn.setEnabled(b);
			m_cancleBtn.setEnabled(b);
		}
		
		public function setPNGAndJPGEnabled(b:Boolean):void
		{
			m_pngRadio.setEnabled(b);
			m_jpgRadio.setEnabled(b);
		}
		
		public function setPicPath(path:String):void
		{
			m_picPathTxt.setText(path);
			
			loadPic(new File(path));
		}
		
		public function setOutPath(path:String):void
		{
			m_outPathTxt.setText(path);
		}
		
		public function setEncodePNG():void
		{
			m_pngRadio.setSelected(true);
		}
		
		public function setEncodeJPG():void
		{
			m_jpgRadio.setSelected(true);
		}
		
		public function setTileWidth(w:int):void
		{
			m_tileWidthTxt.setText(String(w));
		}
		
		public function setTileHeight(h:int):void
		{
			m_tileHeightTxt.setText(String(h));
		}
		
		public function setTileSizeEditable(b:Boolean):void
		{
			m_tileWidthTxt.setEditable(b);
			m_tileHeightTxt.setEditable(b);
		}
		
		override public function dispose():void
		{
			if(m_browserBtn) m_browserBtn.removeActionListener(openFileHandler);
			if(m_outBrowserBtn) m_outBrowserBtn.removeActionListener(selectOutPathHandler);
			
			if(m_loader)
			{
				m_loader.removeEventListener(Event.COMPLETE, __loadCompleteHandler);
				m_loader.unloadAndStop();
			}
			
			DisposeUtil.free(m_loader);
			m_loader = null;
			
			m_picPathTxt = null;
			m_browserBtn = null;
			m_outPathTxt = null;
			m_outBrowserBtn = null;
			m_pngRadio = null;
			m_jpgRadio = null;
			m_tileWidthTxt = null;
			m_tileHeightTxt = null;
			m_progressbar = null;
			m_preview = null;
			m_bitmapData = null;
			
			super.dispose();
		}
	}
}

import flash.display.BitmapData;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.geom.Rectangle;
import flash.utils.ByteArray;

import jsion.core.encoders.JPGEncoder;
import jsion.core.encoders.PNGEncoder;
import jsion.tool.piccuter.PicCuterFrame;
import jsion.utils.StringUtil;

class CutData
{
	public var tileX:int;
	
	public var tileY:int;
	
	public var tileWidth:int;
	
	public var tileHeight:int;
	
	public var tileMaxX:int;
	
	public var tileMaxY:int;
	
	public var outDirectory:File;
	
	public var extension:String;
	
	public var tileRect:Rectangle = new Rectangle();
	
	public var finished:Boolean = false;
	
	public function updateTileRect():void
	{
		tileRect.x = tileX * tileWidth;
		tileRect.y = tileY * tileHeight;
	}
	
	public function saveBitmapData(bmd:BitmapData):void
	{
		if(finished) return;
		
		var bytes:ByteArray = encode(bmd);
		
		var file:File = resolvePath();
		
		var fs:FileStream = new FileStream();
		
		fs.open(file, FileMode.WRITE);
		fs.writeBytes(bytes);
		fs.close();
		
		tileX += 1;
		
		if(tileX >= tileMaxX)
		{
			tileX = 0;
			
			tileY += 1;
			
			if(tileY >= tileMaxY)
			{
				finished = true;
			}
		}
	}
	
	private function encode(bmd:BitmapData):ByteArray
	{
		if(extension == PicCuterFrame.PNG_EXT)
		{
			return PNGEncoder.encode(bmd);
		}
		else
		{
			return JPGEncoder.encode(bmd);
		}
	}
	
	private function resolvePath():File
	{
		var filename:String = StringUtil.format("{1}_{0}{2}", tileX, tileY, extension);
		
		return outDirectory.resolvePath(filename);
	}
}