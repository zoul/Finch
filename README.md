About
=====

Finch is a dead-simple OpenAL-based sound effect player for iPhone.
The reasons for writing Finch instead of sticking with Apple’s
AVAudioPlayer are described in my question on Stack Overflow:

http://stackoverflow.com/questions/986983

The goals are simple: (1) Play sound effects without much fuss,
and (2) do not lag in the `play` method as AVAudioPlayer does.
Finch is not meant to play background music. If you want to play
background music, you can simply stick to AVAudioPlayer. Finch
will play the sound effects over the background music just fine.

Howto
=====

    #import "Finch.h"
    #import "Sound+IO.h"

    // Initializes Audio Session, opens OpenAL device.
    Finch *soundEngine = [[Finch alloc] init];

    NSString *soundPath = [[[NSBundle mainBundle] resourcePath]
        stringByAppendingPathComponent:@"SFX/click.wav"];
    Sound *click = [[Sound alloc] initWithFile:path];
    [sample play];

This is alpha code, the interface will almost certainly change.
That said, it should be fairly easy to adapt to changes.

Bugs, gotchas
=============

Many people are having problems with OpenAL sound in the simulator.
I have not found a definitive answer from Apple, but it seems that
OpenAL simply does not work in the simulator. When run on the
simulator, Finch will warn you that OpenAL is probably not going
to work.

License
=======

You can do with this code whatever you like.

Links
=====

* http://github.com/zoul/Finch/
* http://www.subfurther.com/blog/?p=602
* http://connect.creativelabs.com/openal/Documentation/OpenAL_Programmers_Guide.pdf
* http://connect.creativelabs.com/openal/Documentation/OpenAL%201.1%20Specification.pdf

Author
======

Tomáš Znamenáček, <zoul@fleuron.cz>. Suggestions welcomed.
