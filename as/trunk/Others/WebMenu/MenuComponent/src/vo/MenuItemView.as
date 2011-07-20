package vo
{
	import com.managers.ModuleManager;
	import com.utils.StringHelper;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import vo.data.MenuItemConfig;
	import vo.data.TextAlignMode;
	
	public class MenuItemView extends MovieClip
	{
		private var _width:Number = 0;
		private var _height:Number = 0;
		private var _itemCls:String;
		private var _overCls:String;
		private var _downCls:String;
		private var menuItemConfig:MenuItemConfig;
		
		private var bg:DisplayObject;
		private var foreLayer:Sprite;
		private var overView:DisplayObject;
		private var downView:DisplayObject;
		private var label:TextField;
		private var tf:TextFormat;
		private var overTF:TextFormat;
		private var basePoint:Point;
		
		public function MenuItemView()
		{
			super();
		}
		
		public function build(menuItemConfig:MenuItemConfig):void
		{
			this.menuItemConfig = menuItemConfig;
			
			itemCls = menuItemConfig.itemCls;
			overCls = menuItemConfig.overCls;
			downCls = menuItemConfig.downCls;
			width = menuItemConfig.width;
			height = menuItemConfig.height;
			
			buttonMode = true;
			
			addEvent();
			drawBackground();
			buildBackground();
			buildForeLayer();
			buildLabel();
			
			buildMouseOverView();
			buildMouseDownView();
		}
		
		private function drawBackground():void
		{
			graphics.beginFill(0x0, 0);
			graphics.drawRect(0,0,_width, _height);
			graphics.endFill();
		}
		
		private function addEvent():void
		{
			addEventListener(MouseEvent.CLICK, __clickHandler);
			addEventListener(MouseEvent.MOUSE_OVER, __overHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, __downHandler);
			addEventListener(MouseEvent.MOUSE_OUT, __outHandler);
		}
		
		private function removeEvent():void
		{
			removeEventListener(MouseEvent.CLICK, __clickHandler);
			removeEventListener(MouseEvent.MOUSE_OVER, __overHandler);
			removeEventListener(MouseEvent.MOUSE_OUT, __outHandler);
		}
		
		private function __clickHandler(e:MouseEvent):void
		{
//			trace("Clicked!!");
			navigateToURL(new URLRequest(menuItemConfig.link));
		}
		
		private function __overHandler(e:MouseEvent):void
		{
//			trace("Overed!!");
			label.defaultTextFormat = overTF;
			label.text = menuItemConfig.label;
			label.x = basePoint.x + menuItemConfig.overOffsetX;
			label.y = basePoint.y + menuItemConfig.overOffsetY;
			
			if(overView)
			{
				var mc:MovieClip = overView as MovieClip;
				if(mc)
				{
					mc.gotoAndPlay(1);
					mc.addFrameScript(mc.totalFrames - 1, function():void{
						lastFrameScript(mc);
					});
				}
					
				foreLayer.addChild(overView);
			}
		}
		
		private function __downHandler(e:MouseEvent):void
		{
			if(downView)
			{
				var mc:MovieClip = downView as MovieClip;
				if(mc)
				{
					mc.gotoAndPlay(1);
					mc.addFrameScript(mc.totalFrames - 1, function():void{
						lastFrameScript(mc);
					});
				}
				foreLayer.addChild(downView);
			}
		}
		
		private function __outHandler(e:MouseEvent):void
		{
//			trace("Outed!!");
			label.defaultTextFormat = tf;
			label.text = menuItemConfig.label;
			label.x = basePoint.x;
			label.y = basePoint.y;
			while(foreLayer.numChildren > 0)
			{
				foreLayer.removeChildAt(0);
			}
		}
		
		private function lastFrameScript(mc:MovieClip):void
		{
			mc.stop();
		}
		
		private function buildBackground():void
		{
			if(StringHelper.isNullOrEmpty(itemCls) || 
			   ModuleManager.getInstance().hasDefinition(itemCls) == false) return;
			
			bg = ModuleManager.getInstance().create(itemCls) as DisplayObject;
			addChild(bg);
		}
		/**
		 * 鼠标状态层
		 * 
		 */		
		private function buildForeLayer():void
		{
			foreLayer = new Sprite();
			foreLayer.mouseEnabled = false;
			foreLayer.mouseChildren = false;
			addChild(foreLayer);
		}
		
		private function buildLabel():void
		{
			label = new TextField();
			
			tf = new TextFormat(menuItemConfig.font, menuItemConfig.fontSize, menuItemConfig.fontColor, menuItemConfig.fontBold, menuItemConfig.fontItalic, menuItemConfig.fontUnderLine);
			
			var overSize:Object = menuItemConfig.overSize <= 0 ? menuItemConfig.fontSize : menuItemConfig.overSize;
			var overColor:Object = menuItemConfig.overColor < 0 ? menuItemConfig.fontColor : menuItemConfig.overColor;
			overTF = new TextFormat(menuItemConfig.font, overSize, overColor, menuItemConfig.overBold, menuItemConfig.overItalic, menuItemConfig.overUnderLine);
			
			tf.align = menuItemConfig.textVAlign.split("|")[0];
			label.type = TextFieldType.DYNAMIC;
			label.multiline = false;
			label.wordWrap = false;
			label.defaultTextFormat = tf;
			label.text = menuItemConfig.label;
			label.width = _width;
			label.height = label.textHeight + 5;
			label.mouseEnabled = false;
			
			setLabelPos(label);
			basePoint = new Point(label.x, label.y);
			
			addChild(label);
		}
		
		private function buildMouseOverView():void
		{
			if(StringHelper.isNullOrEmpty(overCls) || 
				ModuleManager.getInstance().hasDefinition(overCls) == false) return;
			
			overView = ModuleManager.getInstance().create(overCls) as DisplayObject;
		}
		
		private function buildMouseDownView():void
		{
			if(StringHelper.isNullOrEmpty(downCls) || 
				ModuleManager.getInstance().hasDefinition(downCls) == false) return;
			
			downView = ModuleManager.getInstance().create(downCls) as DisplayObject;
		}
		
		private function setLabelPos(lab:TextField):void
		{
			switch(menuItemConfig.textHAlign.split("|")[0])
			{
				case TextAlignMode.TOP_ALIGN:
				{
					lab.y = 0;
					break;
				}
				case TextAlignMode.BOTTOM_ALIGN:
				{
					lab.y = _height - lab.height;
					break;
				}
				default:
				{
					lab.y = (_height - lab.height) / 2;
				}
			}
		}
		
		public function get itemCls():String
		{
			return _itemCls;
		}
		
		public function set itemCls(value:String):void
		{
			if(StringHelper.isNullOrEmpty(value)) return;
			_itemCls = value;
		}
		
		public function get downCls():String
		{
			return _downCls;
		}
		
		public function set downCls(value:String):void
		{
			if(StringHelper.isNullOrEmpty(value)) return;
			_downCls = value;
		}
		
		public function get overCls():String
		{
			return _overCls;
		}
		
		public function set overCls(value:String):void
		{
			if(StringHelper.isNullOrEmpty(value)) return;
			_overCls = value;
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function set width(value:Number):void
		{
			if(value <= 0) return;
			_width = value;
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		override public function set height(value:Number):void
		{
			if(value <= 0) return;
			_height = value;
		}
	}
}