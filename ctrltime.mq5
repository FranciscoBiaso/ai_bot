#include "ctrltime.mqh"

CtrlTime::CtrlTime()
{}

void CtrlTime::set_time(string start_trade,string end_trade,string finish_ea)
{
   string times[];
   StringSplit(start_trade,':',times);
   _hour_start_trade = (int)StringToInteger(times[0]);
   _min_start_trade = (int)StringToInteger(times[1]);
   
   StringSplit(end_trade,':',times);
   _hour_end_trade = (int)StringToInteger(times[0]);
   _min_end_trade = (int)StringToInteger(times[1]);
   
   StringSplit(finish_ea,':',times);
   _hour_end_ea = (int)StringToInteger(times[0]);
   _min_end_ea = (int)StringToInteger(times[1]);
}

bool CtrlTime::is_time_to_trade(void)
{
   return ((_datetime.hour == _hour_start_trade && _datetime.min >= _min_start_trade) || (_datetime.hour > _hour_start_trade)) && 
          ((_datetime.hour == _hour_end_trade && _datetime.min <= _min_end_trade) || (_datetime.hour < _hour_end_trade));
}

void CtrlTime::update_datetime(void)
{
   TimeToStruct(TimeCurrent(),_datetime); 
}

bool CtrlTime::is_time_to_end_EA(void)
{
   return _datetime.hour == _hour_end_ea && _datetime.min >= _min_end_ea;
}

bool CtrlTime::on_candle_close(datetime & dt)
{
   CopyTime(Symbol(),Period(),0,1,_time);  
   if(_time[0] != dt)
   {
      dt = _time[0];
      return true;
   }
   else
      return false;
}