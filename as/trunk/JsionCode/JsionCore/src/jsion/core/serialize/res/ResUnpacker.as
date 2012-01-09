package jsion.core.serialize.res
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	import jsion.HashMap;

	public class ResUnpacker
	{
		private var m_indexColors:Array;
		
		private var m_actions:HashMap;
		
		private var m_width:int;
		
		private var m_height:int;
		
		private var m_frameRate:int;
		
		public function ResUnpacker(bytes:ByteArray)
		{
			m_actions = new HashMap();
			
			parseBytes(bytes);
		}
		
		public function getTotalFrame(action:int, dir:int):int
		{
			var dirMap:HashMap = m_actions.get(action);
			
			if(dirMap == null) return 0;
			
			var list:Array = dirMap.get(dir);
			
			if(list == null) return 0;
			
			return list.length;
		}
		
		public function getBitmapDataList(action:int, dir:int, frame:uint):Array
		{
			var dirMap:HashMap = m_actions.get(action);
			
			if(dirMap == null) return null;
			
			var list:Array = dirMap.get(dir);
			
			if(list == null) return null;
			
			return list;
		}
		
		public function getBitmapData(action:int, dir:int, frame:uint):BitmapData
		{
			var dirMap:HashMap = m_actions.get(action);
			
			if(dirMap == null) return null;
			
			var list:Array = dirMap.get(dir);
			
			if(list == null) return null;
			
			if(frame >= list.length) return null;
			
			if(list[frame] is ByteArray)
			{
				return ResSerializeUtil.bytesTransToImage(list[frame] as ByteArray, m_indexColors, m_width, m_height);
			}
			
			return list[frame] as BitmapData;
		}
		
		private function parseBytes(bytes:ByteArray):void
		{
			bytes.uncompress();
			
			bytes.position = 0;
			
			m_frameRate = bytes.readUnsignedByte();//帧频
			m_width = bytes.readUnsignedShort();//宽度
			m_height = bytes.readUnsignedShort();//高度
			
			var indexCount:int = bytes.readUnsignedByte();
			
			m_indexColors = ResSerializeUtil.getIndexColor32(bytes, indexCount);
			
			var actionCount:int = bytes.readUnsignedByte();//动作个数
			
			for(var i:int = 0; i < actionCount; i++)
			{
				var actionID:int = bytes.readUnsignedByte();//动作编号
				var dirCount:int = bytes.readUnsignedByte();//动作方向个数
				
				var dirMap:HashMap = new HashMap();
				m_actions.put(actionID, dirMap);
				
				for(var j:int = 0; j < dirCount; j++)
				{
					var dir:int = bytes.readUnsignedByte();//动作方向
					var frames:int = bytes.readUnsignedByte();//此动作方向上的帧数
					
					var list:Array = [];
					dirMap.put(dir, list);
					
					for(var k:int = 0; k < frames; k++)
					{
						var bytesLen:int = bytes.readUnsignedInt();//图像压缩后的字节长度
						var bmdBytes:ByteArray = new ByteArray();
						bytes.readBytes(bmdBytes, 0, bytesLen);//图像压缩后的字节流
						
						var bmd:BitmapData = ResSerializeUtil.bytesTransToImage(bmdBytes, m_indexColors, m_width, m_height);
						
						list.push(bmd);
					}
				}
			}
		}
	}
}