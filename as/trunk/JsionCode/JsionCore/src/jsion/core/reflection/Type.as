package jsion.core.reflection
{
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	import jsion.utils.*;

	public class Type extends ReflectionInfo
	{
		public var name:String;
		public var base:String;
		public var staticConstants:Dictionary;
		public var constructor:ConstructorInfo;
		public var staticMethods:Dictionary;
		public var memberMethods:Dictionary;
		public var extendsClass:Array;
		public var propertys:Dictionary;
		public var metadatas:Dictionary;
		public var interfaces:Array;
		
		public function getIsImplInterfaceByInterface(cls:Class):Boolean
		{
			var clsPath:String = ReflectionUtil.getClassPath(cls);
			return getIsImplInterface(clsPath);
		}
		
		public function getIsImplInterface(interfaceString:String):Boolean
		{
			return interfaces.indexOf(interfaceString) != -1;
		}
		
		internal function getIsFirstExtendsClassByString(clsPath:String):Boolean
		{
			return extendsClass.indexOf(clsPath) == 0;
		}
		
		public function getIsFirstExtendsClass(cls:Class):Boolean
		{
			var clsPath:String = ReflectionUtil.getClassPath(cls);
			
			return getIsFirstExtendsClassByString(clsPath);
		}
		
		public function getIsExtendsClassByString(clsPath:String):Boolean
		{
			return extendsClass.indexOf(clsPath) != -1;
		}
		
		public function getIsExtendsClass(cls:Class):Boolean
		{
			var clsPath:String = ReflectionUtil.getClassPath(cls);
			
			return getIsExtendsClassByString(clsPath);
		}
		
		public function getCustomMetadatas(meta:String):Dictionary
		{
			if(metadatas[meta])
			{
				return (metadatas[meta] as MetaDataInfo).args;
			}
			return null;
		}
		
		public function getStaticMethod(method:String):MethodInfo
		{
			return staticMethods[method] as MethodInfo;
		}
		
		public function getMethod(method:String):MethodInfo
		{
			return memberMethods[method] as MethodInfo;
		}
		
		public function getProperty(prop:String):PropertyInfo
		{
			return propertys[prop] as PropertyInfo;
		}
		
		override public function analyze():void
		{
			name = StringUtil.replace(name, "::", ".");
			for(var i:uint = 0; i < interfaces.length; i++)
			{
				interfaces[i] = StringUtil.replace(interfaces[i], "::", ".");
			}
		}
		
		public function getClass():Class
		{
			if(StringUtil.isNullOrEmpty(name)) return null;
			
			return AppDomainUtil.getClass(name);
		}
		
		public function create():*
		{
			if(StringUtil.isNullOrEmpty(name)) return null;
			
			var cls:Class = AppDomainUtil.getClass(name);
			return new cls();
		}
		
		public function toString():String
		{
			var str:String = "Type " + name + ":{\n";
			
			str += "    staticConstants:[\n";
			for(var key0:String in staticConstants)
			{
				str += "        " + key0 + "\n";
			}
			str += "    ]\n";
			
			str += "    staticMethods:[\n";
			for(var key1:String in staticMethods)
			{
				str += "        " + key1 + "\n";
			}
			str += "    ]\n";
			
			str += "    memberMethods:[\n";
			for(var key2:String in memberMethods)
			{
				str += "        " + key2 + "\n";
			}
			str += "    ]\n";
			
			str += "    propertys:[\n";
			for(var key3:String in propertys)
			{
				str += "        " + key3 + "\n";
			}
			str += "    ]\n";
			
			str += "    metadatas:[\n";
			for(var key4:String in metadatas)
			{
				str += "        " + key4 + "\n";
			}
			str += "    ]\n";
			
			str += "    interfaces:[\n";
			for each(var key5:String in interfaces)
			{
				str += "        " + key5 + "\n";
			}
			str += "    ]\n";
			
			str += "}";
			
			return str;
		}
	}
}