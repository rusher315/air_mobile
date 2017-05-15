package sudoku
{
	import flash.events.Event;

	public class SudokuGroup
	{
		
		
		private var cellList:Vector.<SudokuCell> = new Vector.<SudokuCell>(true,Sudoku.LENGTH);
		
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
				var cell:SudokuCell = list.pop() as SudokuCell;
				if (cell==null) trace("错误2");
				cellList[i] = cell;
				cellList[i].addEventListener(SudokuCell.THIS_CELL_CONFIRM,onCellConfirm);
			}
			
		}
		
		protected function onCellConfirm(event:Event):void
		{
			var cell:SudokuCell = event.target as SudokuCell;
			if (cell.isConfirm) 
			{
				otherNotNumber(cell.leaveNumber[0]);
			}
			
		}
		
		public function otherNotNumber(number:int):void
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
	}
}