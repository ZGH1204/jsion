package code
{
	import dataType.SimpleDictionary;
	import dataType.TextFile;
	
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.collections.ArrayCollection;
	
	import utils.ArrayUtil;
	import utils.StringHelper;

	public class LanguageFile extends TextFile
	{
		private var _sortKeyArray			:Array;					//查找Key重复项时使用
		private var _sortKeyLengthArray		:Array;					//搜索Key时使用
		private var _keyLengthIndexDic		:SimpleDictionary;		//搜索Key时使用
		private var _sortValueArray			:Array;					//查找Value重复项时使用
		private var _sortValueLengthArray	:Array;					//搜索Value时使用
		private var _valueLengthIndexDic	:SimpleDictionary;		//搜索Value时使用
		
		[Bindable]
		public var acLanguage				:ArrayCollection;		//语言包绑定数据
		
		[Bindable]
		public var repeatLanguage			:ArrayCollection;		//语言包重复项绑定数据
		
		[Bindable]
		public var searchLanguage			:ArrayCollection;		//语言包搜索结果
		
		public function LanguageFile(path:String=null)
		{
			super(path);
		}
		
		/* 生成语言包重复项绑定数据 */
		public function generateRepeatLanguageData(sKey:Boolean = true, sValue:Boolean = false):void
		{
			var array:Array = getRepeatResult(sKey,sValue);
			
			repeatLanguage = new ArrayCollection(array);
		}
		
		private function getRepeatResult(sKey:Boolean = true, sValue:Boolean = false):Array
		{
			var result:Array = [];
			
			if(sKey)
			{
				updateRepeatKeyData();
				
				var keyRepeat:Array = getKeyRepeatResult();
				
				result = ArrayUtil.contact(result,keyRepeat);
			}
			if(sValue)
			{
				updateRepeatValueData();
				
				var valueRepeat:Array = getValueRepeatResult();
				
				result = ArrayUtil.contact(result,valueRepeat);
			}
			
			return result;
		}
		
		private function getKeyRepeatResult():Array
		{
			var result:Array = [];
			
			var keyArray:Array = _sortKeyArray;
			
			var endIndex:int = keyArray.length - 1;
			
			for(var i:uint = 0; i < endIndex; i++)
			{
				var current:LanguageBindModel = keyArray[i] as LanguageBindModel;
				var next:LanguageBindModel = keyArray[i + 1] as LanguageBindModel;
				
				if(current.Key == next.Key)
				{
					if(result.indexOf(current) == -1)
						result.push(current);
					if(result.indexOf(next) == -1)
						result.push(next);
				}
			}
			
			_sortKeyArray = null;
			
			return result;
		}
		
		private function getValueRepeatResult():Array
		{
			var result:Array = [];
			
			var keyArray:Array = _sortValueArray;
			
			var endIndex:int = keyArray.length - 1;
			
			for(var i:uint = 0; i < endIndex; i++)
			{
				var current:LanguageBindModel = keyArray[i] as LanguageBindModel;
				var next:LanguageBindModel = keyArray[i + 1] as LanguageBindModel;
				
				if(StringHelper.removeHtmlTag(current.Value) == StringHelper.removeHtmlTag(next.Value))
				{
					if(result.indexOf(current) == -1)
						result.push(current);
					if(result.indexOf(next) == -1)
						result.push(next);
				}
			}
			
			_sortValueArray = null;
			
			return result;
		}
		
		/* 生成语言包绑定数据(主调函数) */
		public function generateLanguageData():void
		{
			if(exists == false && _arString == null)
				return;
			
			var modelArray:Array = [];
			
			for each(var s:String in _arString)
			{
				if(StringHelper.trim(s).indexOf("#") == 0 || StringHelper.isNullOrEmpty(StringHelper.trim(s)))
					continue;
				var lm:LanguageBindModel = new LanguageBindModel();
				lm.parseLanguage(s);
				modelArray.push(lm);
			}
			
			acLanguage = new ArrayCollection(modelArray);
		}
		
		public function generateSearchLanguageData(keyword:String, sKey:Boolean = true, sValue:Boolean = false):void
		{
			var array:Array = search(keyword,sKey,sValue);
			
			searchLanguage = new ArrayCollection(array);
		}
		
		public function searchLanguageForAnalyze(keyword:String):Array
		{
			return search(keyword);
		}
		
		/* 搜索指定字符串(主调函数) */
		private function search(keyword:String, sKey:Boolean = true, sValue:Boolean = false):Array
		{
			var lanList:Array = [];
			
			if(sKey)
			{
				updateSearchKeyData();
				
				var keyBeginIndex:int = getKeyBeginIndex(keyword.length);
				
				var key:Array = getKeySearchResult(keyBeginIndex,keyword);
				
				lanList = ArrayUtil.contact(lanList,key);
			}
			
			if(sValue)
			{
				updateSearchValueData();
				
				var valueBeginIndex:int = getValueBeginIndex(keyword.length);
				
				var val:Array = getValueSearchResult(valueBeginIndex,keyword);
				
				lanList = ArrayUtil.contact(lanList,val);
			}
			
			return lanList;
		}
		
		/* 更新获取Key重复项时所需的数据(辅助函数) */
		private function updateRepeatKeyData():void
		{
			_sortKeyArray = [];
			
			for each(var lm:LanguageBindModel in acLanguage)
			{
				_sortKeyArray.push(lm);
			}
			
			_sortKeyArray.sort(sortOnKey);
		}
		
		/* 更新获取Value重复项时所需的数据(辅助函数) */
		private function updateRepeatValueData():void
		{
			_sortValueArray = [];
			
			for each(var lm:LanguageBindModel in acLanguage)
			{
				_sortValueArray.push(lm);
			}
			
			_sortValueArray.sort(sortOnValue);
		}
		
		/* 更新搜索Key时所需的数据(辅助函数) */
		private function updateSearchKeyData():void
		{
			_sortKeyLengthArray = [];
			
			for each(var lm:LanguageBindModel in acLanguage)
			{
				_sortKeyLengthArray.push(lm);
			}
			
			_sortKeyLengthArray.sort(sortOnKeyLength);
			
			_keyLengthIndexDic = new SimpleDictionary();
			
			for(var i:uint = 0; i < _sortKeyLengthArray.length; i++)
			{
				if(_keyLengthIndexDic["len" + _sortKeyLengthArray[i].Key.length] == null)
					_keyLengthIndexDic["len" + _sortKeyLengthArray[i].Key.length] = i;
			}
		}
		
		/* 更新搜索Value时所需的数据(辅助函数) */
		private function updateSearchValueData():void
		{
			_sortValueLengthArray = [];
			
			for each(var lm:LanguageBindModel in acLanguage)
			{
				_sortValueLengthArray.push(lm);
			}
			
			_sortValueLengthArray.sort(sortOnValueLength);
			
			_valueLengthIndexDic = new SimpleDictionary();
			
			for(var i:uint = 0; i < _sortValueLengthArray.length; i++)
			{
				if(_valueLengthIndexDic["len" + StringHelper.removeHtmlTag(_sortValueLengthArray[i].Value).length] == null)
					_valueLengthIndexDic["len" + StringHelper.removeHtmlTag(_sortValueLengthArray[i].Value).length] = i;
			}
		}
		
		/* 根据关键字长度获取在_sortKeyLengthArray中开始搜索Key的起始索引(辅助函数) */
		private function getKeyBeginIndex(len:int):int
		{
			var l:int = len;
			while(_keyLengthIndexDic["len" + l] == null)
			{
				l++;
			}
			
			return int(_keyLengthIndexDic["len" + l]);
		}
		
		/* 根据关键字长度获取在_sortKeyLengthArray中开始搜索Value的起始索引(辅助函数) */
		private function getValueBeginIndex(len:int):int
		{
			var l:int = len;
			while(_valueLengthIndexDic["len" + l] == null)
			{
				l++;
			}
			
			return int(_valueLengthIndexDic["len" + l]);
		}
		
		/* 根据起始索引在_sortKeyLengthArray中获取Key字段的搜索结果(辅助函数) */
		private function getKeySearchResult(beginIndex:int,keyword:String):Array
		{
			var result:Array = [];
			
			keyword = keyword.toLowerCase();
			
			for(var i:uint = beginIndex; i < _sortKeyLengthArray.length; i++)
			{
				if(_sortKeyLengthArray[i].Key.toLowerCase().indexOf(keyword) == 0)
					result.push(_sortKeyLengthArray[i]);
			}
			
			result.sort(sortOnKey);
			
			_sortKeyLengthArray = null;
			_keyLengthIndexDic = null;
			
			return result;
		}
		
		/* 根据起始索引在_sortKeyLengthArray中获取Value字段的搜索结果(辅助函数) */
		private function getValueSearchResult(beginIndex:int,keyword:String):Array
		{
			var result:Array = [];
			
			keyword = keyword.toLowerCase();
			
			for(var i:uint = beginIndex; i < _sortValueLengthArray.length; i++)
			{
				if(_sortValueLengthArray[i].Value.toLowerCase().indexOf(keyword) > -1)
					result.push(_sortValueLengthArray[i]);
			}
			
			result.sort(sortOnValue);
			
			_sortValueLengthArray = null;
			_valueLengthIndexDic = null;
			
			return result;
		}
		
		/* 排序函数，根据Key字段的内容(辅助函数) */
		private function sortOnKey(a:LanguageBindModel, b:LanguageBindModel):Number
		{
			if(a.Key == b.Key)
				return 0;
			
			var arr:Array = [];
			arr.push(a.Key);
			arr.push(b.Key);
			arr.sort(Array.CASEINSENSITIVE);
			
			if(String(arr[0]) == a.Key)
				return -1;
			else
				return 1;
		}
		
		/* 排序函数，根据Value字段的内容(辅助函数) */
		private function sortOnValue(a:LanguageBindModel, b:LanguageBindModel):Number
		{
			if(StringHelper.removeHtmlTag(a.Value) == StringHelper.removeHtmlTag(b.Value))
				return 0;
			
			var arr:Array = [];
			arr.push(StringHelper.removeHtmlTag(a.Value));
			arr.push(StringHelper.removeHtmlTag(b.Value));
			arr.sort(Array.CASEINSENSITIVE);
			
			if(String(arr[0]) == StringHelper.removeHtmlTag(a.Value))
				return -1;
			else
				return 1;
		}
		
		/* 排序函数，根据Key字段的长度(辅助函数) */
		private function sortOnKeyLength(a:LanguageBindModel, b:LanguageBindModel):Number
		{
			if(a.Key.length == b.Key.length)
				return 0;
			if(a.Key.length > b.Key.length)
				return 1;
			else
				return -1;
		}
		
		/* 排序函数，根据Value字段的长度(辅助函数) */
		private function sortOnValueLength(a:LanguageBindModel, b:LanguageBindModel):Number
		{
			if(StringHelper.removeHtmlTag(a.Value).length == StringHelper.removeHtmlTag(b.Value).length)
				return 0;
			if(StringHelper.removeHtmlTag(a.Value).length > StringHelper.removeHtmlTag(b.Value).length)
				return 1;
			else
				return -1;
		}
		
		public function deleteLanguage(array:Array):void
		{
			var arr:Array = array;
			
			var data:ArrayCollection = acLanguage;
			
			if(data)
			{
				for each(var model:LanguageBindModel in arr)
				{
					if(data.getItemIndex(model) != -1)
						data.removeItemAt(data.getItemIndex(model));
				}
				
				data.refresh();
			}
			
			
			var repeatData:ArrayCollection = repeatLanguage;
			
			if(repeatData)
			{
				for each(var repeatmodel:LanguageBindModel in arr)
				{
					if(repeatData.getItemIndex(repeatmodel) != -1)
						repeatData.removeItemAt(repeatData.getItemIndex(repeatmodel));
				}
				
				repeatData.refresh();
			}
			
			var searchData:ArrayCollection = searchLanguage;
			
			if(searchData)
			{
				for each(var searchmodel:LanguageBindModel in arr)
				{
					if(searchData.getItemIndex(searchmodel) != -1)
						searchData.removeItemAt(searchData.getItemIndex(searchmodel));
				}
				
				searchData.refresh();
			}
		}
		
		/* 将数据保存到语言包文件(主调函数) */
		override public function saveToFile():void
		{
			var fs:FileStream = new FileStream();
			
			fs.open(this,FileMode.WRITE);
			
			for each(var lm:LanguageBindModel in acLanguage)
			{
				fs.writeUTFBytes(lm.toString() + "\r\n");
			}
			
			fs.close();
		}
	}
}