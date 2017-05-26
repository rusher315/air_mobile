package sudoku2.group
{
	import sudoku2.SudokuCell;
	import sudoku2.SudokuCellMap;
	import sudoku2.SudokuData;
	

	public class SudokuGroup
	{
		protected var cellList:Vector.<SudokuCell> = new Vector.<SudokuCell>(SudokuData.LENGTH,true);
		
		public function SudokuGroup(list:Array)
		{
			init(list);
		}
		
		private function init(list:Array):void
		{
			if (list.length!=SudokuData.LENGTH) throw new Error();
			for (var i:int = 0; i < cellList.length; i++)
			{
				var cell:SudokuCell = list[i] as SudokuCell;
				if (cell==null) throw new Error();
				cellList[i] = cell;
			}
		}
		
		public function groupNotNumber(number:int):void
		{
			for each (var cell:SudokuCell in cellList)
			{
				cell.notNumber(number);
			}
		}
		
		public function otherNotNumber(number:int,list:Array):void
		{
			for each (var cell:SudokuCell in cellList)
			{
				if (list.indexOf(cell)==-1) 
				{
					cell.notNumber(number);
				}
			}
		}
		
		public function comfirmCellCount():int
		{
			var count:int = 0;
			for each (var cell:SudokuCell in cellList)
			{
				if (cell.isConfirm) count++;
			}
			return count;
		}
		
		public function notConfirmCellCount():int
		{
			return cellList.length-comfirmCellCount();
		}
		
		public function hasNumberCount(number:int):int
		{
			var count:int = 0;
			for each (var cell:SudokuCell in cellList)
			{
				if (cell.hasNumber(number)) count++;
			}
			return count;
		}
		
		public function getCellHasNumber(number:int):SudokuCellMap
		{
			var list:Array = [];
			var cell:SudokuCell;
			for each (cell in cellList)
			{
				if (cell.hasNumber(number)) list.push(cell);
			}
			return SudokuCellMap.getInstance(list);
		}
		
		public function deleteExtraNumber():void//行列排除法,宫内排除法,唯余解法
		{
			var cell:SudokuCell;
			var count:int;
			var number:int;
			//
			for each (cell in cellList)
			{
				if (cell.isConfirm) 
				{
					groupNotNumber(cell.leaveNumber[0]);
				}
			}
			//
			for (var i:int = 0; i < SudokuData.LENGTH; i++) 
			{
				number = i+1;
				count=hasNumberCount(number);
				//
				if (count==1)
				{
					for each (cell in cellList)
					{
						if (!cell.isConfirm&&cell.hasNumber(number))
						{
							cell.setConfirmNumber(number);
						}
					}
				}
				//
				else if (false)
				{
				}
			}
			//
			deleteExtraNumber2();
		}
		
		private function deleteExtraNumber2():void 
		{
			var cell:SudokuCell;
			var cell2:SudokuCell;
			var cell3:SudokuCell;
			//显性数对
			for each (cell in cellList) 
			{
				out:for each (cell2 in cellList) 
				{
					var tempsamelist:Array = cell.getSameNumber(cell2);
					if (tempsamelist.length==2) 
					{
						for each (cell3 in cellList)
						{
							if (cell3.hasNumberInList(tempsamelist)) 
							{
								break out;
							}
						}
						//
						cell.setNumberList(tempsamelist);
						cell2.setNumberList(tempsamelist);
					}
				}
			}
			//
			//
			//显性数组
		}
		
		private function checkArrayHasSameNumber(list1:Array,list2:Array):Boolean
		{
			for each (var i:int in list1) 
			{
				if (list2.indexOf(i)!=-1) 
				{
					return true;
				}
			}
			return false;
		}
		
		public function get isConfirm():Boolean
		{
			var list:Array = [];
			var temp:Array = leaveNumber;
			var number:int;
			for (var i:int = 0; i < temp.length; i++) 
			{
				if (temp[i].length==1)
				{
					number = temp[i][0];
					if (int(list[number-1])>=1) 
					{
						throw new Error();
						return false;
					}
					list[number-1]=int(list[number-1])+1;
				}
				else
				{
					return false;
				}
			}
			return true;
		}
		
		public function get leaveNumber():Array
		{
			var list:Array = [];
			for (var i:int = 0; i < cellList.length; i++) 
			{
				list[i] = cellList[i].leaveNumber;
			}
			return list;
		}
		
		public function get numberString():String
		{
			var str:String = "";
			for (var i:int = 0; i < cellList.length; i++) 
			{
				str+=" ("+cellList[i].numberString+") ";
			}
			return str;
		}
		
		
	}
}