package jsion.reflection
{
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	import jsion.utils.*;

	/**
	 * 类类型
	 * @author Jsion
	 * 
	 */	
	public class Type extends ReflectionInfo
	{
		/**
		 * 类的完全限定名 包含包路径
		 */		
		public var name:String;
		/**
		 * 继承的基类
		 */		
		public var base:String;
		/**
		 * 静态常量表
		 */		
		public var staticConstants:Dictionary;
		/**
		 * 构造函数信息
		 */		
		public var constructor:ConstructorInfo;
		/**
		 * 静态方法列表
		 */		
		public var staticMethods:Dictionary;
		/**
		 * 成员方法列表
		 */		
		public var memberMethods:Dictionary;
		/**
		 * 继承树
		 */		
		public var extendsClass:Array;
		/**
		 * 成员属性列表
		 */		
		public var propertys:Dictionary;
		/**
		 * 元数据列表
		 */		
		public var metadatas:Dictionary;
		/**
		 * 实现的接口列表
		 */		
		public var interfaces:Array;
		
		/**
		 * 指定当前类是否实现指定接口
		 * @param cls 接口类
		 */		
		public function getIsImplInterfaceByInterface(cls:Class):Boolean
		{
			var clsPath:String = ReflectionUtil.getClassPath(cls);
			return getIsImplInterface(clsPath);
		}
		
		/**
		 * 指定当前类是否实现指定接口
		 * @param cls 接口类完全限制名 包含包路径
		 */		
		public function getIsImplInterface(interfaceString:String):Boolean
		{
			return interfaces.indexOf(interfaceString) != -1;
		}
		
		/**
		 * 指示是否直接继承指定类
		 * @param clsPath 指定类完全限制名 包含包路径
		 */		
		internal function getIsFirstExtendsClassByString(clsPath:String):Boolean
		{
			return extendsClass.indexOf(clsPath) == 0;
		}
		
		/**
		 * 指示是否直接继承指定类
		 * @param cls 指定类
		 */		
		public function getIsFirstExtendsClass(cls:Class):Boolean
		{
			var clsPath:String = ReflectionUtil.getClassPath(cls);
			
			return getIsFirstExtendsClassByString(clsPath);
		}
		
		/**
		 * 指示是否继承指定类
		 * @param clsPath 指定类完全限制名 包含包路径
		 */		
		public function getIsExtendsClassByString(clsPath:String):Boolean
		{
			return extendsClass.indexOf(clsPath) != -1;
		}
		
		/**
		 * 指示是否继承指定类
		 * @param cls 指定类
		 */		
		public function getIsExtendsClass(cls:Class):Boolean
		{
			var clsPath:String = ReflectionUtil.getClassPath(cls);
			
			return getIsExtendsClassByString(clsPath);
		}
		
		/**
		 * 获取指定名称的元数据信息
		 * @param meta 元数据名称
		 * @return 元数据参数列表
		 * 
		 */		
		public function getCustomMetadatas(meta:String):Dictionary
		{
			if(metadatas[meta])
			{
				return (metadatas[meta] as MetaDataInfo).args;
			}
			return null;
		}
		
		/**
		 * 获取指定静态方法信息
		 * @param method 方法名称
		 */		
		public function getStaticMethod(method:String):MethodInfo
		{
			return staticMethods[method] as MethodInfo;
		}
		
		/**
		 * 获取指定成员方法信息
		 * @param method 方法名称
		 */		
		public function getMethod(method:String):MethodInfo
		{
			return memberMethods[method] as MethodInfo;
		}
		
		/**
		 * 获取指定属性信息
		 * @param prop 属性名
		 */		
		public function getProperty(prop:String):PropertyInfo
		{
			return propertys[prop] as PropertyInfo;
		}
		
		/**
		 * @inheritDoc
		 * 
		 */		
		override public function analyze():void
		{
			name = StringUtil.replace(name, "::", ".");
			for(var i:uint = 0; i < interfaces.length; i++)
			{
				interfaces[i] = StringUtil.replace(interfaces[i], "::", ".");
			}
		}
		
		/**
		 * 获取类
		 */		
		public function getClass():Class
		{
			if(StringUtil.isNullOrEmpty(name)) return null;
			
			return AppDomainUtil.getClass(name);
		}
		
		/**
		 * 创建此类的对象实例
		 */		
		public function create():*
		{
			if(StringUtil.isNullOrEmpty(name)) return null;
			
			var cls:Class = AppDomainUtil.getClass(name);
			return new cls();
		}
		
		/**
		 * 对象的字符串形式
		 */		
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