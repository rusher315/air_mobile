package sudoku.view
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import sudoku.SudokuEvent2;
	import sudoku.model.CellData2;
	
	public class CellView2 extends Sprite
	{
		
		private var _data:CellData2;
		
		private var textfield:TextField;
		
		public function CellView2(cellwidth:Number,data:CellData2)
		{
			super();
			init(cellwidth,data);
		}
		
	
		private function init(cellwidth:Number,data:CellData2):void
		{
			textfield = new TextField();
			textfield.mouseEnabled  =false;
			textfield.width = cellwidth;
			textfield.height = cellwidth;
			textfield.wordWrap = true;
			textfield.autoSize = TextFieldAutoSize.CENTER;
			_data = data;
			_data.addEventListener(CellData2.THIS_CELL_UPDATE,onCellUpdate);
			_data.addEventListener(CellData2.THIS_CELL_CONFIRM,onCellConfirm);
			textfield.htmlText ="<font size='15'>" +_data.numberString +"</font>";
			addChild(textfield);
			//
			this.graphics.clear();
			this.graphics.beginFill(0x888888);
			this.graphics.lineStyle(0.5,0);
			this.graphics.drawRect(0,0,cellwidth,cellwidth);
			this.graphics.endFill();
			//
			this.addEventListener(MouseEvent.CLICK,onClickCell);
		}
		
		protected function onCellConfirm(event:Event):void
		{
			this.graphics.clear();
			this.graphics.beginFill(0x00ff00);
			this.graphics.lineStyle(0.5,0);
			this.graphics.drawRect(0,0,50,50);
			this.graphics.endFill();
		}
		
		protected function onClickCell(event:MouseEvent):void
		{
			dispatchEvent(new SudokuEvent2(SudokuEvent2.ON_CLICK_CELL,_data.cellIndex));
		}
		
		protected function onCellUpdate(event:Event):void
		{
			textfield.htmlText ="<font size='16'>" + _data.numberString +"</font>";
		}		

		public function get data():CellData2
		{
			return _data;
		}
		
		public function select(value:Boolean):void
		{
			if (value) 
			{
				this.filters = [new GlowFilter(0x000000,1,16,16,2,1,true,false)];
			}
			else
			{
				this.filters = [];
			}
			
//			this.graphics.clear();
//			this.graphics.beginFill(0xeeeeee);
//			this.graphics.lineStyle(2,0);
//			this.graphics.drawRect(0,0,cellwidth,cellwidth);
//			this.graphics.endFill();
		}

		
	}
}