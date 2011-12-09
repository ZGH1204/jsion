using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;

namespace JUtils
{
    public class TickUtil
    {
        private static long StopwatchFrequencyMilliseconds = Stopwatch.Frequency / 1000;

        public static long GetTicks()
        {
            return Stopwatch.GetTimestamp() / StopwatchFrequencyMilliseconds;
        }
    }
}
