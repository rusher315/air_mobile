package sudoku
{
	import flash.display.Sprite;
	
	import sudoku.model.SudokuData2;
	import sudoku.view.SudokuView2;
	
	public class SudokuMain2 extends Sprite
	{
		
		private var _sudokudata:SudokuData2;
		private var _sudokuview:SudokuView2;
		
		public function SudokuMain2(stagewidth:Number)
		{
			super();
			//
			_sudokudata = new SudokuData2();
			//
			_sudokuview = new SudokuView2(stagewidth,_sudokudata.celldatas);
			addChild(_sudokuview);
		}
	}
}