package com.plumbee.stardustplayer.emitter
{

import idv.cjcat.stardustextended.sd;
import idv.cjcat.stardustextended.twoD.emitters.Emitter2D;

use namespace sd;

public class BaseEmitterValueObject
{
	protected var _emitter : Emitter2D;
	private var _id : uint;

	public function BaseEmitterValueObject(emitterId : uint, emitter : Emitter2D)
	{
		_emitter = emitter;
		_id = emitterId;
	}

	public function get id() : uint
	{
		return _id;
	}

	public function get emitter() : Emitter2D
	{
		return _emitter;
	}

	public function destroy() : void
	{
		emitter.clearParticles();
		emitter.clearActions();
		emitter.clearInitializers();
	}

	public function resetEmitter() : void
	{
		emitter.reset();
	}
}
}