//+------------------------------------------------------------------+
//|                                                   NeuNet Bot.mq5 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2012, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include "neuron.mqh"
#include "trader.mqh"
#include "ctrltime.mqh"
#include "definitions.mqh"
#include "ctrlindicator.mqh"
#include "_socket.mqh"
#include "gui.mqh"
#include "timer.mqh"

_Socket g_socket("localhost",23456);
_GUI g_gui(GetPointer(g_socket));


Trader trader();
CtrlTime ctrl_time();
CtrlIndicator ctrl_indicator();

Neuron<double> neuron_decision(weights_close);
Neuron<double> neuron_target_tp(weights_take_profit);
Neuron<double> neuron_target_sl(weights_stop_loss);
Neuron<double> neuron_target_break_even(weights_break_even);
Neuron<double> neuron_target_trailling_stop(weights_trailling);

input string §_Horários_§ = "§_Horários_§";
input string in_initialTimeToOpenPositions = "09:05"; //Tempo inicial para abrir posições (hh:mm)
input string in_EndTimeToOpenPositions = "17:05"; // Tempo final para abrir posições (hh:mm)
input string in_timeToClosePositions = "17:30"; // Tempo para fechar posições (hh:mm)

int OnInit()
{    
   if(!g_gui.Create(0,"AI BOT - versão 1.0",0,20,20,GUI_MAIN_WINDOW_LOGIN_WIDTH,GUI_MAIN_WINDOW_LOGIN_HEIGHT))
      return(INIT_FAILED);
//--- run application
   g_gui.Run();
        
   TesterHideIndicators(true);
   trader.start(Symbol());
   if(!ctrl_indicator.start())
   {   
      Print("Failed to get the indicator handle");
      return(-1);
   }
   ctrl_time.set_time(in_initialTimeToOpenPositions,in_EndTimeToOpenPositions,in_timeToClosePositions);    
   

   EventSetMillisecondTimer(1);
   return(0);
}
 

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{ 
   // update indicators data //
   if(!ctrl_indicator.update())
      return;
   // update mql tick //
   trader.update_mql_tick();
   
   // update inputs //
   for(int i=0;i<COUNT_INPUTS;i++)   
   {
      neuron_decision.set_input(i, ctrl_indicator.getRates(i).close);
   }  
   
   for(int i=0;i<neuron_target_tp.getInputSize();i++)  
      neuron_target_tp.set_input(i, ctrl_indicator.getRates(i).close);      
   
   for(int i=0;i<neuron_target_sl.getInputSize();i++)  
      neuron_target_sl.set_input(i, ctrl_indicator.getRates(i).close);
      
   for(int i=0;i<neuron_target_break_even.getInputSize();i++)   
      neuron_target_break_even.set_input(i, ctrl_indicator.getRates(i).close);
      
      
   for(int i=0;i<neuron_target_trailling_stop.getInputSize();i++)   
      neuron_target_trailling_stop.set_input(i, ctrl_indicator.getRates(i).close);
     
   neuron_decision.update_max_min();
   neuron_decision.normalize();
   neuron_decision.calculate();
   
   neuron_target_tp.update_max_min();
   neuron_target_tp.normalize();
   neuron_target_tp.calculate();
   
   neuron_target_sl.update_max_min();
   neuron_target_sl.normalize();
   neuron_target_sl.calculate();
   
   neuron_target_break_even.update_max_min();
   neuron_target_break_even.normalize();
   neuron_target_break_even.calculate();
   
   neuron_target_trailling_stop.update_max_min();
   neuron_target_trailling_stop.normalize();
   neuron_target_trailling_stop.calculate();
   
   int sl = neuron_target_sl.get_out()/0.5 * 300/trader.tick();   
   int tp = neuron_target_tp.get_out()/0.5 * 300/trader.tick();   
   int be = neuron_target_break_even.get_out()/0.5 * 150/trader.tick();
   int ts = neuron_target_trailling_stop.get_out()/0.5 * 150/trader.tick();
   // update time //
   ctrl_time.update_datetime();
   
   // Is time to close EA ? //
   if(ctrl_time.is_time_to_end_EA() && trader.has_position())
      trader.close_all_positions();
      
   // ON CANDLE CLOSE //
   static datetime dt = 0;      
   if(!ctrl_time.on_candle_close(dt)) return;
   
   if(trader.has_position())
   {
      trader.update_trailling_stop_start(be);   
      trader.update_trailling_stop();   
   }
   
   // Conditions //              
   if(neuron_decision.get_out()<0.5)
   {
      if(trader.has_position())
      {
         if(trader.get_position_type()==POSITION_TYPE_SELL) trader.close_all_positions();
         else if(trader.get_position_type()==POSITION_TYPE_BUY) return;
      }
      if(ctrl_time.is_time_to_trade())
         trader.trade(Trader::TradeType::TRADE_BUY,sl,tp,ts);
   }     
   else
   {
      if(trader.has_position())
      {
         if(trader.get_position_type()==POSITION_TYPE_BUY) trader.close_all_positions();         
         else if(trader.get_position_type()==POSITION_TYPE_SELL) return;
      }
      if(ctrl_time.is_time_to_trade())
         trader.trade(Trader::TradeType::TRADE_SELL,sl,tp,ts);
   }
}

void OnDeinit(const int reason)
{
   ctrl_indicator.end();
   g_gui.Destroy(reason);
}

void OnChartEvent(const int    id,
                  const long   &lparam,
                  const double &dparam,
                  const string &sparam)
{
   g_gui.ChartEvent(id,lparam,dparam,sparam);
}
//+------------------------------------------------------------------+

void OnTimer()
{
   g_gui.on_timer();
}