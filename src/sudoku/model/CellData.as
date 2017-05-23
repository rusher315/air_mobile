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
		
		private var groupList:Vector.<GroupData> = new Vector.<GroupData>();
		
		private var _isConfirm:Boolean = false;
		
		public function CellData(cellIndex:int)
		{
			init(cellIndex);
		}
		
		private function init(cellIndex:int):void
		{
			_cellIndex = cellIndex;
			//
			_lineIndex = cellIndex%SudokuData.LENGTH;
			_rowIndex = int(cellIndex/SudokuData.LENGTH);
			_setIndex = int(lineIndex/3)+int(rowIndex/3)*3;
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
		
		public function addGroup(group:GroupData):void
		{
			if (groupList.indexOf(group)!=-1||groupList.length>=3) 
			{
				throw new Error();
			}
			groupList.push(group);
		}
		
		public function tryConfirmNumber(number:int):Boolean//todo
		{
			if (number<=0||number>SudokuData.LENGTH) return false;
			if (leaveNumber.indexOf(number)==-1) return false;
//			if (groupList.length!=3) 
			for each (var group:GroupData in groupList) 
			{
				if (group.hasNumberCount(number)!=1)  return false;
			}
			//
			setConfirmNumber(number);
			return true;
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
			this.dispatchEvent(new SudokuEvent(THIS_CELL_UPDATE));
			checkConfirm();
		}
		
		public function notNumber(number:int):void
		{
			if (number>0&&number<=SudokuData.LENGTH)
			{
				numberList[number-1] = 0;
				this.dispatchEvent(new SudokuEvent(THIS_CELL_UPDATE));
				checkConfirm();
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