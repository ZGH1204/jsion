using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;

namespace PlugIn.Core
{
    public interface IDoozer
    {
        /// <summary>
        /// 创建对象
        /// </summary>
        /// <param name="caller">调用者</param>
        /// <param name="codon">创建信息</param>
        /// <param name="subItems">子对象列表</param>
        /// <returns>创建信息相应的对象</returns>
        object BuildItem(object caller, Codon codon, ArrayList subItems);
    }
}
