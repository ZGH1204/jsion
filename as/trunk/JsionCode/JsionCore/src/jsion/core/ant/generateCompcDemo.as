package jsion.core.ant
{
	/**
	 * <p>生成编译SWC类库的Ant脚本字符串</p>
	 * @param antName 脚本名称
	 * @param targetRoot 存放编译类库的根目录
	 * @param projectRoot 项目根目录
	 * @param refLibsDirs 引用第三方类库所在的目录
	 * @param genLibs 要生成的类库信息
	 * 	<table>
     *		<th>Property name</th>
     *		<th>Data type</th>
     *		<th>Description</th>
	 * 		<tr>
	 * 			<td>lib</td>
	 * 			<td>String</td>
	 * 			<td>src目录的父目录名</td>
	 * 		</tr>
	 * 		<tr>
	 * 			<td>output</td>
	 * 			<td>String</td>
	 * 			<td>类库的文件名</td>
	 * 		</tr>
	 * 		<tr>
	 * 			<td>sources</td>
	 * 			<td>Array</td>
	 * 			<td>其他源路径列表，源路径中src目录的父目录名。</td>
	 * 		</tr>
	 * 	</table>
	 * @param refDir 临时引用目录
	 * @param outDir 输出目录
	 * @param flexHome SDK目录
	 * @return Ant脚本字符串
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 */	
	public function generateCompcDemo(antName:String, targetRoot:String, projectRoot:String, refLibsDirs:Array, genLibs:Array, refDir:String, outDir:String, flexHome:String):String
	{
		//var antName:String = "Publish PTP";
		//var targetRoot:String = "C:\/Users\/Jsion\/Desktop";
		//var projectRoot:String = "F:\/PTPProject\/ptpsvn\/client\/trunk";
		//var flexHome:String = "D:\/Program Files\/Adobe\/Adobe Flash Builder 4\/sdks\/4.0.0";
		//var refDir:String = "ref";
		//var outDir:String = "release";
		
		var generator:GenerateCompcAnt = new GenerateCompcAnt(antName, targetRoot, projectRoot, flexHome, refDir, outDir);
		
		for each(var dir:String in refLibsDirs)
		{
			generator.addReference(dir);
		}
		//generator.addReference("PTPAssets/libs");
		//generator.addReference("PTPAssets/assets");
		
		for each(var obj:Object in genLibs)
		{
			var args:Array = [];
			args.push(obj["lib"]);
			obj["output"] = obj["output"] || obj["lib"]
			args.push(obj["output"]);
			if(obj["sources"] is Array && obj["sources"].length > 0)
				args.push.apply(null, obj["sources"]);
			generator.addLib.apply(null, args); 
		}
		
		//generator.addLib("PTPCore");
		//generator.addLib("PTPLoginScene");
		//generator.addLib("PTPGameScene");
		
		//generator.addLib("PTPStartLib", "ptp.swc", "PTPCore", "PTPStart");
		
		return generator.generateAntScript();
	}
}