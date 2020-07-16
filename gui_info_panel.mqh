#include <Controls\Panel.mqh>
#include <Controls\Label.mqh>

class _GUI;

class InfoPanel{
   protected:
      CPanel m_panel;
      //CLabel m_msg;
      
      _GUI * m_parent;
      
      int get_panel_width(); 
      int get_panel_height();     
   public:
      InfoPanel(_GUI *);
      ~InfoPanel();
      bool create();
      CPanel * get_panel();      
};