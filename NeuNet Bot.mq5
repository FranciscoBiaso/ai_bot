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

Trader trader();
CtrlTime ctrl_time();
CtrlIndicator ctrl_indicator();

Neuron<double> neuron_decision(weights_close);
Neuron<double> neuron_target_tp(weights_take_profit);
Neuron<double> neuron_target_sl(weights_stop_loss);
Neuron<double> neuron_target_break_even(weights_break_even);
Neuron<double> neuron_target_trailling_stop(weights_stop_loss);
input string §_Horários_§ = "§_Horários_§";
input string in_initialTimeToOpenPositions = "09:05"; //Tempo inicial para abrir posições (hh:mm)
input string in_EndTimeToOpenPositions = "17:05"; // Tempo final para abrir posições (hh:mm)
input string in_timeToClosePositions = "17:30"; // Tempo para fechar posições (hh:mm)
input int in_trailling_stop_start = 10; // 
input int in_trailling_stop_distance = 10; //

//--- weight values
input double w0=0.5;
input double w1=0.5;
input double w2=0.5;
input double w3=0.5;
input double w4=0.5;
input double w5=0.5;
input double w6=0.5;
input double w7=0.5;
input double w8=0.5;
input double w9=0.5;
input double w10=0.5;
input double w11=0.5;
input double w12=0.5;
input double w13=0.5;
input double w14=0.5;
input double net_factor = 0.1;

int OnInit()
{         
   trader.start(Symbol());
   
   if(!ctrl_indicator.start())
   {   
      Print("Failed to get the indicator handle");
      return(-1);
   }
   ctrl_time.set_time(in_initialTimeToOpenPositions,in_EndTimeToOpenPositions,in_timeToClosePositions);    
   
   //ChartIndicatorAdd(ChartID(),0,iRSI_handle);
   
   //EventSetTimer(1);
   double _w[10];
   _w[0]= w0;
   _w[1]= w1;
   _w[2]= w2;
   _w[3]= w3;
   _w[4]= w4;
   _w[5]= w5;
   _w[6]= w6;
   _w[7]= w7;
   _w[8]= w8;
   _w[9]= w9;
   neuron_target_trailling_stop.update_weights(_w);
   return(0);
  }
 
//void OnTimer(){}

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
}
  