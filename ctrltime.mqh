class CtrlTime {
   private:
      int _hour_start_trade;
      int _min_start_trade;
      int _hour_end_trade;
      int _min_end_trade;
      int _hour_end_ea;
      int _min_end_ea;
      MqlDateTime _datetime;
      datetime _time[];
   public:
      CtrlTime();
      void set_time(string start_trade,string end_trade,string finish_ea);
      bool is_time_to_trade();
      bool is_time_to_end_EA();
      void update_datetime();
      bool on_candle_close(datetime&);
};