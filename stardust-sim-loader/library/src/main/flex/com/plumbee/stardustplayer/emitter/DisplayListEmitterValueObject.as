package com.plumbee.stardustplayer.emitter
{
import idv.cjcat.stardustextended.twoD.display.bitmapParticle.BitmapParticle;
import idv.cjcat.stardustextended.twoD.emitters.Emitter2D;
import idv.cjcat.stardustextended.twoD.initializers.PooledDisplayObjectClass;

public class DisplayListEmitterValueObject extends BaseEmitterValueObject
{
	public function DisplayListEmitterValueObject(emitterId : uint, emitter : Emitter2D)
	{
		super(emitterId, emitter);
	}

	public function prepareForDisplayList() : void
	{
		addDisplayListInitializers()
	}

	public function addDisplayListInitializers() : void
	{
		addPooledDisplayObjectClass();
	}

	protected function addPooledDisplayObjectClass() : void
	{
		_emitter.addInitializer(new PooledDisplayObjectClass(BitmapParticle));
	}

}
}
