#include "trader.mqh"

Trader::Trader()
{
   reset_trailling_start();
   _trainlling_stop_distance_ticks = 0;
}

bool Trader::has_position()
{
   return PositionSelect(_symbol);
}

double Trader::bid(void)
{
   return _mql_tick.bid;
}

double Trader::ask(void)
{
   return _mql_tick.ask;
}

double Trader::tick(void)
{
   return _tick_size;
}

double Trader::price_open()
{
   return _position.PriceOpen();
}

double Trader::stop_loss()
{
   return _position.StopLoss();
}

double Trader::take_profit()
{
   return _position.TakeProfit();
}

void Trader::update_position(double sl, double tp)
{
   _trade.PositionModify(_symbol,sl,tp);
}

ENUM_POSITION_TYPE Trader::get_position_type()
{
   return _position.PositionType();
}
      
void Trader::close_all_positions()
{
   _trade.PositionClose(_symbol);
}

void Trader::set_trailling(int ts)
{
   _trainlling_stop_distance_ticks = ts;
}

void Trader::trade(TradeType tradeType, int sl, int tp, int ts)
{
   set_trailling(ts);
   
   double stop_loss;
   double take_profit;
   if(tradeType == TradeType::TRADE_BUY)
   {
      if(sl != 0) stop_loss = _mql_tick.ask - sl * _tick_size;
      if(tp != 0) take_profit = _mql_tick.ask + tp * _tick_size;      
      _trade.Buy(_lot,_symbol,0.0,stop_loss,take_profit);
   }
   else if(tradeType == TradeType::TRADE_SELL)
   {
      if(sl != 0) stop_loss = _mql_tick.bid + sl * _tick_size;
      if(tp != 0) take_profit = _mql_tick.bid - tp * _tick_size; 
      _trade.Sell(_lot,_symbol,0.0,stop_loss,take_profit);
   }
      
   reset_trailling_start();
}      

void Trader::update_mql_tick()
{
   SymbolInfoTick(Symbol(),_mql_tick);
}

void Trader::update_tick_size()
{
   _tick_size = SymbolInfoDouble(Symbol(),SYMBOL_TRADE_TICK_SIZE);   
}

void Trader::start(string symbol)
{
   _trade.SetTypeFilling(ORDER_FILLING_RETURN);  
   _lot=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MIN);
   _symbol = symbol;
   update_tick_size();
}


double Trader::get_lot() const
{
   return _lot;
}

void Trader::reset_trailling_start()
{
   _has_activated_trailling_start = false;
}

void Trader::update_trailling_stop_start(int trailling_start)
{
   if(_has_activated_trailling_start)
      return;
   
   if(get_position_type() == POSITION_TYPE_BUY)
   {
      double target = price_open() + trailling_start * tick();
      if(bid() >= target && stop_loss() < target)
      {
         update_position(target,take_profit());
         _has_activated_trailling_start = true;
      }
   }
   else if(get_position_type() == POSITION_TYPE_SELL)
   {
      double target = price_open() - trailling_start * tick();
      if(ask() <= target && stop_loss() > target)
      {
         update_position(target,take_profit());
         _has_activated_trailling_start = true;
      }
   }
}

void Trader::update_trailling_stop()
{
   if(_trainlling_stop_distance_ticks == 0)
      return ;

   if(get_position_type() == POSITION_TYPE_BUY)
   {
      double target = bid() - _trainlling_stop_distance_ticks * tick();
      if(stop_loss() < target)
      {
         update_position(target,take_profit());
         _has_activated_trailling_start = true;
      }
   }
   else if(get_position_type() == POSITION_TYPE_SELL)
   {
      double target = ask() + _trainlling_stop_distance_ticks * tick();
      if(stop_loss() > target)
      {
         update_position(target,take_profit());
         _has_activated_trailling_start = true;
      }
   }
}
      