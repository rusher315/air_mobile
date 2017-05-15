package sudoku
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class SudokuCell extends EventDispatcher
	{
		
		public static const THIS_CELL_CONFIRM:String = "THIS_CELL_CONFIRM";
		
		private var numberList:Vector.<int> = new Vector.<int>(true,Sudoku.LENGTH);
		
		private var _index:int;
		
		public function SudokuCell(index:int)
		{
			init(index);
		}
		
		private function init(index:int):void
		{
			for each (var number:int in numberList) 
			{
				number = 1;
			}
			//
			_index = index;
		}
		
		public function get index():int
		{
			return _index;
		}
		
		public function confirmNumber(number:int):void
		{
			if (number>0&&number<=Sudoku.LENGTH)
			{
				for each (var temp:int in numberList) 
				{
					temp = 0;
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
		
	}
}