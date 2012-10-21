package tool.pngpacker.datas
{
	import jsion.Global;
	import jsion.events.JsionEventDispatcher;
	import jsion.utils.ArrayUtil;
	import jsion.utils.DisposeUtil;
	
	import tool.pngpacker.events.PackerEvent;
	
	[Event(name="addDirData", type="tool.pngpacker.events.PackerEvent")]
	[Event(name="removeDirData", type="tool.pngpacker.events.PackerEvent")]
	public class ActionData extends JsionEventDispatcher
	{
		public var packerData:PackerData;
		
		protected var m_id:int;
		
		protected var m_name:String;
		
		protected var m_dirs:Array;
		
		public function ActionData(id:int)
		{
			super();
			
			m_id = id;
			
			m_name = Global.ActionNames[m_id];
			
			m_dirs = [];
		}
		
		public function get id():int
		{
			return m_id;
		}
		
		public function get name():String
		{
			return m_name;
		}
		
		public function canPack():Boolean
		{
			if(m_dirs.length == 0) return false;
			
			for each(var dir:DirData in m_dirs)
			{
				if(dir.canPack()) return true;
			}
			
			return false;
		}
		
		public function contains(dir:DirData):Boolean
		{
			for each(var item:DirData in m_dirs)
			{
				if(item.dir == dir.dir)
				{
					return true;
				}
			}
			
			return false;
		}
		
		public function setDirs(dirs:Array):void
		{
			var dir:DirData;
			var dir2:DirData;
			
			var oldList:Array = getDirs();
			var removeList:Array = ArrayUtil.clone(oldList);
			
			for each(dir in oldList)
			{
				for each(dir2 in dirs)
				{
					if(dir.dir == dir2.dir)
					{
						ArrayUtil.remove(removeList, dir);
					}
				}
			}
			
			for each(dir in removeList)
			{
				DisposeUtil.free(removeDir(dir.dir));
			}
			
			for each(dir in dirs)
			{
				addDir(dir);
			}
		}
		
		public function addDir(dir:DirData):void
		{
			if(contains(dir) == false)
			{
				if(dir.actionData)
				{
					dir.actionData.removeDir(dir.dir);
				}
				
				dir.actionData = this;
				
				m_dirs.push(dir);
				
				dispatchEvent(new PackerEvent(PackerEvent.ADD_DIR_DATA, dir));
			}
		}
		
		public function removeDir(dir:int):DirData
		{
			for(var i:int = 0; i < m_dirs.length; i++)
			{
				var d:DirData = m_dirs[i] as DirData;
				
				if(d.dir == dir)
				{
					d.actionData = null;
					ArrayUtil.remove(m_dirs, d);
					dispatchEvent(new PackerEvent(PackerEvent.REMOVE_DIR_DATA, d));
					
					return d;
				}
			}
			
			return null;
		}
		
		public function getDir(dir:int):DirData
		{
			for each(var item:DirData in m_dirs)
			{
				if(item.dir == dir)
				{
					return item;
				}
			}
			
			return null;
		}
		
		public function getDirs():Array
		{
			return ArrayUtil.clone(m_dirs);
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			
			while(m_dirs && m_dirs.length > 0)
			{
				var dir:DirData = m_dirs.pop();
				
				DisposeUtil.free(removeDir(dir.dir));
			}
			
			DisposeUtil.free(m_dirs);
			m_dirs = null;
			
			packerData = null;
			
			super.dispose();
		}
	}
}