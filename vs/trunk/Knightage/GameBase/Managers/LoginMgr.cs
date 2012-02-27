using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GameBase.Managers
{
    public class LoginMgr<T1, T2> where T2:Player
    {
        private readonly Dictionary<T1, T2> m_list = new Dictionary<T1, T2>();
        private readonly Dictionary<T2, T1> m_list2 = new Dictionary<T2, T1>();

        private object m_locker = new object();

        public void AddPlayer(T1 key, T2 player)
        {
            T2 temp = null;

            lock (m_locker)
            {
                if (m_list.ContainsKey(key))
                {
                    temp = m_list[key];
                    m_list[key] = player;
                    m_list2[player] = key;
                }
                else
                {
                    m_list.Add(key, player);
                    m_list2.Add(player, key);
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

            RemovePlayer(client.Player as T2);
        }

        public void RemovePlayer(T2 player)
        {
            lock (m_locker)
            {
                if (m_list2.ContainsKey(player))
                {
                    T1 key = m_list2[player];

                    m_list.Remove(key);
                    m_list2.Remove(player);
                }
            }
        }

        public void RemovePlayer(T1 key)
        {
            lock (m_locker)
            {
                if (m_list.ContainsKey(key))
                {
                    T2 player = m_list[key];
                    m_list.Remove(key);
                    m_list2.Remove(player);
                }
            }
        }

        public bool ContainsPlayer(T1 key)
        {
            lock (m_locker)
            {
                return m_list.ContainsKey(key);
            }
        }

        public bool ContainsPlayer(T2 player)
        {
            lock (m_locker)
            {
                return m_list2.ContainsKey(player);
            }
        }

        public T1 GetKey(T2 player)
        {
            lock (m_locker)
            {
                if (m_list2.ContainsKey(player))
                {
                    return m_list2[player];
                }
            }

            return default(T1);
        }

        public T2 GetPlayer(T1 key)
        {
            lock (m_locker)
            {
                if (m_list.ContainsKey(key))
                {
                    return m_list[key];
                }
            }

            return default(T2);
        }
    }
}
