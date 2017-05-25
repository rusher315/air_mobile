package sudoku2
{
	import sudoku2.group.SudokuGroup;

	public class SudokuCellMap
	{
		protected var cellList:Vector.<SudokuCell> = new Vector.<SudokuCell>();
		
		public function SudokuCellMap()
		{
		}
		
		public static function getInstance(list:Array):SudokuCellMap
		{
			var temp:SudokuCellMap = new SudokuCellMap();
			temp.setCellList(list);
			return temp;
		}
		
		public function addSudokuCell(cell:SudokuCell):void
		{
			if (cellList.indexOf(cell)!=-1) throw new Error();
			cellList.push(cell);
		}
		
		public function setCellList(list:Array):void
		{
			for each (var cell:SudokuCell in list) 
			{
				if (cell) addSudokuCell(cell);
			}
		}
		
//		public function get isCellSameGroup():Boolean
//		{
//			return (isCellSameLineOrRow||isCellSameSet);
//		}
//		
//		public function get isCellSameLineOrRow():Boolean
//		{
//			return (isCellSameLine||isCellSameRow);
//		}
		
		public function get isCellSameLine():SudokuGroup
		{
			var index:int=-1;
			var group:SudokuGroup;
			for each (var cell:SudokuCell in cellList) 
			{
				if (index==-1) 
				{
					index=cell.lineIndex;
					group = cell.lineGroup;
				}
				//
				if (index!=cell.lineIndex) return null;
			}
			return group;
		}
		
		public function get isCellSameRow():SudokuGroup
		{
			var index:int=-1;
			var group:SudokuGroup;
			for each (var cell:SudokuCell in cellList) 
			{
				if (index==-1)
				{
					index=cell.rowIndex;
					group = cell.rowGroup;
				}
				//
				if (index!=cell.rowIndex) return null;
			}
			return group;
		}
		
		public function get isCellSameSet():SudokuGroup
		{
			var index:int=-1;
			var group:SudokuGroup;
			for each (var cell:SudokuCell in cellList) 
			{
				if (index==-1) 
				{
					index=cell.setIndex;
					group = cell.setGroup;
				}
				//
				if (index!=cell.setIndex) return null;
			}
			return group;
		}
		
		public function get list():Array
		{
			var temp:Array = [];
			for each (var cell:SudokuCell in cellList) 
			{
				if (cell) temp.push(cell);
			}
			return temp;
		}
		
	}
}