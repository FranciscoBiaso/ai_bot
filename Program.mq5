//+------------------------------------------------------------------+
//|                                                   MainWindow.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\server_off_1.bmp"
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\server_off_2.bmp"
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\server_off_3.bmp"
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\server_off_4.bmp"
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\server_on.bmp"
//---
#include "Program.mqh"
//+------------------------------------------------------------------+
//| Создаёт графический интерфейс программы                          |
//+------------------------------------------------------------------+
bool CProgram::CreateGUI(void)
  {
  int _margin_left = 10;  
  int _margin_top = 25;
  double corner_space = 20;
  int line_height = 8;
  double button_width = 0.25;
  
  
   if(!CWndCreate::CreateWindow(m_window,"AI TRADER ROBOT - v 1.00",5,20,310,105,true,false,true,true))
      return(false);
   
      
   string text_items[2];
   text_items[0]="whatszap: +55 (35) 9 9190-0230";
   text_items[1]="Disconnected...";
   int width_items[]={0,130};
   if(!CWndCreate::CreateStatusBar(m_status_bar,m_window,1,23,22,text_items,width_items))
      return(false);
  
   if(!CWndCreate::CreateTextEdit(m_text_edit_login,"Email: ",
                                  m_window,0,false,_margin_left,_margin_top,m_window.XSize() - m_window.XSize() * 0.15,(m_window.XSize() - m_window.XSize() * 0.15) * 0.8,""))
      return(false);
   m_text_edit_login.FontSize(11);   
   
   if(!CWndCreate::CreateButton(m_button_login,"login",m_window,0,m_window.XSize()/2 - (m_window.XSize() * button_width)/2 ,_margin_top + m_text_edit_login.YSize() + line_height,
                                  m_window.XSize() * button_width))
      return(false);
      
   CWndEvents::CompletedGUI();
  /*
//--- Создание формы для элементов управления
   if(!CWndCreate::CreateWindow(m_window,"EXPERT PANEL",1,1,518,600,true,true,true,true))
      return(false);
//--- Статусная строка
   string text_items[2];
   text_items[0]="For Help, press F1";
   text_items[1]="Disconnected...";
   int width_items[]={0,130};
   if(!CWndCreate::CreateStatusBar(m_status_bar,m_window,1,23,22,text_items,width_items))
      return(false);
   else
     {
      //--- Установка картинок
      int item_index=1;
      m_status_bar.GetItemPointer(item_index).LabelXGap(25);
      m_status_bar.GetItemPointer(item_index).AddImagesGroup(5,3);
      m_status_bar.GetItemPointer(item_index).AddImage(0,"Images\\EasyAndFastGUI\\Icons\\bmp16\\server_off_1.bmp");
      m_status_bar.GetItemPointer(item_index).AddImage(0,"Images\\EasyAndFastGUI\\Icons\\bmp16\\server_off_2.bmp");
      m_status_bar.GetItemPointer(item_index).AddImage(0,"Images\\EasyAndFastGUI\\Icons\\bmp16\\server_off_3.bmp");
      m_status_bar.GetItemPointer(item_index).AddImage(0,"Images\\EasyAndFastGUI\\Icons\\bmp16\\server_off_4.bmp");
     }
//--- Элементы управления графиком
   if(!CWndCreate::CreateTextEdit(m_a_inc,"a:",m_window,0,false,7,25,90,70,1000,1,0.01,2,2))
      return(false);
   if(!CWndCreate::CreateTextEdit(m_b_inc,"b:",m_window,0,false,7,50,90,70,1000,1,0.01,2,0))
      return(false);
   if(!CWndCreate::CreateTextEdit(m_t_inc,"t:",m_window,0,false,7,75,90,70,1000,1,0.01,2,1))
      return(false);
//--- Разделительная линия
   if(!CWndCreate::CreateSepLine(m_sep_line1,m_window,0,110,25,2,72,C'150,150,150',clrWhite,V_SEP_LINE))
      return(false);
   if(!CWndCreate::CreateSepLine(m_sep_line1,m_window,0,280,25,2,72,C'150,150,150',clrWhite,V_SEP_LINE))
      return(false);
//---
   if(!CWndCreate::CreateTextEdit(m_animate,"Animate:",m_window,0,true,125,25,140,70,1,0,0.01,2,0))
      return(false);
   if(!CWndCreate::CreateTextEdit(m_array_size,"Array size:",m_window,0,false,125,50,140,70,10000,3,1,0,100))
      return(false);
   if(!CWndCreate::CreateButton(m_random,"Random",m_window,0,125,75,140))
      return(false);
//---
   if(!CWndCreate::CreateCheckbox(m_line_smooth,"Line smooth",m_window,0,295,29,90,false,false,false))
      return(false);
//---
   string items1[]={"CURVE_POINTS","CURVE_LINES","CURVE_POINTS_AND_LINES","CURVE_STEPS","CURVE_HISTOGRAM"};
   if(!CWndCreate::CreateCombobox(m_curve_type,"Curve type:",m_window,0,false,295,50,215,150,items1,93,1))
      return(false);
   string items2[]=
     {
      "POINT_CIRCLE","POINT_SQUARE","POINT_DIAMOND","POINT_TRIANGLE","POINT_TRIANGLE_DOWN",
      "POINT_X_CROSS","POINT_PLUS","POINT_STAR","POINT_HORIZONTAL_DASH","POINT_VERTICAL_DASH"
     };
   if(!CWndCreate::CreateCombobox(m_point_type,"Point type:",m_window,0,false,295,75,215,150,items2,183,0))
      return(false);
//--- График
   if(!CreateGraph1(2,100))
      return(false);
//--- Завершение создания GUI
   CWndEvents::CompletedGUI();
   /*/
   return(true);
  }