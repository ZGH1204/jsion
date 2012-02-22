using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GameBase.Managers
{
    public class LoginMgr<T> where T:Player
    {
        private readonly Dictionary<uint, T> m_list = new Dictionary<uint, T>();

        private object m_locker = new object();

        public void AddPlayer(T player)
        {
            T temp = null;

            lock (m_locker)
            {
                if (m_list.ContainsKey(player.PlayerID))
                {
                    temp = m_list[player.PlayerID];
                    m_list[player.PlayerID] = player;
                }
                else
                {
                    m_list.Add(player.PlayerID, player);
                }

                player.Logined();

                player.Client.Disconnected += new DisconnectDelegate(Client_Disconnected);

                if (temp != null)
                {
                    temp.Logout();
                }
            }
        }

        void Client_Disconnected(ClientBase client)
        {
            client.Player.OnDisconnect();

            RemovePlayer(client.Player as T);
        }

        public void RemovePlayer(T player)
        {
            lock (m_locker)
            {
                if (player == null ||
                m_list.ContainsKey(player.PlayerID) == false ||
                m_list[player.PlayerID] != player) return;

                m_list.Remove(player.PlayerID);
            }
        }

        public bool ContainsPlayer(uint playerID)
        {
            lock (m_locker)
            {
                return m_list.ContainsKey(playerID);
            }
        }

        public T GetPlayer(uint playerID)
        {
            lock (m_locker)
            {
                if (m_list.ContainsKey(playerID))
                {
                    return m_list[playerID];
                }
            }

            return default(T);
        }
    }
}
