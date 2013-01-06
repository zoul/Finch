About
=====

Finch is a simple OpenAL-based sound effect player for iOS. The reasons for writing Finch instead of sticking with Apple’s `AVAudioPlayer` are described in my [question on Stack Overflow][so]. The goals are simple: (1) Play sound effects without much fuss, and (2) do not lag in the `play` method as `AVAudioPlayer` does. Finch is not meant to play background music. If you want
to play background music, you can go with `AVAudioPlayer`. Finch will play the sound effects over the background music just fine.

[so]: http://stackoverflow.com/questions/986983

Installing
==========

Finch is a static library. Your best bet is to use the “workspace” Xcode 4 feature, adding the Finch project into your project’s workspace and linking the appropriate target against `libFinch`. The only remaining thing is taking care of headers. This is a bit clumsy (see [another SO question][headers]), but in essence you can put Finch into a folder inside your project (say `Support`) and set the user header search path to this folder and below (`Support/**`).

If you are unsure about the instructions above, please see the [Xcode 4 static libraries][tutorial] tutorial by Jonah Williams.

[headers]: http://stackoverflow.com/questions/6289999
[tutorial]: http://blog.carbonfive.com/2011/04/04/using-open-source-static-libraries-in-xcode-4/#using_a_static_library

Using
=====

After you link against the library and import the headers you may start using the code:

    #import "FISoundEngine.h"

    NSError *error = nil;
    FISoundEngine *engine = [FISoundEngine sharedEngine];
    FISound *sound = [engine soundNamed:@"finch.wav" maxPolyphony:4 error:&error];
    if (!sound) {
        NSLog(@"Failed to load sound: %@", error);
    } else {
        [sound play];
    }

Sound loaded without the `maxPolyphony` argument will only play with one “voice” at a time. If you call `play` before such sound is finished, it will play again from the start:

    -----------------> time
    ra
      ra
        rapid fire!

If you wish to overlay multiple instances of the sound, set the `maxPolyphony` argument to maximum number of sounds that you need to layer:

    -----------------> time
    rapid fire!
      rapid fire!
        rapid fire!

And please note that Finch does not yet support compressed audio. You should be safe with 8-bit or 16-bit mono or stereo little-endian WAV files sampled at 44.1 kHz. There is a demo target inside the project, take a look at it to see more.

Audio Interruption Handling
===========================

Your app’s audio session may be interrupted at any moment, be it with an incoming call, the iPod playback being started or whatever else. In this case you are reponsible for correctly suspending your audio session and resuming it later when the interruption ends. This is a bit hard, since the sound system is very particular about your suspend and resume code.

Finch currently supports suspend and resume with the `suspended` property of the `FISoundEngine` class. When you receive an interruption notification or callback from the system, you can set this property to `YES` and later flip it to `NO` when the interruption has ended. There’s a slight catch, though – when your app receives a notification about the interruption being ended, your app still may be in background and therefore it can’t resume the sound session right away. You have to wait until the app is active again and only then resume the sound engine. See the application delegate in the demo project about how this can be done. (Also notice that the audio session delegates, callbacks and notifications differ between iOS versions.)

Further info may be found in the documentation for the `AVAudioSession` class.

Hacking
=======

The `FISoundEngine` and `FISound` classes are just a thin layer atop of the plumbing classes that implement the actual OpenAL primitives. See the Xcode project to learn more, it’s fairly easy to do your own things if you need to. Some links you might find useful:

* [An iPhone OpenAL brain dump][dump]
* [OpenAL Programmer’s Guide][guide]

[dump]: http://www.subfurther.com/blog/?p=602
[guide]: http://connect.creativelabs.com/openal/Documentation/OpenAL_Programmers_Guide.pdf

License
=======

The code is offered under the [MIT License][license]. Essentially you can do with this software whatever you like, provided that you keep the copyright notice and the license text along.

[license]: http://www.opensource.org/licenses/mit-license.php

Authors & Support
=================

Code by Tomáš Znamenáček, <tomas.znamenacek@gmail.com>.  
The Finch image is © [asukawashere].

If you have a question that could possibly be of interest to other people, you can ask it on [Stack Overflow][questions] and send me a link to your question. It’s better than discussing it in private, because you can get answers from other people and once the question has been answered, other people can benefit
from the answer, too.

[questions]: http://stackoverflow.com/questions/tagged/finch
[asukawashere]: http://asukawashere.deviantart.com/art/Gouldian-Finch-Watercolor-122610881
