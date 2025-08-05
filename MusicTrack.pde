import themidibus.*; //<>// //<>// //<>// //<>// //<>// //<>// //<>//

class MusicTrack {
  MidiBus _midiBus;
  MidiNote[] _activeNotes = null;
  MidiPitchQuantizer _midiPitchQuantizer = null;

  String Name = null;
  String MidiOutput = null;
  int MetronomeRate = -1;

  int MinMidiPitch = -1;
  int MaxMidiPitch = -1;
  String PitchParamName = null;
  float PitchParamValue = -1.0;
  float MinPitchParamValue = -1.0;
  float MaxPitchParamValue = -1.0;

  int MinDuration = -1;
  int MaxDuration = -1;
  String DurationParamName = null;
  float DurationParamValue = -1.0;
  float MinDurationParamValue = -1.0;
  float MaxDurationParamValue = -1.0;

  int MinVelocity = -1;
  int MaxVelocity = -1;
  String VelocityParamName = null;
  float VelocityParamValue = -1;
  float MinVelocityParamValue = -1.0;
  float MaxVelocityParamValue = -1.0;

  int _lastNoteStartMilliseconds = -1;

  // stats
  float _lowParamValue = 1000000.0;
  float _highParamValue = -1.0;


  MusicTrack(String name, String midiOutput, int metronomeRate, 
    String pitchParamName, int minMidiPitch, int maxMidiPitch, 
    float minPitchParamValue, float maxPitchParamValue, 
    String durationParamName, int minDuration, int maxDuration, 
    float minDurationParamValue, float maxDurationParamValue, 
    String velocityParamName, int minVelocity, int maxVelocity, 
    float minVelocityParamValue, float maxVelocityParamValue
    )
  {
    Name = name;
    MidiOutput = midiOutput;
    MetronomeRate = metronomeRate;
    _midiPitchQuantizer = new MidiPitchQuantizer();

    _activeNotes = new MidiNote[]{null, null, null};  //for now no more than 3 notes ('voices') at a time; could parameterize, but need to ensure overlapping durations/attacks work

    PitchParamName = pitchParamName;
    MinMidiPitch = minMidiPitch;
    MaxMidiPitch = maxMidiPitch;
    MinPitchParamValue = minPitchParamValue;
    MaxPitchParamValue = maxPitchParamValue;

    DurationParamName = durationParamName;
    MinDuration = minDuration;
    MaxDuration = maxDuration;
    MinDurationParamValue = minDurationParamValue;
    MaxDurationParamValue = maxDurationParamValue;

    VelocityParamName = velocityParamName;
    MinVelocity = minVelocity;
    MaxVelocity = maxVelocity;
    MinVelocityParamValue = minVelocityParamValue;
    MaxVelocityParamValue = maxVelocityParamValue;    

    if (midiOutput != "" && midiOutput != null)
    {
      _midiBus = new MidiBus(this, -1, midiOutput);
      //print(_midiBus.availableOutputs()); // Use to find out available outputs
    }
  }

  MusicTrack(String name, String midiOutput, int metronomeRate, 
    String pitchParamName, int minMidiPitch, int maxMidiPitch, 
    float minPitchParamValue, float maxPitchParamValue, 
    String durationParamName, int minDuration, int maxDuration, 
    float minDurationParamValue, float maxDurationParamValue
    )
  {

    Name = name;
    MidiOutput = midiOutput;
    MetronomeRate = metronomeRate;
    _midiPitchQuantizer = new MidiPitchQuantizer();
    
    _activeNotes = new MidiNote[]{null, null, null};  //for now no more than 3 notes ('voices') at a time; could parameterize

    PitchParamName = pitchParamName;
    MinMidiPitch = minMidiPitch;
    MaxMidiPitch = maxMidiPitch;
    MinPitchParamValue = minPitchParamValue;
    MaxPitchParamValue = maxPitchParamValue;

    // Defaults for velocity
    DurationParamName = null;
    MinVelocity = 70;
    MaxVelocity = 90; 

    DurationParamName = durationParamName;
    MinDuration = minDuration;
    MaxDuration = maxDuration;
    MinDurationParamValue = minDurationParamValue;
    MaxDurationParamValue = maxDurationParamValue;

    if (midiOutput != "" && midiOutput != null)
    {
      _midiBus = new MidiBus(this, -1, midiOutput);
      //print(_midiBus.availableOutputs()); // Use to find out available outputs
    }
  }

  MusicTrack(String name, String midiOutput, int metronomeRate, 
    int minMidiPitch, int maxMidiPitch, String pitchParamName, 
    float minPitchParamValue, float maxPitchParamValue
    )
  {
    Name = name;
    MidiOutput = midiOutput;
    MetronomeRate = metronomeRate;
    _midiPitchQuantizer = new MidiPitchQuantizer();
    
    _activeNotes = new MidiNote[]{null, null, null};  //for now no more than 3 notes ('voices') at a time; could parameterize

    PitchParamName = pitchParamName;
    MinMidiPitch = minMidiPitch;
    MaxMidiPitch = maxMidiPitch;
    MinPitchParamValue = minPitchParamValue;
    MaxPitchParamValue = maxPitchParamValue;

    // Defaults for duration
    DurationParamName = null;
    MinDuration = MetronomeRate - 10; 
    MaxDuration = MetronomeRate; 

    // Defaults for velocity
    DurationParamName = null;
    MinVelocity = 70;
    MaxVelocity = 90; 

    if (midiOutput != "" && midiOutput != null)
    {
      _midiBus = new MidiBus(this, -1, midiOutput);
      //print(_midiBus.availableOutputs()); // Use to find out available outputs
    }
  }

  void Process(float pitchParamValue, float durationParamValue, float velocityParamValue)
  {
    DurationParamValue = durationParamValue;
    VelocityParamValue = velocityParamValue;
    PitchParamValue = pitchParamValue;

    for (int i = 0; i < _activeNotes.length; i++)
    {
      if (( _activeNotes[i] != null) &&  _activeNotes[i].IsItTimeToStop())
      {
        _activeNotes[i].Stop(_midiBus);
        _activeNotes[i] = null;
      }
    }

    if (millis() >= MetronomeRate + _lastNoteStartMilliseconds)
    {           
      _playNote();
    }
  }

  void Process(float pitchParamValue, float durationParamValue)
  {
    Process(pitchParamValue, durationParamValue, -1);
  }

  void Process(float pitchParamValue)
  {
    Process(pitchParamValue, -1.0);
  }

  void AssignScale(int[] midiScalePitches) 
  {
    _midiPitchQuantizer.MidiPitchClasses = midiScalePitches;
  }

  void _playNote()
  {

    int midiPitch = normalizeToRange(PitchParamValue, MinPitchParamValue, MaxPitchParamValue, MinMidiPitch, MaxMidiPitch);
    
    println("Pre-normalized param value: " + PitchParamValue);
    println();
    //println("post-normalized pitch: " + midiPitch);

    int velocity = (VelocityParamName==null || VelocityParamValue < 0 ) ? MinVelocity : normalizeToRange(VelocityParamValue, MinVelocityParamValue, MaxVelocityParamValue, MinVelocity, MaxVelocity);
    int duration = (DurationParamName==null || DurationParamValue < 0 ) ? MinDuration : normalizeToRange(DurationParamValue, MinDurationParamValue, MaxDurationParamValue, MinDuration, MaxDuration);  

    MidiNote mn = new MidiNote(midiPitch, velocity, duration);  
    mn.Play(_midiBus);

    _trackActiveNotes(mn);

    //println (PitchParamName + " = " + PitchParamValue);
    //println ("MidiPitch: " + midiPitch);

    // Stats to help determine range of paramvalues for scaling (for setting MinPitchParamValue, MaxPitchParamValue, etc.)
    if (PitchParamValue > _highParamValue)
      _highParamValue = PitchParamValue;

    if (PitchParamValue < _lowParamValue)
      _lowParamValue = PitchParamValue;

    //myBus.sendControllerChange(channel, number, value); // Send a controllerChange
  }

  void OutputStats()
  {
    println("Use these high and low values to determine MinPitchParamValue, MaxPitchParamValue.");
    println("Low Param: " + _lowParamValue);  
    println("High Param: " + _highParamValue);
    println();
  }

  void StopAllNotes()
  {
    for (MidiNote mn : _activeNotes)
    { //<>//
      if (mn != null)
        mn.Stop(_midiBus);
    }
  }

  void _trackActiveNotes(MidiNote midiNote)
  {
    if (_lastNoteStartMilliseconds == -1)
      _lastNoteStartMilliseconds = millis();
    else
      _lastNoteStartMilliseconds = _lastNoteStartMilliseconds + MetronomeRate; // need this to correct lag due to code run time.

    int len= _activeNotes.length;
    for (int i=0; i < len; i++)
    {
      if (_activeNotes[i] == null)
      {
        _activeNotes[i] = midiNote;
        break;
      }
    }
  }

  class MidiNote // ?? change implementation to inheritance of MidiBus/Note
  {
    int MidiPitch = -1;
    int Duration = -1;
    int Velocity = -1;  
    int _startMilliseconds = -1;
    int _stopMilliseconds = -1;
    Note _midiBusNote = null;

    MidiNote(int midiPitch, int velocity, int duration)
    {
      MidiPitch = _midiPitchQuantizer.QuantizeMidiPitchToScale(midiPitch);

      println("pre-quantized midi pitch: " + midiPitch);
      println("post-quantized midi pitch: " + MidiPitch);
      println();
      Duration = duration;
      Velocity = velocity;    

      _midiBusNote = new Note(1, MidiPitch, Velocity, Duration);
    }

    void Play(MidiBus mBus)
    {
      println("Playing midi note " + _midiBusNote.pitch + "");
      println("Volume: " + _midiBusNote.velocity + ", Duration: " + _midiBusNote.ticks);
      println();
      _startMilliseconds = millis();
      _stopMilliseconds = _startMilliseconds + Duration;
      mBus.sendNoteOn(_midiBusNote);
    }

    void Stop(MidiBus mBus)
    {
      //println("Stopping midi note " + _midiBusNote.pitch());
      mBus.sendNoteOff(_midiBusNote);
      _startMilliseconds = -1;
      _stopMilliseconds = -1;
    }

    boolean IsItTimeToStop()
    {

      boolean rtn = false;
      if (millis() >= _stopMilliseconds)
        rtn = true;

      //println("IsItTimeToStop? = " + rtn);
      return rtn;
    }
  }
}  

float normalizeToRange(float param, float lowParam, float highParam, float lowRange, float highRange)
{
  float rtn = param;

  float pctPlaceInRange  = (param  - lowParam)/ (highParam - lowParam);
  rtn = ((highRange - lowRange) * pctPlaceInRange) + lowRange;

  return rtn;
}

int normalizeToRange(float param, float lowParam, float highParam, int lowRange, int highRange)
{
  float rtn = param;
  //map(value, low, high, 0, 1).
  float pctPlaceInRange  = (param  - lowParam)/ (highParam - lowParam); 
  rtn = ((highRange - lowRange) * pctPlaceInRange) + lowRange;

  return round(rtn);
}

 
//void logNoteOn(int channel, int pitch, int velocity) {
//  // Receive a noteOn
//  println();
//  println("Note On:");
//  println("--------");
//  println("Channel:"+channel);
//  println("Pitch:"+pitch);
//  println("Velocity:"+velocity);
//}

//void logNoteOff(int channel, int pitch, int velocity) {
//  // Receive a noteOff
//  println();
//  println("Note Off:");
//  println("--------");
//  println("Channel:"+channel);
//  println("Pitch:"+pitch);
//  println("Velocity:"+velocity);
//}

//void logControllerChange(int channel, int number, int value) {
//  // Receive a controllerChange
//  println();
//  println("Controller Change:");
//  println("--------");
//  println("Channel:"+channel);
//  println("Number:"+number);
//  println("Value:"+value);
//}

//void delay(int time) {
//  int current = millis();
//  while (millis () < current+time) Thread.yield();
//}
