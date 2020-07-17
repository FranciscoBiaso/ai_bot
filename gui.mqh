#include <Controls\Dialog.mqh>
#include <Controls\Label.mqh>
#include <Controls\Button.mqh>
#include <Controls\ComboBox.mqh>

class InfoPanel;
class _Socket;

class _GUI : public CAppDialog
{
   private:
      CLabel            m_label_email;                         // CLabel object
      CEdit             m_edit_email;
      CButton           m_button_login;      
      InfoPanel *       m_infopanel;
      _Socket *         m_socket;
      
      
      CLabel            m_label_ea_config;
      CPanel            m_sep_line1;
      CLabel            m_label_stop_loss;
      CLabel            m_label_take_profit;
      CLabel            m_label_break_even;
      CLabel            m_label_trailling_stop;
      CLabel            m_label_time_to_start_trade;
      CLabel            m_label_time_to_end_trade;
      CLabel            m_label_time_to_close_position;
      CLabel            m_label_financial_take_by_day;
      CLabel            m_label_financial_take_by_week;
      CLabel            m_label_financial_take_by_mon;
      CLabel            m_label_financial_loss_by_day;
      CLabel            m_label_financial_loss_by_week;
      CLabel            m_label_financial_loss_by_mon;
      CLabel            m_label_financial_loss;
      CComboBox         m_combo_box_stop_loss;
      CComboBox         m_combo_box_take_profit;
      CComboBox         m_combo_box_break_even;
      CComboBox         m_combo_box_trailling_stop;
      CComboBox         m_combo_box_time_to_start_trade;
      CComboBox         m_combo_box_time_to_end_trade;
      CComboBox         m_combo_box_time_to_close_position;
      CComboBox         m_combo_box_financial_take_by_day;
      CComboBox         m_combo_box_financial_take_by_week;
      CComboBox         m_combo_box_financial_take_by_mon;
      CComboBox         m_combo_box_financial_loss_by_day;
      CComboBox         m_combo_box_financial_loss_by_week;
      CComboBox         m_combo_box_financial_loss_by_mon;
      CComboBox         m_combo_box_financial_loss;
      
      double _label_percentage_of_main_window_size;
      double _edit_percentage_of_main_window_size;
      double _button_percentage_of_main_window_size;
      
      string _label_font;
      int _label_fontsize;
      int _label_height;
      int _edit_fontsize;
      int _combobox_width;

      int _margin_left;
      int _margin_top;      
      int _y_cursor;
      int _v_space; 
      int _count_objects;     
   protected:
   public:
      _GUI(_Socket *);
      ~_GUI();   
      
      void centralize_label(CLabel &, int center_position ,int height);   
      void update_label(CLabel & label, int w, int h);
      string get_label_font();
      
      int get_combobox_width();
      
      int get_client_area_height();
      int get_client_area_width();
      
      int get_button_width();

      int label_width();
      int label_height();
      int label_fontsize();
      
      int get_ycursor();
      int get_vspace();     
      
      int get_vsep_line_width(); 
      
      void inc_ycursor(int value);
      
      int edit_fontsize();
      int get_edit_width();
      
      int margin_left();
      int margin_top();
      
      int center();
      int center_by_3();
      
      string eTradeFuncttions_to_string(eTradeFuncttions e);
      eTradeFuncttions string_to_eTradeFuncttions(string s);
            
      string eTimesToTrade_to_string(eTimesToTrade e);
      eTimesToTrade string_to_eTimesToTrade(string s);
      
      string eFinancialTypes_to_string(eFinancialTypes e);
      eFinancialTypes string_to_eFinancialTypes(string s);
      
   
      //--- create dependent controls
      bool              CreateLabel(CLabel & label,string text, int x, int y, int width, int height);
      bool              create_edit(CEdit & edit, int x, int y, int width, int height);
      bool              create_button(CButton & edit,string text, int x, int y, int width, int height);
      bool              create_panel(CPanel & panel, int x, int y, int width, int height);
      bool              create_combo_box(CComboBox & cbox, int x, int y, int width, int height);


      void hide_login_interface();

      //--- create
      virtual bool      Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2);

      //--- chart event handler
      virtual bool      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
      
      void on_timer();
};