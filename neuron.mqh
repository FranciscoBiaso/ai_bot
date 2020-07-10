
class Neuron{
   private:      
      double _weights[];
      double _inputs[];
      double _out;
      double _max;
      double _min;
   public:
      Neuron();
      Neuron(double & weights[]);
      void update_inputs(double & inputs[]);
      void update_weights(double & weights[]);
      void calculate();
      double get_out() const;
      void set_input(int index, double value);
      void update_max_min();
      void normalize();
};