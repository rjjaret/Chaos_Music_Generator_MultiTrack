# Chaos_Music_Generator_MultiTrack
Generates Music (midi notes) based on the Lorenz Attractor equation and sends them to a DAW through a midibus(es).

This app was written in MIT's Processing programming language. It was originally developed to generate music for the film, “Weather and Chaos: The Work of Edward N. Lorenz", which you can view at:
https://vimeo.com/287523707.

You can learn more about how the music was created here:
https://robjaret.com/soundtrack-to-chaos/

and listen to the full soundtrack here:
https://robjaret.bandcamp.com/album/weather-and-chaos-the-work-of-edward-lorenz

The app needs to be configured in the code at these places:
- setup tracks in Chaos_Music_Generator_MultiTrack.setup(), including name of DawInput, pitch ranges, et. al.
- setup midi pitch class set in MidiPitchQuantizer (~ line 9)

Feel free to reach out with any questtions!
