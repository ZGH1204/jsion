package jui.org
{
	import jui.org.coms.labels.Label;
	
	import jutils.org.util.StringUtil;

	public class LabelUtil
	{
		public static function layoutAndComputeLabel(component:Component, 
													 	text:String, 
														font:JFont, 
														icon:Icon, 
														vIconAlign:int, 
														hIconAlign:int, 
														vTextPos:int, 
														hTextPos:int, 
														viewRect:IntRectangle, 
														iconRect:IntRectangle, 
														textRect:IntRectangle, 
														iconTextGap:int):String
		{
			if(!font.isFullFeatured())
			{
				throw new Error("Font is not full featured : " + font);
			}
			
			if(icon != null)
			{
				iconRect.width = icon.getIconWidth(component);
				iconRect.height = icon.getIconHeight(component);
			}
			else
			{
				iconRect.width = iconRect.height = 0;
			}
			
			var textIsEmpty:Boolean = StringUtil.isNullOrEmpty(text);
			
			if(textIsEmpty)
			{
				text = "";
				textRect.width = textRect.height = 0;
			}
			else
			{
				var textSize:IntDimension = inter_computeStringSize(font, text);
				
				textRect.width = textSize.width;
				textRect.height = textSize.height;
			}
			
			var gap:Number = (textIsEmpty || (icon == null)) ? 0 : iconTextGap;
			
			if(!textIsEmpty)
			{
				var availTextWidth:Number;
				
				if (hTextPos == Label.CENTER)
				{
					availTextWidth = viewRect.width;
				}
				else
				{
					availTextWidth = viewRect.width - (iconRect.width + gap);
				}
				
				if (textRect.width > availTextWidth) {
					text = layoutTextWidth(text, textRect, availTextWidth, font);
				}
			}
			
			if (vTextPos == Label.TOP) {
				if (hTextPos!= Label.CENTER) {
					textRect.y = 0;
				}else {
					textRect.y = -(textRect.height + gap);
				}
			}else if (vTextPos == Label.CENTER) {
				textRect.y = (iconRect.height / 2) - (textRect.height / 2);
			}else { // (verticalTextPosition == BOTTOM)
				if (hTextPos != Label.CENTER) {
					textRect.y = iconRect.height - textRect.height;
				}else {
					textRect.y = (iconRect.height + gap);
				}
			}
			
			if (hTextPos == Label.LEFT) {
				textRect.x = -(textRect.width + gap);
			}else if (hTextPos == Label.CENTER) {
				textRect.x = (iconRect.width / 2) - (textRect.width / 2);
			}else { // (horizontalTextPosition == RIGHT)
				textRect.x = (iconRect.width + gap);
			}
			
			/* labelR is the rectangle that contains iconR and textR.
			* Move it to its proper position given the labelAlignment
			* properties.
			*
			* To avoid actually allocating a Rectangle, Rectangle.union
			* has been inlined below.
			*/
			var labelR_x:Number = Math.min(iconRect.x, textRect.x);
			var labelR_width:Number = Math.max(iconRect.x + iconRect.width, textRect.x + textRect.width) - labelR_x;
			var labelR_y:Number = Math.min(iconRect.y, textRect.y);
			var labelR_height:Number = Math.max(iconRect.y + iconRect.height, textRect.y + textRect.height) - labelR_y;
			
			var dx:Number = 0;
			var dy:Number = 0;
			
			if (vIconAlign == Label.TOP) {
				dy = viewRect.y - labelR_y;
			}
			else if (vIconAlign == Label.CENTER) {
				dy = (viewRect.y + (viewRect.height/2)) - (labelR_y + (labelR_height/2));
			}
			else { // (verticalAlignment == Label.BOTTOM)
				dy = (viewRect.y + viewRect.height) - (labelR_y + labelR_height);
			}
			
			if (hIconAlign == Label.LEFT) {
				dx = viewRect.x - labelR_x;
			}
			else if (hIconAlign == Label.RIGHT) {
				dx = (viewRect.x + viewRect.width) - (labelR_x + labelR_width);
			}
			else { // (horizontalAlignment == CENTER)
				dx = (viewRect.x + (viewRect.width/2)) - (labelR_x + (labelR_width/2));
			}
			
			textRect.x += dx;
			textRect.y += dy;
			
			iconRect.x += dx;
			iconRect.y += dy;
			
			
			return text;
		}
		
		private static function inter_computeStringSize(font:JFont, str:String):IntDimension
		{
			if(!font.isFullFeatured())
			{
				throw new Error("Font is not full featured : " + font);
			}
			
			return JUtil.computeStringSizeWithFont(font, str);
		}
		
		private static function inter_computeStringWidth(font:JFont, str:String):Number
		{
			return inter_computeStringSize(font, str).width;
		}
		
		private static function layoutTextWidth(text:String, textR:IntRectangle, availTextWidth:Number, font:JFont):String
		{
			if (textR.width <= availTextWidth)
			{
				return text;
			}
			
			var clipString:String = "...";
			var totalWidth:int = Math.round(inter_computeStringWidth(font, clipString));
			if(totalWidth > availTextWidth)
			{
				totalWidth = Math.round(inter_computeStringWidth(font, ".."));
				if(totalWidth > availTextWidth)
				{
					text = ".";
					textR.width = Math.round(inter_computeStringWidth(font, "."));
					if(textR.width > availTextWidth)
					{
						textR.width = 0;
						text = "";
					}
				}
				else
				{
					text = "..";
					textR.width = totalWidth;
				}
				return text;
			}
			else
			{
				var lastWidth:Number = totalWidth;
				
				
				//begin binary search
				var num:int = text.length;
				var li:int = 0; //binary search of left index 
				var ri:int = num; //binary search of right index
				
				while(li<ri)
				{
					var i:int = li + (ri - li)/2;
					var subText:String = text.substring(0, i);
					var length:int = Math.ceil(lastWidth + inter_computeStringWidth(font, subText));
					
					if((li == i - 1) && li>0)
					{
						if(length > availTextWidth)
						{
							subText = text.substring(0, li);
							textR.width = Math.ceil(lastWidth + inter_computeStringWidth(font, text.substring(0, li)));
						}
						else
						{
							textR.width = length;
						}
						return subText + clipString;
					}
					else if(i <= 1)
					{
						if(length <= availTextWidth)
						{
							textR.width = length;
							return subText + clipString;
						}
						else
						{
							textR.width = lastWidth;
							return clipString;
						}
					}
					
					if(length < availTextWidth)
					{
						li = i;
					}
					else if(length > availTextWidth)
					{
						ri = i;
					}
					else
					{
						text = subText + clipString;
						textR.width = length;
						return text;
					}
				}
				//end binary search
				textR.width = lastWidth;
				return "";
			}
		}
	}
}