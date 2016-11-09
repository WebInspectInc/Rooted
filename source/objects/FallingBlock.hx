package objects;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxTimer;

class FallingBlock extends FlxSprite {
	private static inline var GRAVITY:Int = 420;
	private static inline var FALLING_SPEED:Int = 200;

	private var _appeared:Bool = false;

	public function new(x:Float, y:Float) {
		super(x, y);

		loadGraphic(AssetPaths.tinytiles__png, true, 32, 32);
		animation.add("block", [123], 12);
		animation.play("block");
	}

	override public function update(elapsed:Float) {
		if (!inWorldBounds()) {
			exists = false;
		}

		if (isOnScreen())
			_appeared = true;

		if (_appeared) {
			if (Reg.playerX > x - 16 && Reg.playerX < x + 16) {
				fall();
			}
		}

		super.update(elapsed);
	}

	private function fall() {
		velocity.y = FALLING_SPEED;
		acceleration.y = GRAVITY;
	}

	public function interact(player:Player) {
		FlxObject.separateY(this, player);

		player.hit();
		kill();
	}
}