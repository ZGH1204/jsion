package tool.pngpacker.datas
{
	import jsion.events.JsionEventDispatcher;
	import jsion.utils.ArrayUtil;
	import jsion.utils.DisposeUtil;
	
	import tool.pngpacker.events.PackerEvent;
	
	[Event(name="addActionData", type="tool.pngpacker.events.PackerEvent")]
	[Event(name="removeActionData", type="tool.pngpacker.events.PackerEvent")]
	public class PackerData extends JsionEventDispatcher
	{
		protected var m_actions:Array;
		
		public function PackerData()
		{
			super();
			
			m_actions = [];
		}
		
		public function canPack():Boolean
		{
			if(m_actions.length == 0) return false;
			
			for each(var a:ActionData in m_actions)
			{
				if(a.canPack()) return true;
			}
			
			return false;
		}
		
		public function contains(a:ActionData):Boolean
		{
			for each(var item:ActionData in m_actions)
			{
				if(item.id == a.id) return true;
			}
			
			return false;
		}
		
		public function setActions(list:Array):void
		{
			var a:ActionData;
			var a2:ActionData;
			
			var oldList:Array = getActions();
			var removeList:Array = ArrayUtil.clone(oldList);
			
			for each(a in oldList)
			{
				for each(a2 in list)
				{
					if(a.id == a2.id)
					{
						ArrayUtil.remove(removeList, a);
					}
				}
			}
			
			for each(a in removeList)
			{
				removeAction(a.id);
			}
			
			for each(a in list)
			{
				addAction(a);
			}
		}
		
		public function addAction(a:ActionData):void
		{
			if(a == null) return;
			
			if(contains(a))
			{
				var item:ActionData = getAction(a.id);
				var dirs:Array = a.getDirs();
				item.setDirs(dirs);
			}
			else
			{
				a.packerData = this;
				
				m_actions.push(a);
				
				dispatchEvent(new PackerEvent(PackerEvent.ADD_ACTION_DATA, a));
			}
		}
		
		public function removeAction(id:int):ActionData
		{
			for(var i:int = 0; i < m_actions.length; i++)
			{
				var a:ActionData = m_actions[i] as ActionData;
				
				if(a.id == id)
				{
					a.packerData = null;
					
					ArrayUtil.remove(m_actions, a);
					
					dispatchEvent(new PackerEvent(PackerEvent.REMOVE_ACTION_DATA, a));
					
					DisposeUtil.free(a);
					
					return a;
				}
			}
			
			return null;
		}
		
		public function getAction(id:int):ActionData
		{
			for each(var item:ActionData in m_actions)
			{
				if(item.id == id) return item;
			}
			
			return null;
		}
		
		public function getActions():Array
		{
			return ArrayUtil.clone(m_actions);
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			while(m_actions && m_actions.length > 0)
			{
				var a:ActionData = m_actions.pop();
				removeAction(a.id);
			}
			
			DisposeUtil.free(m_actions);
			m_actions = null;
			
			super.dispose();
		}
	}
}