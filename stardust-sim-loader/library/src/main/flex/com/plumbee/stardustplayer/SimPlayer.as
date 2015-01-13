package com.plumbee.stardustplayer
{

import com.plumbee.stardustplayer.emitter.BaseEmitterValueObject;
import com.plumbee.stardustplayer.project.ProjectValueObject;

import flash.display.BitmapData;
import flash.display.DisplayObjectContainer;

import idv.cjcat.stardustextended.common.clocks.ImpulseClock;
import idv.cjcat.stardustextended.common.handlers.ParticleHandler;
import idv.cjcat.stardustextended.twoD.handlers.BitmapHandler;
import idv.cjcat.stardustextended.twoD.handlers.DisplayObjectHandler;
import idv.cjcat.stardustextended.twoD.handlers.PixelHandler;
import idv.cjcat.stardustextended.twoD.handlers.SingularBitmapHandler;
import idv.cjcat.stardustextended.twoD.starling.StarlingHandler;

/** Simple class to play back simulations. If you need something more custom write your own. */
public class SimPlayer
{
	private var _sim : ProjectValueObject;

	public function setSimulation(sim : ProjectValueObject, renderTarget : Object) : void
	{
		_sim = sim;
		for each (var emitterValueObject : BaseEmitterValueObject in sim.emitters)
		{
			const handler : ParticleHandler = emitterValueObject.emitter.particleHandler;
			if (handler is DisplayObjectHandler)
			{
				DisplayObjectHandler(handler).container = DisplayObjectContainer(renderTarget);
			}
			else if (handler is BitmapHandler)
			{
				BitmapHandler(handler).targetBitmapData = BitmapData(renderTarget);
			}
			else if (handler is SingularBitmapHandler)
			{
				SingularBitmapHandler(handler).targetBitmapData = BitmapData(renderTarget);
			}
			else if (handler is PixelHandler)
			{
				PixelHandler(handler).targetBitmapData = BitmapData(renderTarget);
			}
			else if (handler is StarlingHandler)
			{
				StarlingHandler(handler).container = renderTarget;
			}
		}
	}

	public function stepSimulation(timeStep : Number = 1) : void
	{
		for each (var emitterValueObject : BaseEmitterValueObject in _sim.emitters)
		{
			emitterValueObject.emitter.step(timeStep);
			if (emitterValueObject.emitter.clock is ImpulseClock)
			{
				const impulseClock : ImpulseClock = ImpulseClock(emitterValueObject.emitter.clock);
				if (emitterValueObject.emitter.currentTime >= impulseClock.nextBurstTime)
				{
					const currentTime : Number = emitterValueObject.emitter.currentTime;
					ImpulseClock(emitterValueObject.emitter.clock).impulse(currentTime);
				}
			}
		}
	}

	/**
	 * This is numerically stable simulation step method.
	 * If current time step exceeds base time step then animation step is performed many times with
	 * respectively smaller sub steps (while overall substeps time equals initial time step).
	 * This way the animation actors spatial properties (such as position, rotation etc.)
	 * are not affected by the lower frame rates.
	 * This means that animation will look exactly the same despite the varying frame rate.
	 *
	 * (Note that when there is a massive amount of particles this simulation method may affect performance a lot)
	 *
	 * @param timeStep Current simulation step advance time in milliseconds.
	 * @param baseTimeStep Expected time for one frame of the simulation in milliseconds (for 60 fps == 1/60 * 1000 ms)
	 */
	public function stepSimulationWithSubsteps(timeStep : Number, baseTimeStep : Number = SimTimeModel.msFor60FPS) : void
	{
		var substepsCount : Number = Math.floor(timeStep / baseTimeStep);
		var remainingTime : Number = timeStep - substepsCount * baseTimeStep;

		// Perform "substepsCount" amount of full "baseTimeStep" lasting steps
		while (substepsCount-- > 0)
		{
			stepSimulation(1);
		}

		// Perform step to cover remaining time
		if (remainingTime > 0)
		{
			stepSimulation(remainingTime / baseTimeStep);
		}
	}

	/** When calling this the Emitter2D objects will be recreated, so make sure you update your references. */
	public function resetSimulation() : void
	{
		for each (var emitterValueObject : BaseEmitterValueObject in _sim.emitters)
		{
			emitterValueObject.emitter.reset();
		}
	}

}
}
