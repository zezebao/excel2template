package data
{
	import export.CPlusPlusExport;
	import export.CSExport;
	import export.LuaExport;
	import export.ServerJavaExport;
	
	import flash.filesystem.File;
	import flash.net.SharedObject;
	
	import mx.collections.ArrayList;

	public class Config
	{
		public static const SO_LOCAL_NAME:String = "excel2temp__003_";
		
		/**总输出次数，缓存本地*/
		public static var exportIndex:int = 1;
		
		//--项目类型预定义----
		public static const TYPE_CPP:int = 0;
		public static const TYPE_CS:int = 1;
		public static const TYPE_LUA:int = 2;
		public static const TYPE_AS:int = 3;
		public static const TYPE_SERVER_JAVA:int = 4;
		public static const TYPE_JAVA:int = 5;
		
		/**输出类型列表*/
		public static const OUT_DATA:ArrayList = new ArrayList([
				{"label":"C++","value":TYPE_CPP,"cls":CPlusPlusExport},
				{"label":"C#","value":TYPE_CS,"cls":CSExport},
				{"label":"Lua","value":TYPE_LUA,"cls":LuaExport},
				{"label":"AS3","value":TYPE_AS,"cls":null},
				{"label":"SERVER_JAVA","value":TYPE_SERVER_JAVA,"cls":ServerJavaExport},
				{"label":"JAVA","value":TYPE_JAVA,"cls":null},
			]);
		
		//--模版标签
		public static const START_TAG:String = "//startBuild"; //开始标签
		public static const END_TAG:String = "//endBuild"; //结束标签
		public static const LUA_START_TAG:String = "--startBuild"; //开始标签
		public static const LUA_END_TAG:String = "--endBuild"; //结束标签
		
		public static const RP_DES:String = "{@des}"; //描述标签
		public static const RP_TEMPLATE_NAME:String = "{@templateName}"; //模版表名
		public static const RP_TEMPLATE_NAME_FIRST_LOWER:String = "{@templateName_first_lower}"; //首字母小写
		public static const RP_TEMPLATE_NAME_LOWER:String = "{@templateName_lower}"; //首字母小写
		public static const RP_TABLE_NAME:String = "{@table_name}"; //服务器表名
		public static const RP_ID:String = "{@id}"; //id字段名
		public static const RP_VAR:String = "{@startVar}"; //变量开始标记
		public static const RP_PARSE:String = "{@startParse}"; //解析开始标记
		
		
		public static const RE_DES:RegExp = /{@des}/g; //描述标签
		public static const RE_TEMPLATE_NAME:RegExp = /{@templateName}/g; //模版表名
		public static const RE_TEMPLATE_NAME_FIRST_LOWER:RegExp = /{@templateName_first_lower}/g; //首字母小写
		public static const RE_TABLE_NAME:RegExp = /{@table_name}/g; //首字母小写
		public static const RE_ID:RegExp = /{@id}/g; //id字段名
		public static const RE_VAR:RegExp = /{@startVar}/g; //变量开始标记
		public static const RE_PARSE:RegExp = /{@startParse}/g; //解析开始标记
		
		//---模版
		public static const TEMPPATH_CS:String = "templates/C#.temp"; //c#模版
		public static const TEMPPATH_CPP_H:String = "templates/Cpp_h.temp"; //cpp_header模版
		public static const TEMPPATH_CPP:String = "templates/Cpp.temp"; //cpp模版
		public static const TEMPPATH_LUA:String = "templates/Lua.temp"; //lua模版
		
		public static const TEMPPATH_SERVER_JAVA1:String = "templates/ServerJava_Template.temp";
		public static const TEMPPATH_SERVER_JAVA2:String = "templates/ServerJava_TemplateList.temp";
		
		
		//-------------------------------------------------
		//--兼容以前代码，先不删除...
		/**是否输出类文件*/
		public static var IS_EXPORT_CLASS:Boolean = true;
		/**是否zlib压缩*/
		public static var IS_ZLIB:Boolean = true;
		/**输出类型*/
		public static var OUT_TYPE:int = 0;
		/**输出模版表数据的位置*/		
		public static var TEMPLATE_PATH:String = "";
		/**输出模版表类的位置*/		
		public static var TEMPLATE_CLASS_PATH:String = "";
		/**输出二进制数据位置*/		
		public static var TEMPLATE_BINARY_PATH:String = "";
		//-------------------------------------------------
		
		
		public static function setup():void
		{
			updateProjList();
		}
		
		//------------------------------------------------------------
		
		private static var _projList:Vector.<ProjInfo> = new Vector.<ProjInfo>();
		
		public static function updateProjList():void
		{
			_projList = new Vector.<ProjInfo>();
			
			var file:File = new File(File.applicationDirectory.nativePath + "/projs");
			if(file.exists)
			{
				var arr:Array = file.getDirectoryListing();
				for (var i:int = 0; i < arr.length; i++) 
				{
					var inFile:File = arr[i] as File;
					var fileName:String = inFile.name.replace(inFile.type,"");
					var projInfo:ProjInfo = new ProjInfo(fileName);
					
					_projList.push(projInfo);
				}
			}
		}
		
		public static function getProjList():Vector.<ProjInfo>
		{
			return _projList;
		}
	}
}