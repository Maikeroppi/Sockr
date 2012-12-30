package  
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.VarTween;
	
	/**
	 * ...
	 * @author Maikeroppi
	 */
	public class Ball extends Entity 
	{
		private var Speed_:Number;
		private var Velocity_:Point;
		private var Movement_:Point;
		private var Image_:Image;
		
		public var CurrentVelocityX:Number;
		public var CurrentVelocityY:Number;
		
		private const HVelocity_:Number = 200;
		private const VVelocity_:Number = 200;
		
		private const StartVelocity_:Number = 200;
		private const MaxVelocity_:Number = 400;
		private const MaxYVelocity_:Number = 500;
		
		private var VelocityXIncrease_:VarTween;
		private var VelocityYIncrease_:VarTween;
				
		
		public function Ball() 
		{
			//Velocity_ = new Point(StartVelocity_, StartVelocity_);
			Velocity_ = new Point(1.0, 1.0);
			
			Image_ = new Image(Assets.BallImage);
			graphic = Image_;
			setHitbox(
				Image_.width - 10, 
				Image_.height - 10, 
				-5,
				-5
			);
			
			Image_.color = Math.random() * 0xffffffff;
			
			type = "ball";
			
			x = Assets.kScreenWidth / 2;
			y = Assets.kScreenHeight / 2;
			
			VelocityXIncrease_ = new VarTween();
			VelocityYIncrease_ = new VarTween();
			
			CurrentVelocityX = StartVelocity_;
			CurrentVelocityY = StartVelocity_;
			
			VelocityXIncrease_.tween(this, "CurrentVelocityX", MaxVelocity_, 6.0);			
			//VelocityYIncrease_.tween(this, "CurrentVelocityY", MaxVelocity_, 6.0);
			
			addTween(VelocityXIncrease_, true);
			//addTween(VelocityYIncrease_, true);
		}
		
		override public function update():void
		{
			// Move ball, collide against levels and player, and perform sweeping (ball won't go through wall)
			moveBy(
				Velocity_.x * FP.elapsed * CurrentVelocityX, 
				Velocity_.y * FP.elapsed * CurrentVelocityY, 
				["player", "level"], 
				false
			);
		
			super.update();
		}
		
		override public function moveCollideX(e:Entity): Boolean
		{
			Velocity_.x *= -1.0;
			
			// Check to see if the ball is overlapping the entity
			if (e.type == "player") {
				if (collideWith(e, x, y) ) {
					if ( originX <= e.originX) {	// Collision happened from right
						x -= (originX + width) - e.originX;
					} else {						// Collision happened from left, not right
						x += ( e.originX + e.width) - originX;
					}
				}
				

			}
			
			if(e.type == "player") {
				// Affect ball velocity based on position on paddle
				if (y < (e.y + 20) ) {			// Top of paddle
					CurrentVelocityY -= 75;			// Modify paddle velocity
				} else if (y < (e.y + 40)) {	// Middle of paddle
					CurrentVelocityY -= 50;
				} else {						// Bottom of paddle
					CurrentVelocityY += 75;
				}
			} else {
				// Add a bit of velocity on every wall bounce
				CurrentVelocityY += 50;
			}
			
			// Clamp Y velocity
			if (CurrentVelocityY > MaxYVelocity_) CurrentVelocityY = MaxYVelocity_;
			if (CurrentVelocityY < -MaxYVelocity_) CurrentVelocityY = -MaxYVelocity_;
			
			return super.moveCollideX(e);
		}
		
		override public function moveCollideY(e:Entity): Boolean
		{
			Velocity_.y *= -1.0;
			
			//Check to see if the ball is overlapping the entity
			if(e.type == "player" && collideWith(e, x, y) ) {
				if ( originY <= e.originY) {	// Collision happened from bottom
					y -= (originY + height) - e.originY;
				} else {						// Collision happened from top
					y += ( e.originY + e.height) - originY;
				}
			}
			
			return super.moveCollideY(e);
		}
		
	}

}