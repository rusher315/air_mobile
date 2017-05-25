package sudoku.view
{
	import flash.display.Sprite;
	
	import sudoku.SudokuEvent2;
	import sudoku.model.SudokuData2;
	
	public class NumberSelector2 extends Sprite
	{
		public function NumberSelector2()
		{
			super();
			init();
		}
		
		private function init():void
		{
			for (var i:int = 0; i < SudokuData2.LENGTH; i++) 
			{
				var button:NumberButton = new NumberButton(i+1);
				button.x = i*50;
				addChild(button);
				button.addEventListener("MouseEvent.CLICK",onClickNumber);
			}
			
		}
		
		protected function onClickNumber(event:SudokuEvent2):void
		{
			this.dispatchEvent(new SudokuEvent2(SudokuEvent2.ON_CLICK_NUMBER,event.data));
		}
		
	}
}
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;

import sudoku.SudokuEvent2;

class NumberButton extends Sprite
{
	private var _number:int;
	
	private var textfield:TextField;
	
	public function NumberButton(number:int)
	{
		super();
		init(number);
	}
	
	private function init(number:int):void
	{
		textfield = new TextField();
		textfield.mouseEnabled  =false;
		_number = number;
		textfield.text = _number.toString();
		addChild(textfield);
//		this.graphics.beginFill(0);
		this.graphics.lineStyle(1,0);
		this.graphics.drawRect(0,0,50,50);
		this.graphics.endFill();
		//
		this.addEventListener(MouseEvent.CLICK,onClick);
	}
	
	protected function onClick(event:MouseEvent):void
	{
		this.dispatchEvent(new SudokuEvent2("MouseEvent.CLICK",_number));
	}	
}