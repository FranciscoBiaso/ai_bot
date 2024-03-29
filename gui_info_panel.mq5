#include "gui_info_panel.mqh"

InfoPanel::InfoPanel(_GUI * parent) : m_parent(parent)
{}

InfoPanel::~InfoPanel(void)
{
   if(CheckPointer(m_parent) != POINTER_INVALID) 
      delete m_parent;
}

int InfoPanel::get_panel_width()
{
   return m_parent.get_client_area_width() - m_parent.get_client_area_width() * 0.01;
}

int InfoPanel::get_panel_height()
{
   return m_parent.label_height() + 2 * 3;
}

void InfoPanel::update_label(ushort symbol = '-'){}

bool InfoPanel::create(void)
{
   if(!m_parent.create_panel(m_panel,m_parent.center() - get_panel_width()/2, m_parent.get_client_area_height() - get_panel_height() - 2,
                             get_panel_width(),get_panel_height()))
      return false;   
     
   if(!m_parent.CreateLabel(m_labe_msg,"",0,m_parent.get_client_area_height() - get_panel_height() + 4,0,0))
      return(false);   
   
   if(!m_labe_msg.Font(m_parent.get_label_font()))
     printf("fail to install font!");
      
   // load msg font //   
   m_labe_msg.FontSize(m_parent.label_fontsize()); 
   m_panel.ColorBackground(clrWhite);
   m_panel.ColorBorder(clrSilver);    
   show_msg("Bem vindo ao AI BOT!"); 
   
   return true;
}

CPanel * InfoPanel::get_panel()
{
   return GetPointer(m_panel);
}

CLabel * InfoPanel::get_label()
{
   return GetPointer(m_labe_msg);
}

void InfoPanel::show_msg(string msg, color col = clrDarkBlue, int miliseconds = 0)
{
   m_labe_msg.Color(col);   
   m_labe_msg.Text(msg);
   m_parent.centralize_label(m_labe_msg);
   m_labe_msg.Show();
}

void InfoPanel::panel_align_bottom(void)
{        
   m_panel.Move(m_panel.Rect().LeftTop().x, m_parent.Height() - get_panel_height()/2);
   m_labe_msg.Move(m_labe_msg.Rect().LeftTop().x, m_panel.Rect().CenterPoint().y - 6);
}