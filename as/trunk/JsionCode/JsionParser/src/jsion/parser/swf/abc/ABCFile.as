package jsion.parser.swf.abc
{
	import flash.utils.ByteArray;
	
	import jsion.parser.swf.Reader;

	public class ABCFile extends Reader
	{
		/*
		abcFile
		{
		u16 minor_version
		
		u16 major_version
		
		cpool_info constant_pool
		
		u30 method_count
		method_info method[method_count]
		
		u30 metadata_count
		metadata_info metadata[metadata_count]
		
		u30 class_count
		instance_info instance[class_count]
		class_info class[class_count]
		
		u30 script_count
		script_info script[script_count]
		
		u30 method_body_count
		method_body_info method_body[method_body_count]
		}		
		*/
		
		public var minorVer:uint;
		
		public var majorVer:uint;
		
		public var constant_pool:Cpool_info;
		
		public var method_count:uint;
		public var method:Array = [];
		
		public var metadata_count:uint;
		public var metadata:Array = [];
		
		public var class_count:uint;
		public var instance:Array = [];
		public var classes:Array = [];
		
		public var script_count:uint;
		public var script:Array = [];
		
		public var method_body_count:uint;
		public var method_body:Array = [];
		
		
		public function ABCFile(data:ByteArray):void
		{
			this.data = data;
		}
		
		override protected function read():void
		{
			var i:int = 0;
			
			minorVer = readUnsignedShort();
			majorVer = readUnsignedShort();
			
			constant_pool = new Cpool_info(data);
			
			method_count = readUnsigned30();
			for(i = 0; i < method_count; i++)
			{
				method.push(new Method_info(data));
			}
			
			metadata_count = readUnsigned30();
			for(i = 0; i < metadata_count; i++)
			{
				metadata.push(new Metadata_info(data));
			}
			
			class_count = readUnsigned30();
			for(i = 0; i < class_count; i++)
			{
				instance.push(new Instance_info(data));
			}
			for(i = 0; i < class_count; i++)
			{
				classes.push(new Class_info(data));
			}
			
			script_count = readUnsigned30();
			for(i = 0; i < script_count; i++)
			{
				script.push(new Script_info(data));
			}
			
			method_body_count = readUnsigned30();
			for(i = 0; i < method_body_count; i++)
			{
				method_body.push(new Method_body_info(data));
			}
		}
	}
}