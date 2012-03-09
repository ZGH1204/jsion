using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CrossDomainApp.Core
{
    public class CrossGlobal
    {
        public static readonly string POLICY_XML = "<?xml version=\"1.0\"?><!DOCTYPE cross-domain-policy SYSTEM \"http://www.adobe.com/xml/dtds/cross-domain-policy.dtd\"><cross-domain-policy><allow-access-from domain=\"*\" to-ports=\"*\" /></cross-domain-policy>\0";

        public static bool SimpleCheck = false;

        public static string CONDITION = "<policy-file-request/>";

        public static byte[] POLICY;

        public static readonly CrossFileSrv Server = new CrossFileSrv();
    }
}
