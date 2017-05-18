package sudoku.view
{
	import flash.display.Sprite;
	
	import sudoku.model.CellData;
	import sudoku.model.SudokuData;
	
	public class SudokuView extends Sprite
	{
		public function SudokuView(stagewidth:Number,celldatas:Array)
		{
			super();
			//
			init(stagewidth,celldatas);
		}
		
		private function init(stagewidth:Number,celldatas:Array):void
		{
			
//			for (var i:int = 0; i < SudokuData.LENGTH*SudokuData.LENGTH; i++) 
			var cellwidth:Number = stagewidth/SudokuData.LENGTH;
			var data:CellData;
			for (var i:int = 0; i < celldatas.length; i++) 
			{
				data = celldatas[i];
				var cell:CellView = new CellView(cellwidth,data);
				cell.x = data.lineIndex*cellwidth;
				cell.y = data.rowIndex*cellwidth;
				addChild(cell);
			}
			
//			this.graphics.beginFill(0);
//			this.graphics.lineStyle(1,0xffffff);
//			this.graphics.drawRect(0,0,width1,width1);
//			this.graphics.endFill();
		}
	}
}