package objects;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxTimer;

class HiddenSpike extends FlxSprite {
	private static inline var ATTACK_SPEED:Int = 40;

	private var _countdown:Int = ATTACK_SPEED;
	private var _playerTouched:Bool = false;
	private var _spikeOut:Bool = false;

	public function new(x:Float, y:Float) {
		super(x, y);

		loadGraphic(AssetPaths.tinytiles__png, true, 32, 32);
		animation.add("hidden", [248], 12);
		animation.add("attack", [228], 12);
		animation.play("hidden");

		immovable = true;
		moves = false;
		allowCollisions = FlxObject.WALL;
	}

	override public function update(elapsed:Float) {
		if (_playerTouched) {
			if (_countdown > 0) {
				_countdown -= 1;
			} else {
				_playerTouched = false;
				animation.play("attack");
				_spikeOut = true;
				_countdown = 20;
			}
		}

		if (_spikeOut) {
			if (_countdown > 0) {
				_countdown -= 1;
			} else {
				animation.play("hidden");
				_spikeOut = false;
				_countdown = ATTACK_SPEED;
			}
		}
		super.update(elapsed);
	}

	public function interact(player:Player) {
		FlxObject.separateY(this, player);

		_playerTouched = true;

		if (_spikeOut) {
			player.hit();
		}
	}
}