package export
{
	import com.childoftv.xlsxreader.Worksheet;
	
	import data.Config;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.controls.Alert;
	
	import utils.MyStringUtils;

	public class LuaExport extends Export
	{
		public function LuaExport(path:String)
		{
			super(path);
		}
		
		override protected function saveClass(sheet:Worksheet):void
		{
			super.saveClass(sheet);
						
			var file:File = new File(File.applicationDirectory.nativePath + "/" + Config.TEMPPATH_LUA);
			if(file.exists)
			{
				var fs:FileStream = new FileStream();
				fs.open(file,FileMode.READ);
				var content:String = fs.readUTFBytes(fs.bytesAvailable);
				fs.close();
				var newFile:File = new File(Config.TEMPLATE_CLASS_PATH + "/" + _fileName + "Template.lua");
				var newFs:FileStream = new FileStream();
				if(newFile.exists)
				{
					newFs.open(newFile,FileMode.UPDATE);
					var tmp:String = newFs.readUTFBytes(newFs.bytesAvailable);
					var index1:int = tmp.indexOf(Config.LUA_START_TAG);
					var index2:int = tmp.indexOf(Config.LUA_END_TAG);
					var index3:int = content.indexOf(Config.LUA_START_TAG);
					var index4:int = content.indexOf(Config.LUA_END_TAG);
					if(index1 == -1 || index2 == -1 || index3 == -1 || index4 == -1)
					{
						Alert.show("已存在的模版表" + _fileName + "，不存在开始或者结束标签,内容被重写,请检查后再第二次发布");
						var newFile2:File = new File(Config.TEMPLATE_CLASS_PATH + "/" + _fileName + "Template.lua.bak");
						var newFs2:FileStream = new FileStream();
						newFs2.open(newFile2,FileMode.WRITE);
						newFs2.writeUTFBytes(tmp);
						newFs2.close();
					}else
					{
						var t1:String = tmp.substring(index1,index2);
						var t2:String = content.substring(index3,index4);
						content = tmp.replace(t1,t2);
					}
					
				}else
				{
					newFs.open(newFile,FileMode.UPDATE);
				}
				
				content = content.replace(Config.RE_DES,sheet.getCellValue("A1"));
				content = content.replace(Config.RE_TEMPLATE_NAME,_fileName);
				var temp = _fileName.charAt(0).toLocaleLowerCase() + _fileName.substr(1);
				content = content.replace(Config.RE_TEMPLATE_NAME_FIRST_LOWER,temp);
				
				var varStr:String = "";
				var parseStr:String = "";
				for (var i:int = 1; i < COLS.length; i++) 
				{
					var value:String = sheet.getCellValue(COLS[i] + "2");
					var excelTypeStr:String = sheet.getCellValue(COLS[i] + "3");
					var desStr:String = sheet.getCellValue(COLS[i] + "4");
					if(value == "")break;
					if(value == "templateId")continue; //lua模板的实现逻辑里面，父类有处理过，其他模板暂未作此处理
					
					var typeStr:String = excelTypeStr;
					switch(excelTypeStr)
					{
						//byte;short;int;long;bool;string
						case "byte":
							parseStr += "self." + value + " = bytes:readByte()";
							break;
						case "short":
							parseStr += "self." + value + " = bytes:readShort()";
							break;
						case "int":
							parseStr += "self." + value + " = bytes:readInt()";
							break;
						case "long":
							parseStr += "self." + value + " = bytes:readLong()";
							break;
						case "float":
							parseStr += "self." + value + " = bytes:readFloat()";
							break;
						case "boolean":
							typeStr = "bool";
							parseStr += "self." + value + " = bytes:readBoolean()";
							break;
						case "string":
							parseStr += "self." + value + " = bytes:readString()";
							break;
						case "array": //逗号分隔的数组
							parseStr += "self." + value + " = gg_string_split(bytes:readString(),',')";
							break;
						case "intArray"://逗号分隔的数字数组
							parseStr += "self." + value + " = gg_string_split_2number(bytes:readString(),',')";
							break;
					}
					parseStr += "\n\t";
					
					if(typeStr == "")
					{
						typeStr = "object";
						Alert.show("发现未设置的类型" + _fileName + "," + (COLS[i] + "3"));
					}
					
					varStr += "self." + value + " = nil";
					if(desStr != "")
					{
						varStr += "\t-- " + MyStringUtils.removeNewLine(desStr);
					}
					varStr += "\n\t";
				}
				
				content = content.replace(Config.RP_VAR,varStr);
				content = content.replace(Config.RP_PARSE,parseStr);
				content = content.replace(Config.RP_ID,sheet.getCellValue("B2"));
				
				newFs.position = 0;
				newFs.truncate();
				newFs.writeUTFBytes(content);
				newFs.close();
			}
		}
	}
}