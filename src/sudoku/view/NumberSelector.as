package sudoku.view
{
	import flash.display.Sprite;
	
	import sudoku.SudokuEvent;
	import sudoku.model.SudokuData;
	
	public class NumberSelector extends Sprite
	{
		public function NumberSelector()
		{
			super();
			init();
		}
		
		private function init():void
		{
			for (var i:int = 0; i < SudokuData.LENGTH; i++) 
			{
				var button:NumberButton = new NumberButton(i+1);
				button.x = i*50;
				addChild(button);
				button.addEventListener("MouseEvent.CLICK",onClickNumber);
			}
			
		}
		
		protected function onClickNumber(event:SudokuEvent):void
		{
			this.dispatchEvent(new SudokuEvent(SudokuEvent.ON_CLICK_NUMBER,event.data));
		}
		
	}
}
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;

import sudoku.SudokuEvent;

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
		this.dispatchEvent(new SudokuEvent("MouseEvent.CLICK",_number));
	}	
}