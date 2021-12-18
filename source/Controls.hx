package;

import config.*;

import flixel.FlxG;
import flixel.input.FlxInput;
import flixel.input.actions.FlxAction;
import flixel.input.actions.FlxActionInput;
import flixel.input.actions.FlxActionInputDigital;
import flixel.input.actions.FlxActionManager;
import flixel.input.actions.FlxActionSet;
import flixel.input.gamepad.FlxGamepadButton;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;

#if (haxe >= "4.0.0")
enum abstract Action(String) to String from String
{
	var UP = "up";
	var LEFT = "left";
	var RIGHT = "right";
	var DOWN = "down";
	var UP_P = "up-press";
	var LEFT_P = "left-press";
	var RIGHT_P = "right-press";
	var DOWN_P = "down-press";
	var UP_R = "up-release";
	var LEFT_R = "left-release";
	var RIGHT_R = "right-release";
	var DOWN_R = "down-release";
	var ACCEPT = "accept";
	var BACK = "back";
	var PAUSE = "pause";
	var RESET = "reset";
	var CHEAT = "cheat";

	var L1 = "l1";
	var U1 = "u1";
	var R1 = "r1";
	var L2 = "l2";
	var D1 = "d1";
	var R2 = "r2";

	var L1_P = "l1-press";
	var U1_P = "u1-press";
	var R1_P = "r1-press";
	var L2_P = "l2-press";
	var D1_P = "d1-press";
	var R2_P = "r2-press";

	var L1_R = "l1-release";
	var U1_R = "u1-release";
	var R1_R = "r1-release";
	var L2_R = "l2-release";
	var D1_R = "d1-release";
	var R2_R = "r2-release";

	var B1 = 'b1';
	var B2 = 'b2';
	var B3 = 'b3';
	var B4 = 'b4';
	var B5 = 'b5';
	var B6 = 'b6';
	var B7 = 'b7';
	var B8 = 'b8';
	var B9 = 'b9';

	var B1_P = 'b1-press';
	var B2_P = 'b2-press';
	var B3_P = 'b3-press';
	var B4_P = 'b4-press';
	var B5_P = 'b5-press';
	var B6_P = 'b6-press';
	var B7_P = 'b7-press';
	var B8_P = 'b8-press';
	var B9_P = 'b9-press';

	var B1_R = 'b1-release';
	var B2_R = 'b2-release';
	var B3_R = 'b3-release';
	var B4_R = 'b4-release';
	var B5_R = 'b5-release';
	var B6_R = 'b6-release';
	var B7_R = 'b7-release';
	var B8_R = 'b8-release';
	var B9_R = 'b9-release';
}
#else
@:enum
abstract Action(String) to String from String
{
	var UP = "up";
	var LEFT = "left";
	var RIGHT = "right";
	var DOWN = "down";
	var UP_P = "up-press";
	var LEFT_P = "left-press";
	var RIGHT_P = "right-press";
	var DOWN_P = "down-press";
	var UP_R = "up-release";
	var LEFT_R = "left-release";
	var RIGHT_R = "right-release";
	var DOWN_R = "down-release";
	var ACCEPT = "accept";
	var BACK = "back";
	var PAUSE = "pause";
	var RESET = "reset";
	var CHEAT = "cheat";

	var L1 = "l1";
	var U1 = "u1";
	var R1 = "r1";
	var L2 = "l2";
	var D1 = "d1";
	var R2 = "r2";

	var L1_P = "l1-press";
	var U1_P = "u1-press";
	var R1_P = "r1-press";
	var L2_P = "l2-press";
	var D1_P = "d1-press";
	var R2_P = "r2-press";

	var L1_R = "l1-release";
	var U1_R = "u1-release";
	var R1_R = "r1-release";
	var L2_R = "l2-release";
	var D1_R = "d1-release";
	var R2_R = "r2-release";

	var B1 = 'b1';
	var B2 = 'b2';
	var B3 = 'b3';
	var B4 = 'b4';
	var B5 = 'b5';
	var B6 = 'b6';
	var B7 = 'b7';
	var B8 = 'b8';
	var B9 = 'b9';

	var B1_P = 'b1-press';
	var B2_P = 'b2-press';
	var B3_P = 'b3-press';
	var B4_P = 'b4-press';
	var B5_P = 'b5-press';
	var B6_P = 'b6-press';
	var B7_P = 'b7-press';
	var B8_P = 'b8-press';
	var B9_P = 'b9-press';

	var B1_R = 'b1-release';
	var B2_R = 'b2-release';
	var B3_R = 'b3-release';
	var B4_R = 'b4-release';
	var B5_R = 'b5-release';
	var B6_R = 'b6-release';
	var B7_R = 'b7-release';
	var B8_R = 'b8-release';
	var B9_R = 'b9-release';
}
#end

enum Device
{
	Keys;
	Gamepad(id:Int);
}

/**
 * Since, in many cases multiple actions should use similar keys, we don't want the
 * rebinding UI to list every action. ActionBinders are what the user percieves as
 * an input so, for instance, they can't set jump-press and jump-release to different keys.
 */
enum Control
{
	UP;
	LEFT;
	RIGHT;
	DOWN;
	RESET;
	ACCEPT;
	BACK;
	PAUSE;
	CHEAT;
	L1;
	U1;
	R1;
	L2;
	D1;
	R2;

	B1;
	B2;
	B3;
	B4;
	B5;
	B6;
	B7;
	B8;
	B9;
}

enum KeyboardScheme
{
	Solo;
	Duo(first:Bool);
	None;
	Custom;
}

/**
 * A list of actions that a player would invoke via some input device.
 * Uses FlxActions to funnel various inputs to a single action.
 */
class Controls extends FlxActionSet
{
	var _up = new FlxActionDigital(Action.UP);
	var _left = new FlxActionDigital(Action.LEFT);
	var _right = new FlxActionDigital(Action.RIGHT);
	var _down = new FlxActionDigital(Action.DOWN);
	var _upP = new FlxActionDigital(Action.UP_P);
	var _leftP = new FlxActionDigital(Action.LEFT_P);
	var _rightP = new FlxActionDigital(Action.RIGHT_P);
	var _downP = new FlxActionDigital(Action.DOWN_P);
	var _upR = new FlxActionDigital(Action.UP_R);
	var _leftR = new FlxActionDigital(Action.LEFT_R);
	var _rightR = new FlxActionDigital(Action.RIGHT_R);
	var _downR = new FlxActionDigital(Action.DOWN_R);
	var _accept = new FlxActionDigital(Action.ACCEPT);
	var _back = new FlxActionDigital(Action.BACK);
	var _pause = new FlxActionDigital(Action.PAUSE);
	var _reset = new FlxActionDigital(Action.RESET);
	var _cheat = new FlxActionDigital(Action.CHEAT);

	
	var _l1 = new FlxActionDigital(Action.L1);
	var _l1P = new FlxActionDigital(Action.L1_P);
	var _l1R = new FlxActionDigital(Action.L1_R);

	var _u1 = new FlxActionDigital(Action.U1);
	var _u1P = new FlxActionDigital(Action.U1_P);
	var _u1R = new FlxActionDigital(Action.U1_R);

	var _r1 = new FlxActionDigital(Action.R1);
	var _r1P = new FlxActionDigital(Action.R1_P);
	var _r1R = new FlxActionDigital(Action.R1_R);

	var _l2 = new FlxActionDigital(Action.L2);
	var _l2P = new FlxActionDigital(Action.L2_P);
	var _l2R = new FlxActionDigital(Action.L2_R);

	var _d1 = new FlxActionDigital(Action.D1);
	var _d1P = new FlxActionDigital(Action.D1_P);
	var _d1R = new FlxActionDigital(Action.D1_R);

	var _r2 = new FlxActionDigital(Action.R2);
	var _r2P = new FlxActionDigital(Action.R2_P);
	var _r2R = new FlxActionDigital(Action.R2_R);

	var _b1 = new FlxActionDigital(Action.B1);
	var _b2 = new FlxActionDigital(Action.B2);
	var _b3 = new FlxActionDigital(Action.B3);
	var _b4 = new FlxActionDigital(Action.B4);
	var _b5 = new FlxActionDigital(Action.B5);
	var _b6 = new FlxActionDigital(Action.B6);
	var _b7 = new FlxActionDigital(Action.B7);
	var _b8 = new FlxActionDigital(Action.B8);
	var _b9 = new FlxActionDigital(Action.B9);

	var _b1P = new FlxActionDigital(Action.B1_P);
	var _b2P = new FlxActionDigital(Action.B2_P);
	var _b3P = new FlxActionDigital(Action.B3_P);
	var _b4P = new FlxActionDigital(Action.B4_P);
	var _b5P = new FlxActionDigital(Action.B5_P);
	var _b6P = new FlxActionDigital(Action.B6_P);
	var _b7P = new FlxActionDigital(Action.B7_P);
	var _b8P = new FlxActionDigital(Action.B8_P);
	var _b9P = new FlxActionDigital(Action.B9_P);

	var _b1R = new FlxActionDigital(Action.B1_R);
	var _b2R = new FlxActionDigital(Action.B2_R);
	var _b3R = new FlxActionDigital(Action.B3_R);
	var _b4R = new FlxActionDigital(Action.B4_R);
	var _b5R = new FlxActionDigital(Action.B5_R);
	var _b6R = new FlxActionDigital(Action.B6_R);
	var _b7R = new FlxActionDigital(Action.B7_R);
	var _b8R = new FlxActionDigital(Action.B8_R);
	var _b9R = new FlxActionDigital(Action.B9_R);

	#if (haxe >= "4.0.0")
	var byName:Map<String, FlxActionDigital> = [];
	#else
	var byName:Map<String, FlxActionDigital> = new Map<String, FlxActionDigital>();
	#end

	public var gamepadsAdded:Array<Int> = [];
	public var keyboardScheme = KeyboardScheme.None;

	public var UP(get, never):Bool;

	inline function get_UP()
		return _up.check();

	public var LEFT(get, never):Bool;

	inline function get_LEFT()
		return _left.check();

	public var RIGHT(get, never):Bool;

	inline function get_RIGHT()
		return _right.check();

	public var DOWN(get, never):Bool;

	inline function get_DOWN()
		return _down.check();

	public var UP_P(get, never):Bool;

	inline function get_UP_P()
		return _upP.check();

	public var LEFT_P(get, never):Bool;

	inline function get_LEFT_P()
		return _leftP.check();

	public var RIGHT_P(get, never):Bool;

	inline function get_RIGHT_P()
		return _rightP.check();

	public var DOWN_P(get, never):Bool;

	inline function get_DOWN_P()
		return _downP.check();

	public var UP_R(get, never):Bool;

	inline function get_UP_R()
		return _upR.check();

	public var LEFT_R(get, never):Bool;

	inline function get_LEFT_R()
		return _leftR.check();

	public var RIGHT_R(get, never):Bool;

	inline function get_RIGHT_R()
		return _rightR.check();

	public var DOWN_R(get, never):Bool;

	inline function get_DOWN_R()
		return _downR.check();

	public var ACCEPT(get, never):Bool;

	inline function get_ACCEPT()
		return _accept.check();

	public var BACK(get, never):Bool;

	inline function get_BACK()
		return _back.check();

	public var PAUSE(get, never):Bool;

	inline function get_PAUSE()
		return _pause.check();

	public var RESET(get, never):Bool;

	inline function get_RESET()
		return _reset.check();

	public var CHEAT(get, never):Bool;

	inline function get_CHEAT()
		return _cheat.check();

	public var L1(get, never):Bool;

	inline function get_L1()
		return _l1.check();

	public var L1_P(get, never):Bool;

	inline function get_L1_P()
		return _l1P.check();

	public var L1_R(get, never):Bool;

	inline function get_L1_R()
		return _l1R.check();	

	public var D1(get, never):Bool;

	inline function get_D1()
		return _d1.check();

	public var D1_P(get, never):Bool;

	inline function get_D1_P()
		return _d1P.check();

	public var D1_R(get, never):Bool;

	inline function get_D1_R()
		return _d1R.check();

	public var R1(get, never):Bool;

	inline function get_R1()
		return _r1.check();

	public var R1_P(get, never):Bool;

	inline function get_R1_P()
		return _r1P.check();

	public var R1_R(get, never):Bool;

	inline function get_R1_R()
		return _r1R.check();	


	public var L2(get, never):Bool;

	inline function get_L2()
		return _l2.check();

	public var L2_P(get, never):Bool;

	inline function get_L2_P()
		return _l2P.check();

	public var L2_R(get, never):Bool;

	inline function get_L2_R()
		return _l2R.check();	

	public var U1(get, never):Bool;

	inline function get_U1()
		return _u1.check();

	public var U1_P(get, never):Bool;

	inline function get_U1_P()
		return _u1P.check();

	public var U1_R(get, never):Bool;

	inline function get_U1_R()
		return _u1R.check();

	public var R2(get, never):Bool;

	inline function get_R2()
		return _r2.check();

	public var R2_P(get, never):Bool;

	inline function get_R2_P()
		return _r2P.check();

	public var R2_R(get, never):Bool;

	inline function get_R2_R()
		return _r2R.check();
	
	public var B1(get, never):Bool; inline function get_B1() {return _b1.check();}
	public var B2(get, never):Bool; inline function get_B2() {return _b2.check();}
	public var B3(get, never):Bool; inline function get_B3() {return _b3.check();}
	public var B4(get, never):Bool; inline function get_B4() {return _b4.check();}
	public var B5(get, never):Bool; inline function get_B5() {return _b5.check();}
	public var B6(get, never):Bool; inline function get_B6() {return _b6.check();}
	public var B7(get, never):Bool; inline function get_B7() {return _b7.check();}
	public var B8(get, never):Bool; inline function get_B8() {return _b8.check();}
	public var B9(get, never):Bool; inline function get_B9() {return _b9.check();}

	public var B1_P(get, never):Bool; inline function get_B1_P() {return _b1P.check();}
	public var B2_P(get, never):Bool; inline function get_B2_P() {return _b2P.check();}
	public var B3_P(get, never):Bool; inline function get_B3_P() {return _b3P.check();}
	public var B4_P(get, never):Bool; inline function get_B4_P() {return _b4P.check();}
	public var B5_P(get, never):Bool; inline function get_B5_P() {return _b5P.check();}
	public var B6_P(get, never):Bool; inline function get_B6_P() {return _b6P.check();}
	public var B7_P(get, never):Bool; inline function get_B7_P() {return _b7P.check();}
	public var B8_P(get, never):Bool; inline function get_B8_P() {return _b8P.check();}
	public var B9_P(get, never):Bool; inline function get_B9_P() {return _b9P.check();}

	public var B1_R(get, never):Bool; inline function get_B1_R() {return _b1R.check();}
	public var B2_R(get, never):Bool; inline function get_B2_R() {return _b2R.check();}
	public var B3_R(get, never):Bool; inline function get_B3_R() {return _b3R.check();}
	public var B4_R(get, never):Bool; inline function get_B4_R() {return _b4R.check();}
	public var B5_R(get, never):Bool; inline function get_B5_R() {return _b5R.check();}
	public var B6_R(get, never):Bool; inline function get_B6_R() {return _b6R.check();}
	public var B7_R(get, never):Bool; inline function get_B7_R() {return _b7R.check();}
	public var B8_R(get, never):Bool; inline function get_B8_R() {return _b8R.check();}
	public var B9_R(get, never):Bool; inline function get_B9_R() {return _b9R.check();}

	#if (haxe >= "4.0.0")
	public function new(name, scheme = None)
	{
		super(name);

		add(_up);
		add(_left);
		add(_right);
		add(_down);
		add(_upP);
		add(_leftP);
		add(_rightP);
		add(_downP);
		add(_upR);
		add(_leftR);
		add(_rightR);
		add(_downR);
		add(_accept);
		add(_back);
		add(_pause);
		add(_reset);
		add(_cheat);

		
		add(_l1);
		add(_l1P);
		add(_l1R);
		add(_d1);
		add(_d1P);
		add(_d1R);
		add(_r1);
		add(_r1P);
		add(_r1R);

		add(_l2);
		add(_l2P);
		add(_l2R);
		add(_u1);
		add(_u1P);
		add(_u1R);
		add(_r2);
		add(_r2P);
		add(_r2R);

		add(_b1);
		add(_b2);
		add(_b3);
		add(_b4);
		add(_b5);
		add(_b6);
		add(_b7);
		add(_b8);
		add(_b9);

		add(_b1P);
		add(_b2P);
		add(_b3P);
		add(_b4P);
		add(_b5P);
		add(_b6P);
		add(_b7P);
		add(_b8P);
		add(_b9P);

		add(_b1R);
		add(_b2R);
		add(_b3R);
		add(_b4R);
		add(_b5R);
		add(_b6R);
		add(_b7R);
		add(_b8R);
		add(_b9R);
		for (action in digitalActions)
			byName[action.name] = action;

		setKeyboardScheme(scheme, false);
	}
	#else
	public function new(name, scheme:KeyboardScheme = null)
	{
		super(name);

		add(_up);
		add(_left);
		add(_right);
		add(_down);
		add(_upP);
		add(_leftP);
		add(_rightP);
		add(_downP);
		add(_upR);
		add(_leftR);
		add(_rightR);
		add(_downR);
		add(_accept);
		add(_back);
		add(_pause);
		add(_reset);
		add(_cheat);
		
		add(_l1);
		add(_l1P);
		add(_l1R);
		add(_d1);
		add(_d1P);
		add(_d1R);
		add(_r1);
		add(_r1P);
		add(_r1R);

		add(_l2);
		add(_l2P);
		add(_l2R);
		add(_u1);
		add(_u1P);
		add(_u1R);
		add(_r2);
		add(_r2P);
		add(_r2R);

		add(_b1);
		add(_b2);
		add(_b3);
		add(_b4);
		add(_b5);
		add(_b6);
		add(_b7);
		add(_b8);
		add(_b9);

		add(_b1P);
		add(_b2P);
		add(_b3P);
		add(_b4P);
		add(_b5P);
		add(_b6P);
		add(_b7P);
		add(_b8P);
		add(_b9P);

		add(_b1R);
		add(_b2R);
		add(_b3R);
		add(_b4R);
		add(_b5R);
		add(_b6R);
		add(_b7R);
		add(_b8R);
		add(_b9R);

		for (action in digitalActions)
			byName[action.name] = action;
			
		if (scheme == null)
			scheme = None;
		setKeyboardScheme(scheme, false);
	}
	#end

	override function update()
	{
		super.update();
	}

	// inline
	public function checkByName(name:Action):Bool
	{
		#if debug
		if (!byName.exists(name))
			throw 'Invalid name: $name';
		#end
		return byName[name].check();
	}

	public function getDialogueName(action:FlxActionDigital):String
	{
		var input = action.inputs[0];
		return switch input.device
		{
			case KEYBOARD: return '[${(input.inputID : FlxKey)}]';
			case GAMEPAD: return '(${(input.inputID : FlxGamepadInputID)})';
			case device: throw 'unhandled device: $device';
		}
	}

	public function getDialogueNameFromToken(token:String):String
	{
		return getDialogueName(getActionFromControl(Control.createByName(token.toUpperCase())));
	}

	function getActionFromControl(control:Control):FlxActionDigital
	{
		return switch (control)
		{
			case UP: _up;
			case DOWN: _down;
			case LEFT: _left;
			case RIGHT: _right;
			case ACCEPT: _accept;
			case BACK: _back;
			case PAUSE: _pause;
			case RESET: _reset;
			case CHEAT: _cheat;

			case L1: _l1;
			case D1: _d1;
			case R1: _r1;
			case L2: _l2;
			case U1: _u1;
			case R2: _r2;

			case B1: _b1;
			case B2: _b2;
			case B3: _b3;
			case B4: _b4;
			case B5: _b5;
			case B6: _b6;
			case B7: _b7;
			case B8: _b8;
			case B9: _b9;
		}
	}

	static function init():Void
	{
		var actions = new FlxActionManager();
		FlxG.inputs.add(actions);
	}

	/**
	 * Calls a function passing each action bound by the specified control
	 * @param control
	 * @param func
	 * @return ->Void)
	 */
	function forEachBound(control:Control, func:FlxActionDigital->FlxInputState->Void)
	{
		switch (control)
		{
			case UP:
				func(_up, PRESSED);
				func(_upP, JUST_PRESSED);
				func(_upR, JUST_RELEASED);
			case LEFT:
				func(_left, PRESSED);
				func(_leftP, JUST_PRESSED);
				func(_leftR, JUST_RELEASED);
			case RIGHT:
				func(_right, PRESSED);
				func(_rightP, JUST_PRESSED);
				func(_rightR, JUST_RELEASED);
			case DOWN:
				func(_down, PRESSED);
				func(_downP, JUST_PRESSED);
				func(_downR, JUST_RELEASED);
			case ACCEPT:
				func(_accept, JUST_PRESSED);
			case BACK:
				func(_back, JUST_PRESSED);
			case PAUSE:
				func(_pause, JUST_PRESSED);
			case RESET:
				func(_reset, JUST_PRESSED);
			case CHEAT:
				func(_cheat, JUST_PRESSED);

			case L1:
				func(_l1, PRESSED);
				func(_l1P, JUST_PRESSED);
				func(_l1R, JUST_RELEASED);
			case U1:
				func(_u1, PRESSED);
				func(_u1P, JUST_PRESSED);
				func(_u1R, JUST_RELEASED);
			case R1:
				func(_r1, PRESSED);
				func(_r1P, JUST_PRESSED);
				func(_r1R, JUST_RELEASED);
			case L2:
				func(_l2, PRESSED);
				func(_l2P, JUST_PRESSED);
				func(_l2R, JUST_RELEASED);
			case D1:
				func(_d1, PRESSED);
				func(_d1P, JUST_PRESSED);
				func(_d1R, JUST_RELEASED);
			case R2:
				func(_r2, PRESSED);
				func(_r2P, JUST_PRESSED);
				func(_r2R, JUST_RELEASED);
				
			case B1:
				func(_b1, PRESSED);
				func(_b1P, JUST_PRESSED);
				func(_b1R, JUST_RELEASED);
			case B2:
				func(_b2, PRESSED);
				func(_b2P, JUST_PRESSED);
				func(_b2R, JUST_RELEASED);
			case B3:
				func(_b3, PRESSED);
				func(_b3P, JUST_PRESSED);
				func(_b3R, JUST_RELEASED);
			case B4:
				func(_b4, PRESSED);
				func(_b4P, JUST_PRESSED);
				func(_b4R, JUST_RELEASED);
			case B5:
				func(_b5, PRESSED);
				func(_b5P, JUST_PRESSED);
				func(_b5R, JUST_RELEASED);
			case B6:
				func(_b6, PRESSED);
				func(_b6P, JUST_PRESSED);
				func(_b6R, JUST_RELEASED);
			case B7:
				func(_b7, PRESSED);
				func(_b7P, JUST_PRESSED);
				func(_b7R, JUST_RELEASED);
			case B8:
				func(_b8, PRESSED);
				func(_b8P, JUST_PRESSED);
				func(_b8R, JUST_RELEASED);
			case B9:
				func(_b9, PRESSED);
				func(_b9P, JUST_PRESSED);
				func(_b9R, JUST_RELEASED);				
		}
	}

	public function replaceBinding(control:Control, device:Device, ?toAdd:Int, ?toRemove:Int)
	{
		if (toAdd == toRemove)
			return;

		switch (device)
		{
			case Keys:
				if (toRemove != null)
					unbindKeys(control, [toRemove]);
				if (toAdd != null)
					bindKeys(control, [toAdd]);

			case Gamepad(id):
				if (toRemove != null)
					unbindButtons(control, id, [toRemove]);
				if (toAdd != null)
					bindButtons(control, id, [toAdd]);
		}
	}

	public function copyFrom(controls:Controls, ?device:Device)
	{
		#if (haxe >= "4.0.0")
		for (name => action in controls.byName)
		{
			for (input in action.inputs)
			{
				if (device == null || isDevice(input, device))
					byName[name].add(cast input);
			}
		}
		#else
		for (name in controls.byName.keys())
		{
			var action = controls.byName[name];
			for (input in action.inputs)
			{
				if (device == null || isDevice(input, device))
				byName[name].add(cast input);
			}
		}
		#end

		switch (device)
		{
			case null:
				// add all
				#if (haxe >= "4.0.0")
				for (gamepad in controls.gamepadsAdded)
					if (!gamepadsAdded.contains(gamepad))
						gamepadsAdded.push(gamepad);
				#else
				for (gamepad in controls.gamepadsAdded)
					if (gamepadsAdded.indexOf(gamepad) == -1)
					  gamepadsAdded.push(gamepad);
				#end

				mergeKeyboardScheme(controls.keyboardScheme);

			case Gamepad(id):
				gamepadsAdded.push(id);
			case Keys:
				mergeKeyboardScheme(controls.keyboardScheme);
		}
	}

	inline public function copyTo(controls:Controls, ?device:Device)
	{
		controls.copyFrom(this, device);
	}

	function mergeKeyboardScheme(scheme:KeyboardScheme):Void
	{
		if (scheme != None)
		{
			switch (keyboardScheme)
			{
				case None:
					keyboardScheme = scheme;
				default:
					keyboardScheme = Custom;
			}
		}
	}

	/**
	 * Sets all actions that pertain to the binder to trigger when the supplied keys are used.
	 * If binder is a literal you can inline this
	 */
	public function bindKeys(control:Control, keys:Array<FlxKey>)
	{
		#if (haxe >= "4.0.0")
		inline forEachBound(control, (action, state) -> addKeys(action, keys, state));
		#else
		forEachBound(control, function(action, state) addKeys(action, keys, state));
		#end
	}

	/**
	 * Sets all actions that pertain to the binder to trigger when the supplied keys are used.
	 * If binder is a literal you can inline this
	 */
	public function unbindKeys(control:Control, keys:Array<FlxKey>)
	{
		#if (haxe >= "4.0.0")
		inline forEachBound(control, (action, _) -> removeKeys(action, keys));
		#else
		forEachBound(control, function(action, _) removeKeys(action, keys));
		#end
	}

	inline static function addKeys(action:FlxActionDigital, keys:Array<FlxKey>, state:FlxInputState)
	{
		for (key in keys)
			action.addKey(key, state);
	}

	static function removeKeys(action:FlxActionDigital, keys:Array<FlxKey>)
	{
		var i = action.inputs.length;
		while (i-- > 0)
		{
			var input = action.inputs[i];
			if (input.device == KEYBOARD && keys.indexOf(cast input.inputID) != -1)
				action.remove(input);
		}
	}

	public function setKeyboardScheme(scheme:KeyboardScheme, reset = true)
	{

		loadKeyBinds();
		/*if (reset)
			removeKeyboard();

		keyboardScheme = scheme;
		
		#if (haxe >= "4.0.0")
		switch (scheme)
		{
			case Solo:
				inline bindKeys(Control.UP, [FlxKey.fromString("W"), FlxKey.UP]);
				inline bindKeys(Control.DOWN, [FlxKey.fromString("S"), FlxKey.DOWN]);
				inline bindKeys(Control.LEFT, [FlxKey.fromString("A"), FlxKey.LEFT]);
				inline bindKeys(Control.RIGHT, [FlxKey.fromString("D"), FlxKey.RIGHT]);
				inline bindKeys(Control.ACCEPT, [Z, SPACE, ENTER]);
				inline bindKeys(Control.BACK, [BACKSPACE, ESCAPE]);
				inline bindKeys(Control.PAUSE, [P, ENTER, ESCAPE]);
				inline bindKeys(Control.RESET, [FlxKey.fromString("R")]);
			case Duo(true):
				inline bindKeys(Control.UP, [W, K]);
				inline bindKeys(Control.DOWN, [S, J]);
				inline bindKeys(Control.LEFT, [A, H]);
				inline bindKeys(Control.RIGHT, [D, L]);
				inline bindKeys(Control.ACCEPT, [Z]);
				inline bindKeys(Control.BACK, [X]);
				inline bindKeys(Control.PAUSE, [ONE]);
				inline bindKeys(Control.RESET, [R]);
			case Duo(false):
				inline bindKeys(Control.UP, [FlxKey.UP]);
				inline bindKeys(Control.DOWN, [FlxKey.DOWN]);
				inline bindKeys(Control.LEFT, [FlxKey.LEFT]);
				inline bindKeys(Control.RIGHT, [FlxKey.RIGHT]);
				inline bindKeys(Control.ACCEPT, [O]);
				inline bindKeys(Control.BACK, [P]);
				inline bindKeys(Control.PAUSE, [ENTER]);
				inline bindKeys(Control.RESET, [BACKSPACE]);
			case None: // nothing
			case Custom: // nothing
		}
		#else
		switch (scheme)
		{
			case Solo:
				bindKeys(Control.UP, [W, K, FlxKey.UP]);
				bindKeys(Control.DOWN, [S, J, FlxKey.DOWN]);
				bindKeys(Control.LEFT, [A, H, FlxKey.LEFT]);
				bindKeys(Control.RIGHT, [D, L, FlxKey.RIGHT]);
				bindKeys(Control.ACCEPT, [Z, SPACE, ENTER]);
				bindKeys(Control.BACK, [BACKSPACE, ESCAPE]);
				bindKeys(Control.PAUSE, [P, ENTER, ESCAPE]);
				bindKeys(Control.RESET, [R]);
			case Duo(true):
				bindKeys(Control.UP, [W, K]);
				bindKeys(Control.DOWN, [S, J]);
				bindKeys(Control.LEFT, [A, H]);
				bindKeys(Control.RIGHT, [D, L]);
				bindKeys(Control.ACCEPT, [Z]);
				bindKeys(Control.BACK, [X]);
				bindKeys(Control.PAUSE, [ONE]);
				bindKeys(Control.RESET, [R]);
			case Duo(false):
				bindKeys(Control.UP, [FlxKey.UP]);
				bindKeys(Control.DOWN, [FlxKey.DOWN]);
				bindKeys(Control.LEFT, [FlxKey.LEFT]);
				bindKeys(Control.RIGHT, [FlxKey.RIGHT]);
				bindKeys(Control.ACCEPT, [O]);
				bindKeys(Control.BACK, [P]);
				bindKeys(Control.PAUSE, [ENTER]);
				bindKeys(Control.RESET, [BACKSPACE]);
			case None: // nothing
			case Custom: // nothing
		}
		#end*/
	}

	public function loadKeyBinds()
	{

		//trace(FlxKey.fromString(FlxG.save.data.upBind));

		removeKeyboard();
	
		inline bindKeys(Control.UP, [FlxKey.fromString(FlxG.save.data.upBind), FlxKey.UP]);
		inline bindKeys(Control.DOWN, [FlxKey.fromString(FlxG.save.data.downBind), FlxKey.DOWN]);
		inline bindKeys(Control.LEFT, [FlxKey.fromString(FlxG.save.data.leftBind), FlxKey.LEFT]);
		inline bindKeys(Control.RIGHT, [FlxKey.fromString(FlxG.save.data.rightBind), FlxKey.RIGHT]);
		inline bindKeys(Control.ACCEPT, [SPACE, ENTER]);
		inline bindKeys(Control.BACK, [BACKSPACE, ESCAPE]);
		inline bindKeys(Control.PAUSE, [ENTER, ESCAPE]);
		inline bindKeys(Control.L1, [FlxKey.fromString(FlxG.save.data.L1Bind)]);
		inline bindKeys(Control.D1, [FlxKey.fromString(FlxG.save.data.D1Bind)]);
		inline bindKeys(Control.R1, [FlxKey.fromString(FlxG.save.data.R1Bind)]);
		inline bindKeys(Control.L2, [FlxKey.fromString(FlxG.save.data.L2Bind)]);
		inline bindKeys(Control.U1, [FlxKey.fromString(FlxG.save.data.U1Bind)]);
		inline bindKeys(Control.R2, [FlxKey.fromString(FlxG.save.data.R2Bind)]);
		inline bindKeys(Control.B1, [FlxKey.fromString(FlxG.save.data.B1Bind)]);
		inline bindKeys(Control.B2, [FlxKey.fromString(FlxG.save.data.B2Bind)]);
		inline bindKeys(Control.B3, [FlxKey.fromString(FlxG.save.data.B3Bind)]);
		inline bindKeys(Control.B4, [FlxKey.fromString(FlxG.save.data.B4Bind)]);
		inline bindKeys(Control.B5, [FlxKey.fromString(FlxG.save.data.B5Bind)]);
		inline bindKeys(Control.B6, [FlxKey.fromString(FlxG.save.data.B6Bind)]);
		inline bindKeys(Control.B7, [FlxKey.fromString(FlxG.save.data.B7Bind)]);
		inline bindKeys(Control.B8, [FlxKey.fromString(FlxG.save.data.B8Bind)]);
		inline bindKeys(Control.B9, [FlxKey.fromString(FlxG.save.data.B9Bind)]);
		inline bindKeys(Control.RESET, [FlxKey.fromString(FlxG.save.data.killBind)]);
	}

	function removeKeyboard()
	{
		for (action in this.digitalActions)
		{
			var i = action.inputs.length;
			while (i-- > 0)
			{
				var input = action.inputs[i];
				if (input.device == KEYBOARD)
					action.remove(input);
			}
		}
	}

	public function addGamepad(id:Int, ?buttonMap:Map<Control, Array<FlxGamepadInputID>>):Void
	{
		gamepadsAdded.push(id);
		
		#if (haxe >= "4.0.0")
		for (control => buttons in buttonMap)
			inline bindButtons(control, id, buttons);
		#else
		for (control in buttonMap.keys())
			bindButtons(control, id, buttonMap[control]);
		#end
	}

	inline function addGamepadLiteral(id:Int, ?buttonMap:Map<Control, Array<FlxGamepadInputID>>):Void
	{
		gamepadsAdded.push(id);

		#if (haxe >= "4.0.0")
		for (control => buttons in buttonMap)
			inline bindButtons(control, id, buttons);
		#else
		for (control in buttonMap.keys())
			bindButtons(control, id, buttonMap[control]);
		#end
	}

	public function removeGamepad(deviceID:Int = FlxInputDeviceID.ALL):Void
	{
		for (action in this.digitalActions)
		{
			var i = action.inputs.length;
			while (i-- > 0)
			{
				var input = action.inputs[i];
				if (input.device == GAMEPAD && (deviceID == FlxInputDeviceID.ALL || input.deviceID == deviceID))
					action.remove(input);
			}
		}

		gamepadsAdded.remove(deviceID);
	}

	public function addDefaultGamepad(id):Void
	{
		addGamepadLiteral(id, []);
	}

	public function setMenuControls(id):Void
	{

		removeGamepad(id);

		addGamepadLiteral(id, [
			Control.ACCEPT => [A],
			Control.BACK => [B],
			Control.UP => [DPAD_UP, LEFT_STICK_DIGITAL_UP],
			Control.DOWN => [DPAD_DOWN, LEFT_STICK_DIGITAL_DOWN],
			Control.LEFT => [DPAD_LEFT, LEFT_STICK_DIGITAL_LEFT],
			Control.RIGHT => [DPAD_RIGHT, LEFT_STICK_DIGITAL_RIGHT],
			Control.PAUSE => [START],
			Control.RESET => [FlxGamepadInputID.BACK]
		]);
	}

	/*
	"LEFT: DPAD LEFT / X (SQUARE) / LEFT TRIGGER     DOWN: DPAD DOWN / X (CROSS) / LEFT BUMPER     UP: DPAD UP / Y (TRIANGLE) / RIGHT BUMPER     RIGHT: DPAD RIGHT / B (CIRCLE) / RIGHT TRIGGER", 
	"LEFT: DPAD LEFT / DPAD DOWN     DOWN: DPAD UP / DPAD RIGHT     UP: X (SQUARE) / Y (TRIANGLE)     RIGHT: A (CROSS) / B (CIRCLE)", 
	"LEFT: ALL DPAD DIRECTIONS     DOWN: LEFT BUMPER / LEFT TRIGGER     UP: RIGHT BUMPER / RIGHT TRIGGER     RIGHT: ALL FACE BUTTONS"
	*/

	public function setGameControls(id):Void
	{

		removeGamepad(id);

		switch(Config.controllerScheme){

			case 1:
				addGamepadLiteral(id, [
					Control.UP => [X, Y, RIGHT_SHOULDER],
					Control.DOWN => [DPAD_UP, DPAD_RIGHT, LEFT_SHOULDER],
					Control.LEFT => [DPAD_LEFT, DPAD_DOWN, LEFT_TRIGGER],
					Control.RIGHT => [A, B, RIGHT_TRIGGER],
					Control.PAUSE => [START],
					Control.RESET => [FlxGamepadInputID.BACK]
				]);

			case 2:
				addGamepadLiteral(id, [
					Control.UP => [RIGHT_SHOULDER, RIGHT_TRIGGER],
					Control.DOWN => [LEFT_SHOULDER, LEFT_TRIGGER],
					Control.LEFT => [DPAD_LEFT, DPAD_UP, DPAD_RIGHT, DPAD_DOWN],
					Control.RIGHT => [A, B, X, Y],
					Control.PAUSE => [START],
					Control.RESET => [FlxGamepadInputID.BACK]
				]);
				
			case 3:
				addGamepadLiteral(id, [
					Control.UP => [FlxGamepadInputID.fromString(FlxG.save.data.upBindController)],
					Control.DOWN => [FlxGamepadInputID.fromString(FlxG.save.data.downBindController)],
					Control.LEFT => [FlxGamepadInputID.fromString(FlxG.save.data.leftBindController)],
					Control.RIGHT => [FlxGamepadInputID.fromString(FlxG.save.data.rightBindController)],
					Control.PAUSE => [START],
					Control.RESET => [FlxGamepadInputID.BACK]
				]);

			default:
				addGamepadLiteral(id, [
					Control.UP => [DPAD_UP, Y, RIGHT_SHOULDER],
					Control.DOWN => [DPAD_DOWN, A, LEFT_SHOULDER],
					Control.LEFT => [DPAD_LEFT, X, LEFT_TRIGGER],
					Control.RIGHT => [DPAD_RIGHT, B, RIGHT_TRIGGER],
					Control.PAUSE => [START],
					Control.RESET => [FlxGamepadInputID.BACK]
				]);
		}

		
	}

	/**
	 * Sets all actions that pertain to the binder to trigger when the supplied keys are used.
	 * If binder is a literal you can inline this
	 */
	public function bindButtons(control:Control, id, buttons)
	{
		#if (haxe >= "4.0.0")
		inline forEachBound(control, (action, state) -> addButtons(action, buttons, state, id));
		#else
		forEachBound(control, function(action, state) addButtons(action, buttons, state, id));
		#end
	}

	/**
	 * Sets all actions that pertain to the binder to trigger when the supplied keys are used.
	 * If binder is a literal you can inline this
	 */
	public function unbindButtons(control:Control, gamepadID:Int, buttons)
	{
		#if (haxe >= "4.0.0")
		inline forEachBound(control, (action, _) -> removeButtons(action, gamepadID, buttons));
		#else
		forEachBound(control, function(action, _) removeButtons(action, gamepadID, buttons));
		#end
	}

	inline static function addButtons(action:FlxActionDigital, buttons:Array<FlxGamepadInputID>, state, id)
	{
		for (button in buttons)
			action.addGamepad(button, state, id);
	}

	static function removeButtons(action:FlxActionDigital, gamepadID:Int, buttons:Array<FlxGamepadInputID>)
	{
		var i = action.inputs.length;
		while (i-- > 0)
		{
			var input = action.inputs[i];
			if (isGamepad(input, gamepadID) && buttons.indexOf(cast input.inputID) != -1)
				action.remove(input);
		}
	}

	public function getInputsFor(control:Control, device:Device, ?list:Array<Int>):Array<Int>
	{
		if (list == null)
			list = [];

		switch (device)
		{
			case Keys:
				for (input in getActionFromControl(control).inputs)
				{
					if (input.device == KEYBOARD)
						list.push(input.inputID);
				}
			case Gamepad(id):
				for (input in getActionFromControl(control).inputs)
				{
					if (input.deviceID == id)
						list.push(input.inputID);
				}
		}
		return list;
	}

	public function removeDevice(device:Device)
	{
		switch (device)
		{
			case Keys:
				setKeyboardScheme(None);
			case Gamepad(id):
				removeGamepad(id);
		}
	}

	static function isDevice(input:FlxActionInput, device:Device)
	{
		return switch device
		{
			case Keys: input.device == KEYBOARD;
			case Gamepad(id): isGamepad(input, id);
		}
	}

	inline static function isGamepad(input:FlxActionInput, deviceID:Int)
	{
		return input.device == GAMEPAD && (deviceID == FlxInputDeviceID.ALL || input.deviceID == deviceID);
	}
}
