package com.plumbee.stardustplayer.emitter
{
import starling.display.DisplayObjectContainer;

public interface IStarlingEmitter extends IBaseEmitter
{
	function updateHandlerCanvas(target : DisplayObjectContainer) : void;
	function addStarlingInitializers() : void
}
}
