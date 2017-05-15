/**
 * @Author James Li
 * 2011-2-11 Tunisia, Tunis,
 * http://jamesli.cn/blog;
 * 
 * This class shows an effect same to the one created via HTML5 on weavesilk.com.
 * It is very nice but I believe flash can do the same, here I write the core class and 
 * leave other simple effects such as stars and record/replay away.
 * 
 * */
package com.util
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.GraphicsPathCommand;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	public class SilkFlash extends Sprite
	{
		private var background:Bitmap;
		private var lineShape:Shape;
		private var outputBitmap:Bitmap;
		private var lightBitmapData:BitmapData;
		private var isWind:Boolean;
		private var windX:Number=6;
		private var windY:Number=0.1;
		private var isMouseDown:Boolean;
		private var isDrawable:Boolean;
		private var colorTransform:ColorTransform;
		private var bitmapColorTransform:ColorTransform;
		private var datas:Vector.<Point>;
		private var graphicsCommand:Vector.<int>;
		private var graphicsDatas:Vector.<Number>;
		private var step:int=0;
		private var alphaStep:int=0;
		private var fadeStep:Number=6;
		private var headRandomStep:Number=15;

		private var starBitmap:Bitmap;
		private var stars:Vector.<Star>;

		private var r:int;
		private var g:int;
		private var b:int;
		
		private var isEnd:Boolean = false;
		private var endStep:int = 0;
		
		public function SilkFlash()
		{
			addEventListener(Event.ADDED_TO_STAGE,onAdd);
		}
		private function onAdd(pEvent:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE,onAdd);
			createViews();
			createKeyboardEvents();
			getReady();
			createHelpTexts();
			
			addEventListener(Event.ENTER_FRAME,enterFrameHandler);
		}
		private function createHelpTexts():void{
			var text:TextField = new TextField();
			var tf:TextFormat = new TextFormat();
			tf.color = 0x666666;
			tf.font = "Arial"
			
			text.x = text.y = 10;
			text.width = background.width;
			text.selectable = false;
			//text.mouseEnabled = false;
			text.multiline = true;
			addChild(text);
			
			text.htmlText = "The original effect comes from <a href='http://weavesilk.com' target='_blank'><u>http://weavesilk.com/</u></a>, " +
				" Now I create and share a <a href='http://jamesli.cn/uploads/silk_flash/SilkFlash.as.zip'><u>Flash version.</u></a>" +
				"\nPlease click and drag to draw silks. Press X to renew. Press S to stop. Hold Shift and move mouse to change the wind.";
			
			text.setTextFormat(tf);
		}
		private function createViews():void{
			stage.quality = StageQuality.BEST;
			stage.frameRate = 30;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			
			background = new Bitmap(new BitmapData(1440,900,false,0));
			addChild(background);
			outputBitmap = new Bitmap(new BitmapData(background.width,background.height,false,0xFF));
		
			addChild(outputBitmap);
			
			//Every time draw line in this shape.
			lineShape = new Shape();
			addChild(lineShape);
			
			//This colorTransform provide the base color of the line.
			colorTransform = new ColorTransform();
			
			//This colorTransform create light effect to the silk.
			bitmapColorTransform = new ColorTransform(1,1,1,1,100,100,100,20);
			
			stars = new Vector.<Star>();
			starBitmap = new Bitmap(new BitmapData(background.width,background.height,true,0x00));
			addChild(starBitmap);

		}

		private function resetColor():void{
			var colorArray:Array = [0xFF0000,0xFFFF00,0x00FF00,0x00FFFF,0x0000FF,0xFF00FF];
			var c:int = colorArray[Math.floor(Math.random()*colorArray.length)];
			colorTransform.color = c;
			r = (c >>16);
			g =(c-(r<<16)) >> 8;
			b = c-(r<<16)-(g<<8);
			//trace(c.toString(16)+",r: "+r+",g: "+g+",b"+b);
		}
		private function createKeyboardEvents():void{
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
		}
		private function onKeyDown(pEvent:KeyboardEvent):void{
			if(pEvent.keyCode == Keyboard.SHIFT){
				isWind = true;
			}else if(pEvent.keyCode == 88){
				//X
				getReady();
			}else if(pEvent.keyCode == 83){
				//S
				stopSilk();
			}
		}
		private function onKeyUp(pEvent:KeyboardEvent):void{
			isWind = false;
		}
		
		//Clean the board and be ready to draw.
		private function getReady():void{
			outputBitmap.bitmapData.fillRect(outputBitmap.bitmapData.rect,0xFF000000);
			resetAll();
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		private function onMouseDown(pEvent:MouseEvent):void{
			resetAll();
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			
			isMouseDown = true;
			lineShape.graphics.lineStyle(0,colorTransform.color);
			lineShape.graphics.moveTo(mouseX,mouseY);

		}
		private function onMouseMove(pEvent:MouseEvent):void{
			if(isMouseDown){
				var cpt:Point = new Point(mouseX,mouseY);
				lineShape.graphics.lineTo(cpt.x,cpt.y);
				datas.push(cpt);
				
				newStar(cpt);
			}
		}
		private function onMouseUp(pEvent:MouseEvent):void{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			isMouseDown = false;
			startSilk();
		}
		private function startSilk():void{
			isDrawable = true;
			if(lineShape.parent){
				removeChild(lineShape);
			}
			if(datas.length<3){
				resetAll();
				return;
			}
			updateGraphicsCommand();
		}
		private function stopSilk():void{
			//removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
			isDrawable = false;
			stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		}
		private function resetAll():void{
			stopSilk();
			
			//datas stores every dot on the line that created by drawing
			datas = new Vector.<Point>();
			
			//this will define how to connect every dot via drawing API.
			graphicsCommand = new Vector.<int>();
			
			//this stores every coordinate information for drawing API.
			graphicsDatas = new Vector.<Number>();
			
			//prepare the line.
			lineShape.graphics.clear();
			if(!lineShape.parent) addChild(lineShape);
			lineShape.alpha=1;
			
			//reset color alpha.
			resetColor();
			bitmapColorTransform.alphaOffset= 20;
			
			//reset indicators.
			step = 0;
			endStep = 0;
		}
		private function enterFrameHandler(pEvent:Event):void{
			updateStars();
			if(!isDrawable) return;
			if(isWind){
				windX = Math.max(Math.min(mouseX - background.width/2,4),0);
				windY = Math.max(Math.min(mouseY - background.height/2,1),-1);
			}
			updateColorTransform();
			update();
		}
		private function update():void{
			updateShape();
			//record();
		}
		private function updateColorTransform():void{
			//Base color will turn as this sequence: 0xFF0000 ->0xFFFF00 -> 0x00FF00 -> 0x00FFFF -> 0x0000FF -> 0xFF00FF -> 0xFF0000
			var speed:Number = 0xFF/80;
			
			if(r>0){
				if(g>=0xFF){
					r-=speed;
				}else if(b>=0xFF){
					r +=speed;
				}else if(b==0){
					g+=speed;
				}
			}
			if(g>0){
				if(b>=0xFF){
					g-=speed;
				}else if(r>=0xFF){
					g +=speed;
				}else if(r==0){
					b+=speed;
				}
			}
			if(b>0){
				if(r>=0xFF){
					b-=speed;
				}else if(g>=0xFF){
					b +=speed;
				}else if(g==0){
					r+=speed;
				}
			}
			r = Math.max(Math.min(0xFF,r),0);
			g = Math.max(Math.min(0xFF,g),0);
			b = Math.max(Math.min(0xFF,b),0);
			colorTransform.color = (r<<16)+(g<<8)+b;
		}
		
		private function updateGraphicsCommand():void{
			//this will prepare necessary paramter for API 'drawPath'
			graphicsCommand = new Vector.<int>(datas.length);
			for(var i:int=0;i<graphicsCommand.length;i++){
				if(i==0){
					graphicsCommand[i] = GraphicsPathCommand.MOVE_TO;
				}else{
					graphicsCommand[i] = GraphicsPathCommand.CURVE_TO;
				}
			}
		}
		/**
		 * This method will create fills between two lines and draw the silk.
		 * */
		private function updateShape():void{
			var gpd:Vector.<Number> = newSilkLine();
			if(step>0){
				//The space between two lines will be equarely devided into 20 parts, means there will be 19 more lines between two random lines.
				var number:Number =20;
				for(var i:int=0;i<number;i++){
					var g:Vector.<Number> = new Vector.<Number>();
					for(var j:int=0;j<gpd.length;j++){
						g.push(graphicsDatas[j]+i*(gpd[j] - graphicsDatas[j])/number);
					}
					lineShape.graphics.clear();
					lineShape.graphics.lineStyle(0,colorTransform.color,0);
					lineShape.graphics.drawPath(graphicsCommand,g);
					//use BlendMode.ADD, will create light effect on the silk.
					outputBitmap.bitmapData.draw(lineShape,null,bitmapColorTransform,BlendMode.ADD,null,true);
				}
			}
			graphicsDatas = gpd;
			step ++;
		}
		/**
		 * This method will calculate how to connect random dots to a curve smooth line.
		 * */
		private function newSilkLine():Vector.<Number>{
			var gpd:Vector.<Number> = new Vector.<Number>();
			//var anchorPoint:Point = new Point();
			for(var i:int=datas.length-1;i>=0;i--){
				if(i<2){
					//The first two dots will fly much stronger.
					datas[i].x += windX*1.05  + (1 - 2 * Math.random())*headRandomStep;
					datas[i].y += windY*1.05 + (1 - 2 * Math.random())*headRandomStep
				}else{
					//other dots will fly slightly.
					datas[i].x += windX  + (1 - 2 * Math.random()) * fadeStep;
					datas[i].y += windY + (1 - 2 * Math.random()) * fadeStep;
				}
				if(i>0){
					//Except the first dot, all other dot will slightly follow their previous dots, the silk will shrink because of this.
					datas[i].x += (datas[i-1].x - datas[i].x)/7;
					datas[i].y += (datas[i-1].y - datas[i].y)/7;
				}
				/*gpd.push(datas[i].x);
				gpd.push(datas[i].y);
				
				if(i==datas.length-1 && i>0){
					anchorPoint.x = (datas[i].x + datas[i-1].x)/2;
					anchorPoint.y = (datas[i].y + datas[i-1].y)/2;
				}else{
					anchorPoint.x = 2 * datas[i].x - anchorPoint.x;
					anchorPoint.y = 2 * datas[i].y - anchorPoint.y;
				}
				if(i>0){
					gpd.push(anchorPoint.x);
					gpd.push(anchorPoint.y);
				}*/
				if(i<datas.length-1){
					//preparing curve, the line won't connect the dots themselves, but to go through them and take all the dots as anchor coordinates.
					var x2:Number = (datas[i].x + datas[i+1].x)/2;
					var y2:Number = (datas[i].y + datas[i+1].y)/2;
					var ax:Number = datas[i+1].x;
					var ay:Number = datas[i+1].y;
					if(i<datas.length-2){
						gpd.push(ax);
						gpd.push(ay);
					}
					gpd.push(x2);
					gpd.push(y2);
				}
				if(i% Math.round(Math.random()*5 +2)==0) newStar(new Point(x2,y2));
			}

			//Fading silk
			bitmapColorTransform.alphaOffset-=.1;
			if(step%11==0){
				if(datas.length>0){
					//remove the head dot in order to shrink the silk.
					datas.shift();
				}else{
					if(endStep<4){
						//creating tail.
						endStep++;
					}else{
						stopSilk();
					}
				}
			}
			if(bitmapColorTransform.alphaOffset<=3){
				stopSilk();
			}
			return gpd;
		}
		
		private function newStar(pPoint:Point):void{
			stars.push(new Star(pPoint));
		}
		private function updateStars():void{
			starBitmap.bitmapData.fillRect(starBitmap.bitmapData.rect,0x00);
			for(var i:int=0;i<stars.length;i++){
				var star:Star = stars[i];
				star.update();
				if(star.alpha<=0){
					stars.splice(i--,1);
				}else{
					starBitmap.bitmapData.setPixel32(star.position.x,star.position.y, 
						Math.round((0xFF * star.alpha) <<24) + 0xFFFFFF);
				}
			}
		}

	}
}