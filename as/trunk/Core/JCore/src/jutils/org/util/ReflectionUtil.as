package jutils.org.util
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	import jutils.org.reflection.*;

	public class ReflectionUtil
	{
		public static function getClassPath(cls:Class):String
		{
			var xml:XML = describeType(cls);
			var n:String = String(xml.@name);
			return StringUtil.replace(n, "::", ".");
		}
		
		public static function getClassName(cls:Class):String
		{
			var xml:XML = describeType(cls);
			var n:String = String(xml.@name);
			n = n.split("::")[1];
			return n;
		}
		
		public static function parseAssembly(catalogXml:XML):Assembly
		{
			return new Assembly(parseCatalogXml(catalogXml));
		}
		
		public static function parseCatalogXml(catalogXml:XML):Vector.<String>
		{
			if(catalogXml == null) return new Vector.<String>();
			
			var cList:Vector.<String> = new Vector.<String>();
			
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
			type.propertys = parsePropertys(factoryXml);
			type.metadatas = parseMetaDatas(factoryXml);
			type.interfaces = parseInterfaces(factoryXml);
			type.analyze();
			
			return type;
		}
		
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
		
		public static function parseStaticConstant(constantXml:XML):ConstantInfo
		{
			var constant:ConstantInfo = new ConstantInfo();
			
			XmlUtil.decodeWithProperty(constant, constantXml);
			constant.metadatas = parseMetaDatas(constantXml);
			
			return constant;
		}
		
		public static function parseConstructor(constructorXml:XML):ConstructorInfo
		{
			var ctor:ConstructorInfo = new ConstructorInfo();
			ctor.parameters = parseParameters(constructorXml);
			ctor.analyze();
			return ctor;
		}
		
		public static function parseInterfaces(factoryXml:XML):Vector.<String>
		{
			var list:Vector.<String> = new Vector.<String>();
			var interfaces:XMLList = factoryXml.implementsInterface;
			for each(var interfaceXml:XML in interfaces)
			{
				list.push(parseInterface(interfaceXml));
			}
			return list;
		}
		
		public static function parseInterface(interfaceXml:XML):String
		{
			return interfaceXml.@type;
		}
		
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
		
		public static function parseMethod(methodXml:XML):MethodInfo
		{
			var method:MethodInfo = new MethodInfo();
			
			XmlUtil.decodeWithProperty(method, methodXml);
			method.metadatas = parseMetaDatas(methodXml);
			method.parameters = parseParameters(methodXml);
			method.analyze();
			
			return method;
		}
		
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
		
		public static function parseParameter(parameterXml:XML):ParameterInfo
		{
			var p:ParameterInfo = new ParameterInfo();
			XmlUtil.decodeWithProperty(p, parameterXml);
			p.analyze();
			return p;
		}
	}
}