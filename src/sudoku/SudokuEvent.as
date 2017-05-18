package sudoku
{
	import flash.events.Event;
	
	public class SudokuEvent extends Event
	{
		
		private var _data:*;
		
		public function SudokuEvent(type:String, data:*=null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			_data = data;
		}

		public function get data():*
		{
			return _data;
		}

	}
}