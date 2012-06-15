package jsion.events
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import jsion.IDispose;
	import jsion.utils.DisposeUtil;
	
	/**
	 * 继承自 flash.events.EventDispatcher。
	 * <p>增加dispose时自动释放所有监听函数</p>
	 * @author Jsion
	 * 
	 */	
	public class JsionEventDispatcher extends EventDispatcher implements IDispose
	{
		/**
		 * 保存监听本对象事件的监听信息
		 */		
		private var m_listeners:Dictionary;
		
		public function JsionEventDispatcher(target:IEventDispatcher=null)
		{
			m_listeners = new Dictionary();
			
			super(target);
		}
		
		//==========================================		保存事件监听信息			==========================================
		/**
		 * 重写添加事件监听 保存监听信息
		 * 使用 EventDispatcher 对象注册事件侦听器对象，以使侦听器能够接收事件通知。
		 * @param type 事件的类型
		 * @param listener 处理事件的侦听器函数。此函数必须接受 Event 对象作为其唯一的参数，并且不能返回任何结果，如以下示例所示： function(evt:Event):void
		 * @param useCapture 确定侦听器是运行于捕获阶段、目标阶段还是冒泡阶段。如果将 useCapture 设置为 true，则侦听器只在捕获阶段处理事件，而不在目标或冒泡阶段处理事件。 如果 useCapture 为 false，则侦听器只在目标或冒泡阶段处理事件。 若要在所有三个阶段都侦听事件，请调用两次 addEventListener，一次将 useCapture 设置为 true，第二次再将 useCapture 设置为 false。
		 * @param priority 事件侦听器的优先级。 优先级由一个带符号的 32 位整数指定。 数字越大，优先级越高。 优先级为 n 的所有侦听器会在优先级为 n -1 的侦听器之前得到处理。 如果两个或更多个侦听器共享相同的优先级，则按照它们的添加顺序进行处理。 默认优先级为 0。
		 * @param useWeakReference 确定对侦听器的引用是强引用，还是弱引用。 强引用（默认值）可防止您的侦听器被当作垃圾回收。 弱引用则没有此作用。
		 * @see #removeEventListener()
		 * 
		 */		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
			var str:String = type + useCapture;
			
			var model:ListenerModel;
			
			if(m_listeners[str] != undefined)
			{
				model = m_listeners[str];
				
				if(model.listener.indexOf(listener) == -1)
				{
					model.listener.push(listener);
				}
			}
			else
			{
				model = new ListenerModel();
				
				model.type = type;
				model.listener = [];
				model.listener.push(listener);
				model.useCapture = useCapture;
				
				m_listeners[str] = model;
			}
		}
		
		/**
		 * 重写移除事件监听 删除对应的监听信息
		 * @param type 事件的类型。 
		 * @param listener 要删除的侦听器对象。 
		 * @param useCapture 指出是否为捕获阶段或目标阶段和冒泡阶段注册了侦听器。 如果为捕获阶段以及目标和冒泡阶段注册了侦听器，则需要对 removeEventListener() 进行两次调用才能将这两个侦听器删除，一次调用将 useCapture() 设置为 true，另一次调用将 useCapture() 设置为 false。 
		 * @see #addEventListener()
		 * 
		 */		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			super.removeEventListener(type, listener, useCapture);
			
			var str:String = type + useCapture;
			
			if(m_listeners)
			{
				var model:ListenerModel = m_listeners[str];
				
				if(model != null)
				{
					var index:int = model.listener.indexOf(listener);
					
					if(index == -1) return;
					
					model.listener.splice(index, 1);
					
					if(model.listener.length == 0)
					{
						DisposeUtil.free(m_listeners[str]);
						
						delete m_listeners[str];
					}
				}
			}
		}
		
		//==========================================		保存事件监听信息			==========================================
		
		
		
		/**
		 * 移除所有对本对象的监听
		 * @see #addEventListener()
		 * @see #removeEventListener()
		 */		
		public function removeAllEventListeners():void
		{
			if(m_listeners == null) return;
			
			for(var val:* in m_listeners)
			{
				var model:ListenerModel = m_listeners[val];
				
				delete m_listeners[val];
				
				for each(var fn:Function in model.listener)
				{
					removeEventListener(model.type, fn, model.useCapture);
				}
			}
		}
		
		public function dispose():void
		{
			removeAllEventListeners();
			
			DisposeUtil.free(m_listeners);
			m_listeners = null;
		}
	}
}