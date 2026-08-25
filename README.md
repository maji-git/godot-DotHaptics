# .haptic file support for Godot 🎮

gd .haptic is a Library that adds support for `.haptic` file formats. This includes the file importer, interpreter, translator, and the haptic player itself.

`.haptic` files can be made using [Meta Haptics Studio](https://developers.meta.com/horizon/resources/haptics-studio/) or other Haptics software solution that supports the `.haptic` format. From there you can edit the amplitudes & frequencies in a visual editor. You can also import audio, which is really nice.

## How to use

0. Prepare your `.haptic` file and import it to the editor (simply via dragging the file into the editor)
1. Create `DotHapticsJoy` from the node creation menu.
2. Assign `haptic` variable to the `.haptic` resource you just imported.
3. Configure settings as needed, such as `looped` if you want the haptics to loop.
4. To trigger the haptic, call `.trigger()` on the `DotHapticsJoy` node, you can also call `.stop()` if you chose to loop the haptics and wants to stop it.

> [!TIP]
> I'd also recommend you playing an audio alongside the haptic (if you have one), to really feel it.

## Implementation Layers

### File Importer & Data (`DotHapticsData`)

Imports .haptic file and make it available in the editor

### Interpreter (`DotHapticsInterpreter`)

Takes file data and interpret the haptic data.

### Translator (`DotHapticsTranslator`)

Wrapper around interpreter, it processes decaying haptics (emphasis) and provide a signal that calls frame by frame with weak & strength values.

### Joypad Haptics Player (`DotHapticsJoy`)

The player that wrap around those two, the interpreter and the translator. Provides a simple node which you can call `.trigger()` to play the haptics.
