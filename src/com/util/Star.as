package com.util
{
	import flash.geom.Point;

	public class Star
	{
		public var position:Point;
		public var alpha:Number;
		private var angle:Number;
		private var speed:Number;
		
		
		
		public function Star(pPosition:Point)
		{
			position = pPosition;
			angle = Math.random() * Math.PI * 2;
			alpha = .5 + .5 *Math.random();
			speed = .2 + 2*Math.random();
		}
		public function update():void{
			position.x += Math.cos(angle) * speed;
			position.y += Math.sin(angle) * speed;
			alpha -=.01 + .1*Math.random();
			speed *=.95;
		}
	}
}