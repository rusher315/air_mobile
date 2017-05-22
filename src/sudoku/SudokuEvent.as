package sudoku
{
	import flash.events.Event;
	
	public class SudokuEvent extends Event
	{
		public static const ON_CLICK_CELL:String = "ON_CLICK_CELL";
		public static const ON_CLICK_NUMBER:String = "ON_CLICK_NUMBER";
		
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