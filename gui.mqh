//+------------------------------------------------------------------+
//|                                                      Program.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include <EasyAndFastGUI\Controls\WndEvents.mqh>
//+------------------------------------------------------------------+
//| Class for creating an application                                |
//+------------------------------------------------------------------+
class GUI : public CWndEvents
  {
private:
   //--- Window
   CWindow           m_window;
   CLabel            m_label;
   //---
public:
                     GUI(void);
                    ~GUI(void);
   //--- Initialization/uninitialization
   void              OnInitEvent(void);
   void              OnDeinitEvent(const int reason);
   //--- Timer
   void              OnTimerEvent(void);
   //---
protected:
   //--- Chart event handler
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //---
public:
   //--- Creates a trading panel
   bool              CreateTradePanel(void);
   //---
private:
   bool              CreateWindow(const string text);
  };