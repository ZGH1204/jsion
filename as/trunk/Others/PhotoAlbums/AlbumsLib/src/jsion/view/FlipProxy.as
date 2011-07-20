package jsion.view
{
	import com.StageReference;
	import com.interfaces.IDispose;
	import com.utils.DisposeHelper;
	import com.utils.MatrixHelper;
	
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jsion.AlbumsMgr;
	import jsion.data.Albums;
	import jsion.data.BackcPage;
	import jsion.data.CoverPage;
	import jsion.data.PhotoPage;
	

	public class FlipProxy implements IDispose
	{
		public static const ratios:Array = [0, 255];
		public static const colors:Array = [0x0, 0x0];
		public static const alphas1:Array = [0,1];
		public static const alphas2:Array = [1,0];
		
		public static const STOP:String = "stop";
		public static const START_PLAY:String = "startPlay";
		public static const AUTO_PLAY:String = "autoPlay";
		
		public var curAlbums:Albums;
		
		public var helperContainer:Sprite;
		public var shadowContainer:Sprite;
		
		public var leftPage:PhotoPage;
		public var rightPage:PhotoPage;
		public var flipView:AlbumsPhotoPage;
		public var flipSecondView:AlbumsPhotoPage;
		
		public var mouseUpCallback:Function;
		public var mouseDownCallback:Function;
		public var flipComplete:Function;
		
		public var shape:Shape;
		
		private var bmd:BitmapData;
		private var shadow0:Shape=new Shape();
		
		private var book_TimerFlag:String = STOP;
		private var book_TimerArg0:Number=0;
		private var book_TimerArg1:Number=0;
		
		private var book_CrossGap:Number;
		private var bookArray_layer1:Array;
		
		private var p1:Point;
		private var p2:Point;
		private var p3:Point;
		private var p4:Point;
		
		private var _leftPage:PhotoPage;
		private var _rightPage:PhotoPage;
		
		private var limit_point1:Point;
		private var limit_point2:Point;
		
		private var rotatePoint:Point = new Point();;
		private var matrix:Matrix;
		private var mask:Shape;
		
		
		private var matr:Matrix = new Matrix();
		
		
		public function start():void
		{
			mask = new Shape();
			matrix = new Matrix();
			rotatePoint = new Point();
			book_CrossGap = Math.sqrt(curAlbums.pageWidth*curAlbums.pageWidth+curAlbums.pageHeight*curAlbums.pageHeight);
			
			p1 = new Point(curAlbums.leftPageX, curAlbums.leftPageY);
			p2 = new Point(curAlbums.leftPageX, curAlbums.leftPageY + curAlbums.pageHeight);
			p3 = new Point(curAlbums.leftPageX + curAlbums.pageWidth + curAlbums.pageWidth, curAlbums.leftPageY);
			p4 = new Point(curAlbums.leftPageX + curAlbums.pageWidth + curAlbums.pageWidth, curAlbums.leftPageY + curAlbums.pageHeight);
			
			limit_point1 = new Point(curAlbums.leftPageX + curAlbums.pageWidth, curAlbums.leftPageY);
			limit_point2 = new Point(curAlbums.leftPageX + curAlbums.pageWidth, curAlbums.leftPageY + curAlbums.pageHeight);
			
			shadowContainer.addChild(shadow0);
			shadowContainer.x = curAlbums.leftPageX;
			shadowContainer.y = curAlbums.leftPageY;
			shadowContainer.scrollRect = new Rectangle(0, 0, curAlbums.pageWidth * 2, curAlbums.pageHeight);
			
			StageReference.stage.addEventListener(MouseEvent.MOUSE_DOWN, __stageMouseDownHandler);
			StageReference.stage.addEventListener(MouseEvent.MOUSE_UP, __stageMouseUpHandler);
			StageReference.stage.addEventListener(Event.ENTER_FRAME, __enterFrameHandler);
		}
		
		public function gotoCoverPage():void
		{
			if (book_TimerFlag != STOP || leftPage == curAlbums.cover) return;
			
			pageUpByGoto(-1);
		}
		
		public function gotoBackcPage():void
		{
			if (book_TimerFlag != STOP || rightPage == curAlbums.backc) return;
			
			pageUpByGoto(5);
		}
		
		public function gotoNextPage():void
		{
			if (book_TimerFlag != STOP || rightPage == curAlbums.backc) return;
			
			PageUp(4, true);
		}
		
		public function gotoPrePage():void
		{
			if (book_TimerFlag != STOP || leftPage == curAlbums.cover) return;
			
			PageUp(2, true);
		}
		
		public function gotoPage(no:int):void
		{
			if(curAlbums == null || curAlbums.photoPageList.length == 0) return;
			
			pageUpByGoto(6, no);
		}
		
		private function __stageMouseDownHandler(e:MouseEvent):void
		{
			//不处于静止状态
			if (book_TimerFlag != STOP || AlbumsMgr.Instance.canFlip == false) return;
			
			if(mouseDownCallback != null) mouseDownCallback();
			
			//mouseOnDown时取area绝对值;
			book_TimerArg0 = MouseFindArea(new Point(helperContainer.mouseX,helperContainer.mouseY));
			
//			if(book_TimerArg0 == -1 || book_TimerArg0 == -2)
//			{
////				gotoPrePage();
//				gotoCoverPage();
//				return;
//			}
//			else if(book_TimerArg0 == -3 || book_TimerArg0 == -4)
//			{
////				gotoNextPage();
//				gotoBackcPage();
//				return;
//			}
			
			book_TimerArg0 = Math.abs(book_TimerArg0);
			
			if (book_TimerArg0==0) {
				//不在area区域
				return;
			} else if ((book_TimerArg0==1||book_TimerArg0==2) && leftPage is CoverPage) {
				//向左翻到顶
				return;
			} else if ((book_TimerArg0==3||book_TimerArg0==4) && rightPage is BackcPage) {
				//向右翻到顶
				return;
			} else {
				PageUp(book_TimerArg0);
			}
		}
		
		private function PageUp(startArea:int, isGoto:Boolean = false):void
		{
			if (startArea == 1 || startArea == 2)
			{
				book_TimerArg0 = startArea;
				DisposeHelper.dispose(flipView);
				flipView = createPrePage(leftPage);
				DisposeHelper.dispose(flipSecondView);
				flipSecondView = createPrePrePage(leftPage);
				if(flipView) book_TimerFlag = START_PLAY;
			}
			else if (startArea == 3 || startArea == 4)
			{
				book_TimerArg0 = startArea;
				DisposeHelper.dispose(flipView);
				flipView = createNextPage(rightPage);
				DisposeHelper.dispose(flipSecondView);
				flipSecondView = createNextNextPage(rightPage);
				if(flipView) book_TimerFlag = START_PLAY;
			}
			
			if(book_TimerFlag == START_PLAY)
			{
				isComplete  = isFliped = false;
				addFlipViewToStage();
				setFlipStartBookPos(startArea);
				if(isGoto)
				{
					book_TimerArg1 = -1;
					book_TimerFlag = AUTO_PLAY;
				}
			}
		}
		
		private function setFlipStartBookPos(startArea:int):void
		{
			if(startArea == 1)
			{
				book_px = p1.x;
				book_py = p1.y;
			}
			else if(startArea == 2)
			{
				book_px = p2.x;
				book_py = p2.y;
			}
			else if(startArea == 3)
			{
				book_px = p3.x;
				book_py = p3.y;
			}
			else if(startArea == 4)
			{
				book_px = p4.x;
				book_py = p4.y;
			}
		}
		
		private function pageUpByGoto(startArea:int, no:int = 0):void
		{
			if(startArea == -1)//跳转到封面
			{
				book_TimerArg0 = 2;
				DisposeHelper.dispose(flipView);
				flipView = createPrePage(getNextPageData(getNextPageData(curAlbums.cover)));
				DisposeHelper.dispose(flipSecondView);
				flipSecondView = createCoverPage(leftPage);
				if(flipView) book_TimerFlag = START_PLAY;
			}
			else if(startArea == 5)//跳转到封底
			{
				book_TimerArg0 = 4;
				DisposeHelper.dispose(flipView);
				flipView = createNextPage(getPrePageData(getPrePageData(curAlbums.backc)));
				DisposeHelper.dispose(flipSecondView);
				flipSecondView = createBackcPage(rightPage);
				if(flipView) book_TimerFlag = START_PLAY;
			}
			else if(startArea == 6)//跳转到指定页, no-1为索引
			{
				if(no == -1 || no == 0) gotoCoverPage();
				else if(no == (curAlbums.photoPageList.length + 1)) gotoBackcPage();
				if(no < 1 || no > curAlbums.photoPageList.length || book_TimerFlag != STOP) return;
				
				var index:int = no - 1;
				index = ((index % 2) == 0 ? (index - 1) : index);
				if(index == (curAlbums.photoPageList.length - 1))
				{
					gotoBackcPage();
					return;
				}
				else if(index < 0)
				{
					gotoCoverPage();
					return;
				}
				var lIndex:int = curAlbums.photoPageList.indexOf(leftPage);
				
				if(lIndex == index) return;
				else if(lIndex > index) book_TimerArg0 = 2;
				else book_TimerArg0 = 4;
				
				if(book_TimerArg0 == 2)
				{
					DisposeHelper.dispose(flipView);
					flipView = createPage(curAlbums.photoPageList[index + 1], false);
					DisposeHelper.dispose(flipSecondView);
					flipSecondView = createPage(curAlbums.photoPageList[index], true);
				}
				else
				{
					DisposeHelper.dispose(flipView);
					flipView = createPage(curAlbums.photoPageList[index], true);
					DisposeHelper.dispose(flipSecondView);
					flipSecondView = createPage(curAlbums.photoPageList[index + 1], false);
				}
				
				if(flipView) book_TimerFlag = START_PLAY;
			}
			
			if(book_TimerFlag != START_PLAY)
			{
				DisposeHelper.dispose(flipView);
				flipView = null;
				DisposeHelper.dispose(flipSecondView);
				flipSecondView = null;
			}
			else
			{
				isComplete = isFliped = false;
				book_TimerArg1 = -1;
				addFlipViewToStage();
				setFlipStartBookPos(book_TimerArg0);
				book_TimerFlag = AUTO_PLAY;
			}
		}
		
		private function addFlipViewToStage():void
		{
			if(flipView)
			{
				DisposeHelper.dispose(bmd);
				bmd = new BitmapData(flipView.width, flipView.height);
				bmd.lock();
				bmd.fillRect(bmd.rect, 0x0);
				bmd.draw(flipView);
				bmd.unlock();
			}
			
			if(flipSecondView)
			{
				flipSecondView.addChild(mask);
				flipSecondView.mask = mask;
				helperContainer.addChild(flipSecondView);
			}
		}
		
		private function __stageMouseUpHandler(e:MouseEvent):void
		{
			if(mouseUpCallback != null) mouseUpCallback();
			if(book_TimerFlag == START_PLAY)
			{
				book_TimerArg1 = MouseFindArea(new Point(helperContainer.mouseX,helperContainer.mouseY));
				book_TimerFlag = AUTO_PLAY;
			}
		}
		
		private var book_px:Number=0;
		private var book_py:Number=0;
		private var u:Number = 0.4;
		private var isComplete:Boolean;
		private var isFliped:Boolean;
		private var isFlipLeft:Boolean;
		
		private function __enterFrameHandler(e:Event):void
		{
			if(book_TimerFlag == START_PLAY || book_TimerFlag == AUTO_PLAY)
			{
				var _movePoint:Point;
				
				if (book_TimerFlag == START_PLAY)
				{
					_movePoint = getStartPlayMovePoint();
				}
				else if(book_TimerFlag == AUTO_PLAY)
				{
					_movePoint = getAutoPlayMovePoint();
				}
				
				drawPage(_movePoint);
				
				if(isComplete) complete();
			}
		}
		
		private function getStartPlayMovePoint():Point
		{
			book_px = (helperContainer.mouseX - book_px) * u + book_px;
			book_py = (helperContainer.mouseY - book_py) * u + book_py;
			return new Point(book_px, book_py);
		}
		
		private function createStepPoint(curArea1:int, curArea2:int, curArea3:int, startPoint:Point, targetPoint:Point):Point
		{
			if(book_TimerArg1 == curArea1 || book_TimerArg1 == curArea2 || book_TimerArg1 == curArea3 || book_TimerArg1 == -1)
			{
				book_px = (targetPoint.x - book_px) * u + book_px;
				
				if(book_TimerArg1 == -1)
				{
					book_py = targetPoint.y - 1;
					if(Math.abs(targetPoint.x - book_px) < 1)
						book_py = (targetPoint.y - book_py) * u + book_py;
				}
				else
				{
					book_py = (targetPoint.y - book_py) * u + book_py;
				}
				
				if(Math.abs(targetPoint.x - book_px) < 1 && Math.abs(targetPoint.y - book_py) < 1)
				{
					book_px = targetPoint.x;
					book_py = targetPoint.y;
					isComplete = true;
					isFliped = true;
				}
			}
			else
			{
				book_px = (startPoint.x - book_px) * u + book_px;
				book_py = (startPoint.y - book_py) * u + book_py;
				
				if(Math.abs(startPoint.x - book_px) < 1 && Math.abs(startPoint.y - book_py) < 1)
				{
					book_px = startPoint.x;
					book_py = startPoint.y;
					isComplete = true;
				}
			}
			
			return new Point(book_px, book_py);
		}
		
		private function setFlipedLeftPage():void
		{
			if(isFliped)
			{
				rightPage = _rightPage;//getPrePageData(leftPage);
				leftPage = _leftPage;//getPrePageData(rightPage);
			}
		}
		
		private function setFlipedRightPage():void
		{
			if(isFliped)
			{
				leftPage = _leftPage;//getNextPageData(rightPage);
				rightPage = _rightPage;//getNextPageData(leftPage);
			}
		}
		
		private function getAutoPlayMovePoint():Point
		{
			var rlt:Point;
			if(book_TimerArg0 == 1)
			{
				rlt = createStepPoint(0,3,4, p1, p3);
				setFlipedLeftPage();
				return rlt;
			}
			else if(book_TimerArg0 == 2)
			{
				rlt = createStepPoint(0, 3, 4, p2, p4);
				setFlipedLeftPage();
				return rlt;
			}
			else if(book_TimerArg0 == 3)
			{
				rlt = createStepPoint(0, 1, 2, p3, p1);
				setFlipedRightPage();
				return rlt;
			}
			else if(book_TimerArg0 == 4)
			{
				rlt = createStepPoint(0, 1, 2, p4, p2);
				setFlipedRightPage();
				return rlt;
			}
			return new Point(book_px, book_py);
		}
		
		private function drawPage(movePoint:Point):void
		{
			var _actionPoint:Point;
			var book_array:Array;
			var mask_array:Array = [];
			var Matrix_angle:Number;
			
			if(book_TimerArg0 == 1)
			{
				movePoint = CheckLimit(movePoint,limit_point1,curAlbums.pageWidth);
				movePoint = CheckLimit(movePoint,limit_point2,book_CrossGap);
				
				book_array = GetBook_array(movePoint,p1,p2);
				_actionPoint = book_array[1];
				GeLayer_array(movePoint,_actionPoint,p1,p2,limit_point1,limit_point2);
				
				rotatePoint.x = curAlbums.pageWidth;
				rotatePoint.y = 0;
				
				Matrix_angle = angle(movePoint,_actionPoint) + 90;
				MatrixHelper.rotateWithPoint(matrix, rotatePoint, Matrix_angle);
				matrix.translate(movePoint.x - curAlbums.pageWidth, movePoint.y);
				
				isFlipLeft = true;
			}
			else if(book_TimerArg0 == 2)
			{
				movePoint=CheckLimit(movePoint,limit_point2,curAlbums.pageWidth);
				movePoint=CheckLimit(movePoint,limit_point1,book_CrossGap);
				
				book_array=GetBook_array(movePoint,p2,p1);
				_actionPoint=book_array[1];
				GeLayer_array(movePoint,_actionPoint,p2,p1,limit_point2,limit_point1);
				
				rotatePoint.x = 0;
				rotatePoint.y = curAlbums.pageHeight;
				
				Matrix_angle = angle(movePoint,_actionPoint) - 90;
				MatrixHelper.rotateWithPoint(matrix, rotatePoint, Matrix_angle);
				matrix.translate(book_array[3].x, book_array[3].y - curAlbums.pageHeight);
				
				isFlipLeft = true;
			}
			else if(book_TimerArg0 == 3)
			{
				movePoint=CheckLimit(movePoint,limit_point1,curAlbums.pageWidth);
				movePoint=CheckLimit(movePoint,limit_point2,book_CrossGap);
				
				book_array=GetBook_array(movePoint,p3,p4);
				_actionPoint=book_array[1];
				GeLayer_array(movePoint,_actionPoint,p3,p4,limit_point1,limit_point2);
				
				rotatePoint.x = curAlbums.pageWidth;
				rotatePoint.y = 0;
				
				Matrix_angle = angle(movePoint,_actionPoint) + 90;
				MatrixHelper.rotateWithPoint(matrix, rotatePoint, Matrix_angle);
				matrix.translate(book_array[3].x - curAlbums.pageWidth, book_array[3].y);
				
				isFlipLeft = false;
			}
			else if(book_TimerArg0 == 4)
			{
				movePoint=CheckLimit(movePoint,limit_point2,curAlbums.pageWidth);
				movePoint=CheckLimit(movePoint,limit_point1,book_CrossGap);
				
				book_array=GetBook_array(movePoint,p4,p3);
				_actionPoint=book_array[1];
				GeLayer_array(movePoint,_actionPoint,p4,p3,limit_point2,limit_point1);
				
				rotatePoint.x = 0;
				rotatePoint.y = curAlbums.pageHeight;
				
				Matrix_angle = angle(movePoint,_actionPoint) - 90;
				MatrixHelper.rotateWithPoint(matrix, rotatePoint, Matrix_angle);
				matrix.translate(movePoint.x, movePoint.y - curAlbums.pageHeight);
				
				isFlipLeft = false;
			}
			
			for each(var p:Point in bookArray_layer1)
			{
				if(p.x == curAlbums.leftPageX || p.x == (limit_point2.x + curAlbums.pageWidth)) mask_array.push(p);
				else if(p.y == limit_point1.y || p.y == limit_point2.y) mask_array.push(p);
			}
			drawMask(mask, bookArray_layer1, isFlipLeft);
			drawShadowShape(shadow0, mask_array, curAlbums.pageWidth, curAlbums.pageHeight);
			
			DrawShape(shape, bookArray_layer1, bmd, matrix);
		}
		
		private function complete():void
		{
			book_TimerFlag = STOP;
			shape.graphics.clear();
			mask.graphics.clear();
			shadow0.graphics.clear();
			if(mask && mask.parent) mask.parent.removeChild(mask);
			if(flipSecondView) flipSecondView.mask = null;
			if(flipComplete != null && isFliped) flipComplete();
			
			DisposeHelper.dispose(flipView);
			flipView = null;
			DisposeHelper.dispose(flipSecondView);
			flipSecondView = null;
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
			var minx:Number=curAlbums.leftPageX;
			var maxx:Number=curAlbums.leftPageX + curAlbums.pageWidth + curAlbums.pageWidth;
			var miny:Number=curAlbums.leftPageY;
			var maxy:Number=curAlbums.leftPageY + curAlbums.pageHeight;
			var areaNum:Number=50;
			
			if (point.x > minx && point.x <= (curAlbums.leftPageX + curAlbums.pageWidth))//左边
			{
				tmpn = (point.y > miny && point.y <= (curAlbums.leftPageY + curAlbums.pageHeight * 0.5)) ? 1 : ((point.y > (curAlbums.leftPageY + curAlbums.pageHeight * 0.5) && point.y < maxy) ? 2 : 0);
				if (point.x <= (minx + areaNum))//区域内
				{
					tmpn = (point.y > miny && point.y <= (miny + areaNum)) ? -1 : (point.y > (maxy - areaNum - curAlbums.leftPageY) && point.y < maxy) ? -2 : tmpn;
				}
				return tmpn;
				
			}
			else if (point.x > (curAlbums.leftPageX + curAlbums.pageWidth) && point.x < maxx)//右边
			{
				tmpn = (point.y > miny && point.y <= (curAlbums.leftPageY + curAlbums.pageHeight * 0.5)) ? 3 : (point.y > (curAlbums.leftPageY + curAlbums.pageHeight * 0.5) && point.y < maxy) ? 4 : 0;
				if (point.x >= (maxx - areaNum - curAlbums.leftPageX))//区域内
				{
					tmpn = (point.y > miny && point.y <= (miny + areaNum)) ? -3 : (point.y > (maxy - areaNum) && point.y < maxy) ? -4 : tmpn;
				}
				return tmpn;
			}
			return 0;
		}
		
		private function drawMask(shap:Shape, point_array:Array, isLeft:Boolean):void
		{
			var mask_array:Array = createMaskShadowArray(point_array);
			mask_array.sortOn("y", Array.NUMERIC);
			
			var list:Array = [];
			var minPoint:Point = mask_array[0];
			var maxPoint:Point = mask_array[1];
			
			if(isLeft == false)//在右边
			{
				if(minPoint.x < (limit_point1.x + curAlbums.pageWidth))
				{
					if(maxPoint.x == (limit_point1.x + curAlbums.pageWidth))
					{
						list.push(minPoint, p3, maxPoint);
					}
					else
					{
						list.push(minPoint, p3, p4, maxPoint);
					}
				}
				else
				{
					list.push(minPoint, p4, maxPoint);
				}
			}
			else
			{
				if(minPoint.x > curAlbums.leftPageX)
				{
					if(maxPoint.x == (curAlbums.leftPageX))
					{
						list.push(minPoint, p1, maxPoint);
					}
					else
					{
						list.push(minPoint, p1, p2, maxPoint);
					}
				}
				else
				{
					list.push(minPoint, p2, maxPoint);
				}
			}
			
			mask.graphics.clear();
			mask.graphics.beginFill(0x0);
			var tp:Point = helperContainer.localToGlobal(list[0]);
			tp = mask.globalToLocal(tp);
			mask.graphics.moveTo(tp.x, tp.y);
			for (var i:int=1; i<list.length; i++) {
				tp = helperContainer.localToGlobal(list[i]);
				tp = mask.globalToLocal(tp);
				mask.graphics.lineTo(tp.x, tp.y);
			}
			
			mask.graphics.endFill();
		}
		
		private function drawShadowShape(shadow:Shape, pointList:Array, g_width:Number, g_height:Number):void
		{
			g_width *= 0.3;
			g_height *= 3;
			var shadow_array:Array = createMaskShadowArray(pointList);
			var cp:Point = Point.interpolate(shadow_array[0], shadow_array[1], 0.5);
			shadow.x = cp.x - curAlbums.leftPageX;
			shadow.y = cp.y - curAlbums.leftPageY;
			shadow.rotation = angle(shadow_array[0], shadow_array[1]) - 90;
			
			MatrixHelper.resetMatrix(matr);
			matr.createGradientBox(g_width, g_height, (0/180)*Math.PI,-g_width*0.5, -g_height*0.5);
			
			shadow.graphics.clear();
			
			shadow.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas1, ratios, matr, SpreadMethod.PAD);
			shadow.graphics.drawRect(-g_width*0.5,-g_height*0.5,g_width*0.5,g_height);
			shadow.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas2, ratios, matr, SpreadMethod.PAD);
			shadow.graphics.drawRect(0,-g_height*0.5,g_width*0.5,g_height);
			shadow.graphics.endFill();
		}
		
		private function createMaskShadowArray(pointList:Array):Array
		{
			var shadow_array:Array = [];
			for each(var p:Point in pointList)
			{
				if(p.x == curAlbums.leftPageX || p.x == (limit_point2.x + curAlbums.pageWidth)) shadow_array.push(p);
				else if(p.y == limit_point1.y || p.y == limit_point2.y) shadow_array.push(p);
			}
			return shadow_array;
		}
		
		private function DrawShape(shap:Shape,point_array:Array,myBmp:BitmapData,matr:Matrix):void
		{
			var num:*=point_array.length;
			shap.graphics.clear();
			if(myBmp)
				shap.graphics.beginBitmapFill(myBmp,matr,false,true);
			else
				shap.graphics.beginFill(0x0);
			
			shap.graphics.moveTo(point_array[0].x,point_array[0].y);
			for (var i:int=1; i<num; i++) {
				shap.graphics.lineTo(point_array[i].x,point_array[i].y);
			}
			
			shap.graphics.endFill();
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
			var $tmp3_1:Number=curAlbums.pageWidth*Math.sin(($Angle3/180)*Math.PI);
			var $tmp3_2:Number=curAlbums.pageWidth*Math.cos(($Angle3/180)*Math.PI);
			
			var $tmp_point3:Point=new Point($tmp_point2.x+$tmp3_2,$tmp_point2.y+$tmp3_1);
			var $tmp_point4:Point=new Point($point.x+$tmp3_2,$point.y+$tmp3_1);
			
			array_return.push($point);
			array_return.push($tmp_point2);
			array_return.push($tmp_point3);
			array_return.push($tmp_point4);
			
			return array_return;
			
		}
		
		private function GeLayer_array($point1:Point,$point2:Point,$actionPoint1:Point,$actionPoint2:Point,$limitPoint1:Point,$limitPoint2:Point):void {
			
			var array_layer1:Array = [];
			var $Gap1:Number=Math.abs(pos($actionPoint1,$point1)*0.5);
			var $Angle1:Number=angle($actionPoint1,$point1);
			
			var $tmp1_1:Number=$Gap1/Math.sin(($Angle1/180)*Math.PI);
			var $tmp1_2:Number=$Gap1/Math.cos(($Angle1/180)*Math.PI);
			
			var $tmp_point1:Point=new Point($actionPoint1.x-$tmp1_2,$actionPoint1.y);
			var $tmp_point2:Point=new Point($actionPoint1.x,$actionPoint1.y-$tmp1_1);
			
			var $tmp_point3:Point=$point2;
			
			var $Gap2:Number=Math.abs(pos($point1,$actionPoint2));
			//---------------------------------------------
			if ($Gap2>curAlbums.pageHeight) {
				array_layer1.push($tmp_point3);
				//
				var $pos:Number=Math.abs(pos($tmp_point3,$actionPoint2)*0.5);
				var $tmp3:Number=$pos/Math.cos(($Angle1/180)*Math.PI);
				$tmp_point2=new Point($actionPoint2.x-$tmp3,$actionPoint2.y);
				
			}
			array_layer1.push($tmp_point2);
			array_layer1.push($tmp_point1);
			array_layer1.push($point1);
			bookArray_layer1=array_layer1;
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
		
		private function Arc(arg_R:Number,arg_N1:Number,arg_N2:Number):Number {
			//------圆弧算法-----------------------
			var arg:Number=arg_R*2;
			var r:Number=arg_R*arg_R+arg*arg;
			var a:Number=Math.abs(arg_N1)-arg_R;
			var R_arg:Number=arg_N2 - (Math.sqrt(r-a*a)-arg);
			return R_arg;
		}
		
		private function angle(target1:Point,target2:Point):Number
		{
			var tmp_x:Number=target1.x-target2.x;
			var tmp_y:Number=target1.y-target2.y;
			var tmp_angle:Number= Math.atan2(tmp_y, tmp_x)*180/Math.PI;
			tmp_angle = tmp_angle<0 ? tmp_angle+360 : tmp_angle;
			return tmp_angle;
		}
		private function pos(target1:Point,target2:Point):Number {
			
			var tmp_x:Number=target1.x-target2.x;
			var tmp_y:Number=target1.y-target2.y;
			var tmp_s:Number=Math.sqrt(tmp_x*tmp_x+tmp_y*tmp_y);
			return target1.x > target2.x?tmp_s:- tmp_s;
			
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		private function createCoverPage(curPage:PhotoPage):AlbumsPhotoPage
		{
			if(curAlbums == null || curPage == curAlbums.cover || curPage == null) return null;
			var photoPage:PhotoPage = curAlbums.cover;
			if(photoPage == null) return null;
			return createCover();
		}
		
		private function createBackcPage(curPage:PhotoPage):AlbumsPhotoPage
		{
			if(curAlbums == null || curPage == curAlbums.backc || curPage == null) return null;
			var photoPage:PhotoPage = curAlbums.backc;
			if(photoPage == null) return null;
			return createBackc();
		}
		
		private function createPrePage(curPage:PhotoPage):AlbumsPhotoPage
		{
			if(curAlbums == null || curPage == curAlbums.cover || curPage == null) return null;
			var photoPage:PhotoPage = getPrePageData(curPage);
			if(photoPage == null) return null;
			return createPage(photoPage, false);
		}
		
		private function createPrePrePage(curPage:PhotoPage):AlbumsPhotoPage
		{
			if(curAlbums == null || curPage == curAlbums.cover || curPage == null) return null;
			var photoPage:PhotoPage = getPrePageData(curPage);
			photoPage = getPrePageData(photoPage);
			if(photoPage == null) return null;
			return createPage(photoPage, true);
		}
		
		private function createNextPage(curPage:PhotoPage):AlbumsPhotoPage
		{
			if(curAlbums == null || curPage == curAlbums.backc || curPage == null) return null;
			var photoPage:PhotoPage = getNextPageData(curPage);
			if(photoPage == null) return null;
			return createPage(photoPage, true);
		}
		
		private function createNextNextPage(curPage:PhotoPage):AlbumsPhotoPage
		{
			if(curAlbums == null || curPage == curAlbums.backc || curPage == null) return null;
			var photoPage:PhotoPage = getNextPageData(curPage);
			photoPage = getNextPageData(photoPage);
			if(photoPage == null) return null;
			return createPage(photoPage, false);
		}
		
		public function getPrePageData(curPage:PhotoPage):PhotoPage
		{
			if(curAlbums == null || curPage == null || curAlbums.photoPageList == null || curAlbums.photoPageList.length == 0) return null;
			var index:int = curAlbums.photoPageList.indexOf(curPage);
			if(index == -1)
			{
				if(curPage == curAlbums.cover)
					return null;
				else if(curPage == curAlbums.backc)
					return curAlbums.photoPageList[curAlbums.photoPageList.length - 1];
			}
			else if((index - 1) >= 0)
			{
				return curAlbums.photoPageList[index - 1];
			}
			else
			{
				return curAlbums.cover;
			}
			return null;
		}
		
		public function getNextPageData(curPage:PhotoPage):PhotoPage
		{
			if(curAlbums == null || curPage == null || curAlbums.photoPageList == null || curAlbums.photoPageList.length == 0) return null;
			var index:int = curAlbums.photoPageList.indexOf(curPage);
			if(index == -1)
			{
				if(curPage == curAlbums.backc)
					return null;
				else if(curPage == curAlbums.cover)
					return curAlbums.photoPageList[index + 1];
			}
			else if((index + 1) < curAlbums.photoPageList.length)
			{
				return curAlbums.photoPageList[index + 1];
			}
			else
			{
				return curAlbums.backc;
			}
			return null;
		}
		
		public function getShowInitFirst():PhotoPage
		{
//			if(curAlbums && curAlbums.photoPageList && curAlbums.photoPageList.length > 0) return curAlbums.photoPageList[0];
			leftPage = curAlbums.cover;
			return curAlbums.cover;
		}
		
		public function getShowInitSecond():PhotoPage
		{
//			if(curAlbums && curAlbums.photoPageList && curAlbums.photoPageList.length > 1) return curAlbums.photoPageList[1];
			if(curAlbums && curAlbums.photoPageList && curAlbums.photoPageList.length > 0)
			{
				rightPage = curAlbums.photoPageList[0];
				return curAlbums.photoPageList[0];
			}
			return null;
		}
		
		public function createPage(photoPage:PhotoPage, isLeft:Boolean):AlbumsPhotoPage
		{
			if(photoPage == curAlbums.cover)
			{
				return createCover();
			}
			else if(photoPage == curAlbums.backc)
			{
				return createBackc();
			}
			
			var page:AlbumsPhotoPage = new AlbumsPhotoPage();
			
			page.setData(curAlbums, photoPage, isLeft);
			if(isLeft) _leftPage = photoPage;
			else _rightPage = photoPage;
			return page;
		}
		
		public function createCover():AlbumsPhotoPage
		{
			var page:AlbumsCoverPage = new AlbumsCoverPage();
			page.setData(curAlbums, curAlbums.cover, true);
			_leftPage = curAlbums.cover;
			_rightPage = getNextPageData(curAlbums.cover);
			return page;
		}
		
		public function createBackc():AlbumsPhotoPage
		{
			var page:AlbumsBackcPage = new AlbumsBackcPage();
			page.setData(curAlbums, curAlbums.backc, false);
			_rightPage = curAlbums.backc;
			_leftPage = getPrePageData(curAlbums.backc);
			return page;
		}
		
		public function dispose():void
		{
			StageReference.stage.removeEventListener(MouseEvent.MOUSE_DOWN, __stageMouseDownHandler);
			StageReference.stage.removeEventListener(MouseEvent.MOUSE_UP, __stageMouseUpHandler);
			StageReference.stage.removeEventListener(Event.ENTER_FRAME, __enterFrameHandler);
			
			DisposeHelper.dispose(flipView);
			flipView = null;
			
			DisposeHelper.dispose(flipSecondView);
			flipSecondView = null;
			
			DisposeHelper.dispose(bmd);
			bmd = null;
			
			DisposeHelper.dispose(shadow0);
			shadow0 = null;
			
			DisposeHelper.dispose(mask);
			mask = null;
			
			while(bookArray_layer1 && bookArray_layer1.length > 0)
			{
				bookArray_layer1.shift();
			}
			bookArray_layer1 = null;
			
			helperContainer = null;
			shadowContainer = null;
			shape = null;
			leftPage = null;
			rightPage = null;
			mouseUpCallback = null;
			mouseDownCallback = null;
			flipComplete = null;
			p1 = p2 = p3 = p4 = null;
			_leftPage = null;
			_rightPage = null;
			limit_point1 = null;
			limit_point2 = null;
			rotatePoint = null;
			matrix = null;
			matr = null;
			curAlbums = null;
			
			AlbumsMgr.Instance.proxy = null;
		}
	}
}