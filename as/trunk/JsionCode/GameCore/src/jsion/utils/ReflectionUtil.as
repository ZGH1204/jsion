package jsion.utils
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	import jsion.core.reflection.*;
	
	/**
	 * 反射工具
	 * @author Jsion
	 */	
	public class ReflectionUtil
	{
		/**
		 * 获取指定类的完整类路径
		 * @param cls 类对象
		 */		
		public static function getClassPath(cls:Class):String
		{
			var xml:XML = describeType(cls);
			var n:String = String(xml.@name);
			return StringUtil.replace(n, "::", ".");
		}
		
		/**
		 * 获取指定类的类名
		 * @param cls 类对象
		 */		
		public static function getClassName(cls:Class):String
		{
			var xml:XML = describeType(cls);
			var n:String = String(xml.@name);
			n = n.split("::")[1];
			return n;
		}
		
		/**
		 * 解析类库程序集Xml信息
		 * @param catalogXml
		 */		
		public static function parseAssembly(catalogXml:XML):Assembly
		{
			return new Assembly(parseCatalogXml(catalogXml));
		}
		
		/**
		 * 解析类库内的所有类的完整类路径列表
		 * @param catalogXml
		 */		
		public static function parseCatalogXml(catalogXml:XML):Array
		{
			if(catalogXml == null) return [];
			
			var cList:Array = [];
			
			var nodes:XMLList = catalogXml.children();
			
			for (var j:int = 0; j < nodes.length(); j++)
			{
				if (nodes[j].name().localName == "libraries")
				{
					var libraries:XML = nodes[j];
					var libList:XMLList = libraries.children();
					for(var k:int = 0 ; k < libList.length(); k++)
					{
						var library:XML = libList[k];
						var classList:XMLList = library.children();
						for(var l:int = 0 ; l < classList.length(); l++)
						{
							var classDef:XML = classList[l] as XML;
							if(classDef.name().localName != "script") continue;
//							trace('asset class name: ' + StringUtil.replace(String(classDef.@name),"\/", "\."));
							cList.push(StringUtil.replace(String(classDef.@name), "\/", "\."));
						}
					}
				}
			}
			
			return cList;
		}
		
		/**
		 * 解析继承的接口列表
		 */		
		public static function parseTypeWithInterface(describeTypeXml:XML):Type
		{
			var type:Type = new Type();
			
			var factoryXml:XML = describeTypeXml.factory[0];
			
			XmlUtil.decodeWithProperty(type, describeTypeXml);
			
			type.interfaces = parseInterfaces(factoryXml);
			
			type.analyze();
			
			return type;
		}
		
		/**
		 * 解析元数据标签
		 */		
		public static function parseTypeWithMetaData(describeTypeXml:XML):Type
		{
			var type:Type = new Type();
			
			var factoryXml:XML = describeTypeXml.factory[0];
			
			XmlUtil.decodeWithProperty(type, describeTypeXml);
			
			type.metadatas = parseMetaDatas(factoryXml);
			
			type.analyze();
			
			return type;
		}
		
		/**
		 * 解析为Type对象
		 * @param describeTypeXml
		 */		
		public static function parseType(describeTypeXml:XML):Type
		{
			var type:Type = new Type();
			
			var factoryXml:XML = describeTypeXml.factory[0];
			var constructorXml:XML = factoryXml.constructor[0];
			var declaredBy:String = String(factoryXml.@type);
			
			XmlUtil.decodeWithProperty(type, describeTypeXml);
			
			type.staticConstants = parseStaticConstants(describeTypeXml);
			type.constructor = parseConstructor(constructorXml);
			type.staticMethods = parseStaticMethods(describeTypeXml);
			type.memberMethods = parseMemberMethods(factoryXml, declaredBy);
			type.extendsClass = parseExtendsClass(factoryXml, declaredBy);
			type.propertys = parsePropertys(factoryXml);
			type.metadatas = parseMetaDatas(factoryXml);
			type.interfaces = parseInterfaces(factoryXml);
			type.analyze();
			
			return type;
		}
		
		/**
		 * 解析静态常量列表
		 * @param describeTypeXml
		 */		
		public static function parseStaticConstants(describeTypeXml:XML):Dictionary
		{
			var dic:Dictionary = new Dictionary();
			var constants:XMLList = describeTypeXml.constant;
			for each(var constantXml:XML in constants)
			{
				var constant:ConstantInfo = parseStaticConstant(constantXml);
				constant.analyze();
				dic[constant.name] = constant;
			}
			return dic;
		}
		
		/**
		 * 解析静态常量信息
		 * @param constantXml
		 */		
		public static function parseStaticConstant(constantXml:XML):ConstantInfo
		{
			var constant:ConstantInfo = new ConstantInfo();
			
			XmlUtil.decodeWithProperty(constant, constantXml);
			constant.metadatas = parseMetaDatas(constantXml);
			
			return constant;
		}
		
		/**
		 * 解析构造函数信息
		 * @param constructorXml
		 */		
		public static function parseConstructor(constructorXml:XML):ConstructorInfo
		{
			var ctor:ConstructorInfo = new ConstructorInfo();
			ctor.parameters = parseParameters(constructorXml);
			ctor.analyze();
			return ctor;
		}
		
		/**
		 * 解析实现的接口列表
		 * @param factoryXml
		 */		
		public static function parseInterfaces(factoryXml:XML):Array
		{
			var list:Array = [];
			var interfaces:XMLList = factoryXml.implementsInterface;
			for each(var interfaceXml:XML in interfaces)
			{
				list.push(parseInterface(interfaceXml));
			}
			return list;
		}
		
		/**
		 * 解析实现的接口的完整类路径
		 * @param interfaceXml
		 */		
		public static function parseInterface(interfaceXml:XML):String
		{
			return interfaceXml.@type;
		}
		
		/**
		 * 解析属性列表
		 * @param factoryXml
		 */		
		public static function parsePropertys(factoryXml:XML):Dictionary
		{
			var dic:Dictionary = new Dictionary();
			
			var props:XMLList = factoryXml.accessor;
			
			var declaredBy:String = String(factoryXml.@type);
			
			for each(var propertyXml:XML in props)
			{
				var property:PropertyInfo = parseProperty(propertyXml, declaredBy);
				dic[property.name] = property;
			}
			
			props = factoryXml.variable;
			
			for each(var propXml:XML in props)
			{
				var prop:PropertyInfo = parseProperty(propXml, declaredBy);
				dic[prop.name] = prop;
			}
			
			return dic;
		}
		
		/**
		 * 解析属性信息
		 * @param propertyXml
		 * @param declaredBy
		 */		
		public static function parseProperty(propertyXml:XML, declaredBy:String):PropertyInfo
		{
			var prop:PropertyInfo = new PropertyInfo();
			
			XmlUtil.decodeWithProperty(prop, propertyXml);
			
			if(propertyXml.name() == "variable")
			{
				prop.access = AccessType.ReadWrite;
				if(prop.declaredBy == null) prop.declaredBy = declaredBy;
			}
			else if(prop.declaredBy != declaredBy)
			{
				prop.isInheri = true;
			}
			
			prop.metadatas = parseMetaDatas(propertyXml);
			
			prop.analyze();
			
			return prop;
		}
		
		/**
		 * 解析静态方法列表
		 * @param describeTypeXml
		 */		
		public static function parseStaticMethods(describeTypeXml:XML):Dictionary
		{
			var dic:Dictionary = new Dictionary();
			var staticMethods:XMLList = describeTypeXml.method;
			
			for each(var methodXml:XML in staticMethods)
			{
				var method:MethodInfo = parseMethod(methodXml);
				method.isStatic = true;
				dic[method.name] = method;
			}
			
			return dic;
		}
		
		/**
		 * 解析成员方法列表
		 * @param factoryXml
		 * @param declaredBy
		 */		
		public static function parseMemberMethods(factoryXml:XML, declaredBy:String):Dictionary
		{
			var dic:Dictionary = new Dictionary();
			var methods:XMLList = factoryXml.method;
			for each(var methodXml:XML in methods)
			{
				var method:MethodInfo = parseMethod(methodXml);
				method.isStatic = false;
				if(method.declaredBy != declaredBy) method.isInherit = true;
				dic[method.name] = method;
			}
			
			return dic;
		}
		
		/**
		 * 解析方法信息
		 * @param methodXml
		 */		
		public static function parseMethod(methodXml:XML):MethodInfo
		{
			var method:MethodInfo = new MethodInfo();
			
			XmlUtil.decodeWithProperty(method, methodXml);
			method.metadatas = parseMetaDatas(methodXml);
			method.parameters = parseParameters(methodXml);
			method.analyze();
			
			return method;
		}
		
		/**
		 * 解析继承树
		 * @param factoryXml
		 * @param declaredBy
		 */		
		public static function parseExtendsClass(factoryXml:XML, declaredBy:String):Array
		{
			var list:Array = [];
			
			var exts:XMLList = factoryXml.extendsClass;
			
			if(declaredBy.indexOf("PromiscuousModule") != -1)
				trace("asdfsf");
			
			for each(var ext:XML in exts)
			{
				var t:String = String(ext.@type);
				if(t == "Object") continue;
//				if(t.indexOf("DefaultModule") != -1)
//					trace("sadfsdf");
				list.push(StringUtil.replace(t, "::", "."));
			}
			
			return list;
		}
		
		/**
		 * 解析元数据列表
		 * @param methodXml
		 */		
		public static function parseMetaDatas(methodXml:XML):Dictionary
		{
			var xl:XMLList = methodXml.metadata;
			var dic:Dictionary = new Dictionary();
			for each(var metadataXml:XML in xl)
			{
				var metadata:MetaDataInfo = parseMetaData(metadataXml);
				dic[metadata.name] = metadata;
			}
			return dic;
		}
		
		/**
		 * 解析元数据信息
		 * @param metadataXml
		 * @return 
		 * 
		 */		
		public static function parseMetaData(metadataXml:XML):MetaDataInfo
		{
			var md:MetaDataInfo = new MetaDataInfo();
			
			XmlUtil.decodeWithProperty(md, metadataXml);
			
			var dic:Dictionary = new Dictionary();
			
			var xl:XMLList = metadataXml.arg;
			
			for each(var xml:XML in xl)
			{
				dic[String(xml.@key)] = String(xml.@value);
			}
			
			md.args = dic;
			
			md.analyze();
			
			return md;
		}
		
		/**
		 * 解析参数列表
		 * @param methodXml
		 */		
		public static function parseParameters(methodXml:XML):Vector.<ParameterInfo>
		{
			if(methodXml == null) return new Vector.<ParameterInfo>(); 
			
			var xl:XMLList = methodXml.parameter;
			
			if(xl.length() == 0) return new Vector.<ParameterInfo>();
			
			var rlt:Vector.<ParameterInfo> = new Vector.<ParameterInfo>(xl.length());
			
			for each(var parameterXml:XML in xl)
			{
				var p:ParameterInfo = parseParameter(parameterXml);
				rlt[p.index - 1] = p;
			}
			
			return rlt;
		}
		
		/**
		 * 解析参数信息
		 * @param parameterXml
		 */		
		public static function parseParameter(parameterXml:XML):ParameterInfo
		{
			var p:ParameterInfo = new ParameterInfo();
			XmlUtil.decodeWithProperty(p, parameterXml);
			p.analyze();
			return p;
		}
	}
}