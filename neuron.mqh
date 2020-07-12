template <typename T>
class Neuron{
   //private:      
   public:
      double _weights[];
      T _inputs[];
      double _normalized_inputs[];
      double _out;
      T _max;
      T _min;
      double _net_factor;
   public:
      Neuron(){}
      Neuron(double & weights[])
      {
         _net_factor = 0.4;
         ArrayResize(_inputs, ArraySize(weights));
         ArrayResize(_normalized_inputs, ArraySize(weights));
         update_weights(weights);
      }
      void set_net_factor(double f){ _net_factor = f;}
      void update_inputs(T & inputs[])
      {      
         ArrayResize(_inputs, ArraySize(inputs));
         for(int i=0;i<ArraySize(inputs);i++)
            set_input(i,inputs[i]);   
            
         update_max_min();
         normalize(); 
      }
      void update_weights(double & weights[])
      {
         ArrayResize(_weights, ArraySize(weights));
         for(int i=0;i<ArraySize(weights);i++)
            _weights[i] = weights[i];
      }
      void calculate()
      {
         double NET=0.0;
         for(int i=0;i<ArraySize(_weights);i++)
            NET+= _normalized_inputs[i]*_weights[i];
            NET*= _net_factor;
         //--- multiply the weighted sum of inputs by the additional coefficient         
         //--- send the weighted sum of inputs to the activation function and return its value
         _out =1/(1+exp(-NET));   
      }
      double get_out() const
      {
         return _out;
      }
      void set_input(int index, T value)
      {
         _inputs[index] = value;
      }
      void update_max_min()
      {      
         _min = _inputs[ArrayMinimum(_inputs)];
         _max = _inputs[ArrayMaximum(_inputs)];
      }
      void normalize()
      {
         for(int i=0;i<ArraySize(_inputs);i++)
            _normalized_inputs[i] = (double)(_inputs[i]-_min)/(_max-_min);
      }
      
      int getInputSize(){ return ArraySize(_inputs); }
};