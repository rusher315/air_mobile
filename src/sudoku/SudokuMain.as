package sudoku
{
	import flash.display.Sprite;
	
	import sudoku.model.SudokuData;
	import sudoku.view.SudokuView;
	
	public class SudokuMain extends Sprite
	{
		
		private var _sudokudata:SudokuData;
		private var _sudokuview:SudokuView;
		
		public function SudokuMain(stagewidth:Number)
		{
			super();
			//
			_sudokudata = new SudokuData();
			//
			_sudokuview = new SudokuView(stagewidth,_sudokudata.celldatas);
			addChild(_sudokuview);
		}
	}
}