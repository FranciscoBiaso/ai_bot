#include <Trade\Trade.mqh>        
#include <Trade\PositionInfo.mqh>
  
class Trader{
   enum TradeType{
      TRADE_BUY,
      TRADE_SELL
   };

   private:      
      CTrade _trade;      // entity for execution of trades
      CPositionInfo _position;   // entity for obtaining information on positions
      MqlTick _mql_tick;
      double _tick_size;
      double _lot;
      string _symbol;
      bool _has_activated_trailling_start;
   public:
      Trader();
      bool has_position();
      ENUM_POSITION_TYPE get_position_type();
      void close_all_positions();
      void trade(TradeType tradeType, int sl, int tp);
      void update_mql_tick();
      void update_tick_size();      
      void start(string symbol);
      void update_trailling_stop_start(int trailling_start);
      double get_lot() const;
      
      double bid();
      double ask();
      double tick();
      double price_open();
      double stop_loss();
      double take_profit();
      void update_position(double sl, double tp);
      void reset_trailling_start();
};
