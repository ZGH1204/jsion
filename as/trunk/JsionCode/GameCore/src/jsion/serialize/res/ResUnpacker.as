package jsion.serialize.res
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	import jsion.HashMap;
	import jsion.IDispose;
	import jsion.utils.DisposeUtil;

	/**
	 * 资源解包
	 * @author Jsion
	 * 
	 */	
	public class ResUnpacker implements IDispose
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
		
		/**
		 * 资源帧频
		 */		
		public function get frameRate():int
		{
			return m_frameRate;
		}
		
		/**
		 * 资源宽度
		 */		
		public function get width():int
		{
			return m_width;
		}
		
		/**
		 * 资源高度
		 */		
		public function get height():int
		{
			return m_height;
		}
		
		/**
		 * 获取指定动作和方向的总帧数
		 * @param action 动作类型
		 * @param dir 动作方向
		 * @return 总帧数
		 * 
		 */		
		public function getTotalFrame(action:int, dir:int):int
		{
			var dirMap:HashMap = m_actions.get(action);
			
			if(dirMap == null) return 0;
			
			var list:Array = dirMap.get(dir);
			
			if(list == null) return 0;
			
			return list.length;
		}
		
		/**
		 * 替换掉指定动作序列帧图片列表
		 * 此方法会强制替换掉已有列表。
		 * @param action 动作类型
		 * @param dir 动作方向
		 * @param list 序列帧图片列表
		 * 
		 */		
		public function putBitmapDataList(action:int, dir:int, list:Array):void
		{
			var dirMap:HashMap = m_actions.get(action);
			
			if(dirMap == null) return;
			
			dirMap.put(dir, list);
		}
		
		/**
		 * 获取指定动作和方向的图片资源列表
		 * @param action 动作类型
		 * @param dir 动作方向
		 * @return 图片资源列表
		 * 
		 */		
		public function getBitmapDataList(action:int, dir:int):Array
		{
			var dirMap:HashMap = m_actions.get(action);
			
			if(dirMap == null) return null;
			
			var list:Array = dirMap.get(dir);
			
			if(list == null) return null;
			
			return list;
		}
		
		/**
		 * 获取指定动作、方向和帧索引的图片资源
		 * @param action 动作类型
		 * @param dir 动作方向
		 * @param frame 要获取的帧索引
		 * @return 图片资源 BitmapData 对象
		 * 
		 */		
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
		
		/**
		 * 获取所有动作ID列表
		 */		
		public function getActionIDs():Array
		{
			return m_actions.getKeys();
		}
		
		/**
		 * 获取指定动作的所有方向ID列表
		 */		
		public function getDirIDs(action:int):Array
		{
			var dMap:HashMap = m_actions.get(action) as HashMap;
			
			if(dMap == null) return null;
			
			return dMap.getKeys();
		}
		
		/**
		 * 释放资源
		 * 
		 */		
		public function dispose():void
		{
			DisposeUtil.free(m_actions);
			m_actions = null;
			
			m_indexColors = null;
		}
	}
}