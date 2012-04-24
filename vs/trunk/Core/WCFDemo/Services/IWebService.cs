using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ServiceModel;

namespace WCFDemo.Services
{
    [ServiceContract]
    public interface IWebService
    {
        [OperationContract]
        void SayHello(string name);

        [OperationContract]
        void AddTeam(ServiceData data);
    }
}
