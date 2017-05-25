package sudoku.view
{
	import flash.display.Sprite;
	
	import sudoku.SudokuEvent2;
	import sudoku.model.CellData2;
	import sudoku.model.SudokuData2;
	
	public class SudokuView2 extends Sprite
	{
		
		private var selector:NumberSelector2;
		
		private var selectedCell:CellView2;
		
		private var inputNumber:Array = [];
		
		public function SudokuView2(stagewidth:Number,celldatas:Array)
		{
			super();
			//
			init(stagewidth,celldatas);
		}
		
		private function init(stagewidth:Number,celldatas:Array):void
		{
			selector = new NumberSelector2();
			addChild(selector);
			selector.visible = false;
			//
			var cellwidth:Number = stagewidth/SudokuData2.LENGTH;
			cellwidth = 50;
			var data:CellData2;
			for (var i:int = 0; i < celldatas.length; i++) 
			{
				data = celldatas[i];
				var cell:CellView2 = new CellView2(cellwidth,data);
				cell.x = data.lineIndex*(cellwidth+1)+int(data.lineIndex/3)*5;
				cell.y = data.rowIndex*(cellwidth+1)+int(data.rowIndex/3)*5;
				addChild(cell);
				//
				selector.y = cell.y+cellwidth;
				//
				cell.addEventListener(SudokuEvent2.ON_CLICK_CELL,onClickCell);
			}
			
			selector.addEventListener(SudokuEvent2.ON_CLICK_NUMBER,onClickSelector);
			
		}
		
		protected function onClickCell(event:SudokuEvent2):void
		{
			var index:int = event.data;
			var cell:CellView2 = event.target as CellView2;
			if (selectedCell) 
			{
				selectedCell.select(false);
			}
			selectedCell = cell;
			selectedCell.select(true);
			//
			selector.visible = true;
			
			trace(event.data);
		}
		
		protected function onClickSelector(event:SudokuEvent2):void
		{
			var number:int = event.data;
			
			if (selectedCell) 
			{
				selectedCell.data.setConfirmNumber(number);
			}
			
			trace(event.data);
		}
	}
}