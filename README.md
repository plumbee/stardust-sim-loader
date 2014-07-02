#stardust-sim-loader


Loading and playback library for the stardust simulations made with the stardust editor. You can check out the examples directory how to use it.


##.sde file format specification 1.0

.sde are Stardust simulation files created in the stardust editor. They can be played back by this library. The file is actually a .zip file that is compressed with store only option.

It contains the following files:
- descriptor.json
- emitterImage_[number].png : The bitmap that is used to render the particles from emitter [number], always in .png format. There are always the same number of these as emitters.
- stardustEmitter_[number].xml : The stardust simulation descriptor for emitter [number]. A single project can contain unlimited number of emitters (but more than 8-10 can severely impact performance).


descriptor.json specification: This is a JSON file containing settings for the simulation, an example how it can look:

```json
{
	"version": 1,
	"emitters": [
		{
			"id": "0"
		},
		{
			"id": "1"
		}
	],
	"backgroundColor": 0,
    "backgroundFileName": "background.png",
	"hasBackground": "true"
}
```

`id` associates the emitter with its image and emitter xml file (e.g. emitter with `id=12` has `emitterImage_12.png` and `stardustEmitter_12.png`.)

`backgroundColor` is the color of the background in the editor. Ignored if hasBackground is false.

`backgroundFileName` is the filename of the background. Either a .png or a .swf file.

***

Note that `backgroundColor`, `backgroundFileName` and the `hasBackground` properties are ignored by the playback component. They are meant for easier creation of effects in the simulation editor.