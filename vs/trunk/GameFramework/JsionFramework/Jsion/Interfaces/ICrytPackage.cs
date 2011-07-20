using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JsionFramework.Jsion.Interfaces
{
    public interface ICrytPackage
    {
        byte Encryt(byte b);
        byte Decryt(byte b);
        void EncrytOnceComplete();
        void DecrytOnceComplete();
        //byte[] Encryt(byte[] bytes);
        //byte[] Decryt(byte[] bytes);
    }
}
