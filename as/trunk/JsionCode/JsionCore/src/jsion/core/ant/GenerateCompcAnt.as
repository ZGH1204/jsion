package jsion.core.ant
{
	import jsion.utils.*;

	/**
	 * 生成编译SWC类库的Ant脚本字符串
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public class GenerateCompcAnt
	{
		private var antName:String, targetRootDir:String, projectRootDir:String, flexSDKDir:String, refDir:String, outDir:String;
		
		private var referencesDir:Vector.<String>;
		private var libsList:Vector.<String>;
		private var libsOutList:Vector.<String>;
		private var otherSourceList:Array;
		
		private var antDeclareTemplate:String = "<?xml version=\"1.0\"?>\n" +
			"<project name=\"{0}\" default=\"main\">\n" +
			"    <property name=\"DESKTOP_HOME\" value=\"{1}\" />\n" +
			"    <property name=\"PROJECT_ROOT\" value=\"{2}\" />\n" +
			"    <property name=\"FLEX_HOME\" value=\"{3}\" />\n" +
			"    <taskdef resource=\"flexTasks.tasks\" classpath=\"${FLEX_HOME}/ant/lib/flexTasks.jar\" />\n" +
			"    <property name=\"REF_DIR\" value=\"${DESKTOP_HOME}/{5}\" />\n" +
			"    <property name=\"OUT_DIR\" value=\"${DESKTOP_HOME}/{6}\" />\n" +
			"    \n" +
			"    <target name=\"clean\">\n" +
			"        <delete dir=\"${REF_DIR}\"></delete>\n" +
			"        <delete dir=\"${OUT_DIR}\"></delete>\n" +
			"    </target>\n" +
			"    <target name=\"CopyReferences\">\n" +
			"        {7}\n" +
			"    </target>\n" +
			"    <target name=\"main\">\n" +
			"        <antcall target=\"clean\"></antcall>\n" +
			"        <echo>Clean release dir and refrence dir complete..</echo>\n" +
			"        \n" +
			"        <antcall target=\"CopyReferences\"></antcall>\n" +
			"        <echo>Rebuild refrence dir complete..</echo>\n" +
			"        \n" +
			"        {8}\n" +
			"        \n" +
			"        <delete dir=\"${REF_DIR}\"></delete>\n" +
			"    </target>\n" +
			"    \n" +
			"    {9}\n" +
			"</project>";
		
		private var referenceFilesetTemplate:String = "" +
			"            <fileset dir=\"${PROJECT_ROOT}/{0}\">\n" +
			"                <include name=\"**/*.swc\" />\n" +
			"            </fileset>\n";
		
		public function GenerateCompcAnt(antName:String, targetRootDir:String, projectRootDir:String, flexSDKDir:String, refDir:String, outDir:String)
		{
			this.antName = antName;
			this.targetRootDir = targetRootDir;
			this.projectRootDir = projectRootDir;
			this.flexSDKDir = flexSDKDir;
			this.refDir = refDir;
			this.outDir = outDir;
			
			referencesDir = new Vector.<String>();
			libsList = new Vector.<String>();
			libsOutList = new Vector.<String>();
			otherSourceList = [];
		}
		
		public function addReference(dir:String):void
		{
			if(referencesDir.indexOf(dir) == -1) referencesDir.push(dir);
		}
		
		public function clearReference():void
		{
			referencesDir = new Vector.<String>();
		}
		
		private function generateReferenceTarget():String
		{
			if(referencesDir.length == 0) return "";
			
			var filesets:String = "" +
				"        <copy todir=\"${REF_DIR}\" overwrite=\"true\">\n";
			for each(var str:String in referencesDir)
			{
				filesets += StringUtil.format(referenceFilesetTemplate, str);
			}
			filesets += "" +
				"        </copy>\n";
			
			return filesets;
		}
		
		/**
		 * 添加要生成的库信息
		 * @param libName swc类库名
		 * @param outName 类库输出文件名
		 * @param otherSources 其他源路径
		 * 
		 */		
		public function addLib(libName:String, outName:String = null, ...otherSources):void
		{
			if(StringUtil.isNullOrEmpty(libName)) return;
			
			libsList.push(libName);
			
			if(StringUtil.isNullOrEmpty(outName))
				libsOutList.push(libName + ".swc");
			else
				libsOutList.push(outName);
			
			otherSourceList.push(otherSources);
		}
		
		public function clearLib():void
		{
			libsList = new Vector.<String>();
			libsOutList = new Vector.<String>();
			otherSourceList = [];
		}
		
		private var complierFilesetTemplate:String = "" +
			"        <fileset dir=\"${PROJECT_ROOT}/{0}/src/\">\n" +
			"            <include name=\"**/*.as\" />\n" +
			"        </fileset>\n";
		
		private function generateComplierOtherFilesets(index:int):String
		{
			var fileset:String = "";
			
			var array:Array = otherSourceList[index] as Array;
			
			for each(var str:String in array)
			{
				fileset += StringUtil.format(complierFilesetTemplate, str);
			}
			
			return fileset;
		}
		
		private var translateStrTemplate:String = "" +
			"        <map from=\"${PROJECT_ROOT}/{0}/src/\" to=\"\" />\n";
		
		private function generateTranslateStr(index:int):String
		{
			var translateStr:String = "";
			
			var array:Array = otherSourceList[index] as Array;
			
			for each(var str:String in array)
			{
				translateStr += StringUtil.format(translateStrTemplate, str);
			}
			
			return translateStr;
		}
		
		private var complierSourcePathTemplate:String = "" +
			"            <source-path path-element=\"${PROJECT_ROOT}/{0}/src/\" />\n";
		
		private function complierSourcePath(index:int):String
		{
			var sourcePaths:String = "";
			
			var array:Array = otherSourceList[index] as Array;
			
			for each(var str:String in array)
			{
				sourcePaths += StringUtil.format(complierSourcePathTemplate, str);
			}
			
			return sourcePaths;
		}
		
		private var generateComplierTargetTempate:String = "" +
			"    <property name=\"libPath_{0}\" value=\"${PROJECT_ROOT}/{1}/src/\" />\n" +
			"    <property name=\"out_name_{0}\" value=\"{2}\" />\n" +
			"    <path id=\"src.files_{0}\">\n" +
			"        <fileset dir=\"${libPath_{0}}\">\n" +
			"            <include name=\"**/*.as\" />\n" +
			"        </fileset>\n" +
			"        {3}\n" +
			"    </path>\n" +
			"    <pathconvert property=\"src.class_{0}\" pathsep=\" \" dirsep=\".\" refid=\"src.files_{0}\" >\n" +
			"        <map from=\"\\\" to=\"\/\" />\n" +
			"        <map from=\"${libPath_{0}}\" to=\"\" />\n" +
			"        {4}\n" +
			"        <mapper>\n" +
			"            <chainedmapper>\n" +
			"                <globmapper from=\"*.as\" to=\"*\" />\n" +
			"            </chainedmapper>\n" +
			"        </mapper>\n" +
			"    </pathconvert>\n" +
			"    <target name=\"Build{1}\">\n" +
			"        <compc output=\"${OUT_DIR}/${out_name_{0}}\" include-classes=\"${src.class_{0}}\">\n" +
			"            <external-library-path dir=\"${REF_DIR}\" append=\"true\">\n" +
			"                <include name=\"**/*.swc\" />\n" +
			"            </external-library-path>\n" +
			"            <source-path path-element=\"${libPath_{0}}\" />\n" +
			"            {5}\n" +
			"        </compc>\n" +
			"        <copy file=\"${OUT_DIR}/${out_name_{0}}\" todir=\"${REF_DIR}\" overwrite=\"true\"></copy>\n" +
			"    </target>\n\n";
		
		private function generateComplierTarget():String
		{
			if(libsList.length == 0) return "";
			
			var complierStr:String = "";
			
			for(var i:int = 0; i < libsList.length; i++)
			{
				var complierOtherFileset:String = generateComplierOtherFilesets(i);
				complierOtherFileset = StringUtil.trim(complierOtherFileset);
				
				var translateStr:String = generateTranslateStr(i);
				translateStr = StringUtil.trim(translateStr);
				
				var sourcePaths:String = complierSourcePath(i);
				sourcePaths = StringUtil.trim(sourcePaths);
				
				complierStr += StringUtil.format(generateComplierTargetTempate, i, libsList[i], libsOutList[i], complierOtherFileset, translateStr, sourcePaths);
			}
			
			return complierStr;
		}
		
		private var targetCallTemplate:String = "" +
			"        <antcall target=\"Build{0}\"></antcall>\n" +
			"        <echo>Build {0} complete..</echo>\n\n";
		
		private function generateTargetCall():String
		{
			if(libsList.length == 0) return "";
			
			var callStr:String = "";
			
			for(var i:int = 0; i < libsList.length; i++)
			{
				callStr += StringUtil.format(targetCallTemplate, libsList[i]);
			}
			
			return callStr;
		}
		
		public function setAntName(name:String):void
		{
			antName = name;
		}
		
		public function generateAntScript():String
		{
			if(libsList.length == 0) return "";
			
			var antScript:String = "";
			
			var referenceStr:String = generateReferenceTarget();
			referenceStr = StringUtil.trim(referenceStr);
			
			var targetCallStr:String = generateTargetCall();
			targetCallStr = StringUtil.trim(targetCallStr);
			
			var targetComplierStr:String = generateComplierTarget();
			targetComplierStr = StringUtil.trim(targetComplierStr);
			
			antScript = StringUtil.format(antDeclareTemplate, antName, targetRootDir, projectRootDir, flexSDKDir, "", refDir, outDir, referenceStr, targetCallStr, targetComplierStr);
			
			return antScript;
		}
		
		public function reset():void
		{
			clearReference();
			clearLib();
			antName = "";
		}
	}
}