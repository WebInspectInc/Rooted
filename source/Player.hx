package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxObject;
import flixel.math.FlxMath;

class Player extends FlxSprite {
	private static inline var ACCELERATION:Int = 420;
	private static inline var DRAG:Int = 220;
	private static inline var GRAVITY:Int = 600;
	private static inline var JUMP_FORCE:Int = -280;
	private static inline var WALK_SPEED:Int = 80;
	private static inline var RUN_SPEED:Int = 140;
	private static inline var FALLING_SPEED:Int = 300;
	private static inline var SPRITE_SIZE:Int = 32;
	private static inline var MAIN_GRAPHIC:FlxGraphicAsset = AssetPaths.tinycharacter__png;

	public var direction:Int = 1;
	public function new() {
		super();
		loadGraphic(MAIN_GRAPHIC, true, SPRITE_SIZE, SPRITE_SIZE);

		animation.add("idle", [0]);
		animation.add("walk", [1, 2, 3], 12);
		animation.add("skid", [4]);
		animation.add("jump", [5]);
		animation.add("fall", [5]);
		animation.add("dead", [12]);

		setSize(20, 28);
		offset.set(6, 4);

		drag.x = DRAG;
		acceleration.y = GRAVITY;
		maxVelocity.set(WALK_SPEED, FALLING_SPEED);
	}

	private function move() {
		acceleration.x = 0;

		if (FlxG.keys.pressed.LEFT) {
			flipX = true;
			direction = -1;
			acceleration.x -= ACCELERATION;
		} else if (FlxG.keys.pressed.RIGHT) {
			flipX = false;
			direction = 1;
			acceleration.x += ACCELERATION;
		}

		if (velocity.y == 0) {
			if (FlxG.keys.justPressed.C && isTouching(FlxObject.FLOOR)) {
				velocity.y = JUMP_FORCE;
			}

			if (FlxG.keys.pressed.X) {
				maxVelocity.x = RUN_SPEED;
			} else {
				maxVelocity.x = WALK_SPEED;
			}
		}

		if ((velocity.y < 0) && (FlxG.keys.justReleased.C)) {
			velocity.y = velocity.y * 0.5;
		}

		if (x < 0)
			x = 0;
	}

	private function animate() {
		if ((velocity.y <= 0) && (!isTouching(FlxObject.FLOOR))) {
			animation.play("jump");
		} else if (velocity.y > 0) {
			animation.play("fall");
		} else if (velocity.x == 0) {
			animation.play("idle");
		} else {
			if (FlxMath.signOf(velocity.x) != FlxMath.signOf(direction)) {
				animation.play("skid");
			} else {
				animation.play("walk");
			}
		}
	}

	override public function update(elapsed:Float):Void {
		move();
		animate();

		super.update(elapsed);
	}
	
}