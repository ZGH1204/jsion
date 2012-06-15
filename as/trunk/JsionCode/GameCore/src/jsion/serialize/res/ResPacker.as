package jsion.serialize.res
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	import jsion.HashMap;
	import jsion.IDispose;
	import jsion.utils.ArrayUtil;
	import jsion.utils.DisposeUtil;

	/**
	 * 资源打包
	 * @author Jsion
	 * 
	 */	
	public class ResPacker implements IDispose
	{
		private var m_actionMap:HashMap;
		
		private var m_width:int;
		
		private var m_height:int;
		
		private var m_frameRate:int;
		
		public function ResPacker()
		{
			m_actionMap = new HashMap();
			
			m_width = m_height = -1;
			
			m_frameRate = 30;
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
		 * 设置帧频
		 */		
		public function setFrameRate(rate:int):void
		{
			m_frameRate = rate;
		}
		
		/**
		 * 添加图片资源
		 * @param bmd 图片资源
		 * @param action 动作类型
		 * @param dir 动作方向
		 * 
		 */		
		public function addImage(bmd:BitmapData, action:int, dir:int):void
		{
			if(bmd == null) return;
			
			var dirMap:HashMap = m_actionMap.get(action);
			
			if(dirMap == null)
			{
				dirMap = new HashMap();
				m_actionMap.put(action, dirMap);
			}
			
			var list:Array = dirMap.get(dir);
			
			if(list == null)
			{
				list = [];
				dirMap.put(dir, list);
			}
			
			if(ArrayUtil.containsValue(list, bmd)) return;
			
			if(m_width < 0 || m_height < 0)
			{
				m_width = bmd.width;
				m_height = bmd.height;
			}
			
			list.push(bmd);
		}
		
//		public function getTotalFrames(action:int, dir:int):int
//		{
//			var dirMap:HashMap = m_actionMap.get(action);
//			
//			if(dirMap == null) return 0;
//			
//			var list:Array = dirMap.get(dir);
//			
//			if(list == null) return 0;
//			
//			return list.length;
//		}
//		
//		public function getImage(action:int, dir:int, frame:int):BitmapData
//		{
//			var dirMap:HashMap = m_actionMap.get(action);
//			
//			if(dirMap == null) return null;
//			
//			var list:Array = dirMap.get(dir);
//			
//			if(list == null) return null;
//			
//			if(frame < 0 || frame >= list.length) return null;
//			
//			return list[frame] as BitmapData;
//		}
		
		private function getAllImage():Array
		{
			var imgs:Array = [];
			
			var list:Array = m_actionMap.getValues();
			
			for each(var map:HashMap in list)
			{
				var list2:Array = map.getValues();
				
				for each(var array:Array in list2)
				{
					for each(var bmd:BitmapData in array)
					{
						imgs.push(bmd);
					}
				}
			}
			
			return imgs;
		}
		
		/**
		 * 打包资源
		 */		
		public function pack():ByteArray
		{
			var indexColors:Array = [];//索引颜色列表,写入文件.
			var actionsBytesMap:HashMap = new HashMap();//动作字节流,逐个写入文件.
			
			var replaceColors:HashMap = new HashMap();
			var imgs:Array = getAllImage();
			
			ResSerializeUtil.getIndexAndReplaceColors(imgs, indexColors, replaceColors);
			
			var actionIDs:Array = m_actionMap.getKeys();
			
			for each(var actionID:int in actionIDs)
			{
				var dirMap:HashMap = m_actionMap.get(actionID);
				var dirs:Array = dirMap.getKeys();
				
				var dirBytesMap:HashMap = new HashMap();
				actionsBytesMap.put(actionID, dirBytesMap);
				
				for each(var dir:int in dirs)
				{
					var bmdBytesList:Array = [];
					dirBytesMap.put(dir, bmdBytesList);
					
					var bmdList:Array = dirMap.get(dir);
					for each(var bmd:BitmapData in bmdList)
					{
						var bmdBytes:ByteArray = ResSerializeUtil.imageTransToBytes(bmd, indexColors, replaceColors);
						
						bmdBytes = ResSerializeUtil.compressImageBytes(bmdBytes, indexColors);
						
						bmdBytesList.push(bmdBytes);
					}
				}
			}
			
			return packImp(indexColors, actionsBytesMap);
		}
		
		private function packImp(indexColors:Array, actionsBytesMap:HashMap):ByteArray
		{
			var bytes:ByteArray = new ByteArray();
			
			bytes.writeByte(m_frameRate);//帧频
			bytes.writeShort(m_width);//宽度
			bytes.writeShort(m_height);//高度
			
			//索引色列表
			bytes.writeByte(indexColors.length);
			
			for(var i:int = 0; i < indexColors.length; i++)
			{
				bytes.writeShort(indexColors[i]);
			}
			
			
			
			
			/**
			 * 
			 * 动作数据：
			 * 		动作个数
			 * 		{
			 * 			动作编号
			 * 			动作方向个数
			 * 			{
			 * 				动作方向
			 * 				此动作方向上的帧数
			 * 				{
			 * 					图像压缩后的字节长度
			 * 					图像压缩后的字节流
			 * 				}
			 * 			}
			 * 		}
			 * 
			 */
			
			
			var actionIDs:Array = actionsBytesMap.getKeys();
			
			bytes.writeByte(actionIDs.length);//动作个数
			
			for each(var actionID:int in actionIDs)
			{
				var dirMap:HashMap = actionsBytesMap.get(actionID);
				var dirs:Array = dirMap.getKeys();
				bytes.writeByte(actionID);//动作编号
				bytes.writeByte(dirs.length);//动作方向个数
				
				for each(var dir:int in dirs)
				{
					var bmdList:Array = dirMap.get(dir);
					bytes.writeByte(dir);//动作方向
					bytes.writeByte(bmdList.length);//此动作方向上的帧数
					for each(var bmdBytes:ByteArray in bmdList)
					{
						bytes.writeUnsignedInt(bmdBytes.length);//图像压缩后的字节长度
						bytes.writeBytes(bmdBytes, 0, bmdBytes.length);//图像压缩后的字节流
					}
				}
			}

			bytes.compress();
			
			return bytes;
		}
		
		/**
		 * 释放资源
		 * 
		 */		
		public function dispose():void
		{
			DisposeUtil.free(m_actionMap);
			m_actionMap = null;
		}
	}
}