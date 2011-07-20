using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JsionFramework.Jsion.Interfaces
{
    public interface ICommand
    {
        bool Execute(string[] paramsList);
    }
}
