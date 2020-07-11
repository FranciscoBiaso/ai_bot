double weights1[] = {-0.73,0.83,0.63,0.40,-0.59,0.09,-0.61,-0.25,-0.22,-1.00}; //rsi
double weights2[] = {0.03,0.90,0.63,-0.91,-1.00,0.60,-0.29,-0.34,0.10,-0.33}; // ma
double weights3[] = {-0.93,-0.71,-0.34,-0.28,0.18,-0.40,0.85,0.10,0.86,-0.53}; //_PRICE_CLOSE
double weights4[] = {-0.5,-1.0,-0.2,-0.6,-0.5,0.4,-0.4,0.9,0.8,0.0}; //_PRICE_OPEN
double weights5[] = {-0.9,-0.6,-0.2,-0.7,0.5,-0.9,0.5,0.5,0.9,-0.6}; //_PRICE_LOW
double weights6[] = {-0.7,-0.7,-0.6,-0.9,-0.1,0.4,-0.1,0.3,0.7,0.3}; //_PRICE_HIGH
double weights7[] = {1.0,-0.9,-0.1,0.4,0.4,1.0,0.6,0.7,0.4,-0.6}; // SL //
double weights8[] = {-1.0,-0.9,-0.9,0.2,-1.0,-1.0,-1.0,-1.0,-1.0,0.6}; // TP //
double weights9[] = {0.80,-0.31,0.02,-0.01,-0.07,0.83,-0.22}; // MASTER //
double weights10[] = {-1.00,-1.0,-0.50,0.40,0.2,1.0,-1.00,-1.00,-0.6,-0.10};  // volume //
double weights11[] = {0.2,0.0,0.3,1.0,0.6,0.1,0.4,0.7,1.0,1.0};  // trailling stop //

double weights_close[] = {-0.35,0.41,-0.36,-0.42,-0.41,-0.77,-0.64,-0.42,-0.53,0.05,0.21,0.77,0.96,0.84,-0.64};

#define COUNT_INPUTS 15
#define COUNT_NEURONS 10

enum Neurons{
   _RSI = 0,
   _MA,
   _PRICE_CLOSE,
   _PRICE_OPEN,
   _PRICE_LOW,
   _PRICE_HIGH,
   //_VOLUME,
   _SL,
   _TP,
   _TraillingStop_distance,
   // \/ master
   _MASTER
};

/*
//--- weight values
input double w0=0.5;
input double w1=0.5;
input double w2=0.5;
input double w3=0.5;
input double w4=0.5;
input double w5=0.5;
input double w6=0.5;
input double w7=0.5;
input double w8=0.5;
input double w9=0.5;
*/