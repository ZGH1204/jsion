package code
{
	import utils.StringHelper;
	
	public class LanguageBindModel
	{
		public var Key:String = "";
		public var Value:String = "";
		public var Description:String = "";
		public var Interpret:String = "";
		
		/* 解析语言包的项(辅助函数) */
		public function parseLanguage(str:String):void
		{
			var array:Array = str.split(":");
			
			Key = getKey(array);
			Value = getValue(array);
			Description = getDescription(array);
		}
		
		/* 获取语言项的Key字段(辅助函数) */
		private function getKey(array:Array):String
		{
			return array[0];
		}
		
		/* 获取语言项的Value字段(辅助函数) */
		private function getValue(array:Array):String
		{
			if(array.length < 2)
				return "";
			var arr:Array = String(array[1]).split("##");
			
			return StringHelper.trimRight(String(arr[0]));
		}
		
		/* 获取语言项的Description字段(辅助函数) */
		private function getDescription(array:Array):String
		{
			if(array.length < 2)
				return "";
			var arr:Array = String(array[1]).split("##");
			
			if(arr.length < 2)
			{
				return "";
			}
			else
			{
				arr.shift();
				return StringHelper.trim(arr.join("##"));
			}
		}
		
		public function toString():String
		{
			if(StringHelper.isNullOrEmpty(Key))
				return null;
			if(StringHelper.isNullOrEmpty(Description))
				return Key + ":" + Value;
			return Key + ":" + Value + " ##" + Description;
		}
		
		public function toInterpretString():String
		{
			if(StringHelper.isNullOrEmpty(Key))
				return null;
			if(StringHelper.isNullOrEmpty(Description))
				return Key + ":" + Value;
			return Key + ":" + Interpret + " ##" + Description;
		}
	}
}