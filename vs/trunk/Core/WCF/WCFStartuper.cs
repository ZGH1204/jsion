using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ServiceModel;

namespace WCF
{
    public class WCFStartuper
    {
        private ServiceHost host;

        public WCFStartuper(Type serviceType)
        {
            host = new ServiceHost(serviceType);
        }

        public void Start()
        {
            if (host.State != CommunicationState.Opened && host.State != CommunicationState.Opening)
            {
                host.Open();
            }
        }

        public void Stop()
        {
            if (host.State != CommunicationState.Closed && host.State != CommunicationState.Closing)
            {
                host.Close();
            }
        }
    }
}
