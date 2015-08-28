package export
{
	import com.childoftv.xlsxreader.Worksheet;
	
	import data.Config;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.controls.Alert;
	import mx.logging.Log;

	/**
	 * JAVA服务器导出 
	 * @author Administrator
	 * 
	 */	
	public class ServerJavaExport extends Export
	{
		
		public function ServerJavaExport(path:String)
		{
			super(path);
		}
		
		override protected function saveClass(sheet:Worksheet):void
		{
			var file:File = new File(File.applicationDirectory.nativePath + "/" + Config.TEMPPATH_SERVER_JAVA1);
			if(file.exists)
			{
				var fs:FileStream = new FileStream();
				fs.open(file,FileMode.READ);
				var content:String = fs.readUTFBytes(fs.bytesAvailable);
				fs.close();
				var newFile:File = new File(Config.TEMPLATE_CLASS_PATH + "/" + _fileName + "Template.java");
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
						var newFile2:File = new File(Config.TEMPLATE_CLASS_PATH + "/" + _fileName + "Template.java.bak");
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
						case "short":
						case "int":
						case "long":
							parseStr += "this." + value + " = ((Integer)table.get(\"" + value + "\")).intValue();";
							break;
						case "float":
							//parseStr += "this." + value + " = bytes:readFloat()";
							Alert.show("不支持float类型");
							break;
						case "boolean":
							parseStr += "this." + value + " = ((Integer)table.get(\"" + value + "\")).intValue() == 1;";
							break;
						case "string":
							typeStr = "String";
							parseStr += "this." + value + " = table.get(\"" + value + "\").toString();";
							break;
					}
					if(desStr != "")varStr += "/**" + desStr + "*/\n";
					varStr += "\tpublic " + typeStr + " " + value + ";";
					varStr += "\n\t";
					
					parseStr += "\n\t\t";
					if(typeStr == "")
					{
						typeStr = "object";
						Alert.show("发现未设置的类型" + _fileName + "," + (COLS[i] + "3"));
					}
					
					
				}
				
				content = content.replace(Config.RP_VAR,varStr);
				content = content.replace(Config.RP_PARSE,parseStr);
				content = content.replace(Config.RP_ID,sheet.getCellValue("B2"));
				
				newFs.position = 0;
				newFs.truncate();
				newFs.writeUTFBytes(content);
				newFs.close();
			}
			
			//写模板表列表
			file = new File(File.applicationDirectory.nativePath + "/" + Config.TEMPPATH_SERVER_JAVA2);
			if(file.exists)
			{
				var fs:FileStream = new FileStream();
				fs.open(file,FileMode.READ);
				var content:String = fs.readUTFBytes(fs.bytesAvailable);
				fs.close();
				var newFile:File = new File(Config.TEMPLATE_CLASS_PATH + "/" + _fileName + "TemplateList.java");
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
						Alert.show("已存在的模版表列表" + _fileName + "，不存在开始或者结束标签,内容被重写,请检查后再第二次发布");
						var newFile2:File = new File(Config.TEMPLATE_CLASS_PATH + "/" + _fileName + "TemplateList.java.bak");
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
				content = content.replace(Config.RE_TABLE_NAME,_tabelName);
				
				newFs.position = 0;
				newFs.truncate();
				newFs.writeUTFBytes(content);
				newFs.close();
			}
		}
		
		override protected function saveSQL(sheet:Worksheet):void
		{
			var content:String = "";
			
			content += "SET FOREIGN_KEY_CHECKS=0;" + "\n";
			content += "-- ----------------------------" + "\n";
			content += "-- Table structure for " + _tabelName + "\n";
			content += "-- ----------------------------" + "\n";
			
			content += "DROP TABLE IF EXISTS `" + _tabelName + "`;" + "\n";
			content += "CREATE TABLE `" + _tabelName + "` (" + "\n";
				
			content += getTableCols(sheet);
			
			content += "PRIMARY KEY  (`templateId`)" + "\n";
			content += ") ENGINE=InnoDB AUTO_INCREMENT=184 DEFAULT CHARSET=gb2312;" + "\n";
			
			
			content += "-- ----------------------------" + "\n";
			content += "-- Records of user_info" + "\n";
			content += "-- ----------------------------" + "\n";
			
			content += getTableVals(sheet);
			
			trace(content);
			
			var newFile:File = new File(Config.TEMPLATE_BINARY_PATH + "/output_" + Config.exportIndex + ".sql");
			var newFs:FileStream = new FileStream();
			newFs.open(newFile,FileMode.APPEND);
			newFs.writeUTFBytes(content);
			newFs.close();
		}
		
		/**
		 * 获取数据 
		 * @param sheet
		 * @return 
		 */		
		private function getTableVals(sheet:Worksheet):String
		{
			var parseStr:String = "";
			var start:int = 5;
			var arr2:XMLList = sheet.getRows("B",start);
			var rowList:Vector.<int> = new Vector.<int>();
			var i:int = 0;
			for (i = 0; i < arr2.length(); i++) 
			{
				if(String(arr2[i]) == "")
					continue;
				var row:int = parseInt(String(arr2[i].@r).substr(1));
				rowList.push(row);
			}
			for (i = 0; i < rowList.length; i++) 
			{
				parseStr += "INSERT INTO `" + _tabelName + "` VALUES (";
				for (var j:int = 1; j < COLS.length; j++) 
				{
					var value:String = sheet.getCellValue(COLS[j] + rowList[i]);
					var id:String = sheet.getCellValue(COLS[j] + "2");
					if(id == "")break;
					parseStr += "'" + value + "',";
				}
				
				//删除最后一个逗号
				parseStr = parseStr.substr(0,parseStr.length - 1);
				parseStr += ");" + "\n";
			}
			
			return parseStr;
		}
		/**
		 * 获取数据 
		 * @param sheet
		 * @return 
		 */		
		private function getTableCols(sheet:Worksheet):String
		{
			var parseStr:String = "";
			for (var i:int = 1; i < COLS.length; i++) 
			{
				var value:String = sheet.getCellValue(COLS[i] + "2");
				var excelTypeStr:String = sheet.getCellValue(COLS[i] + "3");
				var desStr:String = sheet.getCellValue(COLS[i] + "4");
				if(value == "")break;
				if(value == "templateId")
				{
					parseStr += "`templateId` int(32) NOT NULL auto_increment,"
					parseStr += "\n";
					continue;
				}
				
				var typeStr:String = excelTypeStr;
				switch(excelTypeStr)
				{
					//byte;short;int;long;bool;string
					case "byte":
					case "short":
					case "int":
					case "long":
					case "float":
					case "boolean":
						parseStr += "`" + value + "` int(32) default '0'"
						break;
					case "string":
						parseStr += "`" + value + "` varchar(255) default ''"
						break;
				}
				if(desStr.length > 0)
				{
					parseStr += " COMMENT '" + desStr + "'"; //描述
				}
				parseStr += ",\n";
				
				if(typeStr == "")
				{
					typeStr = "object";
					Alert.show("发现未设置的类型" + _fileName + "," + (COLS[i] + "3"));
				}
			}
			return parseStr;
		}
	}
}