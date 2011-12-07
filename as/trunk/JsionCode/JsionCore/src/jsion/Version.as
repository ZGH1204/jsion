package jsion
{
	/**
	 * 版本类
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public class Version implements ICloneable, IComparable
	{
		private var _major:int;
		
		private var _minor:int;
		
		private var _build:int;
		
		private var _revision:int;
		
		public function Version(major:int, minor:int, build:int, revision:int)
		{
			_major = major;
			_minor = minor;
			_build = build;
			_revision = revision;
		}
		
		public function clone():Object
		{
			return new Version(_major, _minor, _build, _revision);
		}
		
		public function equals(version:Object):int
		{
			var v:Version = version as Version;
			
			if(v == null) return int.MIN_VALUE;
			
			if(_major > v.major) return 1;
			else if(_major < v.major) return -1;
			else if(_minor > v.minor) return 1;
			else if(_minor < v.minor) return -1;
			else if(_build > v.build) return 1;
			else if(_build < v.build) return -1;
			else if(_revision > v.revision) return 1;
			else if(_revision < v.revision) return -1;
			else return 0;
		}
		
		/**
		 * 获取当前 Version 对象版本号的主要版本号部分的值。
		 * @return 主要版本号或为 0（如果未定义主要版本号）。
		 * 
		 */		
		public function get major():int
		{
			return _major;
		}

		/**
		 * 获取当前 Version 对象版本号的次要版本号部分的值。
		 * @return 次要版本号或为 0（如果未定义次要版本号）。
		 * 
		 */		
		public function get minor():int
		{
			return _minor;
		}

		/**
		 * 获取当前 Version 对象版本号的内部版本号部分的值。
		 * @return 内部版本号或为 0（如果未定义内部版本号）。
		 * 
		 */		
		public function get build():int
		{
			return _build;
		}

		/**
		 * 获取当前 Version 对象版本号的修订号部分的值。
		 * @return 修订号或为 0（如果未定义修订号）。
		 * 
		 */		
		public function get revision():int
		{
			return _revision;
		}
		
		/**
		 * 将版本号的字符串表示形式转换为等效的 Version 对象。
		 * @param input 版本号的字符串表示形式
		 * @return Version 对象。
		 * 
		 */		
		public static function parse(input:String):Version
		{
			var list:Array = input.split(".");
			
			while(list.length < 4)
			{
				list.push(0);
			}
			
			return new Version(int(list[0]), int(list[1]), int(list[2]), int(list[3]));
		}
		
		public function toString():String
		{
			return [_major, _minor, _build, _revision].join(".");
		}
	}
}