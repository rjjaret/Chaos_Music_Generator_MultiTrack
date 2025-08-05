import themidibus.*;  //<>// //<>// //<>//

class MidiPitchQuantizer
{
  int[] MidiPitchClasses = null;
  
  MidiPitchQuantizer()
  {
     MidiPitchClasses = new int[]{0, 2, 4, 5, 7, 9, 11}; // C Major
     //MidiPitchClasses = = new int[]{0, 2, 4, 7, 9}; //algorithm assumes this is sorted! // C Major Pentatonic
     //MidiPitchClasses = = new int[]{0, 4, 7, 11}; //algorithm assumes this is sorted! // C M7
     //MidiPitchClasses = new int[]{0, 2, 4, 7, 9}; // C, D, E, G, B
  }
  
  MidiPitchQuantizer(int[] MidiPitchClassesForScale)
  {
    MidiPitchClasses = sort(MidiPitchClassesForScale);  //algorithm assumes this is sorted, and is list of pitches at lowest octave (C=0)
  }

  int QuantizeMidiPitchToScale(int midiPitch)
  {
    int rtn = -1;

    int octave = int(midiPitch/12);
    int testValue = midiPitch % 12;

    int lowerVal = -1;
    int higherVal = -1;
    
    for (int val : MidiPitchClasses)
    {
      if (testValue > val)
      {
        lowerVal = val;
      } else if (testValue <= val)
      {
        higherVal = val;
        break;
      }
    }

    if (higherVal == -1) // set higher value an octave higher than root in case midiPitch is closer to that pitch than the top of the scale.
      higherVal = MidiPitchClasses[0] + 12;


    int deltaLower = testValue - lowerVal;
    int deltaHigher = higherVal - testValue;

    if (deltaHigher < deltaLower)
      rtn = higherVal + (octave * 12);
    else
      rtn = lowerVal + (octave * 12);

    //println("Quantized Midi Pitch: " + midiPitch + " to " + rtn);
    return rtn;
  }
}
