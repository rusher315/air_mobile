package sudoku2
{
	import sudoku2.group.SudokuGroup;
	import sudoku2.group.SudokuLineGroup;
	import sudoku2.group.SudokuRowGroup;
	import sudoku2.group.SudokuSetGroup;

	public class SudokuData
	{
		public static const LENGTH:int = 9;
		
		private var cellList:Vector.<SudokuCell> = new Vector.<SudokuCell>(LENGTH*LENGTH,true);
		//
		private var lineGroupList:Vector.<SudokuLineGroup> = new Vector.<SudokuLineGroup>(LENGTH,true);//列
		private var rowGroupList:Vector.<SudokuRowGroup> = new Vector.<SudokuRowGroup>(LENGTH,true);//行
		private var setGroupList:Vector.<SudokuSetGroup> = new Vector.<SudokuSetGroup>(LENGTH,true);//组
		//
//		private var temptemp:Array = [
//		0,0,4,0,9,0,0,8,3,
//		0,2,8,0,0,0,0,4,0,
//		3,0,0,0,8,5,0,0,1,
//		0,9,0,0,3,0,7,1,4,
//		0,0,7,0,2,0,8,0,0,
//		4,8,1,0,5,0,0,6,0,
//		1,0,0,2,7,0,0,0,6,
//		0,6,0,0,0,0,1,3,0,
//		8,4,0,0,1,0,2,0,0];
//		private var temptemp:Array = [
//		4,0,0,0,0,0,0,7,0,
//		3,8,0,9,7,0,0,0,0,
//		0,0,2,4,1,0,0,0,6,
//		0,0,4,0,9,3,7,1,0,
//		9,1,0,0,5,0,0,2,8,
//		0,7,5,1,2,0,9,0,0,
//		1,0,0,0,4,9,6,0,0,
//		0,0,0,0,3,7,0,8,1,
//		0,6,0,0,0,0,0,0,4];
//		private var temptemp:Array = [
//		8,0,0,0,3,0,0,0,0,
//		5,0,0,7,0,0,2,1,0,
//		0,0,0,0,0,0,4,0,5,
//		0,0,0,0,1,7,0,3,0,
//		0,0,9,0,8,0,6,0,0,
//		0,8,0,2,6,0,0,0,0,
//		7,0,8,0,0,0,0,0,0,
//		0,5,4,0,0,6,0,0,2,
//		0,0,0,0,5,0,0,0,1];
		private var temptemp:Array = [
		0,0,0,0,0,0,8,0,0,
		0,0,0,0,0,0,0,2,0,
		0,0,0,0,0,0,0,7,0,
		2,0,0,0,0,0,0,0,9,
		0,7,0,0,0,0,0,0,0,
		0,0,0,1,3,0,5,0,0,
		0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,8,0,
		0,0,0,0,0,0,0,0,0];
//		private var temptemp:Array = [
//		0,0,0,0,0,0,0,0,0,
//		0,0,0,0,0,0,0,0,0,
//		0,0,0,0,0,0,0,0,0,
//		0,0,0,0,0,0,0,0,0,
//		0,0,0,0,0,0,0,0,0,
//		0,0,0,0,0,0,0,0,0,
//		0,0,0,0,0,0,0,0,0,
//		0,0,0,0,0,0,0,0,0,
//		0,0,0,0,0,0,0,0,0];
//		private var temptemp:Array = [
//		[0,0,0,0,0,0,0,0,0],
//		[0,0,0,0,0,0,0,0,0],
//		[0,0,0,0,0,0,0,0,0],
//		[0,0,0,0,0,0,0,0,0],
//		[0,0,0,0,0,0,0,0,0],
//		[0,0,0,0,0,0,0,0,0],
//		[0,0,0,0,0,0,0,0,0],
//		[0,0,0,0,0,0,0,0,0],
//		[0,0,0,0,0,0,0,0,0]
//		];
		
		public function SudokuData()
		{
			init();
		}
		
		private function init():void
		{
			var templine:Array = [];
			var temprow:Array = [];
			var tempset:Array = [];
			//
			for (var i:int = 0; i < LENGTH*LENGTH; i++)
			{
				var cell:SudokuCell = new SudokuCell(i,this);
				cellList[i] = cell;
				//
				if (templine[cell.lineIndex]==null) templine[cell.lineIndex]=[];
				if (temprow[cell.rowIndex]==null) temprow[cell.rowIndex]=[];
				if (tempset[cell.setIndex]==null) tempset[cell.setIndex]=[];
				//
				templine[cell.lineIndex][cell.rowIndex] = cell;
				temprow[cell.rowIndex][cell.lineIndex] = cell;
				tempset[cell.setIndex].push(cell);
			}
			//
			for (var n:int = 0; n < templine.length; n++) 
			{
				lineGroupList[n] = new SudokuLineGroup(templine[n]);
			}
			//
			for (var m:int = 0; m < temprow.length; m++) 
			{
				rowGroupList[m] = new SudokuRowGroup(temprow[m]);
			}
			//
			for (var h:int = 0; h < tempset.length; h++) 
			{
				setGroupList[h] = new SudokuSetGroup(tempset[h]);
			}
			//
			start();
		}
		
		public function getLineByIndex(index:int):SudokuGroup
		{
			return lineGroupList[index];
		}
		
		public function getRowByIndex(index:int):SudokuGroup
		{
			return rowGroupList[index];
		}
		
		public function getSetByIndex(index:int):SudokuGroup
		{
			return setGroupList[index];
		}
		
		public function get celldatas():Array
		{
			var list:Array = [];
			for (var i:int = 0; i < cellList.length; i++) 
			{
				list.push(cellList[i]);
			}
			return list;
		}
		
		public function start():void
		{
			if (temptemp.length!=cellList.length) throw new Error();
			
			for (var k:int = 0; k < cellList.length; k++) 
			{
				var number:int = temptemp[k];
				if (number!=0) 
				{
					(cellList[k] as SudokuCell).setConfirmNumber(number);
				}
			}
			//
			var group:SudokuGroup;
			for (var j:int = 0; j < 100; j++) 
			{
				for each (group in lineGroupList) 
				{
					group.deleteExtraNumber();
				}
				for each (group in rowGroupList) 
				{
					group.deleteExtraNumber();
				}
				for each (group in setGroupList) 
				{
					group.deleteExtraNumber();
				}
			}
			
			
			//
			var str:String = "";
			for (var o:int = 0; o < rowGroupList.length; o++) 
			{
				group  =rowGroupList[o];
				str+=group.numberString+"\n";
			}
			trace(str);
			trace(str.length);
		}
		
	}
}