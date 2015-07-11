package export
{
	import com.childoftv.xlsxreader.Worksheet;
	
	import data.Config;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.controls.Alert;
	
	import utils.DateUtil;
	import utils.MyLog;

	/**
	 * 导出c#模版 
	 * @author zezebao
	 */	
	public class CSExport extends Export
	{
		public function CSExport(path:String)
		{
			super(path);
		}
		
		override protected function saveClass(sheet:Worksheet):void
		{
			saveCS(sheet);
		}
		
		/**
		 * 保存c＃文件 
		 */		
		private function saveCS(sheet:Worksheet):void
		{
			var file:File = new File(File.applicationDirectory.nativePath + "/" + Config.TEMPPATH_CS);
			if(file.exists)
			{
				var fs:FileStream = new FileStream();
				fs.open(file,FileMode.READ);
				var content:String = fs.readUTFBytes(fs.bytesAvailable);
				fs.close();
				var newFile:File = new File(Config.TEMPLATE_CLASS_PATH + "/" + _fileName + "TemplateInfo.cs");
				var newFs:FileStream = new FileStream();
				if(newFile.exists)
				{
					newFs.open(newFile,FileMode.UPDATE);
					var tmp:String = newFs.readUTFBytes(newFs.bytesAvailable);
					var index1:int = tmp.indexOf(Config.START_TAG);
					var index2:int = tmp.indexOf(Config.END_TAG);
					var index3:int = content.indexOf(Config.START_TAG);
					var index4:int = content.indexOf(Config.END_TAG);
					if(index1 == -1 || index2 == -1 || index3 == -1 || index4 == -1)
					{
						Alert.show("已存在的模版表" + _fileName + "，不存在开始或者结束标签,内容被重写,请检查后再第二次发布");
						var newFile2:File = new File(Config.TEMPLATE_CLASS_PATH + "/" + _fileName + "TemplateInfo.cs.bak");
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
				
				content = content.replace(Config.RP_DES,sheet.getCellValue("A1"));
				content = content.replace(Config.RP_TEMPLATE_NAME,_fileName);
				
				var varStr:String = "";
				var parseStr:String = "";
				for (var i:int = 1; i < COLS.length; i++) 
				{
					var value:String = sheet.getCellValue(COLS[i] + "2");
					var excelTypeStr:String = sheet.getCellValue(COLS[i] + "3");
					var desStr:String = sheet.getCellValue(COLS[i] + "4");
					if(value == "")break;
					
					var typeStr:String = excelTypeStr;
					switch(excelTypeStr)
					{
						//byte;short;int;long;bool;string
						case "byte":
							parseStr += value + " = bytes.ReadByte();";
							break;
						case "short":
							parseStr += value + " = bytes.ReadShort();";
							break;
						case "int":
							parseStr += value + " = bytes.ReadInt();";
							break;
						case "long":
							parseStr += value + " = bytes.ReadLong();";
							break;
						case "float":
							parseStr += value + " = bytes.ReadFloat();";
							break;
						case "boolean":
							typeStr = "bool";
							parseStr += value + " = bytes.ReadBoolean();";
							break;
						case "string":
							parseStr += value + " = bytes.ReadString();";
							break;
					}
					parseStr += "\n\t\t";
					
					if(typeStr == "")
					{
						typeStr = "object";
						Alert.show("发现未设置的类型" + _fileName + "," + (COLS[i] + "3"));
					}
					
					if(desStr != "")
					{
						varStr += "/// <summary>";
						varStr += "\n\t/// " + desStr;
						varStr += "\n\t/// </summary>";
						varStr += "\n\t";
					}
					varStr += "public " + typeStr + " " + value + ";";
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