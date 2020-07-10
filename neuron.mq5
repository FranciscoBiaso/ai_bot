#include "neuron.mqh"


Neuron::Neuron(double & weights[])
{
   ArrayResize(_inputs, ArraySize(weights));
   update_weights(weights);
}

Neuron::Neuron()
{}

void Neuron::update_inputs(double & inputs[])
{

   ArrayResize(_inputs, ArraySize(inputs));
   for(int i=0;i<ArraySize(inputs);i++)
      set_input(i,inputs[i]);   
      
   update_max_min();
   normalize();  
}

void Neuron::update_max_min(void)
{
   _min = _inputs[ArrayMinimum(_inputs)];
   _max = _inputs[ArrayMaximum(_inputs)];
}

void Neuron::update_weights(double & weights[])
{
   ArrayResize(_weights, ArraySize(weights));
   for(int i=0;i<ArraySize(weights);i++)
      _weights[i] = weights[i];
}

void Neuron::normalize()
{
   //(((iRSI_buf[2]-x_min)*(d2-d1))/(x_max-x_min))+d1;
   
   for(int i=0;i<ArraySize(_inputs);i++)
      _inputs[i] = (_inputs[i]-_min)/(_max-_min);
}

void Neuron::calculate()
{
   double NET=0.0;
   for(int i=0;i<ArraySize(_weights);i++)
      NET+=_inputs[i]*_weights[i];
     
   //--- multiply the weighted sum of inputs by the additional coefficient
   NET*=0.4;
   //--- send the weighted sum of inputs to the activation function and return its value
   _out =1/(1+exp(-NET));   
}

double Neuron::get_out() const
{
   return _out;
}

void Neuron::set_input(int index, double value)
{
   _inputs[index] = value;
}

      