using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JsionFramework.Jsion.WeakRefs
{
    public class WeakRef : WeakReference
    {
        private class NullValue { };

        private static readonly NullValue NULL = new NullValue();

        public WeakRef(object target)
            : base(((target == null) ? NULL : target))
        {

        }

        public WeakRef(object target, bool trackResurrection)
            :base(((target == null) ? NULL : target), trackResurrection)
        {

        }

        override public object Target
        {
            get
            {
                object o = base.Target;
                return ((o == NULL) ? null : o);
            }
            set
            {
                base.Target = (value == null) ? NULL : value;
            }
        }
    }
}
