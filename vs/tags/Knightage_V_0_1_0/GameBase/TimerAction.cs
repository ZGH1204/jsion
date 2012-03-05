using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GameBase
{
    public class TimerAction
    {
        public int CurrentInterval { get; protected set; }

        public int CurrentCount { get; protected set; }

        public bool Finished { get; protected set; }

        public TimerAction()
        {
            CurrentInterval = 0;
            CurrentCount = 0;
            Finished = false;
        }

        public virtual int ExecuteInterval
        {
            get { return 0; }
        }

        public virtual int ExecuteCount
        {
            get { return 0; }
        }

        public void Update(double interval)
        {
            CurrentInterval += (int)interval;

            if (CurrentInterval >= ExecuteInterval)
            {
                Execute();
                CurrentInterval = 0;
            }
        }

        protected virtual void Execute()
        {
            if (ExecuteCount > 0)
            {
                CurrentCount++;
            }
            else
            {
                CurrentCount = -1;
            }

            if (CurrentCount >= ExecuteCount)
            {
                Finished = true;
            }
        }
    }
}
