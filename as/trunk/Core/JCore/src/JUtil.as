package
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import jui.org.JFont;

	/**
	 * 其他特殊工具方法集合
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public class JUtil
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
		 * 替换: :|.|\/
		 */		
		private static const _reg2:RegExp = /[:|.|\/]/g;
		
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
		
		/**
		 * 将路径转换为字典键
		 * @param path 路径
		 * @return 字典键
		 * 
		 */		
		public static function path2Key(path:String):String
		{
			var index:int = path.indexOf("?");
			var key:String = path.substring(0, (index == -1 ? int.MAX_VALUE : index));
			
			key = key.replace(_reg1,"");
			key = key.replace(_reg2,"_");
			
			return key;
		}
		
		/**
		 * 获取指定路径中文件的扩展名
		 * @param url 文件的路径
		 * @return 扩展名
		 * 
		 */		
		public static function getExtension(url:String):String
		{
			var startIndex:int = url.lastIndexOf("/");
			if(startIndex == -1) startIndex = 0;
			
			var endIndex:int = url.indexOf("?");
			if(endIndex == -1) endIndex = url.length;
			
			var name:String = url.substring(startIndex, endIndex);
			var dotIndex:int = name.lastIndexOf(".");
			if(dotIndex == -1) return null;
			var ext:String = name.substr(dotIndex + 1);
			return ext;
		}
		
		/**
		 * 指示ancestor容器中是否包含child显示对象
		 * @param ancestor 显示对象容器
		 * @param child 显示对象
		 * @return true表示包含,false反之.
		 */		
		public static function isAncestorDisplayObject(ancestor:DisplayObjectContainer, child:DisplayObject):Boolean
		{
			if(ancestor == null || child == null) 
				return false;
			
			var pa:DisplayObjectContainer = child.parent;
			while(pa != null){
				if(pa == ancestor){
					return true;
				}
				pa = pa.parent;
			}
			return false;
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
		
		public static function computeStringSizeWithFont(font:JFont, str:String, includeGutters:Boolean = true):IntDimension
		{
			if(!font.isFullFeatured())
			{
				throw new Error("Font is not full featured : " + font);
			}
			
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
	}
}