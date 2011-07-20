using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.IO;

namespace SJSCAN.HandlersLib.Interfaces
{
    public interface IResponder
    {
        void WritePagingList(int len, string str);

        void WriteSuccessed(string str);

        void WriteSuccessed(HttpContext context, string str);

        void WriteErrored(string str);

        void WriteErrored(HttpContext context, string str);


        void WriteSuccessedMsg(string str);

        void WriteSuccessedMsg(HttpContext context, string str);

        void WriteErroredMsg(string str);

        void WriteErroredMsg(HttpContext context, string str);

        void RWExcelFile(FileInfo file);
    }
}
