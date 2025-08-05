int numbOfVoices = 1;  //<>// //<>//

Equation[] equations = null;
MusicTrack[] tracks = null;

Equation bassEquation = null;
MusicTrack bassTrack = null;

void setup()
{
  // Creating the output window
  // and setting up the OPENGL renderer
  size(1080, 720, P3D);
  
  // Initialization - values from film
  float xInit = -6.744375, yInit = -22.852297, zInit = 30.003975;
  float sigma = 10.0, rho = 28.0, beta = 8.0 / 3.0;

  equations = new Equation[numbOfVoices];
  tracks = new MusicTrack[numbOfVoices];

  // piano
  int i = 0;
  xInit = .01;
  yInit = 0.0;
  zInit = 0.0;
  String dawInput = "DP Input " + (i+1);

  // Declaration for reference
  //MusicTrack(String name, String midiOutput, int metronomeRate, 
  //  String pitchParamName, int minMidiPitch, int maxMidiPitch, 
  //  float minPitchParamValue, float maxPitchParamValue, 
  //  String durationParamName, int minDuration, int maxDuration, 
  //  float minDurationParamValue, float maxDurationParamValue,
  //  String velocityParamName, int minVelocity, int maxVelocity, 
  //  float minVelocityParamValue, float maxVelocityParamValue
  //  )
 
  tracks[i] = new MusicTrack("Lorenz " + i, dawInput, 150, "MidiPitch", 72, 96, 0, 57, "Duration", 140, 144, 6, 42, "Velocity", 75, 95, 6, 55); 
  equations[i] = new Equation(xInit, yInit, zInit, sigma, rho, beta, .01); 
  tracks[i].AssignScale(new int[]{0, 2, 4, 5, 7, 9, 11}); // C Major

  //// cello
  //i = 1; 
  //xInit = .01;
  //yInit = 0.0;
  //zInit = 0.0;
  //dawInput = "DP Input " + (i+1);

  //tracks[i] = new MusicTrack("Lorenz " + i, dawInput, 600, "MidiPitch", 43, 60, 51, 0, "Duration", 575, 587, .6, 45, "Velocity", 74, 100, 6, 55);
  //equations[i] = new Equation(xInit, yInit, zInit, constA, constB, constC, .01); 
  //tracks[i].AssignScale(new int[]{0, 4, 7, 11}); //CMaj7
  
  //// synths
  //i = 2;
  //xInit = .010002;
  //yInit = 0.0;
  //zInit = 0.0;
  //dawInput = "DP Input " + (i+1);

  //tracks[i] = new MusicTrack("Lorenz " + i, dawInput, 150, "MidiPitch", 76, 84, 9, 48, "Duration", 140, 144, 6, 42, "Velocity", 75, 95, 6, 55);
  //equations[i] = new Equation(xInit, yInit, zInit, constA, constB, constC, .01);  
  //tracks[i].AssignScale(new int[]{0, 2, 4, 5, 7, 9, 11}); // C Major

  //i = 3;
  //xInit = .010003;
  //yInit = 0.0;
  //zInit = 0.0;
  //dawInput = "DP Input " + (i+1);

  //tracks[i] = new MusicTrack("Lorenz " + i, dawInput, 150, "MidiPitch", 71, 84, 9, 48, "Duration", 140, 144, 6, 42, "Velocity", 75, 95, 6, 55); 
  //equations[i] = new Equation(xInit, yInit, zInit, constA, constB, constC, .01);  
  //tracks[i].AssignScale(new int[]{0, 2, 4, 5, 7, 9, 11}); // C Major

  //i = 4;
  //xInit = .010004;
  //yInit = 0.0;
  //zInit = 0.0;
  //dawInput = "DP Input " + (i+1);

  //tracks[i] = new MusicTrack("Lorenz " + i, dawInput, 150, "MidiPitch", 60, 72, 9, 48, "Duration", 140, 144, 6, 42, "Velocity", 75, 95, 6, 55); 
  //equations[i] = new Equation(xInit, yInit, zInit, constA, constB, constC, .01);   
  //tracks[i].AssignScale(new int[]{0, 2, 4, 5, 7, 9, 11}); // C Major

  //i = 5;
  //xInit = .010005;
  //yInit = 0.0;
  //zInit = 0.0;
  //dawInput = "DP Input " + (i+1);

  //tracks[i] = new MusicTrack("Lorenz " + i, dawInput, 150, "MidiPitch", 52, 64, 9, 48, "Duration", 140, 144, 6, 42, "Velocity", 95, 75  , 6, 55); 
  //equations[i] = new Equation(xInit, yInit, zInit, constA, constB, constC, .01);   
  //tracks[i].AssignScale(new int[]{0, 2, 4, 5, 7, 9, 11}); // C Major

}    

void draw()
{
  background(0);

  for (int i=0; i<numbOfVoices; i++) {
    Equation eq = equations[i];
    MusicTrack tr = tracks[i];

    //println("preCompute: x:y:z:dist =" + eq.X + ":" + eq.Y + ":" + eq.Z + ": ");
    eq.Compute();
    float dist = eq.ComputeDistance(0, 0, 0);
    //println("x:y:z:dist =" + eq.X + ":" + eq.Y + ":" + eq.Z + ": " + dist);

    tr.Process(dist, dist, dist);
  }  
}

void keyPressed() {
  for (MusicTrack tr : tracks)
  {
    tr.OutputStats();
    tr.StopAllNotes();
  }

  //bassTrack.StopAllNotes();
  //bassTrack.OutputStats();

  this.exit();
}
