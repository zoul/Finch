Design Notes
------------

* I don’t think the OpenAL types should leak to the public Sound interface.
* If we want the decoder stuff to be useful for other people, we have to separate
  the file reading from decoding and we have to decode the audio in chunks if the
  caller wants to.
