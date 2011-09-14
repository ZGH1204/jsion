using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace Net
{
    public class Marshal
    {
        /// <summary>
        /// Converts a byte c-style string byte-array 
        /// to a c# string
        /// </summary>
        /// <param name="cstyle">the bytes</param>
        /// <returns>the string</returns>
        public static string ConvertToString(byte[] cstyle)
        {
            if (cstyle == null)
                return null;

            for (int i = 0; i < cstyle.Length; i++)
            {
                if (cstyle[i] == 0)
                    return Encoding.Default.GetString(cstyle, 0, i);
            }
            return Encoding.Default.GetString(cstyle);
        }

        /// <summary>
        /// Converts a byte array into a hex dump
        /// </summary>
        /// <param name="description">Dump description</param>
        /// <param name="dump">byte array</param>
        /// <returns>the converted hex dump</returns>
        public static string ToHexDump(string description, byte[] dump)
        {
            return ToHexDump(description, dump, 0, dump.Length);
        }


        /// <summary>
        /// Converts a byte array into a hex dump
        /// </summary>
        /// <param name="description">Dump description</param>
        /// <param name="dump">byte array</param>
        /// <param name="start">dump start offset</param>
        /// <param name="count">dump bytes count</param>
        /// <returns>the converted hex dump</returns>
        public static string ToHexDump(string description, byte[] dump, int start, int count)
        {
            StringBuilder hexDump = new StringBuilder();
            if (description != null)
            {
                hexDump.Append(description).Append("\n");
            }
            int end = start + count;
            for (int i = start; i < end; i += 16)
            {
                StringBuilder text = new StringBuilder();
                StringBuilder hex = new StringBuilder();
                hex.Append(i.ToString("X4"));
                hex.Append(": ");

                for (int j = 0; j < 16; j++)
                {
                    if (j + i < end)
                    {
                        byte val = dump[j + i];
                        hex.Append(dump[j + i].ToString("X2"));
                        hex.Append(" ");
                        if (val >= 32 && val <= 127)
                        {
                            text.Append((char)val);
                        }
                        else
                        {
                            text.Append(".");
                        }
                    }
                    else
                    {
                        hex.Append("   ");
                        text.Append(" ");
                    }
                }
                hex.Append("  ");
                hex.Append(text.ToString());
                hex.Append('\n');
                hexDump.Append(hex.ToString());
            }
            return hexDump.ToString();
        }
    }
}
