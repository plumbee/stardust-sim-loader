/**
 * Created by Rafal on 12/01/15.
 */
package com.plumbee.stardustplayer
{
import org.flexunit.asserts.assertEquals;

public class SimTimeModelTest
{
	[Test]
	public function test_timeStep_and_timeStepNormalizedTo60fps() : void
	{
		var sut : SimTimeModelMocked = new SimTimeModelMocked();

		sut.mockedTime = 0;
		sut.resetTime();

		sut.mockedTime = SimTimeModel.msFor60FPS;
		sut.update();

		assertEquals(sut.timeStep, SimTimeModel.msFor60FPS);
		assertEquals(sut.timeStepNormalizedTo60fps, 1);
	}
}
}

import com.plumbee.stardustplayer.SimTimeModel;

internal class SimTimeModelMocked extends SimTimeModel {

	private var _time : Number = 0;

	public function get mockedTime() : Number
	{
		return _time;
	}

	public function set mockedTime(value : Number) : void
	{
		_time = value;
	}

	override protected function getTimerInternal() : Number
	{
		return _time;
	}
}
