#include "_socket.mqh"

_Socket::_Socket(string hostname,ushort serverport) : 
         m_hostname(hostname), m_server_port(serverport), m_client_socket(NULL)
{}

int _Socket::establish_connection()
{
   // if null already has a socket //
   if(m_client_socket != NULL)
      return eConnectionTypes::connection_already_exists;
   m_client_socket = new ClientSocket(m_hostname, m_server_port);
   if (m_client_socket.IsSocketConnected()) {
      Print("Conexão estabelecida!");
      return eConnectionTypes::connection_established;
   } else {
      Print("Conexão não estabelecida!");
      return eConnectionTypes::connection_not_established;
   }   
}

void _Socket::send_msg(string msg)
{
   if(m_client_socket.IsSocketConnected())
      m_client_socket.Send(msg);
}

void _Socket::check()
{
   if(m_client_socket != NULL)
   {
      if(!m_client_socket.IsSocketConnected())
      {
         Print("Conexão perdida!");
         delete m_client_socket;
         m_client_socket = NULL;
      }
   }
}

bool _Socket::is_connected()
{
   if(m_client_socket == NULL || m_client_socket.IsSocketConnected() == false)
      return false;
   else
      return true;
}