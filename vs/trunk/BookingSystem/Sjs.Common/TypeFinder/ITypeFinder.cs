#if NET1
#else
using System;
using System.Collections.Generic;
using System.Reflection;

namespace Sjs.Common.TypeFinder
{
    public interface ITypeFinder
    {
        IList<Assembly> GetFilteredAssembliyList();
    }
}

#endif