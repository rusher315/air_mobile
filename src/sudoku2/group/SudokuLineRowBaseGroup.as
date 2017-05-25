package sudoku2.group
{
	import sudoku2.SudokuCell;
	import sudoku2.SudokuCellMap;
	import sudoku2.SudokuData;
	

	public class SudokuLineRowBaseGroup extends SudokuGroup
	{
		public function SudokuLineRowBaseGroup(list:Array)
		{
			super(list);
		}
		
		override public function deleteExtraNumber():void
		{
			super.deleteExtraNumber();
			//
			var cell:SudokuCell;
			var count:int;
			var number:int;
			var list:Vector.<SudokuCell>;
			//
			for (var i:int = 0; i < SudokuData.LENGTH; i++) 
			{
				number = i+1;
				count=hasNumberCount(number);
				//
//				if (count==2||count==3)//区块排除法
				if (count>1)//区块排除法
				{
					var dict:SudokuCellMap = getCellHasNumber(number);
					if (dict.isCellSameSet) 
					{
						dict.isCellSameSet.otherNotNumber(number,dict.list);
					}
				}
			}
			//
		}
		
	}
}