#include "trader.mqh"

Trader::Trader(string symbol)
{
   _trade.SetTypeFilling(ORDER_FILLING_RETURN);
   _symbol = symbol;
   _lot=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MIN);
}

bool Trader::has_position()
{
   return PositionSelect(_symbol);
}

ENUM_POSITION_TYPE Trader::get_position_type()
{
   return _position.PositionType();
}
      
void Trader::close_all_positions()
{
   _trade.PositionClose(_symbol);
}

void Trader::trade(TradeType tradeType, int sl, int tp)
{
   if(tradeType == TradeType::TRADE_BUY)
      _trade.Buy(_lot,_symbol,0.0,_mql_tick.ask - sl * _tick_size, _mql_tick.ask + tp * _tick_size);
   else if(tradeType == TradeType::TRADE_SELL)
      _trade.Sell(_lot,_symbol,0.0,_mql_tick.bid + sl * _tick_size, _mql_tick.bid - tp * _tick_size);
}      

void Trader::update_mql_tick()
{
   SymbolInfoTick(Symbol(),_mql_tick);
}

void Trader::update_tick_size()
{
   _tick_size = SymbolInfoDouble(Symbol(),SYMBOL_TRADE_TICK_SIZE);   
}

void Trader::start()
{
   update_tick_size();
}


double Trader::get_lot() const
{
   return _lot;
}