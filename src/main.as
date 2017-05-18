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
	
	import sudoku.Sudoku;
	
	
//	[SWF(width="720",height="1280"backgroundColor="#333333")]
	public class main extends Sprite
	{
		public function main()
		{
			super();
			new Sudoku();
			
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
			//stage.autoOrients = false;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate=30;
			//
//			root.scale
			//
			var urlloader:URLLoader = new URLLoader();
			urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			urlloader.addEventListener(Event.COMPLETE,onUrlLoaded);
			urlloader.load(new URLRequest("assets/image.swf"));
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