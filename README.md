About
=====

Finch is a dead-simple OpenAL-based sound effect player for iPhone.
The reasons for writing Finch instead of sticking with Apple’s
`AVAudioPlayer` are described in my [question on Stack Overflow][so].

[so]: http://stackoverflow.com/questions/986983

The goals are simple: (1) Play sound effects without much fuss,
and (2) do not lag in the `play` method as `AVAudioPlayer` does.
Finch is not meant to play background music. If you want to play
background music, you can go with `AVAudioPlayer`. Finch will
play the sound effects over the background music just fine.

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

* [Finch on github][git]
* [An iPhone OpenAL brain dump][dump]
* [OpenAL Programmer’s Guide][guide]

[git]: http://github.com/zoul/Finch/
[dump]: http://www.subfurther.com/blog/?p=602
[guide]: http://connect.creativelabs.com/openal/Documentation/OpenAL_Programmers_Guide.pdf

Author
======

Tomáš Znamenáček, <zoul@fleuron.cz>. Suggestions welcomed.
