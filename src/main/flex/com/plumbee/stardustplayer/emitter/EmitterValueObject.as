package com.plumbee.stardustplayer.emitter
{

import flash.display.BitmapData;

import idv.cjcat.stardustextended.sd;

import idv.cjcat.stardustextended.twoD.emitters.Emitter2D;
import idv.cjcat.stardustextended.twoD.initializers.BitmapParticleInit;

use namespace sd;

public class EmitterValueObject
{
    public var burstClockInterval : uint = 33;
    public var emitterName : String;
    public var emitter : Emitter2D;
    private var _id : uint;
    private var _image : BitmapData;

    public function EmitterValueObject( emitterId : uint )
    {
        _id = emitterId;
    }

    public function get id() : uint
    {
        return _id;
    }

    public function get image() : BitmapData
    {
        return _image;
    }

    public function get imageName() : String
    {
        return "emitterImage_" + _id + ".png";
    }

    public function get xmlName() : String
    {
        return "stardustEmitter_" + _id + ".xml";
    }

    public function get smoothing() : Boolean
    {
        const inits : Array = emitter.sd::initializers;
        const numInits : uint = inits.length;
        for (var i:uint=0; i < numInits; i++)
        {
            var bitmapInit : BitmapParticleInit = inits[i] as BitmapParticleInit;
            if ( bitmapInit )
            {
                return bitmapInit.smoothing;
            }
        }

        return false;
    }

    public function set image(imageBD : BitmapData) : void
    {
        _image = imageBD;
        const initializers : Array = emitter.sd::initializers;
        for (var k:int = 0; k < initializers.length; k++)
        {
            var bitmapParticleInit : BitmapParticleInit = initializers[k] as BitmapParticleInit;
            if ( bitmapParticleInit )
            {
                bitmapParticleInit.bitmapData = _image;
                return;
            }
        }
    }
}
}
