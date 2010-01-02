About
=====

Finch is a dead-simple OpenAL-based sound effect player for iPhone. The
reasons for writing Finch instead of sticking with Apple’s `AVAudioPlayer` are
described in my [question on Stack Overflow][so]. The goals are simple: (1)
Play sound effects without much fuss, and (2) do not lag in the `play` method
as `AVAudioPlayer` does. Finch is not meant to play background music. If you
want to play background music, you can go with `AVAudioPlayer`. Finch will play
the sound effects over the background music just fine.

[so]: http://stackoverflow.com/questions/986983

Howto
=====

This is alpha code, the interface will almost certainly change. That said, it
should be fairly easy to adapt to changes.

    #import "Finch.h"
    #import "Sound+IO.h"
    #import "RevolverSound.h"

    // Initializes Audio Session, opens OpenAL device.
    Finch *soundEngine = [[Finch alloc] init];

    // Simple sound, only one instance can play at a time.
    // If you call ‘play’ and the sound is still playing,
    // it will start from the beginning.
    Sound *click = [[Sound alloc] initWithFile:@"…/SFX/click.wav"];
    [click play];

    // For playing multiple instances of the same sample at once.
    RevolverSound *gun = [[RevolverSound alloc]
        initWithFile:@"…/SFX/gunshot.wav" rounds:10];
    // Now I have a machinegun, ho-ho-ho.
    for (int i=1; i<=10; i++)
        [gun play];

Don’t forget to link the application with `AudioToolbox` and `OpenAL`
frameworks. And please note that OpenAL does not support any compressed
audio, which means that Finch – being just a tiny wrapper around OpenAL –
also does not support compressed audio. You should be safe with mono or
stereo WAV files sampled at 44.100 Hz.

Another thing to keep in mind is that you have to pass an absolute path
when loading a sound. If you have a `boom.wav` sound in a `SFX` directory
of your resources directory, you can get the full path using the following
code:

    NSString *fullpath = [[[NSBundle mainBundle] resourcePath]
       stringByAppendingPathComponent:@"SFX/boom.wav"];
    Sound *boom = [[Sound alloc] initWithFile:fullPath];

Background music
================

Finch is designed to play short uncompressed samples. If you want to
play background music, you can use the `AVAudioPlayer` class supplied
by Apple. Finch will mix with the background track just fine.

There is one important catch in playing background music, or more precisely, in
playing compressed audio on iPhone. Each application that wants to work with
sound on iPhone can choose from several audio session ‘categories’ that affect
the way your application behaves with respect to sound. If you want to play
your sound over the system sounds, for example over the iPod sound, you have to
choose the `AmbientSound` category. The problem is that this category [harms
MP3 decoding performance][mp3]. This means that if you want to play your own
background music, you should switch to the `SoloAmbientSound` category, which
does not mix your sound with the system sound, but does not harm the MP3 decoding
performance. In Finch you can use the `mixWithSystemSound` property to switch
between the `SoloAmbientSound` and `AmbientSound` categories:

    soundEngine.mixWithSystemSound = NO;  // SoloAmbientSound
    soundEngine.mixWithSystemSound = YES; // AmbientSound

By default Finch will mix with system sound if there is something playing.

[mp3]: http://stackoverflow.com/questions/1009385

Bugs, gotchas
=============

Many people are having problems with OpenAL sound in the simulator. I have not
found a definitive answer from Apple, but it seems that OpenAL quite often does
not work in the simulator.

License
=======

You can do with this code whatever you like.

Links
=====

Some links you might find useful:

* [Finch on github][git]
* [An iPhone OpenAL brain dump][dump]
* [OpenAL Programmer’s Guide][guide]

[git]: http://github.com/zoul/Finch/
[dump]: http://www.subfurther.com/blog/?p=602
[guide]: http://connect.creativelabs.com/openal/Documentation/OpenAL_Programmers_Guide.pdf

Author
======

Tomáš Znamenáček, <zoul@fleuron.cz>. Suggestions welcomed.
