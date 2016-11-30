package objects;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;

class Enemy extends FlxSprite {
	private static inline var GRAVITY:Int = 420;
	private static inline var WALK_SPEED:Int = 40;
	private static inline var FALLING_SPEED:Int = 200;
	private static inline var SCORE_AMOUNT:Int = 100;
	private static inline var SPRITE_SIZE:Int = 70;

	private var deathSound:FlxSound;

	private var _direction:Int = -1;
	private var _appeared:Bool = false;
	private var _deathCount:Int = 20;
	private var _oppositeDirection:Int = -1;

	public function new(x:Float, y:Float) {
		super(x, y);

		loadGraphic(AssetPaths.spritesheet_baddie__png, true, SPRITE_SIZE, SPRITE_SIZE);
		animation.add("walk", [0, 1, 2, 3, 2, 1], 6);
		animation.add("dead", [3], 12);
		animation.play("walk");

		setSize(28, 15);
		offset.set(20, 34);
		scale.set(0.6, 0.6);

		deathSound = FlxG.sound.load(AssetPaths.reddeath__wav);

		acceleration.y = GRAVITY;
		maxVelocity.y = FALLING_SPEED;
	}

	override public function update(elapsed:Float) {
		if (!inWorldBounds()) {
			exists = false;
		}

		if (isOnScreen())
			_appeared = true;

		if (_appeared) {
			move();

			if (justTouched(FlxObject.WALL))
				flipDirection();

			// if (overlapsAt(x + _direction * width, y + 1, (FlxG.state as PlayState).map.getLayer("foreground"))) {
			// 	// we'll still be on the floor in one width's time; keep walking
			// } else {
			// 	// we'll fall off in a width's time; turn around
			// 	setFacing(facing == LEFT ? RIGHT : LEFT);
			// }
		}

		super.update(elapsed);
	}

	private function flipDirection() {
		flipX = !flipX;
		_direction = -_direction;
	}

	private function move() {
		velocity.x = _direction * WALK_SPEED;
	}

	public function interact(player:Player) {
		FlxObject.separateY(this, player);

		if (player.rooted) {
			if (player.stationary) {
				_oppositeDirection = (x > player.x) ? 1 : -1;

				flipX = _oppositeDirection < 0;
				_direction = _oppositeDirection;
			} else if (alive) {
				deathSound.play();
				alive = false;
				kill();
			}
		} else {
			player.hit();
		}
	}
}