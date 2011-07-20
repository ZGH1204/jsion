using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JCore
{
    public class Config
    {
        private static CoreConfig _config = new CoreConfig();

        public static void Load()
        {
            _config.Refresh();
        }

        public static CoreConfig config { get { return _config; } }
    }
}
