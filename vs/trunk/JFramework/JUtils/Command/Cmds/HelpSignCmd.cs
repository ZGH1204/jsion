using JUtils.Attributes;

namespace JUtils.Command.Cmds
{
    [Cmd(@"/?", "查看命令列表 与'Help'命令相同", "")]
    public class HelpSignCmd : ICommand
    {
        public bool Execute(string[] paramsList)
        {
            CommandMgr.Instance.DisplayCommandList();
            return true;
        }
    }
}
