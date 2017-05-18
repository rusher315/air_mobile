package sudoku.view
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.text.TextField;
	
	import sudoku.model.CellData;
	
	public class CellView extends Sprite
	{
		
		private var _data:CellData;
		
		private var textfield:TextField;
		
		public function CellView(cellwidth:Number,data:CellData)
		{
			super();
			init(cellwidth,data);
		}
		
	
		private function init(cellwidth:Number,data:CellData):void
		{
			textfield = new TextField();
			textfield.mouseEnabled  =false;
			_data = data;
			_data.addEventListener(CellData.THIS_CELL_UPDATE,onCellUpdate);
			textfield.text = _data.numberString;
			addChild(textfield);
//			this.graphics.beginFill(0);
			this.graphics.lineStyle(1,0);
			this.graphics.drawRect(0,0,cellwidth,cellwidth);
			this.graphics.endFill();
			//
			this.addEventListener(MouseEvent.CLICK,onClickCell);
		}
		
		protected function onClickCell(event:MouseEvent):void
		{
			trace("CellView.onTouch(event)");
			
		}
		
		protected function onCellUpdate(event:Event):void
		{
			textfield.text = _data.numberString;
		}		
		
	}
}