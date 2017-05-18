package sudoku
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class SudokuCell extends EventDispatcher
	{
		
		public static const THIS_CELL_CONFIRM:String = "THIS_CELL_CONFIRM";
		
		private var numberList:Vector.<int> = new Vector.<int>(Sudoku.LENGTH,true);
		
		private var _index:int;
		private var _line:int;
		private var _row:int;
		private var _sset:int;
		
		public function SudokuCell(index:int,line:int,row:int,sset:int)
		{
			init(index,line,row,sset);
		}
		
		private function init(index:int,line:int,row:int,sset:int):void
		{
			_index = index;
			_line = line;
			_row = row;
			_sset = sset;
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
		
		public function get index():int
		{
			return _index;
		}
		
		public function confirmNumber(number:int):void
		{
			if (number>0&&number<=Sudoku.LENGTH)
			{
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
			}
		}
		
		public function notNumber(number:int):void
		{
			if (number>0&&number<=Sudoku.LENGTH)
			{
				numberList[number-1] = 0;
				checkConfirm();
			}
		}
		
		private function checkConfirm():void
		{
			if (isConfirm) 
			{
				this.dispatchEvent(new Event(THIS_CELL_CONFIRM));
			}
		}
		
		public function get isConfirm():Boolean
		{
			var count:int = leaveCount;
			return (count==1);
		}
		
		public function get leaveCount():int
		{
			var count:int = 0;
			for each (var number:int in numberList)
			{
				(number==1)&&(count++);
			}
			return count;
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
		
		public function get numberString():String
		{
			return leaveNumber.join("|");
		}
		
	}
}