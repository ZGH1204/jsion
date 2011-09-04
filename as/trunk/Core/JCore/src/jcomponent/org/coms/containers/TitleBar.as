package jcomponent.org.coms.containers
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import jcomponent.org.basic.ASColor;
	import jcomponent.org.basic.ASFont;
	import jcomponent.org.basic.Component;
	import jcomponent.org.basic.Container;
	import jcomponent.org.basic.DefaultConfigKeys;
	import jcomponent.org.basic.IComponentUI;
	import jcomponent.org.coms.images.AbstractImage;
	import jcomponent.org.coms.images.ScaleImageTile;
	
	import jutils.org.util.DisposeUtil;
	
	public class TitleBar implements ITitleBar
	{
		protected var window:Window;
		
		protected var container:Sprite;
		
		protected var img:AbstractImage;
		protected var textField:TextField;
		
		protected var font:ASFont;
		protected var color:ASColor;
		
		protected var textHAlign:int;
		protected var textVAlign:int;
		protected var textHGap:int;
		protected var textVGap:int;
		
		protected var setuped:Boolean;
		
		public function TitleBar()
		{
		}
		
		public function setup(component:Component):void
		{
			if(setuped) return;
			
			setuped = true;
			
			container = new Sprite();
			
			window = Window(component);
			var ui:IComponentUI = window.UI;
			var pp:String = ui.getResourcesPrefix(component) + DefaultConfigKeys.WINDOW_TITLE_BAR_PRE;
			
			var bmd:BitmapData = ui.getBitmapData(pp + DefaultConfigKeys.WINDOW_TITLE_IMAGE);
			var insets:Insets = ui.getInsets(pp + DefaultConfigKeys.WINDOW_TITLE_IMAGE_INSETS);
			font = ui.getFont(pp + DefaultConfigKeys.WINDOW_TITLE_FONT);
			color = ui.getColor(pp + DefaultConfigKeys.WINDOW_TITLE_COLOR);
			textHAlign = ui.getInt(pp + DefaultConfigKeys.WINDOW_TEXT_HALIGN);
			textVAlign = ui.getInt(pp + DefaultConfigKeys.WINDOW_TEXT_VALIGN);
			textHGap = ui.getInt(pp + DefaultConfigKeys.WINDOW_TEXT_HGAP);
			textVGap = ui.getInt(pp + DefaultConfigKeys.WINDOW_TEXT_VGAP);
			
			if(insets == null) insets = new Insets();
			
			img = new ScaleImageTile(bmd, insets);
			img.pack();
			
			textField = new TextField();
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.mouseEnabled = false;
			textField.selectable = false;
			textField.multiline = false;
			textField.wordWrap = false;
			
			
			container.addChild(img);
			container.addChild(textField);
		}
		
		public function getSize():IntDimension
		{
			return img.getSize();
		}
		
		public function setTitle(title:String):void
		{
			var ui:IComponentUI = window.UI;
			var pp:String = ui.getResourcesPrefix(window) + DefaultConfigKeys.WINDOW_TITLE_BAR_PRE;
			
			var viewRect:IntRectangle = new IntRectangle();
			viewRect.setSize(getSize());
			
			var textSize:IntDimension = JUtil.computeStringSizeWithFont(font, title);
			var textRect:IntRectangle = new IntRectangle();
			textRect.setSize(textSize);
			
			JUtil.layoutPosition(viewRect, textHAlign, textVAlign, textHGap, textVGap, textRect);
			
			textField.x = textRect.x;
			textField.y = textRect.y;
			
			if(font) font.apply(textField);
			if(color) textField.textColor = color.getRGB();
			
			textField.text = title;
		}
		
		public function updateTitleBar(component:Component, x:int, y:int):void
		{
			container.x = x;
			container.y = y;
		}
		
		public function getDisplay(component:Component):DisplayObject
		{
			return container;
		}
		
		public function dispose():void
		{
			DisposeUtil.free(img);
			img = null;
			
			DisposeUtil.free(textField);
			textField = null;
			
			DisposeUtil.free(container);
			container = null;
			
			window = null;
		}
	}
}