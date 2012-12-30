package  
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Maikeroppi
	 */
	public class Paddle extends Entity 
	{
		private var PlayerNumber_:int;
		private var UpKey_:int;
		private var DownKey_:int;
		
		private const MovementScale_:Number = 500;
		private var MovementNumber_:Number;
		
		public function Paddle(Player:int = 0) 
		{
			PlayerNumber_ = Player;
			type = "player";
			
			if (PlayerNumber_ == 2) {
				UpKey_ = Key.UP;
				DownKey_ = Key.DOWN;;
			} else {
				UpKey_ = Key.W;
				DownKey_ = Key.S;
			}
			
			MovementNumber_ = 0;
		}
		
		public function updatePosition():void 
		{
			var MovementDirection:Number = 0;
			
			if (Input.check(UpKey_)) {
				MovementDirection = -1.0;
			}
			
			if (Input.check(DownKey_)) {
				MovementDirection = 1.0;
			}
			
			MovementNumber_ =  MovementDirection * MovementScale_ * FP.elapsed;
			
			moveBy(0, MovementNumber_, ["level", "ball"], false);
		}
		
		override public function update():void
		{
			updatePosition();
			super.update();
		}
		
		public function CorrectForBallCollisionOnMove():void
		{
			var TheBalls:Array = new Array();
			
			var StartX:int = originX;
			var StartY:int = originY;
			var EndX:int = StartX + width;
			var EndY:int = StartY + height;
						
			// Get all balls collided with
			collideInto("ball", x, y, TheBalls);
			
			// Loop over the balls, correcting their position
			//for each( var currentBall:Ball in TheBalls) {
				//
				// check for collision in x direction
				//if (
					//
				//) {
				//}
			//}
		}
	}

}