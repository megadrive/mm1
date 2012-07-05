package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Andrew Simeon
	 */
	public class Megaman extends FlxSprite
	{
		/**
		 * On the ground or not.
		 */
		public var onGround:Boolean = false;
		
		/**
		 * On a ladder or not.
		 */
		public var onLadder:Boolean = false;
		
		/**
		 * If Megaman just got hurt.
		 */
		public var justHurt:Boolean = false;
		
		/**
		 * Internal. The gravity of Megaman.
		 */
		private var _gravity:Number = 600;
		
		/**
		 * Internal. Minimum jump height.
		 */
		public var _minJumpHeight:Number = 7;
		
		/**
		 * Internal. The time jump has been held.
		 */
		public var _jumpHeight:Number = 0;
		
		/**
		 * Internal. Minimum jump height.
		 */
		public var _maxJumpHeight:Number = 25;
		
		/**
		 * Get accessor function for gravity.
		 */
		public function get gravity():Number { return _gravity; }
		
		/**
		 * The left/right movement speed.
		 */
		private var _speed:Number = 75;
		
		/**
		 * Get accessor function for speed.
		 */
		public function get speed():Number { return _speed; }
		
		/**
		 * Reference to the map Megaman is on.
		 */
		public var mapRef:Map;
		
		/**
		 * Internal. Sets off the autofall when Megaman runs off a ledge. Relative to Megaman's pos.
		 * This gets set behind megaman when he is running, modified based on his movement speed.
		 */
		public var _autoFallLeft:FlxSprite;
		public var _autoFallRight:FlxSprite;
		private var _autoFallPos:FlxPoint;
		public var _autoFallGrp:FlxGroup = new FlxGroup();
		
		public function Megaman()
		{
			loadGraphic(Game.SPRITE_MEGAMAN, false, false, 24, 24, true);
			width = 16; height = 16;
			this.offset = new FlxPoint(5, 8);
			
			_autoFallPos = new FlxPoint(width / 2, height + 1);
		//*
			_autoFallLeft = new FlxSprite(0, 0);
			_autoFallLeft.width = 1; _autoFallLeft.height = 1;
			_autoFallLeft.makeGraphic(1, 1);
			_autoFallLeft.visible = false;
		/*/
			_autoFallLeft = new FlxObject(0, 0, 1, 1);
			_autoFallRight = new FlxObject(0, 0, 1, 1);
		/*/
			_autoFallRight = new FlxSprite(0, 0);
			_autoFallRight.width = 1; _autoFallRight.height = 1;
			_autoFallRight.makeGraphic(1, 1);
			_autoFallRight.visible = false;
		//*/
			
			_autoFallGrp.add(_autoFallLeft);
			_autoFallGrp.add(_autoFallRight);
			
			mapRef = null;
		}
		
		override public function update():void
		{
			// TODO This will need revisiting. Not sure this is even needed to be honest.
			if ( onGround )
			{
				velocity.y = 0;
			}
			
			if( !onGround && !onLadder )
			{
				velocity.y += gravity * FlxG.elapsed;
			}
			
			if( !onGround && justTouched(FLOOR) && velocity.y > 0 )
			{
				onGround = true;
				onLadder = false; // prevent ladder climbing to allow megaman to go into the floor
				_jumpHeight = 0;
			}
			
			if( onGround && FlxG.keys.justPressed('Z') )
			{
				velocity.y = (gravity * -_maxJumpHeight) * FlxG.elapsed;
				onGround = false;
			}
			
			if( !onGround && FlxG.keys.pressed('Z') && _jumpHeight < _maxJumpHeight )
			{
				_jumpHeight += 2;
			}
			
			if( !justHurt )
			{
				if( FlxG.keys.pressed('LEFT') )
				{
					x += -speed * FlxG.elapsed;
				}
				if( FlxG.keys.pressed('RIGHT') )
				{
					x += speed * FlxG.elapsed;
				}
			}
			
			// Autofall logic
			_autoFallLeft.x = x + _autoFallPos.x - 8;
			_autoFallLeft.y = y + _autoFallPos.y;
			_autoFallRight.x = x + _autoFallPos.x + 8;
			_autoFallRight.y = y + _autoFallPos.y;
			if( !FlxG.overlap(_autoFallGrp, mapRef.collision) && onGround )
			{
				onGround = false;
			}
		}
	}
}