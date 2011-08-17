package jcore.org.ddrop
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import jutils.org.util.DictionaryUtil;
	import jutils.org.util.DisposeUtil;
	import jutils.org.util.StringUtil;

	/**
	 * 拖拽管理
	 * @author Jsion
	 * 
	 */	
	public class DDropMgr
	{
		private static const Default_Group:String = "default";
		
		private static var _useFPS:Boolean;
		
		private static var _draging:Boolean;
		private static var _transData:*;
		private static var _dragger:IDragDrop;
		private static var _dragIcon:DisplayObject;
		private static var _dragingGroup:DDGroup;
		
		private static var _dragStartGlobarPoint:Point = new Point();
		private static var _dragStartPoint:Point = new Point();
		private static var _dragIconStartPoint:Point;
		
		private static var _groups:Dictionary = new Dictionary();
		
		/**
		 * 是否使用EnterFrame事件进入拖动
		 */		
		public static function get useFPS():Boolean
		{
			return _useFPS;
		}
		public static function set useFPS(value:Boolean):void
		{
			_useFPS = value;
		}
		
		/**
		 * 是否正在拖动中 
		 */		
		public static function get draging():Boolean
		{
			return _draging;
		}
		
		/**
		 * 注册拖拽
		 * @param dragger 要注册的对象
		 * @param group 拖拽分组
		 * @param isClickDrag true表示鼠标点击后拖动,false表示鼠标按下后拖动.
		 */		
		public static function registeDrag(dragger:IDragDrop, group:String = null, isClickDrag:Boolean = false):void
		{
			var g:DDGroup = getDDGroup(group);
			
			if(g.contains(dragger)) return;
			
			g.add(dragger);
			
			if(isClickDrag) dragger.addEventListener(MouseEvent.CLICK, __dragStartHandler);
			else dragger.addEventListener(MouseEvent.MOUSE_DOWN, __dragStartHandler);
		}
		
		/**
		 * 取消拖拽
		 * @param dragger 要取消的对象
		 * @param group 拖拽分组
		 */		
		public static function unregisteDrag(dragger:IDragDrop):void
		{
			if(dragger == null) return;
			
			var g:DDGroup = getDDGroupByDragger(dragger);
			
			if(g) g.remove(dragger);
			
			removeDragEvent(dragger);
		}
		
		/**
		 * 清除指定分组
		 * @param group 分组名称,null或空字符串表示默认分组.
		 */		
		public static function clearGroup(group:String = null):void
		{
			if(StringUtil.isNullOrEmpty(group)) group = Default_Group;
			
			for each(var item:DDGroup in _groups)
			{
				if(item.group == group)
				{
					item.each(removeDragEvent);
					DictionaryUtil.delKey(_groups, group);
					break;
				}
			}
		}
		
		/**
		 * 清除所有分组
		 */		
		public static function clearGroups():void
		{
			for each(var item:DDGroup in _groups)
			{
				item.each(removeDragEvent);
			}
			
			DisposeUtil.free(_groups);
		}
		
		/**
		 * 获取拖拽分组,无分组时自动创建.
		 * @param group 分组名称
		 * @return 分组对象
		 * @private
		 */		
		private static function getDDGroup(group:String):DDGroup
		{
			if(StringUtil.isNullOrEmpty(group)) group = Default_Group;
			
			if(_groups[group] == null) _groups[group] = new DDGroup(group);
			
			return _groups[group] as DDGroup;
		}
		
		/**
		 * 通过拖拽对象查找分组
		 * @param dragger 拖拽对象
		 * @return 拖拽分组
		 */		
		private static function getDDGroupByDragger(dragger:Object):DDGroup
		{
			for each(var item:DDGroup in _groups)
			{
				if(item.contains(dragger))
				{
					return item;
				}
			}
			
			return null;
		}
		
		/**
		 * 移除拖动监听
		 * @param dragger 拖动对象
		 */		
		private static function removeDragEvent(dragger:IEventDispatcher):void
		{
			if(dragger == null) return;
			dragger.removeEventListener(MouseEvent.CLICK, __dragStartHandler);
			dragger.removeEventListener(MouseEvent.MOUSE_DOWN, __dragStartHandler);
		}
		
		/**
		 * 移除拖拽中的事件监听
		 */		
		private static function removeDragingEvent():void
		{
			StageRef.removeEventListener(Event.ENTER_FRAME, __dragingHandler);
			StageRef.removeEventListener(MouseEvent.MOUSE_OVER, __dragingHandler);
			StageRef.removeEventListener(MouseEvent.CLICK, __dropHandler);
			StageRef.removeEventListener(MouseEvent.MOUSE_UP, __dropHandler);
			StageRef.removeEventListener(Event.DEACTIVATE, __dropAbortHandler);
			StageRef.removeEventListener(Event.MOUSE_LEAVE, __dropAbortHandler);
			StageRef.removeEventListener(MouseEvent.MOUSE_OUT, __dropAbortHandler);
			StageRef.removeEventListener(MouseEvent.ROLL_OUT, __dropAbortHandler);
		}
		
		private static function __dragStartHandler(e:MouseEvent):void
		{
			if(_draging || e.currentTarget != e.target) return;
			
			//保存拖动数据
			_dragger = IDragDrop(e.currentTarget);
			_transData = _dragger.transData;
			_dragingGroup = getDDGroupByDragger(_dragger);
			
			//添加拖动是的事件监听
			if(_useFPS) StageRef.addEventListener(Event.ENTER_FRAME, __dragingHandler);
			else StageRef.addEventListener(MouseEvent.MOUSE_OVER, __dragingHandler);
			if(e.type == MouseEvent.CLICK) StageRef.addEventListener(MouseEvent.CLICK, __dropHandler);
			else StageRef.addEventListener(MouseEvent.MOUSE_UP, __dropHandler);
			StageRef.addEventListener(Event.DEACTIVATE, __dropAbortHandler);
			StageRef.addEventListener(Event.MOUSE_LEAVE, __dropAbortHandler);
			StageRef.addEventListener(MouseEvent.MOUSE_OUT, __dropAbortHandler);
			StageRef.addEventListener(MouseEvent.ROLL_OUT, __dropAbortHandler);
			
			//视图处理
			_dragStartGlobarPoint.x = StageRef.mouseX;
			_dragStartGlobarPoint.y = StageRef.mouseY;
			_dragStartPoint.x = _dragger.x;
			_dragStartPoint.y = _dragger.y;
			_dragIconStartPoint = _dragger.localToGlobal(Constant.ZeroPoint);
			_dragIcon = _dragger.dragingIcon;
			_dragIcon.x = _dragIconStartPoint.x;
			_dragIcon.y = _dragIconStartPoint.y;
			StageRef.addChild(_dragIcon);
		}
		
		private static function __dragingHandler(e:Event):void
		{
			
		}
		
		private static function __dropHandler(e:MouseEvent):void
		{
			removeDragingEvent();
		}
		
		private static function __dropAbortHandler(e:Event):void
		{
			removeDragingEvent();
		}
	}
}