#include "gui.mqh"
#include "gui_info_panel.mqh"
_GUI::_GUI(_Socket * socket) : m_socket(socket)
{
   _margin_left = 10;
   _margin_top = 10;
   _label_percentage_of_main_window_size = 1/3.0;
   _edit_percentage_of_main_window_size = 2/3.4;
   _button_percentage_of_main_window_size = 1/4.0;
   _label_fontsize = 9;
   _label_height = 21;
   _edit_fontsize = 10;
   _y_cursor = 0;
   _v_space = 10;   
   m_infopanel = new InfoPanel(GetPointer(this));
   _count_objects = 0;
   _label_font = "Consolas";
   
   
   
   // configure basic font //
   if(!TextSetFont(_label_font,-label_fontsize()*10))
      printf("fail to load font Consolas!");
}
_GUI::~_GUI(void)
{
   if(CheckPointer(m_infopanel) != POINTER_INVALID)
      delete m_infopanel;
   if(CheckPointer(m_socket) != POINTER_INVALID)
      delete m_socket;
}

int _GUI::label_width()
{
   return ClientAreaWidth() * _label_percentage_of_main_window_size;
}

int _GUI::label_height()
{
   return _label_height;
}

int _GUI::label_fontsize()
{
   return _label_fontsize;
}

int _GUI::margin_left()
{
   return _margin_left;
}

int _GUI::margin_top()
{
   return _margin_top;
}

int _GUI::center()
{
   return ClientAreaWidth()/2;
}


int _GUI::center_by_3()
{
   return ClientAreaWidth()/3;   
}
      
int _GUI::edit_fontsize()
{
   return _edit_fontsize;
}

int _GUI::get_edit_width()
{
   return ClientAreaWidth() * _edit_percentage_of_main_window_size;
}

int _GUI::get_ycursor()
{
   return _y_cursor;
}

int _GUI::get_vspace()
{
   return _v_space;
}

void _GUI::inc_ycursor(int value)
{
   _y_cursor += value;
}

int _GUI::get_button_width()
{   
   return Width() * _button_percentage_of_main_window_size;
}

int _GUI::get_client_area_height(void)
{
   return ClientAreaHeight();
}

int _GUI::get_client_area_width(void)
{
   return ClientAreaWidth();
}

string _GUI::get_label_font()
{
   return _label_font;
}

int _GUI::get_vsep_line_width(void)
{
   return ClientAreaWidth() * 0.9;
}

int _GUI::get_combobox_width()
{
   return _combobox_width;
}

bool _GUI::Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2)
{
   if(!CAppDialog::Create(chart,name,subwin,x1,y1,x2,y2))
      return(false);   
           
   _combobox_width = center_by_3() - 2 * 5;
   
   inc_ycursor(margin_top());
   if(!CreateLabel(m_label_email, "Email:",ClientAreaWidth() * (1/3.0 * 1/2.0 - 1/3.0 * 1/4.0),get_ycursor(),label_width(),label_height()))
      return(false);
   
   if(!create_edit(m_edit_email, Width() * (1/3.0+2/3.0*1/2.0) - get_edit_width()/2 - 4,get_ycursor(),get_edit_width(),label_height()))
      return(false);  
   inc_ycursor(margin_top()+label_height());
   
   if(!create_button(m_button_login,"login", center() - get_button_width()/2,get_ycursor(),get_button_width(),label_height()))
      return(false);  
      
   if(!m_infopanel.create())
      return false;
   
   /*
   m_label_email.Show();
   m_edit_email.Show();
   m_button_login.Show();
   m_infopanel.get_panel().Show();
   m_infopanel.get_label().Show();
   */
   // DEBUG //
   m_label_email.Hide();
   m_edit_email.Hide();
   m_button_login.Hide();
   Height(GUI_MAIN_WINDOW_APP_HEIGHT);
   m_infopanel.panel_align_bottom();
   
   _y_cursor = 0;    
   inc_ycursor(margin_top());
     
   // LABEL //
   if(!CreateLabel(m_label_ea_config, "EA - configurações",center(),get_ycursor(),label_width(),label_height()))
      return(false);        
   m_label_ea_config.Font(get_label_font());
   m_label_ea_config.FontSize(_label_fontsize);
   centralize_label(m_label_ea_config);
   
   inc_ycursor(m_label_ea_config.Height() + get_vspace());
   // SEP LINE //
   if(!create_panel(m_sep_line1,center() - get_vsep_line_width()/2,get_ycursor(),get_vsep_line_width(),3))
      return(false);
   m_sep_line1.ColorBackground(clrLightYellow);
   m_sep_line1.ColorBorder(clrLightSteelBlue);
      
   // LABEL  stop loss //   
   inc_ycursor(m_sep_line1.Height() + get_vspace());
   if(!CreateLabel(m_label_stop_loss, "Stop Loss",center_by_3()/2 - label_width()/4,get_ycursor(),label_width(),label_height()))
      return(false);
       
   // LABEL take profit //   
   if(!CreateLabel(m_label_take_profit, "Take Profit",center_by_3() + center_by_3()/2 - label_width()/4,get_ycursor(),label_width(),label_height()))
      return(false);        
      
   // COMBO BOX stop loss //        
   inc_ycursor(m_label_stop_loss.Height() + get_vspace()/2 - 10);
   if(!create_combo_box(m_combo_box_stop_loss,center_by_3()/2 -get_combobox_width()/2,get_ycursor(),get_combobox_width(),label_height()))
      return(false);   
   m_combo_box_stop_loss.AddItem(eTradeFuncttions_to_string(eTradeFuncttions::NONE));
   m_combo_box_stop_loss.AddItem(eTradeFuncttions_to_string(eTradeFuncttions::IA));
   m_combo_box_stop_loss.AddItem(eTradeFuncttions_to_string(eTradeFuncttions::FIXED));
   m_combo_box_stop_loss.Select(1);
   
   // COMBO BOX take profit//        
   if(!create_combo_box(m_combo_box_take_profit,center_by_3() + center_by_3()/2 -get_combobox_width()/2,get_ycursor(),get_combobox_width(),label_height()))
      return(false);   
   m_combo_box_take_profit.AddItem(eTradeFuncttions_to_string(eTradeFuncttions::NONE));
   m_combo_box_take_profit.AddItem(eTradeFuncttions_to_string(eTradeFuncttions::IA));
   m_combo_box_take_profit.AddItem(eTradeFuncttions_to_string(eTradeFuncttions::FIXED));
   m_combo_box_take_profit.Select(1);
   
   // LABEL break even //  
   inc_ycursor(m_label_stop_loss.Height() + get_vspace());
   if(!CreateLabel(m_label_break_even, "Break Even",center_by_3()/2 - label_width()/4,get_ycursor(),label_width(),label_height()))
      return(false);
      
    // LABEL trailling //  
   if(!CreateLabel(m_label_trailling_stop, "Trailling Stop",center_by_3() + center_by_3()/2 - label_width()/4,get_ycursor(),label_width(),label_height()))
      return(false);
   
   // COMBO BOX break even//  
   inc_ycursor(m_label_break_even.Height() + get_vspace()/2 - 10);
   if(!create_combo_box(m_combo_box_break_even,center_by_3()/2 -get_combobox_width()/2,get_ycursor(),get_combobox_width(),label_height()))
      return(false);   
   m_combo_box_break_even.AddItem(eTradeFuncttions_to_string(eTradeFuncttions::NONE));
   m_combo_box_break_even.AddItem(eTradeFuncttions_to_string(eTradeFuncttions::IA));
   m_combo_box_break_even.AddItem(eTradeFuncttions_to_string(eTradeFuncttions::FIXED));
   m_combo_box_break_even.Select(1);
   
   // COMBO BOX tralling//  
   if(!create_combo_box(m_combo_box_trailling_stop,center_by_3() + center_by_3()/2 -get_combobox_width()/2,get_ycursor(),get_combobox_width(),label_height()))
      return(false);   
   m_combo_box_trailling_stop.AddItem(eTradeFuncttions_to_string(eTradeFuncttions::NONE));
   m_combo_box_trailling_stop.AddItem(eTradeFuncttions_to_string(eTradeFuncttions::IA));
   m_combo_box_trailling_stop.AddItem(eTradeFuncttions_to_string(eTradeFuncttions::FIXED));
   m_combo_box_trailling_stop.Select(1);
   
   
   //// horários ////
   // LABEL start time to trade // 
   inc_ycursor(m_label_stop_loss.Height() + get_vspace());
   if(!CreateLabel(m_label_time_to_start_trade, "hor. inicial",center_by_3()/2 - label_width()/4,get_ycursor(),label_width(),label_height()))
      return(false);
      
   // LABEL end time to trade //  
   if(!CreateLabel(m_label_time_to_end_trade, "hor. final",center_by_3() + center_by_3()/2 - label_width()/4,get_ycursor(),label_width(),label_height()))
      return(false);
      
   // LABEL end time to close position //  
   if(!CreateLabel(m_label_time_to_close_position, "hor. fech.",2 * center_by_3() + (center_by_3()/2 - label_width()/4),get_ycursor(),label_width(),label_height()))
      return(false);
      
   // COMBO BOX 1//  
   inc_ycursor(m_label_break_even.Height() + get_vspace()/2 - 10);
   if(!create_combo_box(m_combo_box_time_to_start_trade,center_by_3()/2 -get_combobox_width()/2,get_ycursor(),get_combobox_width(),label_height()))
      return(false);   
   for(int i=0;i<COUNT_eTimesToTrade;i++)
      m_combo_box_time_to_start_trade.AddItem(eTimesToTrade_to_string((eTimesToTrade)i));
   m_combo_box_time_to_start_trade.Select(0);
      
   // COMBO BOX 2//  
   if(!create_combo_box(m_combo_box_time_to_end_trade,center_by_3() + center_by_3()/2 -get_combobox_width()/2,get_ycursor(),get_combobox_width(),label_height()))
      return(false);   
   for(int i=0;i<COUNT_eTimesToTrade;i++)
      m_combo_box_time_to_end_trade.AddItem(eTimesToTrade_to_string((eTimesToTrade)i));
   m_combo_box_time_to_end_trade.Select(16);
            
   // COMBO BOX 3//  
   if(!create_combo_box(m_combo_box_time_to_close_position,2 * center_by_3() + center_by_3()/2 -get_combobox_width()/2,get_ycursor(),get_combobox_width(),label_height()))
      return(false);   
   for(int i=0;i<COUNT_eTimesToTrade;i++)
      m_combo_box_time_to_close_position.AddItem(eTimesToTrade_to_string((eTimesToTrade)i));
   m_combo_box_time_to_close_position.Select(17);
      
   //// meta financeira ////
   // LABEL  // 
   inc_ycursor(m_combo_box_time_to_close_position.Height() + get_vspace());
   if(!CreateLabel(m_label_financial_take_by_day, "meta diária",center_by_3()/2 - label_width()/4,get_ycursor(),label_width(),label_height()))
      return(false);
      
   // LABEL //  
   if(!CreateLabel(m_label_financial_take_by_week, "meta semana",center_by_3() + center_by_3()/2 - label_width()/4,get_ycursor(),label_width(),label_height()))
      return(false);
      
   // LABEL //  
   if(!CreateLabel(m_label_financial_take_by_mon, "meta mensal",2 * center_by_3() + (center_by_3()/2 - label_width()/4),get_ycursor(),label_width(),label_height()))
      return(false);
      
   // COMBO BOX 1//  
   inc_ycursor(m_label_financial_take_by_mon.Height() + get_vspace()/2 - 10);
   if(!create_combo_box(m_combo_box_financial_take_by_day,center_by_3()/2 -get_combobox_width()/2,get_ycursor(),get_combobox_width(),label_height()))
      return(false);   
   for(int i=0;i<COUNT_eTimesToTrade;i++)
      m_combo_box_time_to_start_trade.AddItem(eTimesToTrade_to_string((eTimesToTrade)i));
   m_combo_box_time_to_start_trade.Select(0);
      
   // COMBO BOX 2//  
   if(!create_combo_box(m_combo_box_financial_take_by_week,center_by_3() + center_by_3()/2 -get_combobox_width()/2,get_ycursor(),get_combobox_width(),label_height()))
      return(false);   
   for(int i=0;i<COUNT_eTimesToTrade;i++)
      m_combo_box_time_to_end_trade.AddItem(eTimesToTrade_to_string((eTimesToTrade)i));
   m_combo_box_time_to_end_trade.Select(16);
            
   // COMBO BOX 3//  
   if(!create_combo_box(m_combo_box_financial_take_by_mon,2 * center_by_3() + center_by_3()/2 -get_combobox_width()/2,get_ycursor(),get_combobox_width(),label_height()))
      return(false);   
   for(int i=0;i<COUNT_eTimesToTrade;i++)
      m_combo_box_time_to_close_position.AddItem(eTimesToTrade_to_string((eTimesToTrade)i));
   m_combo_box_time_to_close_position.Select(17);
      
   m_label_ea_config.Show();
   m_sep_line1.Show();
   m_combo_box_stop_loss.Show();
   m_combo_box_take_profit.Show();
   m_combo_box_break_even.Show();
   m_combo_box_trailling_stop.Show();
   m_label_stop_loss.Show();
   m_label_take_profit.Show();
   m_label_break_even.Show();
   m_label_trailling_stop.Show();
   m_label_time_to_start_trade.Show();
   m_label_time_to_end_trade.Show();
   m_label_time_to_close_position.Show();
   
   return(true);
}

bool _GUI::CreateLabel(CLabel & label,string text, int x, int y, int width, int height)
  {
//--- create
   if(!label.Create(m_chart_id,m_name+_count_objects,m_subwin,x,y,x + width,y + height))
      return(false);
   _count_objects++;
   if(!label.Text(text))
      return(false);  
   if(!label.FontSize(label_fontsize()))
      return false;    
   if(!Add(label))
      return(false);
//--- succeed
   return(true);
  }
  
bool _GUI::create_edit(CEdit & edit, int x, int y, int width, int height)
{
//--- create
   if(!edit.Create(m_chart_id,m_name+_count_objects,m_subwin,x,y,x + width, y + height))
      return(false);
   _count_objects++;
   if(!edit.FontSize(edit_fontsize()))
      return(false);    
   if(!Add(edit))
      return(false);
//--- succeed
   return(true);
}

bool _GUI::create_button(CButton & button,string text, int x, int y, int width, int height)
{
//--- create
   if(!button.Create(m_chart_id,m_name+_count_objects,m_subwin,x,y, x + width, y + height))
      return(false);
   _count_objects++;
   if(!button.Text(text))
      return(false);  
   if(!Add(button))
      return(false);
//--- succeed
   return(true);
}

bool _GUI::create_panel(CPanel & panel, int x, int y, int width, int height)
{
//--- create
   if(!panel.Create(m_chart_id,m_name+_count_objects,m_subwin,x,y, x + width, y + height))
      return(false); 
   _count_objects++;
   if(!Add(panel))
      return(false);
//--- succeed
   return(true);
}

bool _GUI::create_combo_box(CComboBox & cbox, int x, int y, int width, int height)
{
//--- create
   if(!cbox.Create(m_chart_id,m_name+_count_objects,m_subwin,x,y, x + width, y + height))
      return(false); 
   _count_objects++;
   if(!Add(cbox))
      return(false);
//--- succeed
   return(true);
}

bool _GUI::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
{
   if(id==CHARTEVENT_CUSTOM)
   {
      if(lparam==m_button_login.Id())
      {
         m_infopanel.show_msg("Conectando ao servidor ...");
         eConnectionTypes ret_connection = m_socket.establish_connection();
         //if(ret_connection == eConnectionTypes::connection_not_established
         {
            //m_infopanel.show_msg("Conexão não estabelecida!",clrCrimson);
         }         
         //else if(ret_connection == eConnectionTypes::connection_established)
         {
            m_infopanel.show_msg("Conexão estabelecida!",clrDarkGreen);
            hide_login_interface();
            Height(GUI_MAIN_WINDOW_APP_HEIGHT);
            m_infopanel.panel_align_bottom();
            
         }
         return(true);
      }
   }
   return(CAppDialog::OnEvent(id,lparam,dparam,sparam));
}


void _GUI::centralize_label(CLabel & label)
{
   int width;
   int height;   
   TextGetSize(label.Text(),width,height);
   update_label(label,width,height);   
   label.Move(Left() + center() - width/2,label.Rect().LeftTop().y);   
}

void _GUI::update_label(CLabel & label, int w, int h)
{
   label.Width(w);
   label.Height(h);
}

void _GUI::on_timer(void)
{

}

void _GUI::hide_login_interface()
{
   m_label_email.Hide();
   m_edit_email.Hide();
   m_button_login.Hide();         
}

string eTradeFuncttions_none =  "não utilizar";
string eTradeFuncttions_ai =  "Int. artificial";
string eTradeFuncttions_fixo =  "fixo";

string _GUI::eTradeFuncttions_to_string(eTradeFuncttions e)
{
   switch(e)
   {
      case eTradeFuncttions::NONE: return eTradeFuncttions_none; break;
      case eTradeFuncttions::IA: return eTradeFuncttions_ai; break;
      case eTradeFuncttions::FIXED: return eTradeFuncttions_fixo; break;
      default: return eTradeFuncttions::IA;
   }
}

eTradeFuncttions _GUI::string_to_eTradeFuncttions(string s)
{
   if(s == eTradeFuncttions_none) return eTradeFuncttions::NONE; 
   else if(s == eTradeFuncttions_ai) return eTradeFuncttions::IA; 
   else if(s == eTradeFuncttions_fixo) return eTradeFuncttions::FIXED;
   return eTradeFuncttions::IA;
}

string   s_09_00_ = "09:00";
string   s_09_30_ = "09:30";
string   s_10_00_ = "10:00";
string   s_10_30_ = "10:30";
string   s_11_00_ = "11:00";
string   s_11_30_ = "11:30";
string   s_12_00_ = "12:00";
string   s_12_30_ = "12:30";
string   s_13_00_ = "13:00";
string   s_13_30_ = "13:30";
string   s_14_00_ = "14:00";
string   s_14_30_ = "14:30";
string   s_15_00_ = "15:00";
string   s_15_30_ = "15:30";
string   s_16_00_ = "16:00";
string   s_16_30_ = "16:30";
string   s_17_00_ = "17:00";
string   s_17_30_ = "17:30";
string   s_18_00_ = "18:00";
string   s_18_30_ = "18:30";

string _GUI::eTimesToTrade_to_string(eTimesToTrade e)
{
   switch(e)
   {
      case eTimesToTrade::_09_00_:    return s_09_00_; break;
      case eTimesToTrade::_09_30_:    return s_09_30_; break;
      case eTimesToTrade::_10_00_:    return s_10_00_; break;
      case eTimesToTrade::_10_30_:    return s_10_30_; break;
      case eTimesToTrade::_11_00_:    return s_11_00_; break;
      case eTimesToTrade::_11_30_:    return s_11_30_; break;
      case eTimesToTrade::_12_00_:    return s_12_00_; break;
      case eTimesToTrade::_12_30_:    return s_12_30_; break;
      case eTimesToTrade::_13_00_:    return s_13_00_; break;
      case eTimesToTrade::_13_30_:    return s_13_30_; break;
      case eTimesToTrade::_14_00_:    return s_14_00_; break;
      case eTimesToTrade::_14_30_:    return s_14_30_; break;
      case eTimesToTrade::_15_00_:    return s_15_00_; break;
      case eTimesToTrade::_15_30_:    return s_15_30_; break;
      case eTimesToTrade::_16_00_:    return s_16_00_; break;
      case eTimesToTrade::_16_30_:    return s_16_30_; break;
      case eTimesToTrade::_17_00_:    return s_17_00_; break;
      case eTimesToTrade::_17_30_:    return s_17_30_; break;
      case eTimesToTrade::_18_00_:    return s_18_00_; break;
      case eTimesToTrade::_18_30_:    return s_18_30_; break;
      
      default: return s_09_00_;
   }
}

eTimesToTrade _GUI::string_to_eTimesToTrade(string s)
{
   if(s == s_09_00_)          return eTimesToTrade::_09_00_; 
   else if(s == s_09_30_)     return eTimesToTrade::_09_30_; 
   else if(s == s_10_00_)     return eTimesToTrade::_10_00_;
   else if(s == s_10_30_)     return eTimesToTrade::_10_30_;
   else if(s == s_11_00_)     return eTimesToTrade::_11_00_;
   else if(s == s_11_30_)     return eTimesToTrade::_11_30_;
   else if(s == s_12_00_)     return eTimesToTrade::_12_00_;
   else if(s == s_12_30_)     return eTimesToTrade::_12_30_;
   else if(s == s_13_00_)     return eTimesToTrade::_13_00_;
   else if(s == s_13_30_)     return eTimesToTrade::_13_30_;
   else if(s == s_14_00_)     return eTimesToTrade::_14_00_;
   else if(s == s_14_30_)     return eTimesToTrade::_14_30_;
   else if(s == s_15_00_)     return eTimesToTrade::_15_00_;
   else if(s == s_15_30_)     return eTimesToTrade::_15_30_;
   else if(s == s_16_00_)     return eTimesToTrade::_16_00_;
   else if(s == s_16_30_)     return eTimesToTrade::_16_30_;
   else if(s == s_17_00_)     return eTimesToTrade::_17_00_;
   else if(s == s_17_30_)     return eTimesToTrade::_17_30_;
   else if(s == s_18_00_)     return eTimesToTrade::_18_00_;
   else if(s == s_18_30_)     return eTimesToTrade::_18_30_;
   return eTimesToTrade::_09_00_;
}