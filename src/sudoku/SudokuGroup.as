package sudoku
{
	import flash.events.Event;

	public class SudokuGroup
	{
		
		
		private var cellList:Vector.<SudokuCell> = new Vector.<SudokuCell>(Sudoku.LENGTH,true);
		
		public function SudokuGroup(list:Array)
		{
			init(list);
		}
		
		private function init(list:Array):void
		{
			if (list.length!=Sudoku.LENGTH) trace("错误1");
			for (var i:int = 0; i < cellList.length; i++)
			{
				if (cellList[i]) 
				{
					cellList[i].removeEventListener(SudokuCell.THIS_CELL_CONFIRM,onCellConfirm);
					cellList[i] = null;
				}
				var cell:SudokuCell = list.shift() as SudokuCell;
				if (cell==null) trace("错误2");
				cellList[i] = cell;
				cellList[i].addEventListener(SudokuCell.THIS_CELL_CONFIRM,onCellConfirm);
			}
			
		}
		
		protected function onCellConfirm(event:Event):void
		{
			var cell:SudokuCell = event.target as SudokuCell;
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
			if (number>0&&number<=Sudoku.LENGTH)
			{
				for each (var cell:SudokuCell in cellList)
				{
					if (!cell.isConfirm)
					{
						cell.notNumber(number);
					}
				}
			}
		}
		
		public function checkConfirm():void
		{
			var cell:SudokuCell;
			var temp:Array;
			var list:Array = [];
			for each (cell in cellList)
			{
				temp = cell.leaveNumber;
				for each (var i:int in temp)
				{
//					list[i-1]++;//wrong
					list[i-1]=int(list[i-1])+1;
				}
			}
			//
			for (var n:int = 0; n < list.length; n++) 
			{
				var number:int = list[n];
				if (number==1)
				{
					for each (cell in cellList)
					{
						temp = cell.leaveNumber;
						if (temp.indexOf(n+1)!=-1) 
						{
							cell.confirmNumber(n+1);
						}
					}
				}
			}
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