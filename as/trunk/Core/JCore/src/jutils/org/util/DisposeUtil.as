package jutils.org.util
{
	import flash.display.*;
	import flash.utils.*;
	
	/**
	 * 释放内存工具
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public final class DisposeUtil
	{
		public static function free(obj:Object, freeBmd:Boolean = true):void
		{
			if(obj == null) return;
			
			if(obj is IDispose)
			{
				IDispose(obj).dispose();
				disposeDisplayObject(obj as DisplayObject);
			}
			else if(obj is Bitmap)
			{
				disposeBitMap(obj as Bitmap, freeBmd);
			}
			else if(obj is BitmapData)
			{
				disposeBitMapData(obj as BitmapData, freeBmd);
			}
			else if(obj.hasOwnProperty("dispose"))
			{
				obj["dispose"]();
				disposeDisplayObject(obj as DisplayObject);
			}
			else if(obj is DisplayObject)
			{
				disposeDisplayObject(obj as DisplayObject);
			}
			else if(obj is Array)
			{
				var array:Array = obj as Array;
				
				while(array.length > 0)
				{
					free(array.pop(), freeBmd);
				}
			}
			else if(obj is Dictionary)
			{
				var keys:Array = DictionaryUtil.getKeys(obj as Dictionary);
				
				for each(var str:* in keys)
				{
					free(obj[str], freeBmd);
					delete obj[str];
				}
			}
		}
		
		public static function freeChildren(doc:DisplayObjectContainer, freeBmd:Boolean = true):void
		{
			if(doc == null) return;
			
			while(doc.numChildren > 0)
			{
				var child:DisplayObject = doc.getChildAt(0);
				free(child, freeBmd);
			}
		}
		
		private static function disposeBitMap(bmp:Bitmap, destroyBitMapData:Boolean):void
		{
			//if(bmp.parent) bmp.parent.removeChild(bmp);
			disposeDisplayObject(bmp);
			
			var bmd:BitmapData = bmp.bitmapData;
			bmp.bitmapData = null;
			
			disposeBitMapData(bmd, destroyBitMapData);
		}
		
		private static function disposeBitMapData(bmd:BitmapData, destroyBitMapData:Boolean):void
		{
			if(destroyBitMapData && bmd) bmd.dispose();
		}
		
		private static function disposeDisplayObject(display:DisplayObject):void
		{
			disposeDisplayObjectOther(display);
			if(display && display.parent) display.parent.removeChild(display);
		}
		
		private static function disposeDisplayObjectOther(display:DisplayObject):void
		{
			if(display)
			{
				display.filters = null;
				if(display.hasOwnProperty("graphics")) display["graphics"].clear();
			}
		}
	}
}