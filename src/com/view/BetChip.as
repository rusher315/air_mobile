package com.view
{
	import com.greensock.TweenMax;
	import com.model.ChipVo;
	import com.util.BitmapUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	
	public class BetChip extends Sprite
	{
		public static const CHIP_DISPOSE_ONE:String = "ONE_BETCHIP_DISPOSE_COMPLETE";
		private static const POOL_SIZE:int = 2000;
		
		private static var chipPool:Dictionary = new Dictionary(true);
		private static var poolIndex:uint=0;
		private static var chipCount:int=0;
		private static var tweenIdList:Vector.<int> = new Vector.<int>();
		//
		protected static var _clipX:int = 6;
		protected static var _clipY:int = 1;
		protected static var _url:String = "png.assets.clip.chip_table";
		
		protected static var _clips:Vector.<BitmapData>;
		protected static var _imageWidth:Number = 1;
		protected static var _imageHeight:Number = 1;
		protected static var _clipWidth:Number = 1;
		protected static var _clipHeight:Number = 1;
		
		protected var _bitmap:Bitmap;
		
		private var _container:DisplayObjectContainer;
		protected var _data:ChipVo;
		protected var _id:int=-1;
		
		public static function getChip(container:DisplayObjectContainer,chip:ChipVo):BetChip
		{
			var temp:BetChip;
			//
			while(poolIndex)
			{
				poolIndex--;
				temp=chipPool[poolIndex];
				if (temp!=null) 
				{
					delete chipPool[poolIndex];
					break;
				}
			}
			//
			if (temp==null)temp=new BetChip();
			temp.reset(container,chip);
			return temp;
		}
		
		public function BetChip()
		{
			super();
			chipCount++;
			_id=chipCount;
			//
			_bitmap = new Bitmap();
			addChild(_bitmap);
			//
			this.mouseChildren = false;
			this.mouseEnabled = false;
			//
			if (_clips==null) 
			{
				TweenMax.delayedCall(0.1,initClipList);
			}
		}
		
		protected function initClipList():void
		{
			if (_clips!=null) 
			{
				TweenMax.delayedCall(0.1,resetBtimap);
			}
			else if (ApplicationDomain.currentDomain.hasDefinition(_url))
			{
				var imageCls:Class = getDefinitionByName(_url) as Class;
				loadComplete(_url,new imageCls());
			} 
			else 
			{
			}
		}
		
		protected function loadComplete(url:String, bmd:BitmapData):void 
		{
			if (url!= _url||bmd==null)return; 
			if (_clips==null) 
			{
				_imageWidth = bmd.width;
				_imageHeight = bmd.height;
				_clipWidth = _imageWidth / _clipX;
				_clipHeight = _imageHeight / _clipY;
				_clips = BitmapUtils.createClips(bmd, _clipX, _clipY);
			}
			TweenMax.delayedCall(0.1,resetBtimap);
		}
		
		/**当前值*/
		public function get chipIndex():int
		{
			return _data.index;
		}
		
		public function set chipIndex(value:int):void
		{
			_data.index = value;
			setClip(_data.index);
		}
		
		private function setClip(index:int):void
		{
			if (_clips==null||_clips.length==0)return; 
			if (_clips.length!=_clipX)throw new Error();
			index = (index < _clips.length && index > -1) ? index : 0;
			//
			_bitmap.bitmapData = _clips[index];
			_bitmap.x = -_clipWidth*0.5;
			_bitmap.y = -_clipHeight*0.5;
			//
//			_bitmap.smoothing = true;
		}
		
		private function resetBtimap():void
		{
			chipIndex = _data.index;
		}
		
		public function removeChildChip():void
		{
			if (parent!=null) 
			{
				if (!_container.contains(this)) throw new Error("");
				_container.removeChild(this);
			}
		}
		
		public function addChildChip():void
		{
			if (!_container.contains(this)) _container.addChild(this);
		}
		
		private function reset(container:DisplayObjectContainer,chip:ChipVo):void
		{
			if (container==null)throw new Error(""); 
			_container = container;
			_data = chip;
			//
			resetBtimap();
		}
		
		public function doMove():void
		{
			stage.addEventListener(Event.ENTER_FRAME,move);
		}
		
		private var speedx:int = 5;
		private var speedy:int = 5;
		public function move(e:*=null):void
		{
			if (this.x<=0) speedx=5+Math.random()*3;
			else if (this.x>=stage.stageWidth) speedx=-(5+Math.random()*3);
			this.x+=speedx;
			//
			if (this.y<=0) speedy=5+Math.random()*3;
			else if (this.y>=stage.stageHeight) speedy=-(5+Math.random()*3);
			this.y+=speedy;
		}
		
		public function doTween(to:Point,from:Point=null,duration:Number=1,delay:Number=0,isHide:Boolean=false,toZone:int=-1,isRandom:Boolean=false,isTop:Boolean=true,isFadeOut:Boolean=false,isDispose:Boolean=false):void
		{
			stopTweening();
			addChildChip();
			if (from) 
			{
				from = parent.globalToLocal(from);
				this.x = from.x;
				this.y = from.y;
			}
			else
			{
				from = new Point(this.x,this.y);
			}
			to = parent.globalToLocal(to);
			addTweenCount(_id);
			var temp:Number = duration;
			if (isRandom) 
			{
				var type:int = Math.random()>0.5?1:-1;
				temp = duration+Number((duration*0.21*Math.random()).toFixed(2))*type;
			}
			var tweenObj:Object = {delay:delay,x:to.x,y:to.y,onComplete:tweenComplete,onCompleteParams:[isHide,toZone,isTop,isDispose]};
			if (isFadeOut) 
			{
				tweenObj.autoAlpha=0;
			}
			TweenMax.to(this,temp,tweenObj);
		}
		
		private function tweenComplete(isHide:Boolean,zone:int,isTop:Boolean,isDispose:Boolean):void
		{
			if (isHide) this.visible = false;
			//
			if(parent&&_container&&isTop)_container.setChildIndex(this,_container.numChildren-1);
			//
			removeTweenCount(_id);
			//
			if (isDispose) dispose();
			//
			if (tweenIdList.length==0) 
			{
				//todo
			}
		}
		
		protected function get isTweening():Boolean
		{
			return TweenMax.isTweening(this);
		}
		
		protected function stopTweening():void
		{
			if (isTweening) 
			{
				TweenMax.killTweensOf(this);
			}
			if (tweenIdListContain(_id))
			{
				removeTweenCount(_id);
			}
		}
		
		public function get data():ChipVo
		{
			return _data;
		}
		
		protected function addTweenCount(id:int):void
		{
			if (tweenIdListContain(id)||id==-1) throw new Error("");
			tweenIdList.push(id);
		}
		
		protected function removeTweenCount(id:int):void
		{
			if (!tweenIdListContain(id)||id==-1)
			{
				return;
			}
			var tempIndex:int = tweenIdList.indexOf(id);
			tweenIdList.splice(tempIndex,1);
		}
		
		protected function tweenIdListContain(id:int):Boolean
		{
			return (tweenIdList.indexOf(id)!=-1);
		}
		
		public function dispose():void
		{
			removeChildChip();
			//
			alpha = 1;
			visible = true;
			_container = null;
			_data=null;
			_bitmap.bitmapData= null;
			//
			stopTweening();
			//
			if (poolIndex<POOL_SIZE)
			{
				chipPool[poolIndex] = this;
				poolIndex++;
			}
			//
		}
		
		public function get id():int
		{
			return _id;
		}
		
	}
}