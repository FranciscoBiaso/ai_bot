#include <socket-library-mt4-mt5.mqh>

enum eConnectionTypes{
   connection_already_exists = 0,
   connection_established,
   connection_not_established
};

class _Socket{
   public:
      _Socket(string,ushort);
      string   m_hostname;    // Server hostname or IP address
      ushort   m_server_port;        // Server port
      ClientSocket * m_client_socket;
      int establish_connection();
      void send_msg(string msg);
      void check();
      bool is_connected();
};
