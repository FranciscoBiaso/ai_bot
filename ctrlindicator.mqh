class CtrlIndicator{
   private:
      int   _iRSI_handle;  // variable for storing the indicator handle
      int   _iMA_handle1;  
      int   _iMA_handle2;  
      double   _iRSI_buf[];   // dynamic array for storing indicator values
      double   _iMA_buf1[];   
      double   _iMA_buf2[]; 
      long _real_volume[];
      MqlRates _rates[];
      int _err_code;
   public:
      CtrlIndicator();
      bool start();
      void end();
      bool update();
      
      double getRSI(int index) const;
      double getMA1(int index) const;
      double getMA2(int index) const;
      long getVolume(int index) const;
      MqlRates CtrlIndicator::getRates(int index) const;     
};