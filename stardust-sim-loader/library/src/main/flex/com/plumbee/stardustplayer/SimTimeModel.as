/**
 * Created by Rafal on 09/01/15.
 */
package com.plumbee.stardustplayer
{
import flash.utils.getTimer;

/**
 * Simulation Time Model is responsible for providing the time step values for simulation player based on flash app internal timer.
 * Note: This model does not own accumulated simulation time, for such value query Emitter.currentTime property.
 */
public class SimTimeModel
{
	public static const msFor60FPS:Number = 1/60 * 1000;
	private static var lastTime : Number;
	private var elapsedDeltaTime : Number;

	public function SimTimeModel()
	{
		resetTime();
	}

	public function resetTime() : void
	{
		lastTime = getTimerInternal();
	}

	/**
	 * Current time step normalized to value that represents single time unit in stardust-engine.
	 * @return Returns the elapsed time since the previous step in stardust time units.
	 */
	public function get timeStepNormalizedTo60fps() : Number
	{
		return elapsedDeltaTime/msFor60FPS;
	}

	/**
	 * Current time step value in milliseconds
	 * @return Returns the elapsed time since the previous step in milliseconds.
	 */
	public function get timeStep() : Number
	{
		return elapsedDeltaTime;
	}

	/**
	 * Should be called on per simulation step basis.
	 */
	public function update() : void
	{
		var currentMillis : Number = getTimerInternal();
		elapsedDeltaTime = currentMillis - lastTime;
		lastTime = currentMillis;
	}

	/**
	 * Creared for testing purposes.
	 */
	protected function getTimerInternal() : Number {
		return getTimer();
	}

}
}
