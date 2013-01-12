package  
{
	import flash.geom.Point;
	import flash.utils.describeType;
	
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
		private const MaxVelocity_:Number = 350;
		private const MaxYVelocity_:Number = 800;
		
		private const PaddleEdgeYVelocityChange_:Number = 150;
		private const PaddleMiddleYVelocityChange_:Number = 75;
		private const WallYVelocityChange_:Number = 100;
		
		private var VelocityXIncrease_:VarTween;
		private var VelocityYIncrease_:VarTween;
		
		private var BallColor_:Number;
		
		private static var CurrentBallColor:Number =0;
				
		
		public function Ball() 
		{
			Velocity_ = new Point(1.0, 1.0);
			
			Image_ = new Image(Assets.BallImage);
			graphic = Image_;
			setHitbox(
				Image_.width - 10, 
				Image_.height - 10, 
				-5,
				-5
			);
			
			// Randomly select one of the colors from color index.
			BallColor_ = CurrentBallColor++; //Math.round( Math.random() * (Assets.kNeonColors.length));
			if (CurrentBallColor >= Assets.kNeonColors.length) CurrentBallColor = 0;
			
			
			Image_.color = Assets.kNeonColors[BallColor_];
			
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
		
		public function UpdateCollidedEntityColor(e:Entity, collideOnX:Boolean):void
		{
			// See if it's a level
			var type:String = describeType(e).@base.toString();
			
			var lvlEntity:Level = e as Level;
			if (lvlEntity != null) {
				var offsetX:Number = Assets.kTileWidth;
				var offsetY:Number = Assets.kTileHeight;
				
				if (collideOnX) {
					if (Velocity_.x < 0) {
						offsetX *= -1.0;
					//	offsetX -= -1.0;
					} else {
						offsetX += width;
					//	offsetX += 1;
					}
				} else {
					if (Velocity_.y < 0) {
						offsetY *= -1.0;
					//	offsetY -= 1.0;
					} else {
						offsetY += height;
					//	offsetY += 1.0;
					}
				}

				lvlEntity.SetTileColor(x + offsetX, y + offsetY, BallColor_);				
			}
			
			var paddleEntity:Paddle = e as Paddle;
			if (paddleEntity != null) {
				var color:uint = paddleEntity.GetColor();
				
				color = (color + Assets.kNeonColors[BallColor_]);
				
				// Make sure alpha channel is completely set.
				//color |= 0xff000000;
				//paddleEntity.SetColor(color);
				paddleEntity.SetColor(Assets.kNeonColors[BallColor_]);
				
			}
		}
		
		override public function moveCollideX(e:Entity): Boolean
		{
			// Do this before flipping velocity.
			UpdateCollidedEntityColor(e, true);
			
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
					CurrentVelocityY -= PaddleEdgeYVelocityChange_;			// Modify paddle velocity
				} else if (y < (e.y + 40)) {	// Middle of paddle
					// Basic goal of this is for the middle of the paddle, it should reduce ball velocity.
					// If hit enough times in this "sweet spot", the Y velocity will go to zero, i.e. straight.
					if(CurrentVelocityY < 0) {
						CurrentVelocityY -= PaddleMiddleYVelocityChange_;
					} else {
						CurrentVelocityY += PaddleMiddleYVelocityChange_;
					}
					
					if ( (CurrentVelocityY > -PaddleMiddleYVelocityChange_) && (CurrentVelocityY < PaddleMiddleYVelocityChange_) ) {
						CurrentVelocityY = 0;
					}
				} else {						// Bottom of paddle
					CurrentVelocityY += PaddleEdgeYVelocityChange_;
				}
			} else {
				// Add a bit of velocity on every wall bounce
				if (CurrentVelocityY < 0) {
					CurrentVelocityY -= WallYVelocityChange_;
				} else {
					CurrentVelocityY += WallYVelocityChange_;
				}
			}
		
			// Clamp Y velocity
			if (CurrentVelocityY > MaxYVelocity_) CurrentVelocityY = MaxYVelocity_;
			if (CurrentVelocityY < -MaxYVelocity_) CurrentVelocityY = -MaxYVelocity_;
			
			return super.moveCollideX(e);
		}
		
		override public function moveCollideY(e:Entity): Boolean
		{
			// Do this before flipping velocity
			UpdateCollidedEntityColor(e, false);
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