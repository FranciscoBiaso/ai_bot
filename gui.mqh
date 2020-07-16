#include <Controls\Dialog.mqh>
#include <Controls\Label.mqh>
#include <Controls\Button.mqh>

//#include "gui_info_panel.mqh"

class _GUI : public CAppDialog
{
   private:
      CLabel            m_label_email;                         // CLabel object
      CEdit             m_edit_email;
      CButton           m_button_login;      
      //InfoPanel *       m_infopanel;
      
      double _label_percentage_of_main_window_size;
      double _edit_percentage_of_main_window_size;
      double _button_percentage_of_main_window_size;
      int _label_fontsize;
      int _label_height;
      int _edit_fontsize;

      int _margin_left;
      int _margin_top;      
      int _y_cursor;
      int _v_space;

public:
   
      int get_button_width();

      int label_width();
      int label_height();
      int label_fontsize();
      
      int get_ycursor();
      int get_vspace();
      
      
      void inc_ycursor(int value);
      
      int edit_fontsize();
      int get_edit_width();
      
      int margin_left();
      int margin_top();
      
      int center();
      _GUI(void);
      ~_GUI();
   
      //--- create dependent controls
      bool              CreateLabel(CLabel & label,string text, int x, int y, int width, int height);
      bool              create_edit(CEdit & edit, int x, int y, int width, int height);
      bool              create_button(CButton & edit,string text, int x, int y, int width, int height);
      bool              create_panel(CPanel & panel, int x, int y, int width, int height);
      //--- handlers of the dependent controls events
      void              OnClickLabel(void);

      //--- create
      virtual bool      Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2);
protected:
      //--- chart event handler
      virtual bool      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
};