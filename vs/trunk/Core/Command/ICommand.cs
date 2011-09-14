using System;
using System.Collections.Generic;
using System.Text;

namespace Command
{
    public interface ICommand
    {
        bool Execute(string[] paramsList);
    }
}
