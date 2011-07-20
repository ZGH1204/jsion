package
{
	/* 
	<type name="TestCls" base="Object" isDynamic="false" isFinal="false" isStatic="false">
	  <extendsClass type="Object"/>
	  <accessor name="Name" access="readwrite" type="String" declaredBy="TestCls"/>
	  <variable name="NickName" type="String"/>
	  <accessor name="Age" access="readwrite" type="int" declaredBy="TestCls"/>
	  <variable name="Sex" type="String"/>
	  <method name="setName" declaredBy="TestCls" returnType="void">
	    <parameter index="1" type="String" optional="false"/>
	  </method>
	</type>

	 */
	public class TestCls
	{
		public function TestCls()
		{
		}
		
		public var NickName:String;
		
		private var _name:String;
		
		public function get Name():String
		{
			return _name;
		}
		public function set Name(value:String):void
		{
			_name = value;
		}
		
		private var _age:int;
		
		public function get Age():int
		{
			return _age;
		}
		public function set Age(value:int):void
		{
			_age = value;
		}
		
		public var Sex:String;
		
		public function setName(value:String):void
		{
			_name = value;
		}
	}
}