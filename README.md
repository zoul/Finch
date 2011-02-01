About
=====

Finch is a simple OpenAL-based sound effect player for iOS. The reasons for
writing Finch instead of sticking with Apple’s `AVAudioPlayer` are described in
my [question on Stack Overflow][so]. The goals are simple: (1) Play sound
effects without much fuss, and (2) do not lag in the `play` method as
`AVAudioPlayer` does. Finch is not meant to play background music. If you want
to play background music, you can go with `AVAudioPlayer`. Finch will play the
sound effects over the background music just fine.

[so]: http://stackoverflow.com/questions/986983

Howto
=====

The code is fairly tested. The interface changes from time to time as I don’t
bother with backward compatibility, but it should be fairly easy to keep up
with the changes. Basic use case:

    #import "Finch.h"
    #import "Sound.h"
    #import "RevolverSound.h"

    // Initializes OpenAL
    Finch *soundEngine = [[Finch alloc] init];
    NSBundle *bundle = [NSBundle mainBundle];

    // Simple sound, only one instance can play at a time.
    // If you call ‘play’ and the sound is still playing,
    // it will start from the beginning.
    Sound *click = [[Sound alloc] initWithFile:
        [bundle URLForResource:@"click" withExtension:@"wav"]];
    [click play];

    // For playing multiple instances of the same sample at once
    RevolverSound *gun = [[RevolverSound alloc] initWithFile:
        [bundle URLForResource:@"gunshot" withExtension:@"wav"] rounds:10];
    // Now I have a machinegun, ho-ho-ho
    for (int i=1; i<=10; i++)
        [gun play];

Don’t forget to link the application with `AudioToolbox` and `OpenAL`
frameworks. And please note that Finch does not yet support compressed
audio. You should be safe with mono or stereo WAV files sampled at 44.100 Hz.

Download the demo project to see more.

Audio Session Primer
====================

Before your application can play any sound whatsoever, you should set up the
audio session so that the system knows how to work with your sounds – if they
should be muted by the hardware Mute switch, for example, or if the iPod music
should play behind your sounds.

Finch used to set up the audio session for you, but that’s not the right way to
do it™, so that in recent versions you have to set the audio session yourself.
Yes, that’s considered progress :-) The good news is that there is a nice class
called [`AVAudioSession`][session] shipped by Apple that lets you configure the
session in no time. The basic code looks like this:

    NSError *error = nil;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    NSAssert(error == nil, @"Failed to set audio session category.");
    [session setActive:YES error:&error];
    NSAssert(error == nil, @"Failed to activate audio session.");

[session]: http://developer.apple.com/library/ios/documentation/AVFoundation/Reference/AVAudioSession_ClassReference/Reference/Reference.html

The main point is the `AVAudioSessionCategoryPlayback` constant. See the
`AVAudioSession` documentation for a list of the possible categories and their
meaning. This matters, you should know which category you are choosing.

Design Notes
============

Finch has been designed so that its components can be used separately. If you
want to, you can initialize the OpenAL yourself and only use the `Sound` class.
And if you want to, you can use just the `Decoder` to get raw PCM data from WAV
and CAF files without having to import the `Finch` and `Sound` classes. You can
also come up with the PCM data yourself and pass it to OpenAL using the designated
initializer of the `Sound` class:

    - (id) initWithData: (const ALvoid*) data size: (ALsizei) size
        format: (ALenum) format sampleRate: (ALsizei) frequency
        duration: (float) seconds;

Bugs, Gotchas
=============

Many people are having problems with OpenAL sound in the simulator. I have not
found a definitive answer from Apple, but it seems that OpenAL quite often does
not work in the simulator.

License
=======

Licensed under the [MIT License][license]. Essentially you can do with this
software whatever you like, provided that you keep the copyright notice and
the license text along.

[license]: http://www.opensource.org/licenses/mit-license.php

Links
=====

Some links you might find useful:

* [Finch on github][git]
* [An iPhone OpenAL brain dump][dump]
* [OpenAL Programmer’s Guide][guide]

[git]: http://github.com/zoul/Finch/
[dump]: http://www.subfurther.com/blog/?p=602
[guide]: http://connect.creativelabs.com/openal/Documentation/OpenAL_Programmers_Guide.pdf

Author & Support
================

Tomáš Znamenáček, <zoul@fleuron.cz>. Suggestions welcomed.

If you have a question that could possibly be of interest to other people, you
can ask it on [Stack Overflow][questions] and send me a link to your question.
It’s better than discussing it in private, because you can get answers from
other people and once the question has been answered, other people can benefit
from the answer, too.

[questions]: http://stackoverflow.com/questions/tagged/finch
