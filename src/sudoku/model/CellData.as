package sudoku.model
{
	import flash.events.EventDispatcher;
	
	import sudoku.SudokuEvent;

	public class CellData extends EventDispatcher
	{
		
		public static const THIS_CELL_CONFIRM:String = "THIS_CELL_CONFIRM";
		public static const THIS_CELL_UPDATE:String = "THIS_CELL_UPDATE";
		
		private var numberList:Vector.<int> = new Vector.<int>(SudokuData.LENGTH,true);
		
		private var _cellIndex:int;
		private var _lineIndex:int;
		private var _rowIndex:int;
		private var _setIndex:int;
		
		private var _isConfirm:Boolean = false;
		
		public function CellData(cellIndex:int/*,lineIndex:int,rowIndex:int,setIndex:int*/)
		{
			init(cellIndex/*,lineIndex,rowIndex,setIndex*/);
		}
		
		private function init(cellIndex:int/*,lineIndex:int,rowIndex:int,setIndex:int*/):void
		{
			_cellIndex = cellIndex;
			//
			_lineIndex = cellIndex%SudokuData.LENGTH;
			_rowIndex = int(cellIndex/SudokuData.LENGTH);
			_setIndex = int(lineIndex/3)+int(rowIndex/3)*3;
			//
//			_lineIndex = lineIndex;
//			_rowIndex = rowIndex;
//			_setIndex = setIndex;
			//
//			for each (var number:int in numberList) //wrong
//			{
//				number = 1;
//			}
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
		
		public function confirmNumber(number:int):void
		{
			if (number>0&&number<=SudokuData.LENGTH)
			{
				if (leaveNumber.indexOf(number)==-1) 
				{
					throw new Error();
				}
//				for each (var temp:int in numberList) //wrong
//				{
//					temp = 0;
//				}
				for (var i:int = 0; i < numberList.length; i++) 
				{
					numberList[i] = 0;
				}
				numberList[number-1] = 1;
				checkConfirm();
				this.dispatchEvent(new SudokuEvent(THIS_CELL_UPDATE));
			}
		}
		
		public function notNumber(number:int):void
		{
			if (number>0&&number<=SudokuData.LENGTH)
			{
				numberList[number-1] = 0;
				checkConfirm();
				this.dispatchEvent(new SudokuEvent(THIS_CELL_UPDATE));
			}
		}
		
		private function checkConfirm():void
		{
			if (isConfirm) 
			{
				this.dispatchEvent(new SudokuEvent(THIS_CELL_CONFIRM));
			}
		}
		
		public function get isConfirm():Boolean
		{
			if (!_isConfirm) 
			{
				var count:int = leaveNumber.length;
				_isConfirm = (count==1);
			}
			return _isConfirm;
		}
		
//		private function get leaveCount():int
//		{
////			var count:int = 0;
////			for each (var number:int in numberList)
////			{
////				(number==1)&&(count++);
////			}
////			return count;
//			return leaveNumber.length;
//		}
		
		public function get leaveNumber():Array
		{
			var list:Array = [];
			for (var i:int = 0; i < numberList.length; i++) 
			{
				if(numberList[i]==1)list.push(i+1);
			}
			return list;
		}
		
		public function get numberString():String
		{
			return leaveNumber.join("|");
		}
		
	}
}