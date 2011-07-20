package dataType
{
	import event.DictionaryEvent;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	public dynamic class SimpleDictionary extends Dictionary
	{
		private var dispatcher:EventDispatcher;
		private var _list:Array;
		
		public function SimpleDictionary(weakKeys:Boolean=false)
		{
			dispatcher = new EventDispatcher(null);
			_list = [];
			super(weakKeys);
		}
		
		public function get keys():Array
		{
			var temp:Array = [];
			
			for(var i:String in this)
			{
				temp.push(i);
			}
			
			return temp;
		}
		
		private function setValue(key:*, data:Object):void
		{
			if(this[key])
			{
				dispatchEvent(new DictionaryEvent(DictionaryEvent.PREUPDATE,data,this[key]));
				updateInArray(this[key],data);
				this[key] = data;
				dispatchEvent(new DictionaryEvent(DictionaryEvent.UPDATE,data,this[key]));
			}
			else
			{
				dispatchEvent(new DictionaryEvent(DictionaryEvent.PREADD,data,this[key]));
				addInArray(data);
				this[key] = data;
				dispatchEvent(new DictionaryEvent(DictionaryEvent.ADD,data,this[key]));
			}
		}
		
		private function addInArray(obj:Object):void
		{
			_list.push(obj);
		}
		
		private function updateInArray(oldObj:Object, newObj:Object):void
		{
			var index:int = _list.indexOf(oldObj);
			if(index > -1)
				_list.splice(index,1,newObj);
		}
		
		private function delInArray(obj:Object):void
		{
			var index:int = _list.indexOf(obj);
			if(index > -1)
				_list.splice(index,1);
		}
		
		private function delValue(key:*):void
		{
			if(this[key])
			{
				var old:Object = this[key];
				dispatchEvent(new DictionaryEvent(DictionaryEvent.PREDELETE,null,old));
				delInArray(old);
				delete this[key];
				dispatchEvent(new DictionaryEvent(DictionaryEvent.PREDELETE,null,old));
				old = null;
			}
		}
		
		private function checkToAddOrUpdate(key:*,data:Object):Boolean
		{
			if(data == null)
			{
				delValue(key);
				return false;
			}
			
			return true;
		}
		
		public function add(key:*, data:Object):void
		{
			if(checkToAddOrUpdate(key,data))
				setValue(key, data);
		}
		
		public function update(key:*, data:Object):void
		{
			if(checkToAddOrUpdate(key,data))
				setValue(key, data);
		}
		
		public function del(key:*):void
		{
			delValue(key);
		}
		
		public function clear():void
		{
			dispatchEvent(new DictionaryEvent(DictionaryEvent.PRECLEAR));
			
			var temp:Array = keys;
			
			for each(var s:String in temp)
			{
				delete this[s];
			}
			
			_list = [];
			
			dispatchEvent(new DictionaryEvent(DictionaryEvent.CLEAR));
		}
		
		public function setDictionary(dic:SimpleDictionary):void
		{
			clear();
			
			for(var i:String in dic)
			{
				add(i,dic[i]);
			}
		}
		
		/* 返回一个键/值对的数组,使用key 和 value访问 */
		public function slice(startIndex:int = 0, endIndex:int = 166777215):Array
		{
			var sliced:Array = keys.slice(startIndex,endIndex);
			var returnArray:Array = [];
			
			for(var i:uint = 0; i < sliced.length; i++)
			{
				var obj:Object = new Object();
				
				obj.key = sliced[i];
				obj.value = this[sliced[i]];
				
				returnArray.push(obj);
				
				delete this[sliced[i]];
			}
			
			return returnArray;
		}
		
		/* 返回一个键/值对的数组,使用key 和 value访问 */
		public function splice(startIndex:int, deleteCount:uint):Array
		{
			var spliced:Array = keys.splice(startIndex,deleteCount);
			
			var returnArray:Array = [];
			
			for(var i:uint = 0; i < spliced.length; i++)
			{
				var obj:Object = new Object();
				
				obj.key = spliced[i];
				obj.value = this[spliced[i]];
				
				returnArray.push(obj);
				
				delete this[spliced[i]];
			}
			
			return returnArray;
		}
		
		public function dispatchEvent(event:DictionaryEvent):void
		{
			dispatcher.dispatchEvent(event);
		}
		
		public function addEventListener(type:String, listener:Function):void
		{
			dispatcher.addEventListener(type,listener);
		}
		
		public function removeEventListener(type:String, listener:Function):void
		{
			dispatcher.removeEventListener(type,listener);
		}
	}
}