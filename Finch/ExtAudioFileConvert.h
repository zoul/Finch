//
//  ExtAudioFileConvert.h
//  Bazingo
//
//  Created by Jacob Agar on 2013-07-04.
//  Copyright (c) 2013 Uken Games, Inc. All rights reserved.
//

#ifndef Bazingo_ExtAudioFileConvert_h
#define Bazingo_ExtAudioFileConvert_h

#define DEBUG_CONVERT_AUDIO 0

__BEGIN_DECLS

extern OSStatus DoConvertFile(CFURLRef sourceURL, CFURLRef destinationURL, OSType outputFormat, Float64 outputSampleRate) ;

extern AudioBufferList * GetConvertedData(CFURLRef sourceURL, OSType outputFormat, Float64 outputSampleRate, AudioStreamBasicDescription **outFormat);

extern void ThreadStateInitalize();

__END_DECLS

#endif
