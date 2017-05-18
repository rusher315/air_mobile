package sudoku
{
	public class Sudoku
	{
		public static const LENGTH:int = 9;
		
		private var cellList:Vector.<SudokuCell> = new Vector.<SudokuCell>(LENGTH*LENGTH,true);
		//
		private var lineList:Vector.<SudokuGroup> = new Vector.<SudokuGroup>(LENGTH,true);//列
		private var rowList:Vector.<SudokuGroup> = new Vector.<SudokuGroup>(LENGTH,true);//行
		private var ssetList:Vector.<SudokuGroup> = new Vector.<SudokuGroup>(LENGTH,true);//组
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
		private var temptemp:Array = [
		8,0,0,0,3,0,0,0,0,
		5,0,0,7,0,0,2,1,0,
		0,0,0,0,0,0,4,0,5,
		0,0,0,0,1,7,0,3,0,
		0,0,9,0,8,0,6,0,0,
		0,8,0,2,6,0,0,0,0,
		7,0,8,0,0,0,0,0,0,
		0,5,4,0,0,6,0,0,2,
		0,0,0,0,5,0,0,0,1];
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
		
		public function Sudoku()
		{
			init();
		}
		
		private function init():void
		{
			var index:int;
			var line:int;
			var row:int;
			var sset:int;
			//
			var templine:Array = [];
			var temprow:Array = [];
			var tempsset:Array = [];
			//
			for (var i:int = 0; i < LENGTH*LENGTH; i++)
			{
				index = i;
				line = index%LENGTH;
				row = int(index/LENGTH);
				sset = int(line/3)+int(row/3)*3;
				//
				var cell:SudokuCell = new SudokuCell(index,line,row,sset);
				cellList[index] = cell;
//				trace(index,line,row,sset);
				//
				if (templine[line]==null) templine[line]=[];
				if (temprow[row]==null) temprow[row]=[];
				if (tempsset[sset]==null) tempsset[sset]=[];
				//
				templine[line][row] = cell;
				temprow[row][line] = cell;
				tempsset[sset].push(cell);
			}
			//
			for (var n:int = 0; n < templine.length; n++) 
			{
				lineList[n] = new SudokuGroup(templine[n]);
			}
			//
			for (var m:int = 0; m < temprow.length; m++) 
			{
				rowList[m] = new SudokuGroup(temprow[m]);
			}
			//
			for (var h:int = 0; h < tempsset.length; h++) 
			{
				ssetList[h] = new SudokuGroup(tempsset[h]);
			}
			//
			if (temptemp.length!=cellList.length) throw new Error();
			
			for (var k:int = 0; k < cellList.length; k++) 
			{
				var number:int = temptemp[k];
				if (number!=0) 
				{
					cellList[k].confirmNumber(number);
				}
			}
			//
			var group:SudokuGroup;
			for (var j:int = 0; j < 100; j++) 
			{
				for each (group in lineList) 
				{
					group.checkConfirm();
				}
				for each (group in rowList) 
				{
					group.checkConfirm();
				}
				for each (group in ssetList) 
				{
					group.checkConfirm();
				}
			}
			//
			
			//
			var str:String = "";
			for (var o:int = 0; o < rowList.length; o++) 
			{
				group  =rowList[o];
				trace(group.numberString);
			}
			
		}
		
	}
}