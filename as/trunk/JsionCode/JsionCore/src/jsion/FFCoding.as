package jsion
{
//	import Tools.HashMap;
//	
//	import flash.display.BitmapData;
//	import flash.filesystem.File;
//	import flash.filesystem.FileMode;
//	import flash.filesystem.FileStream;
//	import flash.geom.Point;
//	import flash.geom.Rectangle;
//	import flash.utils.ByteArray;
//	import flash.utils.Dictionary;
//	import flash.utils.Endian;
//	import flash.utils.getTimer;
	
	/**
	 独创的针对角色和装备的图片压缩处理技术														<br/>
	 可以高强度压缩格种图片到专用格式(.ff格式)，还可装载多张图片一起压缩							<br/>
	 当存缩的图片数越多时压缩率会越高，同时提供动态读取指定图块方法，减少CPU消耗 					<br/>
	 <br/>
	 @example Basic usage:<listing version="3.0">											
	 <br/>
	 yf 2010-5-15																			<br/><br/><br/>
	 
	 
	 .ff文件内部编码标准说明																	<br/><br/>
	 
	 文件分为三个部分																			<br/>
	 -文件头		记录文件数据的结构															<br/>
	 -动作数据	记录动作所表示的图像位置														<br/>
	 -调色版		记录文件的索引颜色															<br/>
	 -图像数据 保存图像数据																	<br/><br/>
	 
	 
	 每一部分都按以下大体格式																	<br/>
	 -总长度			每一部分的数据总长度														<br/>
	 -数据块		第一部分的数据块																<br/><br/>
	 
	 
	 #说明#							#所占字节#												<br/>
	 
	 文件头格式：																				<br/><br/>
	 
	 总长度						1														<br/>
	 ------------------------------------------------------------动作起始位循环跟据动作总数<br/>
	 动作编号					1														<br/>
	 动作起始位				2														<br/>
	 ------------------------------------------------------------						<br/><br/>
	 
	 
	 动作数据																					<br/>
	 总长度						2														<br/>
	 ------------------------------------------------------------动作数据循环跟据动作总数<br/>
	 方向数					1														<br/>
	 帧数						2														<br/>
	 --------------------------------------------------------方向循环  				<br/>
	 ----------------------------------------------------帧数循环 数据块		<br/>
	 图像宽度			1														<br/>
	 图像高度			1														<br/>
	 X偏移量			1														<br/>
	 Y偏移量			1														<br/>
	 数据起始点		4														<br/>
	 数据长度			4														<br/>
	 ----------------------------------------------------						<br/>
	 --------------------------------------------------------						<br/>
	 ------------------------------------------------------------						<br/><br/>
	 
	 调色板																					<br/>
	 总长度						2														<br/>
	 //注，如果索引色超过254，则不能导入.因为 254和255表示图像空白区，而总数不能超过256		<br/>
	 ------------------------------------------------------------索引色循环				<br/>
	 索引色A					1														<br/>
	 索引色R					1														<br/>
	 索引色G					1														<br/>
	 索引色B					1														<br/>
	 ------------------------------------------------------------						<br/><br/>
	 
	 图像数据																					<br/>
	 总长度						4														<br/>
	 ------------------------------------------------------------						<br/>
	 索引号					1              				 ------------+				<br/>
	 ------------------------------------------------------------						<br/>
	 <br/>
	 <br/>
	 如果索引号是255或254,表示后面的索引都是全透明空白 占用两字节表示空白区					<br/>
	 254	空白片总数（1字节）																<br/>
	 255	空白片总数（2字节）																<br/>
	 可以从一行像素的结尾跨行到下一行的像素开始												<br/><br/>
	 
	 最后加一个字节的附加码 																	<br/>
	 可能表示武器类型																		<br/>
	 </listing>
	 */
	public class FFCoding
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
//		private var wptype:int;//武器类型 0 单手 1双手 2盾牌
//		private var iswrite:Boolean = false;
//		/**
//		 * 创建一个图象编码对象,当参数_ffbytes为空时表示只写模式，
//		 * 当参数不为空时表示只写模式
//		 * 
//		 * @see
//		 * #FFCoding
//		 * 
//		 * @author
//		 * yf
//		 */ 
//		public function FFCoding()
//		{
//			_indexdatademo1 = new Array();
//			iswrite = true;
//			_images = new Array();
//		}
//		
//		/**
//		 * 添加一张原始图片bitmapdata和相关数据到.ff中.
//		 * @param
//		 * _sourcebitmapdata 图像源bitmapdata
//		 * @param
//		 * _action 图像所属动作标识，默认为0 取值范围0-255，无顺序
//		 * @param
//		 * _direction 图像所属动作下的方向标识，默认为0 取值范围0-255，必需从0开始1，2，3，4
//		 * @param
//		 * _offsetX 图像的X坐标偏移量，默认为0 取值范围：有符号短整型
//		 * @param
//		 * _offsetY 图像的Y坐标偏移量，默认为0 取值范围：有符号短整型
//		 * <br/>
//		 */
//		public function AddPNG(_sourcebitmapdata:BitmapData,_action:int=0,_direction:int=0,_offsetX:int=0,_offsetY:int=0):void
//		{
//			if(!iswrite)
//				throw new Error("error:[FFCoding.AddPNG] only read");
//			
//			_images.push([_sourcebitmapdata,_action,_direction,[_offsetX,_offsetY]]);
//			
//			
//		}
//		
//		
//		/**
//		 * 保存FF文件
//		 * @param
//		 * _url 要保存的地址，绝对路径 如：C：\test.ff
//		 * offsetfoot/Y 偏移量X
//		 * ftp 帧频
//		 */
//		public function Save(_url:String,offsetfoot:int=0,ftp:int = 0):void
//		{
//			if(!iswrite)
//				throw new Error("error:[FFCoding.AddPNG] only read");
//			if(!_url)
//				throw new Error("error:[FFCoding.Save] url is null");
//			url = _url;
//			
//			//[1]0宽 1高 2偏X 3偏Y 4图像数据 5动作类型 6方向
//			var pngdata:Array = DeCoderPNG32toPNG8(_images);
//			AddIndexData(pngdata[0]);
//			var arrpngdata2:Array = pngdata[1];
//			for(var i:int=0;i<arrpngdata2.length;i++)
//			{
//				if(findActionStart(arrpngdata2[i][5])==-1)//如果此动作属于新动作，则添加到动作中
//					addActionTothis(arrpngdata2[i][5]);
//				
//				addFreamImage(arrpngdata2[i]);
//			}
//			
//			var f:File = new File(url);
//			if(f.exists)
//				f.deleteFile();
//			bytedata.compress();
//			var savedatas:ByteArray = new ByteArray();
//			//头
//			savedatas.writeByte(bytehead.length);
//			savedatas.writeBytes(bytehead,0,bytehead.length);
//			//动作
//			savedatas.writeShort(byteaction.length);
//			savedatas.writeBytes(byteaction,0,byteaction.length);
//			//索引
//			savedatas.writeShort(byteindex.length);
//			savedatas.writeBytes(byteindex,0,byteindex.length);
//			//图像数据
//			savedatas.writeUnsignedInt(bytedata.length);
//			savedatas.writeBytes(bytedata,0,bytedata.length);
//			//附加码
//			savedatas.writeByte(offsetfoot);//偏移量
//			savedatas.writeShort(ftp);//帧频
//			
//			
//			//var timer1:int = getTimer();
//			//var timer2:int = getTimer()-timer1;
//			//trace(timer2);
//			var filest:FileStream = new FileStream();
//			filest.open(f,FileMode.UPDATE);
//			filest.writeBytes(savedatas,0,savedatas.length);
//			filest.close();
//			savedatas = null;
//			clear();
//			
//		}
//		
//		/**
//		 * 清空编码对象中所用到的字节流
//		 */ 
//		private function clear():void
//		{
//			bytehead = null;
//			byteaction = null;
//			if(byteindex!=null)
//				byteindex = null;
//			bytedata = null;
//			_indexdatademo1 = null;
//		}
//		
//		/**
//		 * 释放所有FF编码文件所使用过的资源
//		 */ 
//		public function Dispose():void
//		{
//			clear();
//			if(_actionBitmapData!=null)
//			{
//				var values1:Dictionary = _actionBitmapData.values();
//				for each(var i:Array in values1)
//				{
//					for(var j:int =0;j<i.length;j++)
//					{
//						for(var k:int =0;k<i[j].length;k++)
//						{
//							i[j][k][0].dispose();
//						}
//					}
//				}
//			}
//		}
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
//		//查找一套动作文件在动作数据中的起始位置
//		private function findActionStart(_action:int):int
//		{
//			bytehead.position=0;
//			while(bytehead.position<bytehead.length)
//			{
//				var actd:int = bytehead.readUnsignedByte();
//				var actstart:int = bytehead.readUnsignedShort();
//				if(actd==_action)
//					return actstart;
//			}
//			return -1;
//		}
//		
//		//添加一套新的动作文件的起始位置
//		private function addActionTothis(_action:int):void
//		{
//			bytehead.position=bytehead.length;
//			bytehead.writeByte(_action);
//			bytehead.writeShort(byteaction.length);
//			byteaction.writeByte(8);
//			byteaction.writeShort(0);
//		}
//		
//		//添加一张帧图片到.ff文件中
//		private function addFreamImage(_pngdata:Array):void
//		{
//			//重新设定动作的方向数量和每个方向的帧数
//			//_pngdata[5] 为当前动作 _pngdata[6] 为当前方向
//			byteaction.position = findActionStart(_pngdata[5]);
//			var direc1:int = 1;
//			var hmdire:HashMap;
//			if(!_direandfreamcount.containsKey(_pngdata[5]))//没有出现过的动作
//			{
//				hmdire = new HashMap();
//				hmdire.put(_pngdata[6],1)
//				_direandfreamcount.put(_pngdata[5],hmdire);
//			}
//			else
//			{
//				hmdire = _direandfreamcount.get(_pngdata[5]);
//				if(!hmdire.containsKey(_pngdata[6]))
//					hmdire.put(_pngdata[6],1);
//				else
//				{
//					direc1 = hmdire.get(_pngdata[6])+1;
//					hmdire.put(_pngdata[6],direc1);
//				}
//			}
//			byteaction.writeByte(hmdire.size());//重新写入方向总数
//			var tfream:int = byteaction.readUnsignedShort();
//			byteaction.position-=2;
//			byteaction.writeShort(tfream+1);//重新写入动作总帧数[这里记录的是所有方向加起来的帧总和，在取值时需要除以方向数才能获得每一个方向的帧数]
//			
//			//写入动作数据
//			var newDAT:ByteArray = _pngdata[4];
//			byteaction.position = byteaction.length;
//			byteaction.writeShort(_pngdata[0]);
//			byteaction.writeShort(_pngdata[1]);
//			byteaction.writeShort(_pngdata[2]);
//			byteaction.writeShort(_pngdata[3]);
//			byteaction.writeUnsignedInt(bytedata.length);
//			
//			
//			//写入图像数据
//			newDAT.position = 0;
//			bytedata.position = bytedata.length;
//			var isn:Boolean = false;
//			var isnnum:int = 0;
//			var datalenght1:int = bytedata.position;
//			while(newDAT.bytesAvailable>0)
//			{
//				
//				var uindex1:uint = newDAT.readUnsignedByte();
//				var color1:uint = _indexdatademo1[uindex1];				
//				var a1:uint = color1 >> 28 & 0xF;
//				if(a1==0x0)
//				{
//					if(!isn)
//					{
//						isn = true;
//						isnnum = 1;
//					}
//					else
//						isnnum++;
//				}
//				else
//				{
//					if(isn)
//					{
//						isn = false;
//						if(isnnum>=256)
//						{
//							bytedata.writeByte(255);
//							bytedata.writeShort(isnnum);
//						}
//						else
//						{
//							bytedata.writeByte(254);
//							bytedata.writeByte(isnnum);
//						}
//					}
//					bytedata.writeByte(uindex1);
//				}
//			}
//			newDAT.position = 0;
//			
//			byteaction.writeUnsignedInt(bytedata.position-datalenght1);//最终写入长度[减去了空白之后的图片长度]
//			//完成加入
//		}
//		
//		/**
//		 * 将传入的所有图片处理为PNG8位250共用索引色图片
//		 * 并在处理完成后返回PNG8位索引色数据及图像索引数据
//		 * @param
//		 * imgs 图像数据<br>
//		 * 参数说明：<br>
//		 * imgs是一个三维数组<br><br>
//		 * 第一维是数像数据数组，总长度就是图像个数<br><br>
//		 * 第二维有四组数据<br>
//		 * 第二维[0] = 图像的bitmapData<br>
//		 * 第二维[1] = 图像的动作编号，在多个动作的需求下才用得上，一个动作包括多个方向，默认为1<br>
//		 * 第二维[2] = 图像的方向编号，在多个方向的需求下才用得上，默认为0<br>
//		 * 第二维[3] = 图像的偏移量-校对图像有效区域左上角xy点和原始图像00坐标的偏移量<br><br> 
//		 * 
//		 * 第二维[3] 中有两个项<br><br>
//		 * 第二维[3][0] = 图像的X偏移量<br>
//		 * 第二维[3][1] = 图像的Y偏移量<br>
//		 */ 
//		private function DeCoderPNG32toPNG8(imgs:Array):Array
//		{
//			var _indexdata32map:HashMap = new HashMap();
//			var _indexdata65536:Array = new Array();
//			var imgsKG:Array = new Array(imgs.length);
//			
//			for(var sd:int =0 ;sd<imgs.length;sd++)
//			{	
//				var ar1:BitmapData = imgs[sd][0];
//				if(ar1==null) //没图片，用来占位置
//				{
//					imgsKG[sd]=[0,0,0,0,null];
//				}
//				else
//				{
//					var rec:Rectangle = ar1.getColorBoundsRect(0xFF000000,0x00000000,false);
//					if(rec.width==0||rec.height==0)
//					{
//						rec.width = ar1.width;
//						rec.height = ar1.height;
//					}
//					var arkg:BitmapData = new BitmapData(rec.width,rec.height,true,0xFF000000);
//					arkg.copyPixels(ar1,rec,new Point(0,0));
//					imgsKG[sd]=[rec.width,rec.height,rec.x+int(imgs[sd][3][0]),rec.y+int(imgs[sd][3][1]),arkg];
//					ar1.dispose();
//				}
//			}
//			//取颜色表
//			for(var i:int=0;i<imgsKG.length;i++)
//			{
//				ar1 = imgsKG[i][4];
//				if(ar1==null)
//					continue;
//				var w1:int = ar1.width;
//				var h1:int = ar1.height;
//				for(var l:int = 0;l<h1;l++)
//				{
//					for(var k:int = 0;k<w1;k++)
//					{
//						//取RGB的高4位，丢掉低四位误差->16
//						var color:uint = ar1.getPixel32(k,l);
//						var a1:int = color >> 28 & 0xF;
//						var r1:int = color >> 20 & 0xF;  
//						var g1:int = color >> 12 & 0xF;  
//						var b1:int = color >> 4  & 0xF;
//						
//						var color2:uint = a1 << 12 |r1 << 8 | g1 << 4 | b1;
//						if(_indexdata65536[color2]==null)
//							_indexdata65536[color2] = 1;
//						else
//							_indexdata65536[color2]++;
//					}
//				}
//			}
//			//取出使用次数大于0的颜色
//			var minco:uint = 0;//设定一个最小值，使用次数少于这个次数的像素值都会被替换掉
//			for(i=0;i<65536;i++)
//			{
//				if(_indexdata65536[i]>0)
//					_indexdata32map.put(i,_indexdata65536[i]);
//			}
//			var values1:Array = _indexdata32map.valuesclone();
//			values1.sort(Array.NUMERIC);
//			//生成250索引色	分开需要替换的颜色
//			var _tagcount:int = values1[values1.length-250];//分界点,使用等于和少于这么多次的颜色都将被替换
//			var _indexdatademo1:Array = new Array();
//			var _indexdatademo2:HashMap = new HashMap();//需要被替换的颜色表
//			var _fcolors:Array = _indexdata32map.keysclone();
//			var _indatademocount:int = 0;//记录进入真正索引表的次数，超过250就再进不了了
//			for each(var colorkey1:uint in _fcolors)
//			{
//				var colorcount1:uint = _indexdata32map.get(colorkey1);
//				if(_indatademocount<250&&colorcount1>=_tagcount)
//				{
//					_indexdatademo1[_indatademocount]=colorkey1;
//					_indatademocount++;
//				}
//				else
//					_indexdatademo2.put(colorkey1,colorcount1);
//			}
//			//找出替换色
//			_fcolors = _indexdatademo2.keysclone();
//			var a:uint;  
//			var r:uint;  
//			var g:uint;  
//			var b:uint;
//			var a2:uint;  
//			var r2:uint;  
//			var g2:uint;  
//			var b2:uint;
//			var a3:uint;  
//			var r3:uint;  
//			var g3:uint;  
//			var b3:uint;
//			for each(color in _fcolors)
//			{
//				a = color >>> 12 << 4&0xFF;
//				r = color >>> 8  << 4&0xFF;  
//				g = color >>> 4  << 4&0xFF;  
//				b = color >>> 0  << 4&0xFF;
//				
//				//找出最接近color1的颜色
//				
//				var i2:int = 0;
//				var maxar:int = 256;
//				for(i=0;i<250;i++)
//				{
//					color2 = _indexdatademo1[i];
//					a2 = color2 >>> 12 << 4&0xFF;
//					r2 = color2 >>> 8  << 4&0xFF;  
//					g2 = color2 >>> 4  << 4&0xFF;  
//					b2 = color2 >>> 0  << 4&0xFF;
//					
//					a3 = Math.abs(a2-a);
//					r3 = Math.abs(r2-r);
//					g3 = Math.abs(g2-g);
//					b3 = Math.abs(b2-b);
//					var arint1:int = a3>r3?a3:r3;
//					arint1 = arint1>g3?arint1:g3;
//					arint1 = arint1>b3?arint1:b3;
//					if(arint1<maxar)
//					{
//						maxar = arint1;
//						i2 = i;
//					}
//				}
//				_indexdatademo2.put(color,_indexdatademo1[i2]);
//			}
//			
//			//写入图像数据
//			var ar2:Array = new Array();
//			for(i=0;i<imgsKG.length;i++)
//			{
//				ar1 = imgsKG[i][4];
//				if(ar1==null)
//				{
//					ar2.push([0,0,0,0,new ByteArray(),imgs[i][1],0]);
//				}
//				else
//				{
//					var bimgnew:ByteArray = new ByteArray();				
//					w1 = ar1.width;
//					h1 = ar1.height;
//					for(l = 0;l<h1;l++)
//					{
//						for(k = 0;k<w1;k++)
//						{
//							color = ar1.getPixel32(k,l);
//							a1 = color >> 28 & 0xF;
//							r1 = color >> 20 & 0xF;  
//							g1 = color >> 12 & 0xF;  
//							b1 = color >> 4  & 0xF;
//							color2 = a1 << 12 |r1 << 8 | g1 << 4 | b1;
//							if(_indexdatademo2.containsKey(color2))
//								color2 = _indexdatademo2.get(color2);
//							var newindex:int = _indexdatademo1.indexOf(color2);
//							if(newindex!=-1)
//								bimgnew.writeByte(newindex);
//							else
//								throw new VerifyError("error:not find index color");
//						}
//					}
//					bimgnew.position = 0;
//					//宽 高 偏X 偏Y 图像数据 动作类型 方向
//					ar2.push([imgsKG[i][0],imgsKG[i][1],imgsKG[i][2],imgsKG[i][3],bimgnew,imgs[i][1],imgs[i][2]]);
//				}
//			}
//			
//			//索引色数据
//			var ar:ByteArray = new ByteArray();
//			for(i=0;i<250;i++)
//			{
//				color = _indexdatademo1[i];
//				ar.writeShort(color);
//			}
//			
//			ar.position = 0;
//			imgs.splice(0,imgs.length);
//			return [ar,ar2];
//		}
//		/**
//		 * 将删除的颜色匹配到颜色引索中最相近的颜色值中.
//		 */ 
//		private static function getdelcolor(_color:uint,_indexdata32del:HashMap):uint
//		{
//			if(!_indexdata32del.containsKey(_color))
//				return _color;
//			else
//				return getdelcolor(_indexdata32del.get(_color),_indexdata32del);
//		}
		
		
	}
}