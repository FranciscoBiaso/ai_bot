#include <Controls\Panel.mqh>
#include <Controls\Label.mqh>
class _GUI;

class InfoPanel{
   protected:
      CPanel m_panel;
      CLabel m_labe_msg;
      
      _GUI * m_parent;
      
      int get_panel_width(); 
      int get_panel_height();  
      void update_label(ushort);
   public:
      InfoPanel(_GUI *);
      ~InfoPanel();
      bool create();
      CPanel * get_panel();  
      CLabel * get_label();   
      void show_msg(string, color, int miliseconds);   
      void panel_align_bottom();
};