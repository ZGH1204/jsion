package jsion
{
//	import Tools.HashMap;
//	
//	import flash.display.BitmapData;
//	import flash.geom.Point;
//	import flash.geom.Rectangle;
//	import flash.utils.ByteArray;
//	import flash.utils.Dictionary;
//	import flash.utils.Endian;
//	import flash.utils.getTimer;
	
	public class FFData
	{
		
//		private var bytehead:ByteArray		= new ByteArray();
//		private var byteaction:ByteArray	= new ByteArray();
//		private var byteindex:ByteArray;
//		private var bytedata:ByteArray		= new ByteArray();
//		private var url:String				= "";
//		private var _indexdatademo1:Array;//真正的颜色表
//		private var _actiondata:HashMap = new HashMap();
//		private var _direandfreamcount:HashMap = new HashMap();//记录每个动作的帧数和方向数
//		private var _actionBitmapData:HashMap;//图像缓存器
//		private var _images:Array;//要处理的源图像列表
//		
//		
//		public var offsetfood:int = 0; //落脚点偏移量
//		public var fps:int = 0;		//帧频
//		
//		
//		public function FFData(_ffbytes:ByteArray)
//		{
//			_indexdatademo1 = new Array();				
//			//var timer1:int = getTimer();			
//			byteindex = new ByteArray();
//			_ffbytes.readBytes(bytehead,0,_ffbytes.readUnsignedByte());
//			_ffbytes.readBytes(byteaction,0,_ffbytes.readUnsignedShort());
//			_ffbytes.readBytes(byteindex,0,_ffbytes.readUnsignedShort());
//			_ffbytes.readBytes(bytedata,0,_ffbytes.readUnsignedInt());
//			//wptype = _ffbytes.readUnsignedByte();
//			offsetfood = _ffbytes.readByte();			
//			if(_ffbytes.position==_ffbytes.length)
//				fps = 0;
//			else
//				fps = _ffbytes.readUnsignedShort();
//			//_ffbytes.clear();
//			_ffbytes.position = 0;
//			
//			AddIndexData(byteindex);
//			
//			bytedata.uncompress();
//			bytehead.position = 0;
//			
//			_actionBitmapData = new HashMap();
//			while(bytehead.bytesAvailable>0)
//			{
//				var key1:int = bytehead.readUnsignedByte();//动作标识
//				var action1:int = bytehead.readShort();//动作起始位
//				_actiondata.put(key1,action1);
//				byteaction.position = action1;
//				var dire1:int = byteaction.readUnsignedByte();
//				_direandfreamcount.put(key1,[dire1,byteaction.readUnsignedShort()/dire1]);//前面是方向数，后面是方向的子帧数(方向总帧数/方向数)
//				
//				var arrdire:Array = new Array();
//				for(var i:int = 0;i<16;i++)
//				{
//					arrdire.push(new Array());
//				}
//				_actionBitmapData.put(key1,arrdire);
//			}
//			//clear();
//			bytehead = null;
//			byteindex = null;
//			//var timer2:int = getTimer()-timer1;
//			//trace(timer2);
//		}
//		
//		/**
//		 * 从图像编码中提取一张指定的图片.<br/>由于开启了图像缓存机制，当数据第一次被反编码成图像后，图像会留在缓存中，所以请不要主动释放所返回的bitmapdata对象,需要销毁时请主动调用Dispose方法.
//		 * <br/>
//		 * 如果用于纸娃娃系统，则可以参考以下取值，如果是单动作单方向，则可以默认都为0
//		 * @param
//		 * _fream 要获取动作的方向第多少帧。参考如下 默认为0
//		 * <li> 1-8  动作为8帧 </li><br/>
//		 * <li> 9-15 动作为16帧 </li><br/>
//		 * <li> 16   动作为18帧 </li><br/>
//		 * @param
//		 * _action 要获取的动作 取值可以参考如下 默认为0<br/>
//		 * <li> 1  空手呼吸</li><br/>
//		 * <li> 2  主手武器呼吸</li><br/>
//		 * <li> 3  副手武器呼吸</li><br/>
//		 * <li> 4  双手武器呼吸</li><br/>
//		 * <li> 5  空手跑动</li><br/>
//		 * <li> 6  主手武器跑动</li><br/>
//		 * <li> 7  副手武器跑动</li><br/>
//		 * <li> 8  双手武器跑</li><br/>
//		 * <li> 9  空手砍(主手)</li><br/>
//		 * <li> 10 主手砍</li><br/>
//		 * <li> 11 主手砍第二种</li><br/>
//		 * <li> 12 主手砍(副手不空动作)</li><br/>
//		 * <li> 13 副手砍</li><br/>
//		 * <li> 14 副手砍(主手不空动作)</li><br/>
//		 * <li> 15 副手砍(主手空动作)</li><br/>
//		 * <li> 16 双手砍</li><br/>
//		 * @param
//		 * _dire 要获取的动作的方向 取值按顺时针方向，参考如下 默认为0
//		 * <li> 正下方为第方向0 </li><br/>
//		 * <li> 正左方为第方向4</li><br/>
//		 * <li> 正上方为第方向8</li><br/>
//		 * <li> 正右方为第方向12</li><br/>
//		 * @return
//		 * 返回 0 BitmapData 对象。和1 X,2 Y 偏移量,数字表示返回的数组的索引
//		 * @see
//		 * #FFCoding
//		 */
//		public function GetBitmapData(_fream:int=0,_action:int=0,_dire:int=0):Array
//		{
//			//			var timer1:int = getTimer();			
//			var arr1:Array = _actionBitmapData.get(_action)[_dire];
//			var bitmapdataarr1:Array = arr1[_fream];
//			if(bitmapdataarr1!=null)
//				return bitmapdataarr1;
//			
//			var bitmapdata1:BitmapData;
//			var _freamcount:int = _direandfreamcount.get(_action)[1];//跟据动作获得当前动作中的某个方向的帧数[同一动作下方向子帧数相等]
//			var off1:int = _actiondata.get(_action);
//			off1 = off1+3+(_dire*_freamcount*16)+(_fream+1)*16-16;//16代表一个图像头的数据长度,以下面读取字节数量为准
//			byteaction.position = off1;
//			var w1:int = byteaction.readUnsignedShort();
//			if(w1==0)
//				return [null];
//			var h1:int = byteaction.readUnsignedShort();
//			var ox1:int = byteaction.readShort();
//			var oy1:int = byteaction.readShort();
//			off1 = byteaction.readUnsignedInt();
//			var len1:int = byteaction.readUnsignedInt();
//			var imgbyte:ByteArray = new ByteArray();
//			bytedata.position = off1;
//			bytedata.readBytes(imgbyte,0,len1);
//			bitmapdata1 = new BitmapData(w1,h1,true,0x00000000);
//			var isindexnul:int = 0;
//			bitmapdata1.lock();
//			for(var i:int=0;i<bitmapdata1.height;i++)
//			{
//				for(var j:int=0;j<bitmapdata1.width;j++)
//				{
//					if(imgbyte.bytesAvailable==0)	
//						break;
//					
//					
//					var index1:int = imgbyte.readUnsignedByte();
//					if(index1>250)
//					{
//						if(index1==254)
//							isindexnul = imgbyte.readUnsignedByte();
//						else
//							isindexnul = imgbyte.readUnsignedShort();
//						var syj:int = (bitmapdata1.width-j);
//						if(syj>isindexnul)
//						{
//							j+=isindexnul-1;
//							isindexnul = 0;
//						}
//						else
//						{
//							isindexnul-=syj;
//							i+=int(isindexnul/bitmapdata1.width)+1;
//							isindexnul = int(isindexnul%bitmapdata1.width);
//							j = isindexnul-1;
//							isindexnul = 0;
//						}
//					}
//					bitmapdata1.setPixel32(j,i,_indexdatademo1[index1]);
//				}
//			}
//			bitmapdata1.unlock();
//			//			var timer2:int = getTimer()-timer1;
//			//			trace("解压时间:"+timer2);
//			
//			arr1[_fream] = [bitmapdata1,ox1,oy1];
//			return arr1[_fream];
//			//			return [bitmapdata1,ox1,oy1];
//		}
//		
//		
//		/**
//		 * 获取某一个动作下的最大方向数量,只有读取时可用。
//		 * @param _action
//		 * 动作标识，默认为0
//		 * @return
//		 * 返回指定动作的方向数量
//		 */ 
//		public function getMaxDirection(_action:int=0):int
//		{
//			if(_direandfreamcount.containsKey(_action))
//				return _direandfreamcount.get(_action)[0];
//			else
//				return 0;
//		}
//		
//		/**
//		 * 获取某一个动作下的任意一个方向的最大帧数量[提前是所有方向下的帧数都必需是相同的],只有读取时可用。
//		 * @param _action
//		 * 动作标识，默认为0
//		 * @return
//		 * 返回指定动作的任意一个方向的帧数量
//		 */ 
//		public function getMaxFarme(_action:int=0):int
//		{			
//			if(_direandfreamcount.containsKey(_action))
//				return _direandfreamcount.get(_action)[1];
//			else
//				return 0;
//		}
//		
//		/**
//		 * 获得总动作数量
//		 */ 
//		public function getMaxActon():int
//		{
//			return _direandfreamcount.size();
//		}
//		
//		
//		/**
//		 * 添加一个颜色索引数据流到.ff中
//		 * @param
//		 * _indexdata 二进制的图像索引数据
//		 */ 
//		private function AddIndexData(_indexdata:ByteArray):void
//		{
//			byteindex = _indexdata;
//			byteindex.position = 0;
//			for(var i:int=0;i<250;i++)
//			{
//				var color1:int = byteindex.readUnsignedShort();
//				var a:uint = (color1 >>> 12 << 4&0xFF);
//				var addv:int = a==0?0:8;
//				if(a==0xF0)
//					a = 0xFF;
//				var r:uint = (color1 >>> 8  << 4&0xFF)+addv;
//				var g:uint = (color1 >>> 4  << 4&0xFF)+addv;
//				var b:uint = (color1 >>> 0  << 4&0xFF)+addv;
//				var color2:uint =  a << 24 |r << 16 | g << 8 | b;
//				
//				_indexdatademo1[i] = color2;
//			}
//			byteindex.position = 0;
//		}
//		
//		
//		/**
//		 * 释放所有FF编码文件所使用过的资源
//		 */ 
//		public function Dispose():void
//		{
//			bytehead = null;
//			byteaction = null;
//			if(byteindex!=null)
//				byteindex = null;
//			bytedata = null;
//			_indexdatademo1 = null;
//			if(_actionBitmapData!=null)
//			{
//				var values1:Dictionary = _actionBitmapData.values();
//				for each(var i:Array in values1)
//				{
//					for(var j:int =0;j<i.length;j++)
//					{
//						for(var k:int =0;k<i[j].length;k++)
//						{
//							try
//							{
//								i[j][k][0].dispose();
//							}catch(e:Error){
//								
//							}
//						}
//					}
//				}
//			}
//		}
	}
}