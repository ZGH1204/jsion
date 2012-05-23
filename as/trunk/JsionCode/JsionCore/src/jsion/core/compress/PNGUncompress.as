package jsion.core.compress
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
//	import jsion.HashMap;

	public class PNGUncompress
	{
//		private var m_bytes:ByteArray;
//		
//		private var m_indexColors:Array;
//		
//		private var m_actions:HashMap;
//		
//		public function PNGUncompress(bytes:ByteArray)
//		{
//			m_bytes = bytes;
//			
//			m_indexColors = [];
//			
//			m_actions = new HashMap();
//			
//			parseBytes(m_bytes);
//		}
//		
//		public function getBmd(action:int, dir:int, frame:int):BitmapData
//		{
//			var map:HashMap = m_actions.get(action);
//			
//			if(map == null) return null;
//			
//			var list:Array = map.get(dir);
//			
//			if(list == null) return null;
//			
//			if(frame < 0 || frame >= list.length) return null;
//			
//			return list[frame] as BitmapData;
//		}
//		
//		private function parseBytes(bytes:ByteArray):void
//		{
//			trace(bytes.readByte());
//			trace(bytes.readByte());
//			trace(bytes.readByte());
//			trace(bytes.readByte());
//			trace(bytes.readByte());
//			
//			var count:int;
//			
//			count = bytes.readUnsignedByte();
//			
//			var i:int;
//			var color:uint;
//			
//			for(i = 0; i < count; i++)
//			{
//				var c:uint = bytes.readUnsignedShort();
//				
//				var a:uint = (c >>> 12 << 4 & 0xFF) + 0x8;
//				var r:uint = (c >>> 8  << 4 & 0xFF) + 0x8;
//				var g:uint = (c >>> 4  << 4 & 0xFF) + 0x8;
//				var b:uint = (c >>> 0  << 4 & 0xFF) + 0x8;
//				
//				color  = a << 24;
//				color |= (r << 16);
//				color |= (g << 8);
//				color |= b;
//				
//				m_indexColors.push(color);
//			}
//			
//			count = bytes.readUnsignedByte();//动作数量
//			
//			for(i = 0; i < count; i++)
//			{
//				var actionLen:uint = bytes.readUnsignedInt();//动作字节长度
//				
//				var actionID:int = bytes.readByte();//动作编号
//				
//				var dirLen:uint = bytes.readUnsignedInt();//方向字节长度
//				
//				var map:HashMap = m_actions.get(actionID);
//				
//				if(map == null)
//				{
//					map = new HashMap();
//					m_actions.put(actionID, map);
//				}
//				
//				var dir:int = bytes.readByte();//动作方向
//				var frame:int = bytes.readByte();//动作帧数
//				var width:int = bytes.readUnsignedShort();//宽度
//				var height:int = bytes.readUnsignedShort();//高度
//				
//				var list:Array = map.get(dir);
//				
//				if(list == null)
//				{
//					list = [];
//					map.put(dir, list);
//				}
//				
//				for(var m:int = 0; m < frame; m++)
//				{
//					var pngLen:uint = bytes.readUnsignedInt();//图像字节长度
//					var offsetX:int = bytes.readUnsignedShort();//x偏移量
//					var offsetY:int = bytes.readUnsignedShort();//y偏移量
//					var pngWidth:int = bytes.readUnsignedShort();
//					var pngHeight:int = bytes.readUnsignedShort();
//					
//					var dirPngBytes:ByteArray = new ByteArray();
//					bytes.readBytes(dirPngBytes, 0, pngLen);
//					
//					dirPngBytes.position = 0;
//					
//					var bmd:BitmapData = new BitmapData(width, height, true, 0x00000000);
//					
//					var x:int = offsetX, y:int = offsetY;
//					
//					bmd.lock();
//					while(dirPngBytes.bytesAvailable > 0)
//					{
//						var index:int = dirPngBytes.readUnsignedByte();
//						
//						var tmp:int;
//						
//						if(index == 255)
//						{
//							tmp = dirPngBytes.readUnsignedShort();
//						}
//						else if(index == 254)
//						{
//							tmp = dirPngBytes.readUnsignedByte();
//						}
//						else
//						{
//							tmp = 1;
//							color = m_indexColors[index] as uint;
//							bmd.setPixel32(x, y, color);
//						}
//						
//						x += tmp;
//						
//						if(x > (pngWidth + offsetX))
//						{
//							x = (x - tmp) + (tmp % pngWidth) - pngWidth;
//							
//							y += int(tmp / pngWidth) + 1;
//							
//							if(y > (pngHeight + offsetY)) break;
//						}
//					}
//					bmd.unlock();
//					
//					list.push(bmd);
//				}
//			}
//		}
	}
}