package;

import config.*;

import flixel.FlxSprite;
//import polymod.format.ParseRules.TargetSignatureElement;

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	public var noteScore:Float = 1;

	public var playedEditorClick:Bool = false;
	public var editorBFNote:Bool = false;
	public var absoluteNumber:Int;
	public static var mania:Int = 0;

	public var editor = false;

	public static var swagWidth:Float;
	public static var noteScale:Float;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;
	public static var tooMuch:Float = 82;

	public function new(_strumTime:Float, _noteData:Int, ?_editor = false, ?_prevNote:Note, ?_sustainNote:Bool = false)
	{
		swagWidth = 160 * 0.7; //factor not the same as noteScale
		noteScale = 0.7;
		mania = 0;
		if (PlayState.SONG.mania == 1)
		{
			swagWidth = 120 * 0.7;
			noteScale = 0.6;
			mania = 1;
		}
		else if (PlayState.SONG.mania == 2)
		{
			swagWidth = 95 * 0.7;
			noteScale = 0.5;
			mania = 2;
		}				
		super();

		if (_prevNote == null)
			_prevNote = this;

		prevNote = _prevNote;
		isSustainNote = _sustainNote;

		x += 100;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;

		if (PlayState.SONG.mania == 2)
			{
				x -= tooMuch;
			}
		editor = _editor;
		
		if(!editor){
			strumTime = _strumTime + Config.offset;
			if(strumTime < 0) {
				strumTime = 0;
			}
		}
		else {
			strumTime = _strumTime;
		}


		noteData = _noteData % 9;

		var daStage:String = PlayState.curStage;

		switch (daStage)
		{
			case 'school' | 'schoolEvil':
				loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);

				animation.add('greenScroll', [6]);
				animation.add('redScroll', [7]);
				animation.add('blueScroll', [5]);
				animation.add('purpleScroll', [4]);

				animation.add('green glow', [22]);
				animation.add('red glow', [23]);
				animation.add('blue glow', [21]);
				animation.add('purple glow', [20]);

				if (isSustainNote)
				{
					loadGraphic(Paths.image('weeb/pixelUI/arrowEnds'), true, 7, 6);

					animation.add('purpleholdend', [4]);
					animation.add('greenholdend', [6]);
					animation.add('redholdend', [7]);
					animation.add('blueholdend', [5]);

					animation.add('purplehold', [0]);
					animation.add('greenhold', [2]);
					animation.add('redhold', [3]);
					animation.add('bluehold', [1]);
				}

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();

			default:
				frames = Paths.getSparrowAtlas('NOTE_assets');

				animation.addByPrefix('greenScroll', 'green0');
				animation.addByPrefix('redScroll', 'red0');
				animation.addByPrefix('blueScroll', 'blue0');
				animation.addByPrefix('purpleScroll', 'purple0');
				animation.addByPrefix('whiteScroll', 'white0');
				animation.addByPrefix('yellowScroll', 'yellow0');
				animation.addByPrefix('violetScroll', 'violet0');
				animation.addByPrefix('blackScroll', 'black0');
				animation.addByPrefix('darkScroll', 'dark0');

				animation.addByPrefix('purpleholdend', 'purple hold end');
				animation.addByPrefix('purpleholdend', 'pruple end hold');
				animation.addByPrefix('greenholdend', 'green hold end');
				animation.addByPrefix('redholdend', 'red hold end');
				animation.addByPrefix('blueholdend', 'blue hold end');
				animation.addByPrefix('whiteholdend', 'white hold end');
				animation.addByPrefix('yellowholdend', 'yellow hold end');
				animation.addByPrefix('violetholdend', 'violet hold end');
				animation.addByPrefix('blackholdend', 'black hold end');
				animation.addByPrefix('darkholdend', 'dark hold end');

				animation.addByPrefix('purplehold', 'purple hold piece');
				animation.addByPrefix('greenhold', 'green hold piece');
				animation.addByPrefix('redhold', 'red hold piece');
				animation.addByPrefix('bluehold', 'blue hold piece');
				animation.addByPrefix('whitehold', 'white hold piece');
				animation.addByPrefix('yellowhold', 'yellow hold piece');
				animation.addByPrefix('violethold', 'violet hold piece');
				animation.addByPrefix('blackhold', 'black hold piece');
				animation.addByPrefix('darkhold', 'dark hold piece');

				animation.addByPrefix('purpleconfirm', 'left confirm0');
				animation.addByPrefix('greenconfirm', 'up confirm0');
				animation.addByPrefix('redconfirm', 'right confirm0');
				animation.addByPrefix('blueconfirm', 'down confirm0');
				animation.addByPrefix('whiteconfirm', 'white confirm0');
				animation.addByPrefix('yellowconfirm', 'yel confirm0');
				animation.addByPrefix('violetconfirm', 'violet confirm0');
				animation.addByPrefix('blackconfirm', 'black confirm0');
				animation.addByPrefix('darkconfirm', 'dark confirm0');

				setGraphicSize(Std.int(width * noteScale));
				updateHitbox();
				antialiasing = true;
		}
		var frameN:Array<String> = ['purple', 'blue', 'green', 'red'];
		if (mania == 1) frameN = ['purple', 'green', 'red', 'yellow', 'blue', 'dark'];
		else if (mania == 2) frameN = ['purple', 'blue', 'green', 'red', 'white', 'yellow', 'violet', 'black', 'dark'];
		x += swagWidth * noteData;
		animation.play(frameN[noteData] + 'Scroll');

		// switch (noteData)
		// {
		// 	case 0:
		// 		x += swagWidth * 0;
		// 		animation.play('purpleScroll');
		// 	case 1:
		// 		x += swagWidth * 1;
		// 		animation.play('blueScroll');
		// 	case 2:
		// 		x += swagWidth * 2;
		// 		animation.play('greenScroll');
		// 	case 3:
		// 		x += swagWidth * 3;
		// 		animation.play('redScroll');
		// }

		// trace(prevNote);

		if (isSustainNote && prevNote != null)
		{
			alpha = 0.6;

			x += width / 2;
			
			flipY = Config.downscroll;

			// switch (noteData)
			// {
			// 	case 2:
			// 		animation.play('greenholdend');
			// 	case 3:
			// 		animation.play('redholdend');
			// 	case 1:
			// 		animation.play('blueholdend');
			// 	case 0:
			// 		animation.play('purpleholdend');
			// }
			
			animation.play(frameN[noteData] + 'holdend');

			updateHitbox();

			x -= width / 2;

			if (PlayState.curStage.startsWith('school'))
				x += 30;

			if (prevNote.isSustainNote)
			{
				// switch (prevNote.noteData)
				// {
				// 	case 2:
				// 		prevNote.animation.play('greenhold');
				// 	case 3:
				// 		prevNote.animation.play('redhold');
				// 	case 1:
				// 		prevNote.animation.play('bluehold');
				// 	case 0:
				// 		prevNote.animation.play('purplehold');
				// }

				prevNote.animation.play(frameN[prevNote.noteData] + 'hold');
				// prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				// prevNote.updateHitbox();
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (mustPress)
		{
			if(isSustainNote){
				canBeHit = (strumTime < Conductor.songPosition + Conductor.safeZoneOffset * 1 && (prevNote == null ? true : prevNote.wasGoodHit));
			}
			else{
				canBeHit = (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
							&& strumTime < Conductor.songPosition + Conductor.safeZoneOffset);
			}

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit)
				tooLate = true;
			
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
			{
				canBeHit = true;
			}
		}

		//Glow note stuff.

		if (canBeHit && Config.noteGlow && !isSustainNote && !editor && animation.curAnim.name.contains("Scroll")){
			glow();
		}

		if (tooLate && !isSustainNote && !editor && !animation.curAnim.name.contains("Scroll")){
			idle();
		}

	}

	public function glow(){

		// switch (noteData)
		// {
		// 	case 2:
		// 		animation.play('green glow');
		// 		case 3:
		// 		animation.play('red glow');
		// 	case 1:
		// 		animation.play('blue glow');
		// 	case 0:
		// 		animation.play('purple glow');
		// }

		var frameN:Array<String> = ['purple', 'blue', 'green', 'red'];
		if (mania == 1) frameN = ['purple', 'green', 'red', 'yellow', 'blue', 'dark'];
		else if (mania == 2) frameN = ['purple', 'blue', 'green', 'red', 'white', 'yellow', 'violet', 'black', 'dark'];
		animation.play(frameN[noteData] + 'Scroll');
	}

	public function idle(){

		// switch (noteData)
		// {
		// 	case 2:
		// 		animation.play('greenScroll');
		// 	case 3:
		// 		animation.play('redScroll');
		// 	case 1:
		// 		animation.play('blueScroll');
		// 	case 0:
		// 		animation.play('purpleScroll');
		// }

		var frameN:Array<String> = ['purple', 'blue', 'green', 'red'];
		if (mania == 1) frameN = ['purple', 'green', 'red', 'yellow', 'blue', 'dark'];
		else if (mania == 2) frameN = ['purple', 'blue', 'green', 'red', 'white', 'yellow', 'violet', 'black', 'dark'];
		animation.play(frameN[noteData] + 'Scroll');
	}
}
