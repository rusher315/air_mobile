package
{
	import com.greensock.TweenMax;
	import com.model.ChipVo;
	import com.util.ZooProfile;
	import com.view.BetChip;
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;
	
	
//	[SWF(width="720",height="1280"backgroundColor="#333333")]
	public class main extends Sprite
	{
		public function main()
		{
			super();
			if (stage) 
			{
				initialize();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE,onStage);
			}

			
//			var shape:Shape = new Shape();
//			shape.graphics.beginFill(0,1);
//			shape.graphics.drawRect(0,0,100,100);
//			shape.graphics.endFill();
//			addChild(shape);
			
		}
		
		protected function onStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,onStage);
			initialize();
			//
		}
		
		private function initialize():void
		{
			// 支持 autoOrient
			stage.autoOrients = false;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate=30;
			//
//			root.scale
			//
//			addChild(new SudokuMain2(stage.stageWidth));
//			new SudokuData();
//			combine_increase([1,2,3,4,5,6],0,[],4,4,6);
			combine_increase([1,2,3,4,5,6,7,8,9],0,[],2,2);
			return;
			//
			var urlloader:URLLoader = new URLLoader();
			urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			urlloader.addEventListener(Event.COMPLETE,onUrlLoaded);
			urlloader.load(new URLRequest("assets/image.swf"));
		}
		
		//arr为原始数组  
		//start为某位置选取元素的开始位置，因为之后要选择的元素序号需要大于start，所以需要这个变量进行标记  
		//result保存一次组合选取的元素的序号，比如第一次选的是1234，则result中则存储1234，之后根据序号进行输出  
		//count为result数组的索引值，起辅助作用；count用来确定现在在选的是第几位数，或者还剩几位数就凑够要选择的数的个数；是递归变量之一:递归变量就是每次递归都会起作用或者发生改变的变量，在画递归树分析的时候不止要写出每次的递归变量值，而且对递归变量的限制（例如在循环中，有循环条件限制），也都要列出来，才比较容易模拟清楚过程；而且要尽量选规模小的进行模拟；  
		//NUM为要选取的元素个数  
		//arr_len为原始数组的长度，为定值  
		private function combine_increase(arr:Array,start:int,result:Array,count:int,NUM:int):void
		{
			var arr_len:int = arr.length;
			var i:int = 0;  
			for (i = start; i < arr_len + 1 - count; i++)  //i=start是为了使后续选择的元素都比之前选的元素序号大，避免重复。
			{                                            //i<arr_len+1-count是因为假如第一个元素后面还要选count-1个比它大的
				result[count - 1] = i;                     //那么它最多只有arr_len-(count-1)种选择，而且数组从0开始，所以
				if (count-1 == 0)                  //有了循环约束条件
				{  
					var j:int;
					var str:String="";
					for (j = NUM - 1; j >= 0; j--) //当只剩最后一个数需要选择的时候，就循环输出所有的其他位确定的组合
					{
						str+=arr[result[j]];  
					}
					trace(str);
				}  
				else
				{
					combine_increase(arr, i + 1, result, count-1, NUM); //还有多于一位数需要选择的时候，就递归选择剩  //下数中少一位的组合，直到只剩一位；          
				}
			}  
		}  
		
		
		protected function onUrlLoaded(event:Event):void
		{
			var data:* = (event.target as URLLoader).data;
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onImageSwf);
			//
			var loadercontext:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
			loadercontext.allowCodeImport = true;
			//
			loader.loadBytes(data,loadercontext);
		}
		
		private var textfield:TextField;
		
		protected function onImageSwf(event:Event):void
		{
			var imageCls:Class = getDefinitionByName("image.background") as Class;
			var bitmap:Bitmap = new Bitmap(new imageCls());
			bitmap.width = stage.stageWidth;
			bitmap.height = stage.stageHeight;
			addChild(bitmap);
//			trace(ApplicationDomain.currentDomain.hasDefinition("IMAGE_RED_SON"));
//			addChild(new SilkFlash());
			addChild(new ZooProfile());
			//
			textfield = new TextField();
			textfield.x = 250;
			addChild(textfield);
			//
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onNativeKeyDown);
			//
			if(Capabilities.cpuArchitecture=="ARM")
			{
				NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onNativeDeactivate, false, 0, true);
			}
			//
			if (stage) 
			{
				stage.addEventListener(MouseEvent.CLICK,onClickStage);
			}
			
		}
		
		private var chipCount:int = 0;
		
		protected function onClickStage(event:MouseEvent):void
		{
			var vo:ChipVo = new ChipVo();
			vo.index = int(Math.random()*6);
			var chip:BetChip = BetChip.getChip(this,vo);
//			chip.scaleX = chip.scaleY = 2;
			addChild(chip);
			//
			chipCount++;
			textfield.htmlText = "<font color='#00ff00' size='60'>"+chipCount+"</font>";
			//
			TweenMax.delayedCall(0.1,chip.doMove);
		}
		
		protected function onNativeDeactivate(event:Event):void
		{
			exitApplication();
		}
		
		protected function onNativeKeyDown(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case Keyboard.MENU :
					break;
				
				case Keyboard.BACK :
//					event.preventDefault();
					exitApplication();
					break;
			}
		}
		
		protected function exitApplication():void
		{
			NativeApplication.nativeApplication.exit();
		}
		
	}
}