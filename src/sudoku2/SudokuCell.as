package sudoku2
{
	import flash.events.EventDispatcher;
	
	import sudoku2.group.SudokuGroup;

	public class SudokuCell extends EventDispatcher
	{
		private var numberList:Vector.<int> = new Vector.<int>(SudokuData.LENGTH,true);
		
		private var _cellIndex:int;
		private var _lineIndex:int;
		private var _rowIndex:int;
		private var _setIndex:int;
		
		private var _data:SudokuData;
		
		private var _isConfirm:Boolean = false;
		
		public function SudokuCell(cellIndex:int,data:SudokuData)
		{
			init(cellIndex,data);
		}
		
		private function init(cellIndex:int,data:SudokuData):void
		{
			_cellIndex = cellIndex;
			_data = data;
			//
			_lineIndex = cellIndex%SudokuData.LENGTH;
			_rowIndex = int(cellIndex/SudokuData.LENGTH);
			_setIndex = int(lineIndex/3)+int(rowIndex/3)*3;
			//
			for (var i:int = 0; i < numberList.length; i++) 
			{
				numberList[i] = 1;
			}
		}
		
		public function get cellIndex():int
		{
			return _cellIndex;
		}
		
		public function get lineIndex():int
		{
			return _lineIndex;
		}
		
		public function get rowIndex():int
		{
			return _rowIndex;
		}
		
		public function get setIndex():int
		{
			return _setIndex;
		}
		
		public function get lineGroup():SudokuGroup
		{
			return _data.getLineByIndex(lineIndex);
		}
		
		public function get rowGroup():SudokuGroup
		{
			return _data.getRowByIndex(rowIndex);
		}
		
		public function get setGroup():SudokuGroup
		{
			return _data.getSetByIndex(setIndex);
		}
		
		public function setConfirmNumber(number:int):void
		{
			if (number<=0||number>SudokuData.LENGTH) throw new Error();
			if (leaveNumber.indexOf(number)==-1) throw new Error();
			//
			for (var i:int = 0; i < numberList.length; i++) 
			{
				numberList[i] = 0;
			}
			numberList[number-1] = 1;
		}
		
		public function setNumberList(list:Array):void
		{
			for (var i:int = 0; i < numberList.length; i++) 
			{
				numberList[i] = 0;
			}
			for each (var number:int in list) 
			{
				numberList[number-1] = 1;
			}
		}
		
		public function notNumber(number:int):void
		{
			if (!isConfirm&&number>0&&number<=SudokuData.LENGTH)
			{
				numberList[number-1] = 0;
			}
		}
		
		public function get isConfirm():Boolean
		{
			_isConfirm = (leaveCount==1);
			return _isConfirm;
		}
		
//		public function isSameGroup(cell:SudokuCell):int
//		{
//			
//		}
		
		public function getSameNumber(cell:SudokuCell):Array
		{
			var list:Array = [];
			var temp1:Array = this.leaveNumber;
			var temp2:Array = cell.leaveNumber;
			for (var i:int = 0; i < temp1.length; i++) 
			{
				if (temp2.indexOf(temp1[i])!=-1) 
				{
					list.push(temp1[i]);
				}
			}
			return list;
		}
		
		public function hasNumberInList(list:Array):Boolean
		{
			for each (var i:int in list) 
			{
				if (hasNumber(i)) return true; 
			}
			return false;
		}
		
		public function hasNumber(number:int):Boolean
		{
			return leaveNumber.indexOf(number)!=-1;
		}
		
		public function get leaveNumber():Array
		{
			var list:Array = [];
			for (var i:int = 0; i < numberList.length; i++) 
			{
				if(numberList[i]==1)list.push(i+1);
			}
			return list;
		}
		
		public function get leaveCount():int
		{
			return leaveNumber.length;
		}
		
		public function get numberString():String
		{
			return leaveNumber.join("|");
		}
		
	}
}