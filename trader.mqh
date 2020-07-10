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
   public:
      Trader(string symbol);
      bool has_position();
      ENUM_POSITION_TYPE get_position_type();
      void close_all_positions();
      void trade(TradeType tradeType, int sl, int tp);
      void update_mql_tick();
      void update_tick_size();      
      void start();
      double get_lot() const;
};
