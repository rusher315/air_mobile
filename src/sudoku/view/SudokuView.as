package sudoku.view
{
	import flash.display.Sprite;
	
	import sudoku.SudokuEvent;
	import sudoku.model.CellData;
	import sudoku.model.SudokuData;
	
	public class SudokuView extends Sprite
	{
		
		private var selector:NumberSelector;
		
		private var selectedCell:CellView;
		
		private var inputNumber:Array = [];
		
		public function SudokuView(stagewidth:Number,celldatas:Array)
		{
			super();
			//
			init(stagewidth,celldatas);
		}
		
		private function init(stagewidth:Number,celldatas:Array):void
		{
			selector = new NumberSelector();
			addChild(selector);
			selector.visible = false;
			//
			var cellwidth:Number = stagewidth/SudokuData.LENGTH;
			cellwidth = 50;
			var data:CellData;
			for (var i:int = 0; i < celldatas.length; i++) 
			{
				data = celldatas[i];
				var cell:CellView = new CellView(cellwidth,data);
				cell.x = data.lineIndex*(cellwidth+1)+int(data.lineIndex/3)*5;
				cell.y = data.rowIndex*(cellwidth+1)+int(data.rowIndex/3)*5;
				addChild(cell);
				//
				selector.y = cell.y+cellwidth;
				//
				cell.addEventListener(SudokuEvent.ON_CLICK_CELL,onClickCell);
			}
			
			selector.addEventListener(SudokuEvent.ON_CLICK_NUMBER,onClickSelector);
			
		}
		
		protected function onClickCell(event:SudokuEvent):void
		{
			var index:int = event.data;
			var cell:CellView = event.target as CellView;
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
		
		protected function onClickSelector(event:SudokuEvent):void
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