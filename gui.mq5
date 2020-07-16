#include "gui.mqh"

_GUI::_GUI(void)
{
   _margin_left = 10;
   _margin_top = 10;
   _label_percentage_of_main_window_size = 1/3.0;
   _edit_percentage_of_main_window_size = 2/3.4;
   _button_percentage_of_main_window_size = 1/4.0;
   _label_fontsize = 13;
   _label_height = 22;
   _edit_fontsize = 10;
   _y_cursor = 0;
   _v_space = 10;   
   //m_infopanel = new InfoPanel(GetPointer(this));
   
}
_GUI::~_GUI(void)
{
   //if(CheckPointer(m_infopanel) != POINTER_INVALID)
      //delete m_infopanel;
}

int _GUI::label_width()
{
   return Width() * _label_percentage_of_main_window_size;
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
   return Width()/2;
}

int _GUI::edit_fontsize()
{
   return _edit_fontsize;
}

int _GUI::get_edit_width()
{
   return Width() * _edit_percentage_of_main_window_size;
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

bool _GUI::Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2)
{
   if(!CAppDialog::Create(chart,name,subwin,x1,y1,x2,y2))
      return(false);
            
   inc_ycursor(margin_top());
   if(!CreateLabel(m_label_email, "Email:",Width() * (1/3.0 * 1/2.0 - 1/3.0 * 1/4.0),get_ycursor(),label_width(),label_height()))
      return(false);
   
   if(!create_edit(m_edit_email, Width() * (1/3.0+2/3.0*1/2.0) - get_edit_width()/2 + 2,get_ycursor(),get_edit_width(),label_height()))
      return(false);  
   inc_ycursor(margin_top()+label_height());
   
   if(!create_button(m_button_login,"login", center() - get_button_width()/2,get_ycursor(),get_button_width(),label_height()))
      return(false);  
      
   //if(!m_infopanel.create())
      //return false;
   
   m_label_email.Show();
   m_edit_email.Show();
   m_button_login.Show();
   
   //m_infopanel.get_panel().Show();
           
   return(true);
}

bool _GUI::CreateLabel(CLabel & label,string text, int x, int y, int width, int height)
  {
//--- create
   if(!label.Create(m_chart_id,m_name+"label",m_subwin,x,y,x + width,y + height))
      return(false);
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
   if(!edit.Create(m_chart_id,m_name+"edit",m_subwin,x,y,x + width, y + height))
      return(false);
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
   if(!button.Create(m_chart_id,m_name+"button",m_subwin,x,y, x + width, y + height))
      return(false);
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
   if(!panel.Create(m_chart_id,m_name+"panel",m_subwin,x,y, x + width, y + height))
      return(false); 
   if(!Add(panel))
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
         //m_status_bar.GetItemPointer(0).LabelText("Conectando ao servidor...");
         //m_status_bar.GetItemPointer(0).Update(true);
         //if(m_socket.establish_connection() == eConnectionTypes::connection_not_established)
         {
            //m_text_edit_login.Hide();
            //m_button_login.Hide();
         }         
         return(true);
      }
   }
   return(true);
}