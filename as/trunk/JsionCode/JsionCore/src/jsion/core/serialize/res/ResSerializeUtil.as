package jsion.core.serialize.res
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import jsion.HashMap;
	import jsion.utils.ArrayUtil;

	internal class ResSerializeUtil
	{
		/**
		 * 获取索引颜色和替换颜色对应关系
		 * @param imgs
		 * @param indexColors
		 * @param replaceColors
		 * 
		 */		
		public static function getIndexAndReplaceColors(imgs:Array, indexColors:Array, replaceColors:HashMap):void
		{
			ArrayUtil.removeAll(indexColors);
			replaceColors.removeAll();
			
			//遍历所有图像数据并统计所有颜色的使用频率
			var colorsIndex65535:Array = [];
			
			for(var i:int = 0; i < imgs.length; i++)
			{
				var bmd:BitmapData = imgs[i] as BitmapData;
				
				var rect:Rectangle = bmd.getColorBoundsRect(0xFF000000, 0x00000000, false);
				
				if(rect.width == 0 || rect.height == 0)
				{
					rect.width = bmd.width;
					rect.height = bmd.height;
				}
				
				var w1:int = rect.x + rect.width;
				var h1:int = rect.y + rect.height;
				
				for(var y:int = rect.y; y < h1; y++)
				{
					for(var x:int = rect.x; x < w1; x++)
					{
						var color:uint = bmd.getPixel32(x, y);
						
						var indexColor:uint = pixel32ToPixel16(color);
						
						if(colorsIndex65535[indexColor] == null)
						{
							colorsIndex65535[indexColor] = 1;
						}
						else
						{
							colorsIndex65535[indexColor] += 1;
						}
					}
				}
			}
			
			//遍历出所有被使用的颜色值列表
			var indexColorsMap:HashMap = new HashMap();
			var orderList:Array = [];
			
			for(var j:int = 0; j < 65536; j++)
			{
				if(colorsIndex65535[j] != null && colorsIndex65535[j] > 0)
				{
					indexColorsMap.put(j, colorsIndex65535[j]);
					orderList.push({color: j, count: colorsIndex65535[j]});
				}
			}
			
			orderList.sortOn("count", Array.NUMERIC | Array.DESCENDING);
			
			var indexColorsCount:int = 0;
			
			for (var k:int = 0; k < orderList.length; k++)
			{
				var obj:Object = orderList[k];
				
				if(indexColorsCount < 250)
				{
					indexColors[k] = obj.color;
					indexColorsCount++;
				}
				else
				{
					replaceColors.put(obj.color, obj.count);
				}
			}
			
			//找出替换颜色
			var replaceColorsList:Array = replaceColors.getKeys();
			
			for each(var rColor:uint in replaceColorsList)
			{
				var n:int = getAlikeIndex(rColor, indexColors);
				
				//Key:原颜色，Value：替换后的颜色
				replaceColors.put(rColor, indexColors[n]);
			}
		}
		
		/**
		 * 将图像转换为索引字节流
		 * @param bmd
		 * @param indexColors
		 * @param replaceColors
		 * @return 
		 * 
		 */		
		public static function imageTransToBytes(bmd:BitmapData, indexColors:Array, replaceColors:HashMap):ByteArray
		{
			var bytes:ByteArray = new ByteArray();
			
			var rect:Rectangle = bmd.getColorBoundsRect(0xFF000000, 0x00000000, false);
			
			if(rect.width == 0 || rect.height == 0)
			{
				rect.width = bmd.width - rect.x;
				rect.height = bmd.height - rect.y;
			}
			
			var w1:int = rect.x + rect.width;
			var h1:int = rect.y + rect.height;
			
			bytes.writeShort(rect.x);
			bytes.writeShort(rect.y);
			bytes.writeShort(rect.width);
			bytes.writeShort(rect.height);
			
			for(var y:int = rect.y; y < h1; y++)
			{
				for(var x:int = rect.x; x < w1; x++)
				{
					var color:uint = bmd.getPixel32(x, y);
					
					var indexColor:uint = pixel32ToPixel16(color);
					
					if(replaceColors.containsKey(indexColor))
					{
						indexColor = replaceColors.get(indexColor);
					}
					
					var index:int = indexColors.indexOf(indexColor);
					
					if(index != -1)
					{
						bytes.writeByte(index);
					}
					else
					{
						throw new VerifyError("Not found index color.");
					}
				}
			}
			
			return bytes;
		}
		
		/**
		 * 压缩图像的索引字节流
		 * @param bytes
		 * @param indexColors
		 * @return 
		 * 
		 */		
		public static function compressImageBytes(bytes:ByteArray, indexColors:Array):ByteArray
		{
			var rltBytes:ByteArray = new ByteArray();
			
			bytes.position = 0;
			
			rltBytes.writeShort(bytes.readUnsignedShort());
			rltBytes.writeShort(bytes.readUnsignedShort());
			rltBytes.writeShort(bytes.readUnsignedShort());
			rltBytes.writeShort(bytes.readUnsignedShort());
			
			var isn:Boolean = false;
			var isnNum:int = 0;
			
			while(bytes.bytesAvailable > 0)
			{
				var index:int = bytes.readUnsignedByte();
				
				var color:uint = indexColors[index];
				
				var a:uint = color >> 12 & 0xF;
				
				if(a == 0x0)
				{
					if(isn == false)
					{
						isn = true;
						isnNum = 1;
					}
					else
					{
						isnNum += 1;
					}
				}
				else
				{
					if(isn)
					{
						isn = false;
						
						if(isnNum > 255)
						{
							rltBytes.writeByte(255);
							rltBytes.writeShort(isnNum);
						}
						else
						{
							rltBytes.writeByte(254);
							rltBytes.writeByte(isnNum);
						}
					}
					
					rltBytes.writeByte(index);
				}
			}
			
			return rltBytes;
		}
		
		/**
		 * 去掉a、r、g、b通道的低4位
		 * @param pixel
		 * @return 
		 * 
		 */		
		private static function pixel32ToPixel16(pixel:uint):uint
		{
			var a:int = pixel >> 28 & 0xF;
			var r:int = pixel >> 20 & 0xF;
			var g:int = pixel >> 12 & 0xF;
			var b:int = pixel >> 4  & 0xF;
			
			var indexColor:int = a << 12;
			indexColor |= (r << 8);
			indexColor |= (g << 4);
			indexColor |= b;
			
			return indexColor;
		}
		
		/**
		 * 还原a、r、g、b通道的低4位,低4位补0.
		 * @param pixel
		 * @return 
		 * 
		 */		
		private static function pixel16ToPixel32(pixel:uint):uint
		{
			var a1:uint, r1:uint, g1:uint, b1:uint;
			
			a1 = pixel >>> 12 << 4 & 0xFF;
			r1 = pixel >>> 8 << 4 & 0xFF;
			g1 = pixel >>> 4 << 4 & 0xFF;
			b1 = pixel >>> 0 << 4 & 0xFF;
			
			var color:uint = a1 << 24;
			color |= (r1 << 16);
			color |= (g1 << 8);
			color |= b1;
			
			return color;
		}
		
		/**
		 * 在指定列表中查找与指定颜色相近的颜色并返回索引位置
		 * @param rColor
		 * @param indexColors
		 * @return 
		 * 
		 */		
		private static function getAlikeIndex(rColor:uint, indexColors:Array):int
		{
			var n:int = 0;
			var maxer:int = 256;
			
			var a1:uint, r1:uint, g1:uint, b1:uint;
			var a2:uint, r2:uint, g2:uint, b2:uint;
			var a3:uint, r3:uint, g3:uint, b3:uint;
			
			a1 = rColor >>> 12 << 4 & 0xFF;
			r1 = rColor >>> 8 << 4 & 0xFF;
			g1 = rColor >>> 4 << 4 & 0xFF;
			b1 = rColor >>> 0 << 4 & 0xFF;
			
			for(var m:int = 0; m < 250; m++)
			{
				var tmpColor:uint = indexColors[m];
				
				a2 = tmpColor >>> 12 << 4 & 0xFF;
				r2 = tmpColor >>> 8 << 4 & 0xFF;
				g2 = tmpColor >>> 4 << 4 & 0xFF;
				b2 = tmpColor >>> 0 << 4 & 0xFF;
				
				a3 = Math.abs(a2 - a1);
				r3 = Math.abs(r2 - r1);
				g3 = Math.abs(g2 - g1);
				b3 = Math.abs(b2 - b1);
				
				var tmp:int = Math.max(a3, r3, g3, b3);
				
				if(tmp < maxer)
				{
					maxer = tmp;
					n = m;
				}
			}
			
			return n;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		public static function getIndexColor32(bytes:ByteArray, count:int):Array
		{
			var indexColors:Array = [];
			
			for(var i:int = 0; i < count; i++)
			{
				var color:uint = bytes.readUnsignedShort();
				
				color = pixel16ToPixel32(color);
				
				indexColors.push(color);
			}
			
			return indexColors;
		}
		
		public static function bytesTransToImage(bytes:ByteArray, indexColors:Array, width:int, height:int):BitmapData
		{
			var count:int;
			
			bytes.position = 0;
			
			var offsetX:int = bytes.readUnsignedShort(), 
				offsetY:int = bytes.readUnsignedShort(), 
				bWidth:int = bytes.readUnsignedShort(), 
				bHeight:int = bytes.readUnsignedShort();
			
			var x:int = offsetX, y:int = offsetY;
			
			var bmd:BitmapData = new BitmapData(width, height, true, 0x0);
			
			bmd.lock();
			
			while(bytes.bytesAvailable > 0)
			{
				var index:int = bytes.readUnsignedByte();
				
				if(index == 255)
				{
					count = bytes.readUnsignedShort();
				}
				else if(index == 254)
				{
					count = bytes.readUnsignedByte();
				}
				else
				{
					count = 1;
					var color:uint = indexColors[index] as uint;
					bmd.setPixel32(x, y, color);
				}
				
				x += count;
				
				if(x > (bWidth + offsetX))
				{
					x = (x - count) + (count % bWidth) - bWidth;
					
					y += int(count / bWidth) + 1;
					
					if(y > (bHeight + offsetY)) break;
				}
			}
			
			bmd.unlock();
			
			return bmd;
		}
	}
}