package jsion.comps
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import jsion.IntDimension;
	
	/**
	 * 组件工具
	 * @author Jsion
	 */
	public class CompUtil
	{
		private static var TEXT_FIELD_EXT:TextField = new TextField();
		{
			TEXT_FIELD_EXT.autoSize = TextFieldAutoSize.LEFT;
			TEXT_FIELD_EXT.type = TextFieldType.DYNAMIC;
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
		
		/**
		 * 根据字符串样式计算字符串长度
		 * @param tf
		 * @param str
		 * @param includeGutters
		 * @param textField
		 * 
		 */		
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
		
		/**
		 * 根据对齐方式计算布局位置
		 * @param width 范围宽度
		 * @param height 范围高度
		 * @param hAlign 水平对齐方式
		 * @param hGap 水平间隙
		 * @param vAlign 垂直对齐方式
		 * @param vGap 垂直间隙
		 * @param rect 对象范围 其中x、y位置属性用于存储计算结果
		 * 
		 */		
		public static function layoutPosition(width:int, height:int, hAlign:String, hGap:int, vAlign:String, vGap:int, rect:Rectangle):void
		{
			switch(hAlign)
			{
				case CompGlobal.LEFT:
					rect.x = hGap;
					break;
				case CompGlobal.RIGHT:
					rect.x = width - rect.width - hGap;
					break;
				case CompGlobal.CENTER:
					rect.x = width - rect.width;
					rect.x /= 2;
					rect.x += hGap;
					break;
				default:
					throw new Error("水平对齐方式错误!");
					break;
			}
			
			switch(vAlign)
			{
				case CompGlobal.TOP:
					rect.y = vGap;					
					break;
				case CompGlobal.BOTTOM:
					rect.y = height - rect.height;
					rect.y -= vGap;
					break;
				case CompGlobal.MIDDLE:
					rect.y = height - rect.height;
					rect.y /= 2;
					rect.y += vGap;
					break;
				default:
					throw new Error("垂直对齐方式错误!");
					break;
			}
		}
	}
}