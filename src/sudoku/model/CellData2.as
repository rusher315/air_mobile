package sudoku.model
{
	import flash.events.EventDispatcher;
	
	import sudoku.SudokuEvent2;

	public class CellData2 extends EventDispatcher
	{
		
		public static const THIS_CELL_CONFIRM:String = "THIS_CELL_CONFIRM";
		public static const THIS_CELL_UPDATE:String = "THIS_CELL_UPDATE";
		
		private var numberList:Vector.<int> = new Vector.<int>(SudokuData2.LENGTH,true);
		
		private var _cellIndex:int;
		private var _lineIndex:int;
		private var _rowIndex:int;
		private var _setIndex:int;
		
		private var groupList:Vector.<GroupData2> = new Vector.<GroupData2>();
		
		private var _isConfirm:Boolean = false;
		
		public function CellData2(cellIndex:int)
		{
			init(cellIndex);
		}
		
		private function init(cellIndex:int):void
		{
			_cellIndex = cellIndex;
			//
			_lineIndex = cellIndex%SudokuData2.LENGTH;
			_rowIndex = int(cellIndex/SudokuData2.LENGTH);
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
		
		public function addGroup(group:GroupData2):void
		{
			if (groupList.indexOf(group)!=-1||groupList.length>=3) 
			{
				throw new Error();
			}
			groupList.push(group);
		}
		
		private function checkConfirmNumber(number:int):Boolean
		{
			if (number<=0||number>SudokuData2.LENGTH) return false;
			if (leaveNumber.indexOf(number)==-1) return false;
//			if (groupList.length!=3) 
			for each (var group:GroupData2 in groupList) 
			{
				if (group.hasNumberCount(number)!=1/*&&group.hasNumberCount(number)!=SudokuData.LENGTH*/)  return false;
			}
			return true;
		}
		
		public function tryConfirmNumber(number:int):Boolean//todo
		{
			if(checkConfirmNumber(number))
			{
				setConfirmNumber(number);
				return true;
			}
			return false;
		}
		
		public function setConfirmNumber(number:int):void
		{
			if (number<=0||number>SudokuData2.LENGTH) throw new Error();
			if (leaveNumber.indexOf(number)==-1) throw new Error();
			//
			for (var i:int = 0; i < numberList.length; i++) 
			{
				numberList[i] = 0;
			}
			numberList[number-1] = 1;
			this.dispatchEvent(new SudokuEvent2(THIS_CELL_UPDATE));
			_isConfirm = true;
			checkConfirm();
		}
		
		public function setNumber(list:Array):void
		{
			
		}
		
		public function notNumber(number:int):void
		{
			if (number>0&&number<=SudokuData2.LENGTH)
			{
				numberList[number-1] = 0;
				this.dispatchEvent(new SudokuEvent2(THIS_CELL_UPDATE));
				checkConfirm();
			}
		}
		
		private function checkConfirm():void
		{
			if (!_isConfirm) 
			{
				var count:int = leaveNumber.length;
				_isConfirm = (count==1&&checkConfirmNumber(leaveNumber[0])) 
			}
			//
			if (isConfirm) 
			{
				this.dispatchEvent(new SudokuEvent2(THIS_CELL_CONFIRM));
			}
		}
		
		public function get isConfirm():Boolean
		{
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