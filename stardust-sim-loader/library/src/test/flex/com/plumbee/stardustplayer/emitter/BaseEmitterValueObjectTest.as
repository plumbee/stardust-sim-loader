package com.plumbee.stardustplayer.emitter
{
import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;

public class BaseEmitterValueObjectTest
{
	[Test]
	public function resetEmitter_willResetEmitter() : void
	{
		var spy : Emitter2DSpy = new Emitter2DSpy();
		var emitter : BaseEmitterValueObject = new BaseEmitterValueObject(0, spy);
		emitter.resetEmitter();
		assertThat(spy.getResetCount(), equalTo(1));
	}
}
}

import idv.cjcat.stardustextended.twoD.emitters.Emitter2D;

class Emitter2DSpy extends Emitter2D
{
	private var count : uint = 0;

	override public function reset() : void
	{
		++count;
	}

	public function getResetCount() : uint
	{
		return count;
	}
}