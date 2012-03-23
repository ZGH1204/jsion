package jsion.tool.pngpacker.data
{
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import jsion.HashMap;
	import jsion.core.Global;
	import jsion.core.serialize.res.ResPacker;
	import jsion.core.serialize.res.ResUnpacker;
	
	import org.aswing.tree.DefaultMutableTreeNode;
	import org.aswing.tree.DefaultTreeModel;

	public class PackerModel
	{
		public var name:String;
		
		private var m_actions:HashMap;
		
		public var model:DefaultTreeModel;
		public var root:DefaultMutableTreeNode;
		
		private var m_changed:Boolean;
		
		public function PackerModel(name:String = "动作列表")
		{
			this.name = name;
			m_actions = new HashMap();
			root = new DefaultMutableTreeNode(this.name);
			model = new DefaultTreeModel(root);
		}
		
		public function change():void
		{
			m_changed = true;
		}
		
		public function addAction(actionID:int, dir:int):DirectionInfo
		{
			var actionName:String = Global.ActionNames[actionID - 1];
			var dirName:String = Global.DirNames[dir - 1];
			
			var action:ActionInfo = m_actions.get(actionID) as ActionInfo;
			
			var dirInfo:DirectionInfo;
			
			if(action == null)
			{
				action = new ActionInfo(actionName);
				action.actionID = actionID;
				action.root = root;
				action.model = this;
				m_actions.put(actionID, action);
				
				root.append(action.node);
			}
			else
			{
				dirInfo = action.getDirInfo(dir);
				if(dirInfo != null) return dirInfo;
			}
			
			dirInfo = new DirectionInfo(dirName)
			dirInfo.dir = dir;
			action.addDirInfo(dirInfo);
			
			return dirInfo;
		}
		
		public function getAction(actionID:int):ActionInfo
		{
			return m_actions.get(actionID) as ActionInfo;
		}
		
		public function getPath(node:DefaultMutableTreeNode):DirectionInfo
		{
			var dirInfo:DirectionInfo;
			
			var aList:Array = getAllActions();
			
			for each(var aItem:ActionInfo in aList)
			{
				var dList:Array = aItem.getAllDirInfos();
				
				for each(var dItem:DirectionInfo in dList)
				{
					if(dItem.node == node)
					{
						dirInfo = dItem;
						break;
					}
				}
			}
			
			return dirInfo;
		}
		
		public function getAllActions():Array
		{
			return m_actions.getValues();
		}
		
		public function getAllDirs():Array
		{
			var list:Array = [];
			
			var actions:Array = m_actions.getValues();
			
			for each(var a:ActionInfo in actions)
			{
				var dirs:Array = a.getAllDirInfos();
				
				for each(var d:DirectionInfo in dirs)
				{
					list.push(d);
				}
			}
			
			return list;
		}
		
		public function clear():void
		{
			var list:Array = getAllDirs();
			
			for each(var d:DirectionInfo in list)
			{
				d.removeFromAction();
			}
		}
		
		public function save(file:String):void
		{
			if(m_changed == false) return;
			
			var bytes:ByteArray = getPackBytes();
			
			var f:File = new File(file);
			
			var fs:FileStream = new FileStream();
			
			fs.open(f, FileMode.WRITE);
			fs.writeBytes(bytes);
			fs.close();
		}
		
		private function getPackBytes():ByteArray
		{
			var bytes:ByteArray = new ByteArray();
			
			var packer:ResPacker = new ResPacker();
			
			var list:Array = getAllActions();
			
			for each(var action:ActionInfo in list)
			{
				if(action.hasDir == false) continue;
				
				var dirList:Array = action.getAllDirInfos();
				
				for each(var dir:DirectionInfo in dirList)
				{
					if(dir.hasPNG == false) continue;
					
					var bmdList:Array = dir.getList();
					
					for each(var bmd:BitmapData in bmdList)
					{
						packer.addImage(bmd.clone(), action.actionID, dir.dir);
					}
				}
			}
			
			return packer.pack();
		}
		
		public function read(f:File):DirectionInfo
		{
			var bytes:ByteArray = new ByteArray();
			
			var fs:FileStream = new FileStream();
			
			fs.open(f, FileMode.READ);
			fs.readBytes(bytes);
			fs.close();
			
			var first:DirectionInfo;
			var dir:DirectionInfo;
			
			var unpacker:ResUnpacker = new ResUnpacker(bytes);
			
			for (var i:int = 1; i <= Global.ActionCount; i++)
			{
				for (var j:int = 1; j <= Global.DirCount; j++)
				{
					var list:Array = unpacker.getBitmapDataList(i, j);
					
					if(list && list.length > 0)
					{
						dir = addAction(i, j);
						if(first == null) first = dir;
						
						for each(var bmd:BitmapData in list)
						{
							dir.addBitmapData(bmd);
						}
					}
				}
			}
			
			return first;
		}
	}
}