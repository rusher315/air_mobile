package sudoku.model
{
	import flash.events.Event;

	public class GroupData2
	{
		
		
		private var cellList:Vector.<CellData2> = new Vector.<CellData2>(SudokuData2.LENGTH,true);
		
		public function GroupData2(list:Array)
		{
			init(list);
		}
		
		private function init(list:Array):void
		{
			if (list.length!=SudokuData2.LENGTH) trace("错误1");
			for (var i:int = 0; i < cellList.length; i++)
			{
				if (cellList[i]) 
				{
					cellList[i].removeEventListener(CellData2.THIS_CELL_CONFIRM,onCellConfirm);
					cellList[i] = null;
				}
//				var cell:SudokuCell = list.shift() as SudokuCell;
				var cell:CellData2 = list[i] as CellData2;
				if (cell==null) trace("错误2");
				cell.addGroup(this);
				cellList[i] = cell;
				cellList[i].addEventListener(CellData2.THIS_CELL_CONFIRM,onCellConfirm);
			}
			
		}
		
		protected function onCellConfirm(event:Event):void
		{
			var cell:CellData2 = event.target as CellData2;
//			trace(cell.index);
			if (cell.isConfirm)
			{
				otherNotNumber(cell.leaveNumber[0]);
				//
				checkConfirm();
			}
			
		}
		
		private function otherNotNumber(number:int):void
		{
			if (number>0&&number<=SudokuData2.LENGTH)
			{
				for each (var cell:CellData2 in cellList)
				{
					if (!cell.isConfirm)
					{
						cell.notNumber(number);
					}
				}
			}
		}
		
		public function hasNumberCount(number:int):int
		{
			var count:int = 0;
			var cell:CellData2;
			var temp:Array;
			for each (cell in cellList)
			{
				temp = null;
				temp = cell.leaveNumber;
				if (temp.indexOf(number)!=-1) 
				{
					count++;
				}
			}
			return count;
		}
		
		public function checkConfirm():void
		{
			var cell:CellData2;
			var temp:Array;
			var list:Array = [];
			var number:int;
			for each (cell in cellList)
			{
				temp = null;
//				if (cell.isConfirm) continue;
				//
				temp = cell.leaveNumber;
				for each (number in temp)
				{
//					list[i-1]++;//wrong
					list[number-1]=int(list[number-1])+1;
				}
			}
			//
			for (var n:int = 0; n < list.length; n++) 
			{
				number = list[n];
				if (number==1)
				{
					for each (cell in cellList)
					{
						temp = cell.leaveNumber;
						if (temp.indexOf(n+1)!=-1&&!cell.isConfirm) 
						{
							cell.tryConfirmNumber(n+1);
						}
					}
				}
			}
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