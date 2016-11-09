package objects;

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
	private static inline var WALK_SPEED:Int = 140;
	private static inline var RUN_SPEED:Int = 180;
	private static inline var FALLING_SPEED:Int = 300;
	private static inline var SPRITE_SIZE:Int = 64;
	private static inline var MAIN_GRAPHIC:FlxGraphicAsset = AssetPaths.slime__png;

	private var startHealth:Float = Reg.health;
	private var invincibility:Int = 0;

	public var rootDuration:Int = 100;
	public var rootTime:Int = Reg.rootTime;
	public var rooted:Bool = false;
	public var noRoot = false;
	public var direction:Int = 1;
	public var stationary:Bool = false;
	public function new() {
		super();
		loadGraphic(MAIN_GRAPHIC, true, SPRITE_SIZE, SPRITE_SIZE);


		animation.add("idle", [100]);
		animation.add("walk", [101,102], 12);
		animation.add("skid", [100]);
		animation.add("jump", [123]);
		animation.add("fall", [126]);
		animation.add("dead", [146]);
		animation.add("hurt", [146]);
		animation.add("rooted", [128]);

		setSize(24, 30);
		offset.set(20, 34);

		health = startHealth;
		drag.x = DRAG;
		acceleration.y = GRAVITY;
		maxVelocity.set(WALK_SPEED, FALLING_SPEED);
	}

	private function move() {
		acceleration.x = 0;
		acceleration.y = GRAVITY;

		if (FlxG.keys.pressed.LEFT && !rooted) {
			flipX = false;
			direction = -1;
			acceleration.x -= ACCELERATION;
		} else if (FlxG.keys.pressed.RIGHT && !rooted) {
			flipX = true;
			direction = 1;
			acceleration.x += ACCELERATION;
		}

		if (velocity.y == 0) {
			if (FlxG.keys.justPressed.C && (isTouching(FlxObject.FLOOR) || rooted)) {
				velocity.y = JUMP_FORCE;
				rooted = false;
			}

			if (FlxG.keys.pressed.X) {
				maxVelocity.x = RUN_SPEED;
			} else {
				maxVelocity.x = WALK_SPEED;
			}
		}

		if ((velocity.y < 0) && (FlxG.keys.justReleased.C)) {
			// variable jump height
			velocity.y = velocity.y * 0.5;
		}

		if (FlxG.keys.pressed.X && isTouching(FlxObject.ANY)) {
			rootCharacter();
		}

		if (rooted) {
			// wall jumping
			velocity.y = 0;
			acceleration.y = 0;
			if (FlxG.keys.pressed.DOWN) {
				rooted = false;
			}
			if (rootTime > 0) {
				rootTime--;
				Reg.rootTime = rootTime;
			} else {
				rooted = false;
				stationary = false;
			}

			if (velocity.x == 0) {
				stationary = true;
			} else {
				stationary = false;
			}
		} else {
			if (rootTime < 100) {
				rootTime++;
				Reg.rootTime = rootTime;
			}
		}

		if (x < 0)
			x = 0;

		Reg.playerX = x;
	}

	public function hit() {
		if (invincibility <= 0) {
			hurt(10);
			// velocity.y = -velocity.y * 2;
			velocity.y = JUMP_FORCE / 2;
			velocity.x = -velocity.x * 2;
			Reg.health -= 10;
			invincibility = 200;
		}
	}

	private function rootCharacter() {
		if (!noRoot) {
			rooted = true;
		}
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
		if (rooted) {
			animation.play("rooted");
		}
	}

	override public function update(elapsed:Float):Void {
		move();
		animate();

		if (invincibility > 0) {
			invincibility -= 1;

			if (invincibility % 7 == 0) {
				alpha = 0.2;
			} else {
				alpha = 1;
			}
		} else {
			alpha = 1;
		}

		super.update(elapsed);
	}
	
}