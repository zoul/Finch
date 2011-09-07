Design Notes
------------

* I don’t think the OpenAL types should leak to the public Sound interface.
* If we want the decoder stuff to be useful for other people, we have to separate
  the file reading from decoding and we have to decode the audio in chunks if the
  caller wants to.
* “A tip for when you want to add panning to Finch – move (AL_POSITION) the
  listener or the source slightly from the default Z position (0.0f) to get
  smooth panning.”
