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
   return m_parent.Width();
}

int InfoPanel::get_panel_height()
{
   return m_parent.label_height() + 2 * 5;
}

bool InfoPanel::create(void)
{
   if(!m_parent.create_panel(m_panel,20,20,200,200))
      return false;   
   return true;
}

CPanel * InfoPanel::get_panel()
{
   return GetPointer(m_panel);
}