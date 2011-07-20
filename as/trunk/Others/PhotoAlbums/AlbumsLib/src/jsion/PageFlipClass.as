/**
*
* 6dn PageFlip

*----------------------------------------------------------------
* @notice 6dn PageFlip翻页类
* @author 6dn
* @as version3.0
* @date 2009-1-4
*
* AUTHOR ******************************************************************************
* 
* authorName : 黎新苑 - www.6dn.cn
* QQ :160379558(小星@6dn)
* MSN :xdngo@hotmail.com
* email :6dn@6dn.cn
* webpage :       http://www.6dn.cn
* 
* LICENSE ******************************************************************************
* 
* ① 此类是在AS3基础上编写,只能对使用as3的swf文件完全支持!
* ② 基本上实现了现有的杂志功能,支持显示阴影,支持拖动翻页以及点击翻页，支持单页和双页显示，支持页面跳转；
* ③ 使用内部xml或外部xml，支持外部读取jpg、gif、png、swf并可混合使用；
* ④ 可扩展实现缩略图预览，可扩展添加loading；
* ⑤ 可自由设置Timer，值越小翻页越流畅，值越大占用CPU越小；
* ⑥ 此类作为开源使用，但请重视作者劳动成果，请使用此类的朋友保留作者信息。
* Please, keep this header and the list of all authors
 * 
 * 
private function PageFlipClassDemo():void
{
	var book_container:MovieClip=new MovieClip();
	var mypageflip:PageFlipClass=new PageFlipClass();
	var myXML:XML =
		<content width="300" height="400">
				<page src="photos/2rssadgsdf.jpg"/>
				<page src="photos/asdfasdfasgrghbn.jpg"/>
				<page src="photos/asdfsadf.jpg"/>
				<page src="photos/asdfsdf.jpg"/>
				<page src="photos/http_imgload.jpg"/>
		</content>;
	
	book_container.x=30;
	book_container.y=30;
	addChild(book_container);
	
	mypageflip.myXML=myXML;
	mypageflip.book_root=book_container;
	mypageflip.book_initpage=0;
	mypageflip.book_TimerNum=30;
	mypageflip.InitBook();
}
 * 
 * 
 * 
* 
*/
package jsion
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.utils.*;
	import flash.utils.Timer;

	public class PageFlipClass {
		//可设置或可调用接口,页数以单页数计算~---------------------------------------
		public var myXML:XML;
		public var book_root:MovieClip;//装载book的MC
		public var book_initpage:Number=0;//初始化到第N页
		public var book_totalpage:Number=0;//总页数
		public var book_TimerNum:Number=30;//Timer的间隔时间
		public var book_page:Number=0;//当前页
		public var onLoadinit:Function=null;//加载外部影片或图片时调用
		public var onLoading:Function=null;//正在加载外部影片或图片时调用
		public var onLoadEnd:Function=null;//加载外部影片或图片完毕时调用
		public var onPageEnd:Function=null;//翻页动作结束时调用
		//PageGoto:Function;//翻页跳转
		//PageDraw:Function;//绘制缩略图
		//InitBook:Function;//初始化
		//END!!--------------------------------------------------------------------

		private var book_width:Number;
		private var book_height:Number;
		private var book_topage:Number;

		private var book_CrossGap:Number;
		private var bookArray_layer1:Array;
		private var bookArray_layer2:Array;

		private var book_TimerFlag:String="stop";
		private var book_TimerArg0:Number=0;
		private var book_TimerArg1:Number=0;
		private var u:Number;
		private var book_px:Number=0;
		private var book_py:Number=0;
		private var book_toposArray:Array;
		private var book_myposArray:Array;
		private var book_timer:Timer;

		private var Bmp0:BitmapData;
		private var Bmp1:BitmapData;
		private var bgBmp0:BitmapData;
		private var bgBmp1:BitmapData;

		private var pageMC:Sprite=new Sprite();
		private var bgMC:Sprite=new Sprite();

		private var render0:Shape=new Shape();
		private var render1:Shape=new Shape();
		private var shadow0:Shape=new Shape();
		private var shadow1:Shape=new Shape();

		private var Mask0:Shape=new Shape();
		private var Mask1:Shape=new Shape();

		private var p1:Point;
		private var p2:Point;
		private var p3:Point;
		private var p4:Point;

		private var limit_point1:Point;
		private var limit_point2:Point;

		//**init Parts------------------------------------------------------------------------
		public function InitBook():void {
			book_width=myXML.attribute("width");
			book_height=myXML.attribute("height");
			book_totalpage=myXML.child("page").length();
			book_page=book_topage=book_initpage;
			book_CrossGap=Math.sqrt(book_width*book_width+book_height*book_height);

			p1=new Point(0,0);
			p2=new Point(0,book_height);
			p3=new Point(book_width+book_width,0);
			p4=new Point(book_width+book_width,book_height);

			limit_point1=new Point(book_width,0);
			limit_point2=new Point(book_width,book_height);

			book_toposArray=[p3,p4,p1,p2];
			book_myposArray=[p1,p2,p3,p4];

			book_root.addChild(pageMC);
			book_root.addChild(bgMC);
			SeFilter(pageMC);
			SeFilter(bgMC);

			book_root.addChild(Mask0);
			book_root.addChild(Mask1);
			
			book_root.addChild(render0);
			book_root.addChild(shadow0);			
			book_root.addChild(render1);
			book_root.addChild(shadow1);

			SetLoadMC();
			SetPageMC(book_page);
			book_timer= new Timer(book_TimerNum, 0);
			book_root.stage.addEventListener(MouseEvent.MOUSE_DOWN, MouseOnDown);
			book_root.stage.addEventListener(MouseEvent.MOUSE_UP, MouseOnUp);
			book_timer.addEventListener("timer", bookTimerHandler);
		}
		//End init------------------------------------------------------------------------

		//**DrawPage Parts------------------------------------------------------------------------
		private function DrawPage(num:Number,_movePoint:Point,bmp1:BitmapData,bmp2:BitmapData):void {

			//var _movePoint:Point=new Point(mouseX,mouseY);
			var _actionPoint:Point;

			var book_array:Array;
			var book_Matrix1:Matrix=new Matrix();
			var book_Matrix2:Matrix=new Matrix();
			var Matrix_angle:Number;


			if (num==1) {

				_movePoint=CheckLimit(_movePoint,limit_point1,book_width);
				_movePoint=CheckLimit(_movePoint,limit_point2,book_CrossGap);

				book_array=GetBook_array(_movePoint,p1,p2);
				_actionPoint=book_array[1];
				GeLayer_array(_movePoint,_actionPoint,p1,p2,limit_point1,limit_point2);

				DrawShadowShap(shadow0,Mask0,book_width*1.5,book_height*4,p1,_movePoint,new Array(p1,p3,p4,p2),0.5);
				DrawShadowShap(shadow1,Mask1,book_width*1.5,book_height*4,p1,_movePoint,bookArray_layer1,0.45);


				Matrix_angle=angle(_movePoint,_actionPoint)+90;
				book_Matrix1.rotate((Matrix_angle/180)*Math.PI);
				book_Matrix1.tx=book_array[3].x;
				book_Matrix1.ty=book_array[3].y;

				book_Matrix2.tx=p1.x;
				book_Matrix2.ty=p1.y;

			} else if (num==2) {

				_movePoint=CheckLimit(_movePoint,limit_point2,book_width);
				_movePoint=CheckLimit(_movePoint,limit_point1,book_CrossGap);

				book_array=GetBook_array(_movePoint,p2,p1);
				_actionPoint=book_array[1];
				GeLayer_array(_movePoint,_actionPoint,p2,p1,limit_point2,limit_point1);

				DrawShadowShap(shadow0,Mask0,book_width*1.5,book_height*4,p2,_movePoint,new Array(p1,p3,p4,p2),0.5);
				DrawShadowShap(shadow1,Mask1,book_width*1.5,book_height*4,p2,_movePoint,bookArray_layer1,0.45);

				Matrix_angle=angle(_movePoint,_actionPoint)-90;
				book_Matrix1.rotate((Matrix_angle/180)*Math.PI);
				book_Matrix1.tx=book_array[2].x;
				book_Matrix1.ty=book_array[2].y;

				book_Matrix2.tx=p1.x;
				book_Matrix2.ty=p1.y;

			} else if (num==3) {

				_movePoint=CheckLimit(_movePoint,limit_point1,book_width);
				_movePoint=CheckLimit(_movePoint,limit_point2,book_CrossGap);

				book_array=GetBook_array(_movePoint,p3,p4);
				_actionPoint=book_array[1];
				GeLayer_array(_movePoint,_actionPoint,p3,p4,limit_point1,limit_point2);

				DrawShadowShap(shadow0,Mask0,book_width*1.5,book_height*4,p3,_movePoint,new Array(p1,p3,p4,p2),0.5);
				DrawShadowShap(shadow1,Mask1,book_width*1.5,book_height*4,p3,_movePoint,bookArray_layer1,0.4);

				Matrix_angle=angle(_movePoint,_actionPoint)+90;
				book_Matrix1.rotate((Matrix_angle/180)*Math.PI);
				book_Matrix1.tx=_movePoint.x;
				book_Matrix1.ty=_movePoint.y;

				book_Matrix2.tx=limit_point1.x;
				book_Matrix2.ty=limit_point1.y;

			} else {

				_movePoint=CheckLimit(_movePoint,limit_point2,book_width);
				_movePoint=CheckLimit(_movePoint,limit_point1,book_CrossGap);

				book_array=GetBook_array(_movePoint,p4,p3);
				_actionPoint=book_array[1];
				GeLayer_array(_movePoint,_actionPoint,p4,p3,limit_point2,limit_point1);

				DrawShadowShap(shadow0,Mask0,book_width*1.5,book_height*4,p4,_movePoint,new Array(p1,p3,p4,p2),0.5);
				DrawShadowShap(shadow1,Mask1,book_width*1.5,book_height*4,p4,_movePoint,bookArray_layer1,0.4);

				Matrix_angle=angle(_movePoint,_actionPoint)-90;
				book_Matrix1.rotate((Matrix_angle/180)*Math.PI);
				book_Matrix1.tx=_actionPoint.x;
				book_Matrix1.ty=_actionPoint.y;

				book_Matrix2.tx=limit_point1.x;
				book_Matrix2.ty=limit_point1.y;

			}
			//trace(bookArray_layer2)
			//
			DrawShape(render1,bookArray_layer1,bmp1,book_Matrix1);
			DrawShape(render0,bookArray_layer2,bmp2,book_Matrix2);
		}
		
		private function CheckLimit($point:Point,$limitPoint:Point,$limitGap:Number):Point {

			var $Gap:Number=Math.abs(pos($limitPoint,$point));
			var $Angle:Number=angle($limitPoint,$point);
			if ($Gap>$limitGap) {
				var $tmp1:Number=$limitGap*Math.sin(($Angle/180)*Math.PI);
				var $tmp2:Number=$limitGap*Math.cos(($Angle/180)*Math.PI);
				$point=new Point($limitPoint.x-$tmp2,$limitPoint.y-$tmp1);
			}
			return $point;

		}
		private function GetBook_array($point:Point,$actionPoint1:Point,$actionPoint2:Point):Array {

			var array_return:Array=new Array();
			var $Gap1:Number=Math.abs(pos($actionPoint1,$point)*0.5);
			var $Angle1:Number=angle($actionPoint1,$point);
			var $tmp1_2:Number=$Gap1/Math.cos(($Angle1/180)*Math.PI);
			var $tmp_point1:Point=new Point($actionPoint1.x-$tmp1_2,$actionPoint1.y);

			var $Angle2:Number=angle($point,$tmp_point1)-angle($point,$actionPoint2);
			var $Gap2:Number=pos($point,$actionPoint2);
			var $tmp2_1:Number=$Gap2*Math.sin(($Angle2/180)*Math.PI);
			var $tmp2_2:Number=$Gap2*Math.cos(($Angle2/180)*Math.PI);
			var $tmp_point2:Point=new Point($actionPoint1.x+$tmp2_2,$actionPoint1.y+$tmp2_1);

			var $Angle3:Number=angle($tmp_point1,$point);
			var $tmp3_1:Number=book_width*Math.sin(($Angle3/180)*Math.PI);
			var $tmp3_2:Number=book_width*Math.cos(($Angle3/180)*Math.PI);

			var $tmp_point3:Point=new Point($tmp_point2.x+$tmp3_2,$tmp_point2.y+$tmp3_1);
			var $tmp_point4:Point=new Point($point.x+$tmp3_2,$point.y+$tmp3_1);

			array_return.push($point);
			array_return.push($tmp_point2);
			array_return.push($tmp_point3);
			array_return.push($tmp_point4);

			return array_return;

		}
		private function GeLayer_array($point1:Point,$point2:Point,$actionPoint1:Point,$actionPoint2:Point,$limitPoint1:Point,$limitPoint2:Point):void {

			var array_layer1:Array=new Array();
			var array_layer2:Array=new Array();
			var $Gap1:Number=Math.abs(pos($actionPoint1,$point1)*0.5);
			var $Angle1:Number=angle($actionPoint1,$point1);

			var $tmp1_1:Number=$Gap1/Math.sin(($Angle1/180)*Math.PI);
			var $tmp1_2:Number=$Gap1/Math.cos(($Angle1/180)*Math.PI);

			var $tmp_point1:Point=new Point($actionPoint1.x-$tmp1_2,$actionPoint1.y);
			var $tmp_point2:Point=new Point($actionPoint1.x,$actionPoint1.y-$tmp1_1);

			var $tmp_point3:Object=$point2;

			var $Gap2:Number=Math.abs(pos($point1,$actionPoint2));
			//---------------------------------------------
			if ($Gap2>book_height) {
				array_layer1.push($tmp_point3);
				//
				var $pos:Number=Math.abs(pos($tmp_point3,$actionPoint2)*0.5);
				var $tmp3:Number=$pos/Math.cos(($Angle1/180)*Math.PI);
				$tmp_point2=new Point($actionPoint2.x-$tmp3,$actionPoint2.y);

			} else {
				array_layer2.push($actionPoint2);
			}
			array_layer1.push($tmp_point2);
			array_layer1.push($tmp_point1);
			array_layer1.push($point1);
			bookArray_layer1=array_layer1;

			array_layer2.push($limitPoint2);
			array_layer2.push($limitPoint1);
			array_layer2.push($tmp_point1);
			array_layer2.push($tmp_point2);
			bookArray_layer2=array_layer2;

		}

		private function DrawShape(shape:Shape,point_array:Array,myBmp:BitmapData,matr:Matrix):void {

			var num:*=point_array.length;
			shape.graphics.clear();
			shape.graphics.beginBitmapFill(myBmp,matr,false,true);

			shape.graphics.moveTo(point_array[0].x,point_array[0].y);
			for (var i:int=1; i<num; i++) {
				shape.graphics.lineTo(point_array[i].x,point_array[i].y);
			}

			shape.graphics.endFill();

		}
		
		private function DrawShadowShap(shape:Shape,maskShape:Shape,g_width:Number,g_height:Number,$point1:Point,$point2:Point,$maskArray:Array,$arg:Number):void {

			var fillType:String = GradientType.LINEAR;
			var colors:Array = [0x0, 0x0];
			var alphas1:Array = [0,0.5];
			var alphas2:Array = [0.5,0];
			var ratios:Array = [0, 255];
			var matr:Matrix = new Matrix();
			var spreadMethod:String = SpreadMethod.PAD;
			var myscale:Number;
			var myalpha:Number;

			shape.graphics.clear();
			matr.createGradientBox(g_width, g_height, (0/180)*Math.PI,-g_width*0.5, -g_height*0.5);

			shape.graphics.beginGradientFill(fillType, colors, alphas1, ratios, matr, spreadMethod);
			shape.graphics.drawRect(-g_width*0.5,-g_height*0.5,g_width*0.5,g_height);
			shape.graphics.beginGradientFill(fillType, colors, alphas2, ratios, matr, spreadMethod);
			shape.graphics.drawRect(0,-g_height*0.5,g_width*0.5,g_height);

			shape.x=$point2.x+($point1.x-$point2.x)*$arg;
			shape.y=$point2.y+($point1.y-$point2.y)*$arg;
			shape.rotation=angle($point1,$point2);
			myscale=Math.abs($point1.x-$point2.x)*0.5/book_width;
			myalpha=1-myscale*myscale;

			shape.scaleX=myscale+0.1;
			shape.alpha=myalpha+0.1;

			var tmp_Bmp:BitmapData=new BitmapData(book_width*2, book_height,true, 0x0);
			DrawShape(maskShape,$maskArray,tmp_Bmp,new Matrix());
			shape.mask=maskShape;

		}
		//End DrawPage------------------------------------------------------------------------
		
		//**Setting Parts------------------------------------------------------------------------
		private function SeFilter(obj:Object):void {
			var filter:DropShadowFilter=new DropShadowFilter();
			filter.blurX=filter.blurY=10;
			filter.alpha=0.5;
			filter.distance=0;
			filter.angle=0;
			obj.filters=[filter];
		}
		private function SetLoadMC():void {
			var pageRequest:URLRequest;
			var u1:String;
			var u2:String;
			var u3:String;

			for (var i:Number = 1; i<=book_totalpage; i++) {
				pageRequest=new URLRequest(myXML.child("page")[i-1].attribute("src"));
				book_root["pload_" + i]=new MovieClip();
				book_root["pload_" + i].id=i;
				book_root["pload_" + i].loadedflag=false;
				book_root["pload_" + i].loadedtype="";
				book_root["pload_" + i].brotherMC=null;
				book_root["pload_" + i].isWidthPage=false;

				if (i>1) {
					u1=myXML.child("page")[i-2].attribute("src");
					u2=myXML.child("page")[i-1].attribute("src");
					if (u1==u2) {
						book_root["pload_" + i].brotherMC=book_root["pload_" + (i-1)];
						book_root["pload_" + i].isWidthPage=true;
					}
				}
				book_root["pload_" + i]["loader"]=new Loader();
				book_root["pload_" + i]["loader"].contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadProgress);
				book_root["pload_" + i]["loader"].contentLoaderInfo.addEventListener(Event.COMPLETE, LoadEnd);
				book_root["pload_" + i]["loader"].load(pageRequest);

				book_root["pload_" + i].addChild(book_root["pload_" + i]["loader"]);
				onLoadinit!=null?onLoadinit(book_root["pload_" + i]):null;
			}
		}
		private function SetPageMC(pageNum:Number):void {
			var p_mc1:MovieClip=new MovieClip();
			var p_mc2:MovieClip=new MovieClip();
			var MC_content1:MovieClip;
			var MC_content2:MovieClip;

			if (pageNum>0&&pageNum<=book_totalpage) {
				p_mc1=book_root["pload_"+pageNum];
			}
			if ((pageNum+1)>0&&(pageNum+1)<=book_totalpage) {
				p_mc2=book_root["pload_"+(pageNum+1)];
			}

			if (p_mc2.isWidthPage) {
				pageMC.addChild(p_mc1);
				p_mc1.x=p_mc1.y=0;
				if (p_mc1.loadedflag==true&&p_mc1.loadedtype=="application/x-shockwave-flash") {
					MC_content1=p_mc1["loader"].content;
					MC_content1.gotoAndPlay(2);
				}
			} else {
				pageMC.addChild(p_mc1);
				pageMC.addChild(p_mc2);
				p_mc1.x=p_mc1.y=0;
				p_mc2.x=book_width;
				p_mc2.y=0;
				if (p_mc1.loadedflag==true&&p_mc1.loadedtype=="application/x-shockwave-flash") {
					MC_content1=p_mc1["loader"].content;
					MC_content1.gotoAndPlay(2);
				}
				if (p_mc2.loadedflag==true&&p_mc2.loadedtype=="application/x-shockwave-flash") {
					MC_content2=p_mc2["loader"].content;
					MC_content2.gotoAndPlay(2);
				}
			}

		}
		//End Setting------------------------------------------------------------------------

		//**Loder Parts------------------------------------------------------------------------
		private function LoadFindLoader(LoaderObj:Object):Number {
			var i:Number;
			var tmpageMC:MovieClip;

			for (i = 1; i<=book_totalpage; i++) {
				tmpageMC=book_root["pload_" + i];
				if (tmpageMC["loader"].contentLoaderInfo==LoaderObj) {
					return i;
				}
			}
			return 0;
		}
		private function loadProgress(evtObj:ProgressEvent):void {
			var obj:Object=evtObj.currentTarget;
			var n:Number=(LoadFindLoader(obj));
			var percentLoaded:Number = evtObj.bytesLoaded/evtObj.bytesTotal;

			percentLoaded = Math.round(percentLoaded * 100);
			if (onLoading!=null) {
				onLoading(book_root["pload_" + n],percentLoaded);
			}
		}
		private function LoadEnd(evtObj:Event):void {
			var obj:Object=evtObj.target.loader.parent;
			var n:Number=obj.id;
			var tmpPageMC:MovieClip;

			obj.loadedtype=evtObj.target.contentType;
			obj.loadedflag=true;

			if (obj.loadedtype=="application/x-shockwave-flash") {
				tmpPageMC=obj["loader"].content;
				if (obj.parent==null) {
					tmpPageMC.gotoAndStop(1);
				} else {
					tmpPageMC.gotoAndPlay(2);
				}
			}
			evtObj.target.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loadProgress);
			evtObj.target.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, LoadEnd);
			if (onLoadEnd!=null) {
				onLoadEnd(obj);
			}
		}
		//Loder End---------------------------------------------------------------------------------

		//**MouseEvent Parts------------------------------------------------------------------------
		private function MouseOnDown(evt:Event):void {
			if (book_TimerFlag!="stop"||evt.target.hasEventListener(MouseEvent.CLICK)) {
				//不处于静止状态
				return;
			}
			//mouseOnDown时取area绝对值;
			book_TimerArg0=MouseFindArea(new Point(book_root.mouseX,book_root.mouseY));
			book_TimerArg0=book_TimerArg0<0?-book_TimerArg0:book_TimerArg0;
			if (book_TimerArg0==0) {
				//不在area区域
				return;
			} else if ((book_TimerArg0==1||book_TimerArg0==2)&&book_page<=1) {
				//向左翻到顶
				return;
			} else if ((book_TimerArg0==3||book_TimerArg0==4)&&book_page>=book_totalpage) {
				//向右翻到顶
				return;
			} else {
				book_TimerFlag="startplay";
				PageUp();
			}
		}
		private function MouseOnUp(evt:Event):void {
			if (book_TimerFlag=="startplay") {
				//处于mousedown状态时
				book_TimerArg1=MouseFindArea(new Point(book_root.mouseX,book_root.mouseY));
				book_TimerFlag="autoplay";
			}
		}
		private function MouseFindArea(point:Point):Number {
			/* 取下面的四个区域,返回数值:
			*   --------------------
			*  | -1|     |     | -3 |
			*  |---      |      ----|
			*  |     1   |   3      |
			*  |---------|----------| 
			*  |     2   |   4      |
			*  |----     |      ----|
			*  | -2 |    |     | -4 |
			*   --------------------
			*/
			var tmpn:Number;
			var minx:Number=0;
			var maxx:Number=book_width+book_width;
			var miny:Number=0;
			var maxy:Number=book_height;
			var areaNum:Number=50;

			if (point.x>minx&&point.x<=maxx*0.5) {
				tmpn=(point.y>miny&&point.y<=(maxy*0.5))?1:(point.y>(maxy*0.5)&&point.y<maxy)?2:0;
				if (point.x<=(minx+areaNum)) {
					tmpn=(point.y>miny&&point.y<=(miny+areaNum))?-1:(point.y>(maxy-areaNum)&&point.y<maxy)?-2:tmpn;
				}
				return tmpn;
			} else if (point.x>(maxx*0.5)&&point.x<maxx) {
				tmpn=(point.y>miny&&point.y<=(maxy*0.5))?3:(point.y>(maxy*0.5)&&point.y<maxy)?4:0;
				if (point.x>=(maxx-areaNum)) {
					tmpn=(point.y>miny&&point.y<=(miny+areaNum))?-3:(point.y>(maxy-areaNum)&&point.y<maxy)?-4:tmpn;
				}
				return tmpn;
			}
			return 0;
		}
		//End MouseEvent------------------------------------------------------------------------

		//**Page Parts------------------------------------------------------------------------
		public function PageGoto(topage:Number):void {
			var n:Number;
			topage=topage%2==1?topage-1:topage;
			n=topage-book_page;
			if (book_TimerFlag=="stop"&&topage>=0&&topage<=book_totalpage&&n!=0) {
				book_TimerArg0=n<0?1:3;
				book_TimerArg1=-1;
				book_topage=topage>book_totalpage?book_totalpage:topage;
				book_TimerFlag="autoplay";
				PageUp();
			}
		}
		public function PageDraw(pageNum:Number):BitmapData {
			var myBmp:BitmapData=new BitmapData(book_width, book_height,true, 0x000000);
			if (pageNum>0&&pageNum<=book_totalpage) {
				if (book_root["pload_"+pageNum].isWidthPage) {
					myBmp.draw(book_root["pload_"+pageNum].brotherMC, new Matrix(1,0,0,1,-book_width,0));
				} else {
					myBmp.draw(book_root["pload_"+pageNum]);
				}
			}
			return myBmp;
			//
		}
		private function PageUp():void {
			var page1:Number;
			var page2:Number;
			var page3:Number;
			var page4:Number;
			var point_mypos:Point=book_myposArray[book_TimerArg0-1];
			var b0:Bitmap;
			var b1:Bitmap;

			if (book_TimerArg0==1||book_TimerArg0==2) {
				
				book_topage=book_topage==book_page?book_page-2:book_topage;
				page1=book_page;
				page2=book_topage+1;
				page3=book_topage;
				page4=book_page+1;

			} else if (book_TimerArg0==3||book_TimerArg0==4) {
				
				book_topage=book_topage==book_page?book_page+2:book_topage;
				page1=book_page+1;
				page2=book_topage;
				page3=book_page;
				page4=book_topage+1;

			}
			
			book_px=point_mypos.x;
			book_py=point_mypos.y;

			Bmp0=PageDraw(page1);
			Bmp1=PageDraw(page2);
			bgBmp0=PageDraw(page3);
			bgBmp1=PageDraw(page4);

			b0 = new Bitmap(bgBmp0);
			b1 = new Bitmap(bgBmp1);
			b1.x=book_width;
			bgMC.addChild(b0);
			bgMC.addChild(b1);
			bgMC.visible=false;
			book_timer.start();

		}
		//End Page------------------------------------------------------------------------

		//**Timer Parts------------------------------------------------------------------------
		private function bookTimerHandler(event:TimerEvent):void {

			var point_topos:Point=book_toposArray[book_TimerArg0-1];
			var point_mypos:Point=book_myposArray[book_TimerArg0-1];

			var PageObj:Object;
			var array_point1:Array;
			var array_point2:Array;
			var numpoint1:Number;
			var numpoint2:Number;

			var tmpMC0:MovieClip;
			var tmpageMC0:MovieClip;

			var tox:Number;
			var toy:Number;
			var toflag:Number;
			var tmpx:Number;
			var tmpy:Number;

			var arg:Number;
			var r:Number;
			var a:Number;

			bgMC.visible=true;
			
			while (pageMC.numChildren>0) {
				pageMC.removeChildAt(0);
				if (book_page>0&&book_page<=book_totalpage) {
					tmpMC0=book_root["pload_"+book_page];
					if (tmpMC0.loadedflag==true&&tmpMC0.loadedtype=="application/x-shockwave-flash") {
						tmpageMC0=tmpMC0["loader"].content;
						tmpageMC0.gotoAndStop(1);
					}
				}
				if ((book_page+1)>0&&(book_page+1)<=book_totalpage) {
					tmpMC0=book_root["pload_"+(book_page+1)];
					if (tmpMC0.loadedflag==true&&tmpMC0.loadedtype=="application/x-shockwave-flash") {
						tmpageMC0=tmpMC0["loader"].content;
						tmpageMC0.gotoAndStop(1);
					}
				}
			}
			if (book_TimerFlag=="startplay") {
				u=0.4;
				render0.graphics.clear();
				render1.graphics.clear();
				book_px=((render0.mouseX-book_px)*u+book_px)>>0;
				book_py=((render0.mouseY-book_py)*u+book_py)>>0;

				DrawPage(book_TimerArg0,new Point(book_px,book_py),Bmp1,Bmp0);

				//book_timer.stop();

			} else if (book_TimerFlag=="autoplay") {
				render0.graphics.clear();
				render1.graphics.clear();
				if (Math.abs(point_topos.x-book_px)>book_width&&book_TimerArg1>0) {
					//不处于点翻区域并且翻页不过中线时
					tox=point_mypos.x;
					toy=point_mypos.y;
					toflag=0;
				} else {
					tox=point_topos.x;
					toy=point_topos.y;
					toflag=1;
				}
				tmpx=(tox-book_px)>>0;
				tmpy=(toy-book_py)>>0;

				if (book_TimerArg1<0) {
					//处于点翻区域时
					u=0.3;//降低加速度
					book_py=Arc(book_width,tmpx,point_topos.y);
				} else {
					u=0.4;//原始加速度
					book_py=tmpy*u+book_py;
				}
				book_px=tmpx*u+book_px;

				DrawPage(book_TimerArg0,new Point(book_px,book_py),Bmp1,Bmp0);

				if (tmpx==0&&tmpy==0) {
					
					render0.graphics.clear();
					render1.graphics.clear();
					shadow0.graphics.clear();
					shadow1.graphics.clear();
					
					Bmp0.dispose();
					Bmp1.dispose();
					bgBmp0.dispose();
					bgBmp1.dispose();
					
					while (bgMC.numChildren>0) {
						bgMC.removeChildAt(0);
					}
					book_topage=toflag==0?book_page:book_topage;
					book_page=book_topage;

					SetPageMC(book_page);

					book_TimerFlag="stop";//恢得静止状态
					if (onPageEnd!=null) {
						onPageEnd();
					}
					
					bgMC.visible=false;
					book_timer.reset();

				}
			}
		}
		//End Timer ------------------------------------------------------------------------

		//**Tools Parts------------------------------------------------------------------------
		private function Arc(arg_R:Number,arg_N1:Number,arg_N2:Number):Number {
			//------圆弧算法-----------------------
			var arg:Number=arg_R*2;
			var r:Number=arg_R*arg_R+arg*arg;
			var a:Number=Math.abs(arg_N1)-arg_R;
			var R_arg:Number=arg_N2 - (Math.sqrt(r-a*a)-arg);
			return R_arg;
		}
		private function angle(target1:Object,target2:Object):Number {
			var tmp_x:Number=target1.x-target2.x;
			var tmp_y:Number=target1.y-target2.y;
			var tmp_angle:Number= Math.atan2(tmp_y, tmp_x)*180/Math.PI;
			tmp_angle = tmp_angle<0 ? tmp_angle+360 : tmp_angle;
			return tmp_angle;
		}
		private function pos(target1:Object,target2:Object):Number {

			var tmp_x:Number=target1.x-target2.x;
			var tmp_y:Number=target1.y-target2.y;
			var tmp_s:Number=Math.sqrt(tmp_x*tmp_x+tmp_y*tmp_y);
			return target1.x > target2.x?tmp_s:- tmp_s;

		}
		//End Tools------------------------------------------------------------------------
	}
}