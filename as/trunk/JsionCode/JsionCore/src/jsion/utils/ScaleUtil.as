package jsion.utils
{
	public class ScaleUtil
	{
		/**
		 * 计算从原始大小到目标大小的等比缩放比例
		 * @param sourceWidth 原始宽度
		 * @param sourceHeight 原始高度
		 * @param targetWidth 目标宽度
		 * @param targetHeight 目标高度
		 */		
		public static function calcScaleFullSize(sourceWidth:Number, sourceHeight:Number, targetWidth:Number, targetHeight:Number):Number
		{
			var scaleWidth:Number = targetWidth / sourceWidth;
			var scaleHeight:Number = targetHeight / sourceHeight;
			
			if(targetWidth <= 0) return scaleHeight;
			else if(targetHeight <= 0) return scaleWidth;
			
			if((sourceHeight * scaleWidth) <= targetHeight)
			{
				return scaleWidth;
			}
			else if((sourceWidth * scaleHeight) <= targetWidth)
			{
				return scaleHeight;
			}
			else
			{
				return Math.min(scaleWidth, scaleHeight);
			}
		}
	}
}