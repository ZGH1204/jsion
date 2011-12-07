package jsion.ui
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import jsion.*;
	import jsion.utils.JUtil;
	import jsion.utils.StringUtil;

	public class UIUtil
	{
		private static var TEXT_FIELD_EXT:TextField = new TextField();
		{
			TEXT_FIELD_EXT.autoSize = TextFieldAutoSize.LEFT;
			TEXT_FIELD_EXT.type = TextFieldType.DYNAMIC;
		}
		
		private static var sprite:Sprite = new Sprite();
		
		/**
		 * 替换掉http://..../ 
		 */		
		private static const _reg1:RegExp = /http:\/\/[\w|.|:]+\//i;
		/**
		 * 替换: :|.|\/|\\
		 */		
		private static const _reg2:RegExp = /[:|.|\/|\\]/g;
		
		
		
		/**
		 * 全局帧频刷新事件, 保证所有处理都在同一帧, 避免异步问题。
		 * @param listener 处理事件的侦听器函数。
		 * @param useCapture 此参数适用于 SWF 内容所使用的 ActionScript 3.0 显示列表体系结构中的显示对象。确定侦听器是运行于捕获阶段还是目标阶段和冒泡阶段。如果将 useCapture 设置为 true，则侦听器只在捕获阶段处理事件，而不在目标或冒泡阶段处理事件。如果 useCapture 为 false，则侦听器只在目标或冒泡阶段处理事件。要在所有三个阶段都侦听事件，请调用 addEventListener 两次：一次将 useCapture 设置为 true，一次将 useCapture 设置为 false。
		 * @param priority 事件侦听器的优先级。优先级由一个带符号的 32 位整数指定。数字越大，优先级越高。优先级为 n 的所有侦听器会在优先级为 n -1 的侦听器之前得到处理。如果两个或更多个侦听器共享相同的优先级，则按照它们的添加顺序进行处理。默认优先级为 0。
		 * @param useWeakReference 确定对侦听器的引用是强引用，还是弱引用。强引用（默认值）可防止您的侦听器被当作垃圾回收。弱引用则没有此作用。
		 * 
		 */		
		public static function addEnterFrame(listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			sprite.addEventListener(Event.ENTER_FRAME, listener, useCapture, priority, useWeakReference);
		}
		
		public static function removeEnterFrame(listener:Function, useCapture:Boolean = false):void
		{
			sprite.removeEventListener(Event.ENTER_FRAME, listener, useCapture);
		}
		
		
		
		public static function computeStringSize(tf:TextFormat, str:String, includeGutters:Boolean = true, textField:TextField = null):IntDimension
		{
			if(textField)
			{
				TEXT_FIELD_EXT.embedFonts = textField.embedFonts;
				TEXT_FIELD_EXT.antiAliasType = textField.antiAliasType;
				TEXT_FIELD_EXT.gridFitType = textField.gridFitType;
				TEXT_FIELD_EXT.sharpness = textField.sharpness;
				TEXT_FIELD_EXT.thickness = textField.thickness;
			}
			
			TEXT_FIELD_EXT.text = str;
			TEXT_FIELD_EXT.setTextFormat(tf);
			
			if(includeGutters)
			{
				return new IntDimension(Math.ceil(TEXT_FIELD_EXT.width), Math.ceil(TEXT_FIELD_EXT.height));
			}
			else
			{
				return new IntDimension(Math.ceil(TEXT_FIELD_EXT.textWidth), Math.ceil(TEXT_FIELD_EXT.textHeight));
			}
		}
		
		public static function computeStringSizeWithFont(font:ASFont, str:String, includeGutters:Boolean = true):IntDimension
		{
			if(!font.isFullFeatured())
			{
				throw new Error("Font is not full featured : " + font);
			}
			
			if(StringUtil.isNullOrEmpty(str)) return new IntDimension();
			
			TEXT_FIELD_EXT.text = str;
			font.apply(TEXT_FIELD_EXT);
			
			if(includeGutters)
			{
				return new IntDimension(Math.ceil(TEXT_FIELD_EXT.width), Math.ceil(TEXT_FIELD_EXT.height));
			}
			else
			{
				return new IntDimension(Math.ceil(TEXT_FIELD_EXT.textWidth), Math.ceil(TEXT_FIELD_EXT.textHeight));
			}
		}
		
		public static function layoutPosition(viewRect:IntRectangle, hAlign:int, vAlign:int, hGap:int, vGap:int, r:IntRectangle):IntRectangle
		{
			if(viewRect == null) throw new ArgumentError("参数 viewRect 不能为空!");
			if(r == null) throw new ArgumentError("参数 r 不能为空!");
			
			switch(hAlign)
			{
				case UIConstants.LEFT:
					r.x = viewRect.x + hGap;
					break;
				case UIConstants.RIGHT:
					r.x = viewRect.x + viewRect.width;
					r.x -= r.width;
					r.x -= hGap;
					break;
				case UIConstants.CENTER:
					r.x = viewRect.x + viewRect.width;
					r.x -= r.width;
					r.x /= 2;
					r.x += hGap;
					break;
				default:
					throw new Error("水平对齐方式错误!");
					break;
			}
			
			switch(vAlign)
			{
				case UIConstants.TOP:
					r.y = viewRect.y + vGap;
					break;
				case UIConstants.BOTTOM:
					r.y = viewRect.y + viewRect.height;
					r.y -= r.height;
					r.y -= vGap;
					break;
				case UIConstants.MIDDLE:
					r.y = viewRect.y + viewRect.height;
					r.y -= r.height;
					r.y /= 2;
					r.y += vGap;
					break;
				default:
					throw new Error("垂直对齐方式错误!");
					break;
			}
			
			return r;
		}
		
		public static function layoutTextAndBox(text:String, font:ASFont, horizontalAlginment:int, verticalAlginment:int, textRect:IntRectangle, 
												boxWidth:int, boxHeight:int, textHGap:int, textVGap:int, boxHGap:int, boxVGap:int, boxDir:int, boxRect:IntRectangle, viewRect:IntRectangle):String
		{
			if(text == null) text = "";
			
			var textSize:IntDimension = computeStringSizeWithFont(font, text);
			
			textRect.setSize(textSize);
			boxRect.setRectXYWH(0, 0, boxWidth, boxHeight);
			
			if(boxDir == UIConstants.CENTER)
			{
				calcCenterDir(viewRect, boxRect, textRect, horizontalAlginment, verticalAlginment, textHGap, textVGap, boxHGap, boxVGap);
			}
			else if(boxDir == UIConstants.RIGHT)
			{
				calcRightDir(viewRect, boxRect, textRect, horizontalAlginment, verticalAlginment, textHGap, textVGap, boxHGap, boxVGap);
			}
			else if(boxDir == UIConstants.TOP)
			{
				calcTopDir(viewRect, boxRect, textRect, horizontalAlginment, verticalAlginment, textHGap, textVGap, boxHGap, boxVGap);
			}
			else if(boxDir == UIConstants.BOTTOM)
			{
				calcBottomDir(viewRect, boxRect, textRect, horizontalAlginment, verticalAlginment, textHGap, textVGap, boxHGap, boxVGap);
			}
			else
			{
				calcLeftDir(viewRect, boxRect, textRect, horizontalAlginment, verticalAlginment, textHGap, textVGap, boxHGap, boxVGap);
			}
			
			return text;
		}
		
		private static function calcCenterDir(viewRect:IntRectangle, boxRect:IntRectangle, textRect:IntRectangle, horizontalAlginment:int, verticalAlginment:int, textHGap:int, textVGap:int, boxHGap:int, boxVGap:int):void
		{
			boxRect.x = viewRect.width - boxRect.width;
			boxRect.x /= 2;
			boxRect.x += boxHGap;
			
			boxRect.y = viewRect.height - boxRect.height;
			boxRect.y /= 2;
			boxRect.y += boxVGap;
			
			if(horizontalAlginment == UIConstants.CENTER)
			{
				textRect.x = viewRect.width - textRect.width;
				textRect.x /= 2;
				textRect.x += textHGap;
			}
			else if(horizontalAlginment == UIConstants.RIGHT)
			{
				textRect.x = boxRect.x + boxRect.width;
				textRect.x -= textRect.width;
				textRect.x -= textHGap;
			}
			else
			{
				textRect.x = boxRect.x + textHGap;
			}
			
			if(verticalAlginment == UIConstants.TOP)
			{
				textRect.y = boxRect.y + textVGap;
			}
			else if(verticalAlginment == UIConstants.BOTTOM)
			{
				textRect.y = boxRect.y + boxRect.height;
				textRect.y -= textRect.height;
				textRect.y -= textVGap;
			}
			else
			{
				textRect.y = viewRect.height - textRect.height;
				textRect.y /= 2;
				textRect.y += textVGap;
			}
		}
		
		private static function calcRightDir(viewRect:IntRectangle, boxRect:IntRectangle, textRect:IntRectangle, horizontalAlginment:int, verticalAlginment:int, textHGap:int, textVGap:int, boxHGap:int, boxVGap:int):void
		{
			boxRect.x = viewRect.width - boxRect.width;
			boxRect.x -= boxHGap;
			
			if(horizontalAlginment == UIConstants.CENTER)
			{
				textRect.x = boxRect.x - textRect.width;
				textRect.x /= 2;
				textRect.x += textHGap;
			}
			else if(horizontalAlginment == UIConstants.RIGHT)
			{
				textRect.x = boxRect.x - textRect.width;
				textRect.x -= textHGap;
			}
			else
			{
				textRect.x = textHGap;
			}
			
			if(verticalAlginment == UIConstants.TOP)
			{
				boxRect.y = boxVGap;
				textRect.y = textVGap;
			}
			else if(verticalAlginment == UIConstants.BOTTOM)
			{
				boxRect.y = viewRect.height - boxRect.height;
				boxRect.y -= boxVGap;
				
				textRect.y = viewRect.height - textRect.height;
				textRect.y -= textVGap;
			}
			else
			{
				boxRect.y = viewRect.height - boxRect.height;
				boxRect.y /= 2;
				boxRect.y += boxVGap;
				
				textRect.y = viewRect.height - textRect.height;
				textRect.y /= 2;
				textRect.y += textVGap;
			}
		}
		
		private static function calcTopDir(viewRect:IntRectangle, boxRect:IntRectangle, textRect:IntRectangle, horizontalAlginment:int, verticalAlginment:int, textHGap:int, textVGap:int, boxHGap:int, boxVGap:int):void
		{
			boxRect.y = boxVGap;
			
			if(horizontalAlginment == UIConstants.CENTER)
			{
				boxRect.x = viewRect.width - boxRect.width;
				boxRect.x /= 2;
				boxRect.x += boxHGap;
				
				textRect.x = viewRect.width - textRect.width;
				textRect.x /= 2;
				textRect.x += textHGap;
			}
			else if(horizontalAlginment == UIConstants.RIGHT)
			{
				boxRect.x = viewRect.width - boxRect.width;
				boxRect.x -= boxHGap;
				
				textRect.x = viewRect.width - textRect.width;
				textRect.x -= textHGap;
			}
			else
			{
				boxRect.x = boxHGap;
				textRect.x = textHGap;
			}
			
			if(verticalAlginment == UIConstants.TOP)
			{
				textRect.y = boxRect.x + boxRect.height;
				textRect.y += textVGap;
			}
			else if(verticalAlginment == UIConstants.BOTTOM)
			{
				textRect.y = viewRect.height - textRect.height;
				textRect.y -= textVGap;
			}
			else
			{
				textRect.y = viewRect.height - boxRect.y;
				textRect.y -= boxRect.height;
				textRect.y -= textRect.height;
				textRect.y /= 2;
				textRect.y += boxRect.y;
				textRect.y += boxRect.height;
				textRect.y += textVGap;
			}
		}
		
		private static function calcBottomDir(viewRect:IntRectangle, boxRect:IntRectangle, textRect:IntRectangle, horizontalAlginment:int, verticalAlginment:int, textHGap:int, textVGap:int, boxHGap:int, boxVGap:int):void
		{
			boxRect.y = viewRect.height - boxRect.height;
			boxRect.y -= boxVGap;
			
			if(horizontalAlginment == UIConstants.CENTER)
			{
				boxRect.x = viewRect.width - boxRect.width;
				boxRect.x /= 2;
				boxRect.x += boxHGap;
				
				textRect.x = viewRect.width - textRect.width;
				textRect.x /= 2;
				textRect.x += textHGap;
			}
			else if(horizontalAlginment == UIConstants.RIGHT)
			{
				boxRect.x = viewRect.width - boxRect.width;
				boxRect.x -= boxHGap;
				
				textRect.x = viewRect.width - textRect.width;
				textRect.x -= textHGap;
			}
			else
			{
				boxRect.x = boxHGap;
				textRect.x = textHGap;
			}
			
			if(verticalAlginment == UIConstants.TOP)
			{
				textRect.y = textVGap;
			}
			else if(verticalAlginment == UIConstants.BOTTOM)
			{
				textRect.y = boxRect.y - textRect.height;
				textRect.y -= textVGap;
			}
			else
			{
				textRect.y = boxRect.y - textRect.height;
				textRect.y /= 2;
				textRect.y += textVGap;
			}
		}
		
		private static function calcLeftDir(viewRect:IntRectangle, boxRect:IntRectangle, textRect:IntRectangle, horizontalAlginment:int, verticalAlginment:int, textHGap:int, textVGap:int, boxHGap:int, boxVGap:int):void
		{
			boxRect.x = boxHGap;
			
			if(horizontalAlginment == UIConstants.CENTER)
			{
				textRect.x = viewRect.width - boxRect.width;
				textRect.x -= boxRect.x;
				textRect.x -= textRect.width;
				textRect.x /= 2;
				textRect.x += boxRect.x;
				textRect.x += boxRect.width;
				textRect.x += textHGap;
			}
			else if(horizontalAlginment == UIConstants.RIGHT)
			{
				textRect.x = viewRect.width - textRect.width;
				textRect.x -= textHGap;
			}
			else
			{
				textRect.x = boxRect.x + boxRect.width;
				textRect.x += textHGap;
			}
			
			if(verticalAlginment == UIConstants.TOP)
			{
				boxRect.y = boxVGap;
				textRect.y = textVGap;
			}
			else if(verticalAlginment == UIConstants.BOTTOM)
			{
				boxRect.y = viewRect.height - boxRect.height;
				boxRect.y -= boxVGap;
				
				textRect.y = viewRect.height - textRect.height;
				textRect.y -= textVGap;
			}
			else
			{
				textRect.y = viewRect.height - textRect.height;
				textRect.y /= 2;
				textRect.y += textVGap;
				
				boxRect.y = viewRect.height - boxRect.height;
				boxRect.y /= 2;
				boxRect.y += boxVGap;
			}
		}
		
		public static function layoutText(text:String, font:ASFont, horizontalAlginment:int, verticalAlginment:int, viewRect:IntRectangle, textRect:IntRectangle):String
		{
			if(text == null) text = "";
			var textSize:IntDimension = computeStringSizeWithFont(font, text);
			textRect.setSize(textSize);
			
			if(horizontalAlginment == UIConstants.CENTER)
			{
				textRect.x = viewRect.width - textRect.width;
				textRect.x /= 2;
			}
			else if(horizontalAlginment == UIConstants.RIGHT)
			{
				textRect.x = viewRect.width - textRect.width;
			}
			else
			{
				textRect.x = 0;
			}
			
			if(verticalAlginment == UIConstants.TOP)
			{
				textRect.y = 0;
			}
			else if(verticalAlginment == UIConstants.BOTTOM)
			{
				textRect.y = viewRect.height - textRect.height;
			}
			else
			{
				textRect.y = viewRect.height - textRect.height;
				textRect.y /= 2;
			}
			
			return text;
		}
		
		/**
		 * 指示ancestor容器中是否包含child显示对象
		 * @param ancestor 显示对象容器
		 * @param child 显示对象
		 * @return true表示包含,false反之.
		 */		
		public static function isAncestorDisplayObject(ancestor:DisplayObjectContainer, child:DisplayObject):Boolean
		{
			if(ancestor == null || child == null) return false;
			
			var pa:DisplayObjectContainer = child.parent;
			
			while(pa != null)
			{
				if(pa == ancestor)
				{
					return true;
				}
				
				pa = pa.parent;
			}
			
			return false;
		}
		
		public static function checkAbstract(obj:Object):void
		{
			JUtil.checkAbstract(obj);
		}
	}
}