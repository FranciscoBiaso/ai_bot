class Timer{
   private:
      uint _time;
   public:
      Timer();
      void reset();      
      uint elapsed_mil();
};

Timer::Timer()
{
}

void Timer::reset()
{
   _time = GetTickCount();
}

uint Timer::elapsed_mil()
{
   return GetTickCount() - _time;
}