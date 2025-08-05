class Equation
{
  float X, Y, Z;
  float _sigma, _rho, _beta;
  float _dt;

  Equation (float initialX, float initialY, float initialZ, float sigma, float rho, float beta, float deltaTime)
  {
    X = initialX; 
    Y = initialY;
    Z = initialZ;
    _sigma = sigma;
    _rho =  rho;
    _beta = beta;
    _dt = deltaTime;
  }

  void Compute()
  {
    // Implementation of the differential equations 
    float dx = (_sigma * (Y - X)) * _dt; //<>// //<>//
    float dy = (X * (_rho - Z) - Y) * _dt;
    float dz = (X * Y - _beta * Z) * _dt;
    X += dx;
    Y += dy;
    Z += dz;
    
    //println("dx = " + dx + "  X = " + X);
    //println("dy = " + dy + "  Y = " + Y);
    //println("dz = " + dz + "  Z = " + Z);
    //println("");
  }

  float ComputeDistance(float fixedX, float fixedY, float fixedZ)
  {
    float rtn = sqrt(pow(X - fixedX, 2) + pow(Y - fixedY, 2) + pow(Z - fixedZ, 2));
    
    //if (Z < fixedZ)
    //  rtn = -rtn;
      
    return rtn;
  }
}
