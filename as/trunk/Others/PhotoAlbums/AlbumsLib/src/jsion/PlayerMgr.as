package jsion
{
	import com.managers.InstanceManager;
	import com.utils.DisposeHelper;
	import com.utils.ObjectHelper;
	
	import flash.display.DisplayObjectContainer;
	
	import jsion.data.PlayItem;
	import jsion.data.PlayList;
	import jsion.data.PlayerSkin;
	import jsion.view.PlayerView;

	public class PlayerMgr
	{
		private var _skinList:Vector.<PlayerSkin>;
		private var _playLists:Vector.<PlayList>;
		
		private var _currentSkin:PlayerSkin;

		public function get currentSkin():PlayerSkin
		{
			return _currentSkin;
		}

		public function set currentSkin(value:PlayerSkin):void
		{
			_currentSkin = value;
		}

		private var _currentList:PlayList;

		public function get currentList():PlayList
		{
			return _currentList;
		}

		public function set currentList(value:PlayList):void
		{
			_currentList = value;
		}

		private var _currentItem:PlayItem;

		public function get currentItem():PlayItem
		{
			return _currentItem;
		}

		public function set currentItem(value:PlayItem):void
		{
			_currentItem = value;
		}
		
		private var _musicPlayer:PlayerView;
		
		public function get musicPlayer():PlayerView
		{
			return _musicPlayer;
		}
		
		public function set musicPlayer(value:PlayerView):void
		{
			DisposeHelper.dispose(_musicPlayer);
			_musicPlayer = value;
			if(_musicPlayer && _parent) _parent.addChild(_musicPlayer);
		}
		
		private var _parent:DisplayObjectContainer;
		public function setParent(parent:DisplayObjectContainer):void
		{
			_parent = parent;
			if(_musicPlayer && _parent) _parent.addChild(_musicPlayer);
		}
		
		public function setCurrentSkin(index:int):void
		{
			currentSkin = getSkin(index);
		}
		
		public function getSkin(index:int):PlayerSkin
		{
			if(index < 0 || index >= _skinList.length) return null;
			return _skinList[index];
		}
		
		public function setCurrentPlayList(index:int):void
		{
			currentList = getPlayList(index);
		}
		
		public function getPlayList(index:int):PlayList
		{
			if(index < 0 || index >= _playLists.length) return null;
			return _playLists[index];
		}

		
		public function PlayerMgr()
		{
			_skinList = new Vector.<PlayerSkin>();
			_playLists = new Vector.<PlayList>();
		}
		
		public function setup(configXml:XML):void
		{
			if(configXml == null) return;
			var skinsListXL:XMLList = configXml.PlayerSkins;
			for each(var skinsListXml:XML in skinsListXL)
			{
				var skinXL:XMLList = skinsListXml.skin;
				for each(var skinXml:XML in skinXL)
				{
					var skin:PlayerSkin = new PlayerSkin();
					
					Util.parseXml(skin, skinXml, skinsListXml);
					
					_skinList.push(skin);
				}
			}
			
			var playListsXL:XMLList = configXml.PlayLists;
			for each(var playListsXml:XML in playListsXL)
			{
				var listXL:XMLList = playListsXml.list;
				for each(var listXml:XML in listXL)
				{
					var list:PlayList = new PlayList();
					
					Util.parseXml(list, listXml, playListsXml);
					
					var itemsXL:XMLList = listXml.item;
					for each(var itemXml:XML in itemsXL)
					{
						var item:PlayItem = new PlayItem();
						
						Util.parseXml(item, itemXml, listXml);
						
						list.items.push(item);
					}
					
					_playLists.push(list);
				}
			}
			
			var index:int;
			for each(var skinsXml:XML in skinsListXL)
			{
				if(_skinList.length == 0) break;
				index = int(String(skinsXml.@defaultSkin));
				index--;
				if(index >= _skinList.length || index < 0) currentSkin = _skinList[0];
				else currentSkin = _skinList[index];
				break;
			}
			
			for each(var playListXml:XML in playListsXL)
			{
				if(_playLists.length == 0) break;
				
				index = int(String(playListXml.@defaultList));
				index--;
				if(index >= _playLists.length || index < 0) currentList = _playLists[0];
				else currentList = _playLists[index];
				break;
			}
		}
		
		
		public static function get Instance():PlayerMgr
		{
			return InstanceManager.createSingletonInstance(PlayerMgr) as PlayerMgr;
		}
	}
}