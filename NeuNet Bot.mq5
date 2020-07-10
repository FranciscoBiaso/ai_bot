//+------------------------------------------------------------------+
//|                                                   NeuNet Bot.mq5 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

#property copyright "Copyright 2012, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
#include "neuron.mqh"
#include "trader.mqh"
#include "ctrltime.mqh"

#define COUNT_NEURONS 10
double weights1[] = {-0.9,0.7,0.8,1.0,0.1,-0.3,-0.8,0.0,-0.2,0.8};
double weights2[] = {0.8,0.4,-0.3,-0.5,-0.9,0.4,0.8,-0.9,0.1,0.4};
double weights3[] = {-0.8,0.1,0.4,-1.0,0.0,0.3,0.1,0.1,1.0,-0.8};
double weights4[] = {-0.5,-1.0,-0.2,-0.6,-0.5,0.4,-0.4,0.9,0.8,0.0};
double weights5[] = {-0.9,-0.6,-0.2,-0.7,0.5,-0.9,0.5,0.5,0.9,-0.6};
double weights6[] = {-0.7,-0.7,-0.6,-0.9,-0.1,0.4,-0.1,0.3,0.7,0.3};
double weights7[] = {0.7,0.0,0.6,0.8,-0.4,0.8,-0.2,0.4,0.8,-0.7};
double weights8[] = {0.6,1.0,0.6,0.1,-0.8,-0.1,0.6,0.7,0.7,0.2};
double weights9[] = {-1.0,-0.9,-0.9,0.2,-1.0,-1.0,-1.0,-1.0,-1.0,0.6};
double weights10[] = {0.80,-0.31,0.02,-0.01,-0.07,0.83,-0.22};

Neuron neurons[COUNT_NEURONS];

Trader trader(Symbol());
CtrlTime ctrl_time();

input string §_Horários_§ = "§_Horários_§";
input string in_initialTimeToOpenPositions = "09:05"; //Tempo inicial para abrir posições (hh:mm)
input string in_EndTimeToOpenPositions = "17:05"; // Tempo final para abrir posições (hh:mm)
input string in_timeToClosePositions = "17:30"; // Tempo para fechar posições (hh:mm)


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

double            weight[10];   // array for storing weights
int               iRSI_handle;  // variable for storing the indicator handle
int               iMA_handle1;  
int               iMA_handle2;  
double            iRSI_buf[];   // dynamic array for storing indicator values
double            iMA_buf1[];   
double            iMA_buf2[];   

long real_volumes[];
MqlRates g_rates[];
double tick_size;
MqlTick g_tick;

enum Neurons{
   _RSI = 0,
   _MA,
   _PRICE_CLOSE,
   _PRICE_OPEN,
   _PRICE_LOW,
   _PRICE_HIGH,
   _VOLUME,
   _SL,
   _TP,
   _MASTER
};

int OnInit()
{
   neurons[_RSI] = Neuron(weights1);
   neurons[_MA] = Neuron(weights2);
   neurons[_PRICE_CLOSE] = Neuron(weights3);
   neurons[_PRICE_OPEN] = Neuron(weights4);
   neurons[_PRICE_LOW] = Neuron(weights5);
   neurons[_PRICE_HIGH] = Neuron(weights6);
   neurons[_VOLUME] = Neuron(weights7);
   neurons[_SL] = Neuron(weights8);
   neurons[_TP] = Neuron(weights9);
   neurons[_MASTER] = Neuron(weights10);

   trader.start();
   ctrl_time.set_time(in_initialTimeToOpenPositions,in_EndTimeToOpenPositions,in_timeToClosePositions);    

   iRSI_handle=iRSI(Symbol(),Period(),14,PRICE_CLOSE);
   iMA_handle1 =iMA(Symbol(),Period(),8,0,MODE_SMA,PRICE_CLOSE);
   iMA_handle2 =iMA(Symbol(),Period(),21,0,MODE_SMA,PRICE_CLOSE);
   
   //--- check the availability of the indicator handle
   if(iRSI_handle==INVALID_HANDLE || iMA_handle1 == INVALID_HANDLE || iMA_handle2 == INVALID_HANDLE)
   {
      Print("Failed to get the indicator handle");
      return(-1);
   }
     
   //ChartIndicatorAdd(ChartID(),0,iRSI_handle);

   ArraySetAsSeries(iRSI_buf,true);
   ArraySetAsSeries(iMA_buf1,true);
   ArraySetAsSeries(iMA_buf2,true);
   
   //EventSetTimer(1);
   
   return(0);
  }
 
//void OnTimer(){}


//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{ 
   int err1=CopyBuffer(iRSI_handle,0,1,COUNT_NEURONS,iRSI_buf);            if(err1<0)return;
   err1 = CopyBuffer(iMA_handle1,0,1,COUNT_NEURONS,iMA_buf1);              if(err1<0)return;
   err1 = CopyBuffer(iMA_handle2,0,1,COUNT_NEURONS,iMA_buf2);              if(err1<0)return;
   err1 = CopyRates(Symbol(),Period(),1,COUNT_NEURONS,g_rates);            if(err1<0)return;
   err1 = CopyRealVolume(Symbol(),Period(),1,COUNT_NEURONS,real_volumes);  if(err1<0)return;
   
   trader.update_mql_tick();
   
   // update inputs //
   for(int i=0;i<COUNT_NEURONS;i++)   
   {
      neurons[Neurons::_TP].set_input(i, g_rates[i].close);
      neurons[Neurons::_SL].set_input(i, g_rates[i].close);
      neurons[Neurons::_RSI].set_input(i, iRSI_buf[i]); 
      neurons[Neurons::_PRICE_CLOSE].set_input(i, g_rates[i].close);
      neurons[Neurons::_PRICE_LOW].set_input(i, g_rates[i].low); 
      neurons[Neurons::_PRICE_HIGH].set_input(i, g_rates[i].high); 
      neurons[Neurons::_PRICE_OPEN].set_input(i, g_rates[i].open); 
      neurons[Neurons::_VOLUME].set_input(i, real_volumes[i]); 
      
      if(i < COUNT_NEURONS/2)
         neurons[Neurons::_MA].set_input(i, iMA_buf1[i]); 
      else
         neurons[Neurons::_MA].set_input(i, iMA_buf2[i]);
   }  
   for(int i=0;i<COUNT_NEURONS-1;i++)   
   {  
      neurons[i].update_max_min();
   }
   
   for(int i=0;i<COUNT_NEURONS-1;i++)   
   {  
      neurons[i].normalize();
   }   
       
   for(int i=0;i<COUNT_NEURONS-1;i++)   
   {
      neurons[i].calculate();
   }    
   
   double inputs[7];
   inputs[0] = neurons[Neurons::_RSI].get_out();
   inputs[1] = neurons[Neurons::_MA].get_out();
   inputs[2] = neurons[Neurons::_PRICE_CLOSE].get_out();
   inputs[3] = neurons[Neurons::_PRICE_OPEN].get_out();
   inputs[4] = neurons[Neurons::_PRICE_LOW].get_out();
   inputs[5] = neurons[Neurons::_PRICE_HIGH].get_out();
   inputs[6] = neurons[Neurons::_VOLUME].get_out();
   
   neurons[Neurons::_MASTER].update_inputs(inputs);
   neurons[Neurons::_MASTER].calculate();
   
   double out_neuron =  neurons[Neurons::_MASTER].get_out();
   double out_neuron_sl = neurons[Neurons::_SL].get_out();  
   double out_neuron_tp = neurons[Neurons::_TP].get_out();    
   int sl = (((int)(out_neuron_sl*100)) + 1.0);
   int tp = (((int)(out_neuron_tp*100)) + 1.0);
   
   
   // update time //
   ctrl_time.update_datetime();
   
   // Is time to close EA ? //
   if(ctrl_time.is_time_to_end_EA() && trader.has_position())
      trader.close_all_positions();
      
   // ON CANDLE CLOSE //
   static datetime dt = 0;      
   if(!ctrl_time.on_candle_close(dt)) return;
   
   // Conditions //              
   if(out_neuron<0.5)
   {
      if(trader.has_position())
      {
         if(trader.get_position_type()==POSITION_TYPE_SELL) trader.close_all_positions();
         else if(trader.get_position_type()==POSITION_TYPE_BUY) return;
      }
      if(ctrl_time.is_time_to_trade())
         trader.trade(Trader::TradeType::TRADE_BUY,sl,tp);
   }     
   if(out_neuron>=0.5)
   {
      if(trader.has_position())
      {
         if(trader.get_position_type()==POSITION_TYPE_BUY) trader.close_all_positions();         
         else if(trader.get_position_type()==POSITION_TYPE_SELL) return;
      }
      if(ctrl_time.is_time_to_trade())
         trader.trade(Trader::TradeType::TRADE_SELL,sl,tp);
   }
}


//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- delete the indicator handle and deallocate the memory space it occupies
   IndicatorRelease(iRSI_handle);
   IndicatorRelease(iMA_handle1);
   IndicatorRelease(iMA_handle2);
//--- free the iRSI_buf dynamic array of data
   ArrayFree(iRSI_buf);
   ArrayFree(iMA_buf1);
   ArrayFree(iMA_buf2);
  }
  