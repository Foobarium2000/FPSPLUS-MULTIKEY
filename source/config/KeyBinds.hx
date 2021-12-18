package config;

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

class KeyBinds
{

    public static function resetBinds():Void{

        FlxG.save.data.upBind = "W";
        FlxG.save.data.downBind = "S";
        FlxG.save.data.leftBind = "A";
        FlxG.save.data.rightBind = "D";
        FlxG.save.data.L1Bind = "S";
        FlxG.save.data.U1Bind = "D";
        FlxG.save.data.R1Bind = "F";
        FlxG.save.data.L2Bind = "J";
        FlxG.save.data.D1Bind = "K";
        FlxG.save.data.R2Bind = "L";
        FlxG.save.data.B1Bind = "A";
        FlxG.save.data.B2Bind = "S";
        FlxG.save.data.B3Bind = "D";
        FlxG.save.data.B4Bind = "F";
        FlxG.save.data.B5Bind = "SPACE";
        FlxG.save.data.B6Bind = "H";
        FlxG.save.data.B7Bind = "J";
        FlxG.save.data.B8Bind = "K";
        FlxG.save.data.B9Bind = "L";
        FlxG.save.data.killBind = "R";

        FlxG.save.data.upBindController = "Y";
        FlxG.save.data.downBindController = "A";
        FlxG.save.data.leftBindController = "X";
        FlxG.save.data.rightBindController = "B";

        PlayerSettings.player1.controls.loadKeyBinds();

	}

    public static function keyCheck():Void
    {
        //Keyboard stuff
        if(FlxG.save.data.upBind == null){
            FlxG.save.data.upBind = "W";
            trace("No UP");
        }
        if(FlxG.save.data.downBind == null){
            FlxG.save.data.downBind = "S";
            trace("No DOWN");
        }
        if(FlxG.save.data.leftBind == null){
            FlxG.save.data.leftBind = "A";
            trace("No LEFT");
        }
        if(FlxG.save.data.rightBind == null){
            FlxG.save.data.rightBind = "D";
            trace("No RIGHT");
        }
        if(FlxG.save.data.L1Bind == null){
            FlxG.save.data.L1Bind = "S";
            trace("No L1");
        }
        if(FlxG.save.data.U1Bind == null){
            FlxG.save.data.U1Bind = "D";
            trace("No U1");
        }
        if(FlxG.save.data.R1Bind == null){
            FlxG.save.data.R1Bind = "F";
            trace("No R1");
        }
        if(FlxG.save.data.L2Bind == null){
            FlxG.save.data.L2Bind = "J";
            trace("No L2");
        }
        if(FlxG.save.data.D1Bind == null){
            FlxG.save.data.D1Bind = "K";
            trace("No D1");
        }
        if(FlxG.save.data.R2Bind == null){
            FlxG.save.data.R2Bind = "L";
            trace("No R2");
        }
        if(FlxG.save.data.B1Bind == null){
            FlxG.save.data.B1Bind = "A";
            trace("No B1");
        }
        if(FlxG.save.data.B2Bind == null){
            FlxG.save.data.B2Bind = "S";
            trace("No B2");
        }
        if(FlxG.save.data.B3Bind == null){
            FlxG.save.data.B3Bind = "D";
            trace("No B3");
        }
        if(FlxG.save.data.B4Bind == null){
            FlxG.save.data.B4Bind = "F";
            trace("No B4");
        }
        if(FlxG.save.data.B5Bind == null){
            FlxG.save.data.B5Bind = "SPACE";
            trace("No B5");
        }
        if(FlxG.save.data.B6Bind == null){
            FlxG.save.data.B6Bind = "H";
            trace("No B6");
        }
        if(FlxG.save.data.B7Bind == null){
            FlxG.save.data.B7Bind = "J";
            trace("No B7");
        }
        if(FlxG.save.data.B8Bind == null){
            FlxG.save.data.B8Bind = "K";
            trace("No B8");
        }
        if(FlxG.save.data.B9Bind == null){
            FlxG.save.data.B9Bind = "L";
            trace("No B9");
        }
        if(FlxG.save.data.killBind == null){
            FlxG.save.data.killBind = "R";
            trace("No KILL");
        }
        //Controller stuff
        if(FlxG.save.data.upBindController == null){
            FlxG.save.data.upBindController = "Y";
            trace("No Controller UP");
        }
        if(FlxG.save.data.downBindController == null){
            FlxG.save.data.downBindController = "A";
            trace("No Controller DOWN");
        }
        if(FlxG.save.data.leftBindController == null){
            FlxG.save.data.leftBindController = "X";
            trace("No Controller LEFT");
        }
        if(FlxG.save.data.rightBindController == null){
            FlxG.save.data.rightBindController = "B";
            trace("No Controller RIGHT");
        }
    }

}