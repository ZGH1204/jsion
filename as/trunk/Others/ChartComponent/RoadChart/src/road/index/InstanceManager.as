package road.index
{
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	public class InstanceManager
	{
		private static var instances:Dictionary = new Dictionary();
		
		public function InstanceManager(limit:singletonLimit)
		{
		}
        
        public static function createSingletonInstance(param1:*):*
        {
            return createUniqueInstance(param1, "singleton");
        }
		
		public static function createInstance(param1:*):*
        {
            if (param1 is String)
            {
                param1 = getClass(param1);
            }
            if (param1 is Class)
            {
                return new param1;
            }
            return param1;
        }
        
        public static function createUniqueInstance(param1:*, param2:*):*
        {
            if (param1 is String)
            {
                param1 = getClass(param1);
            }
            if (param1 is Class)
            {
                if (instances[param1] == null)
                {
                    instances[param1] = new Dictionary();
                }
                if (instances[param1][param2] == null)
                {
                    instances[param1][param2] = createInstance(param1);
                }
                return instances[param1][param2];
            }
            return param1;
        }
        
		public static function getClass(param1:String) : Class
        {
            return ApplicationDomain.currentDomain.getDefinition(param1) as Class;
        }
	}
}

class singletonLimit
{
	
}