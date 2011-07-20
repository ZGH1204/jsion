#if NET1
#else

using System;
using System.Collections.Generic;
using System.Text;
using System.Collections.ObjectModel;
using System.Runtime.Serialization;

namespace Sjs.Common.Generic
{
    public class List<T> : System.Collections.Generic.List<T>, ISjsCollection<T> //:Collection<T>  // where T : new()
    {
        public List() : base() { }

        public List(IEnumerable<T> collection) : base(collection) { }

        public List(int capacity) : base(capacity) { }


        public object SyncRoot
        {
            get
            {
                return this;
            }
        }

        public bool IsEmpty
        {
            get
            {
                return this.Count == 0;
            }
        }

        private int _fixedsize = default(int);
        public int FixedSize
        {
            get
            {
                return _fixedsize;
            }
            set
            {
                _fixedsize = value;
            }
        }

        public bool IsFull
        {
            get
            {
                if ((FixedSize != default(int)) && (this.Count >= FixedSize))
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }

        public string Version
        {
            get
            {
                return "1.0";
            }
        }

        public string Author
        {
            get
            {
                return "Discuz!NT";
            }
        }

        public bool IsReadOnly
        {
            get
            {
                return false;
            }
        }

        public new void Add(T value)
        {
            if (!this.IsFull)
            {
                base.Add(value);
            }
        }

        public void Accept(ISjsVisitor<T> visitor)
        {
            if (visitor == null)
            {
                throw new ArgumentNullException("访问器为空");
            }

            //for (int i = 0; i < this.Count; i++)
            //{
            //    visitor.Visit(this[i]);

            //    if (visitor.HasCompleted)
            //    {
            //        break;
            //    }
            //}

            System.Collections.Generic.List<T>.Enumerator enumerator = this.GetEnumerator();

            while (enumerator.MoveNext())
            {
                visitor.Visit(enumerator.Current);

                if (visitor.HasDone)
                {
                    return;
                }
            }
        }

        public int CompareTo(object obj)
        {
            if (obj == null)
            {
                throw new ArgumentNullException("obj");
            }

            if (obj.GetType() == this.GetType())
            {
                List<T> l = obj as List<T>;

                return this.Count.CompareTo(l.Count);
            }
            else
            {
                return this.GetType().FullName.CompareTo(obj.GetType().FullName);
            }
        }
    }

    #region 注释测试代码段

    //class Program
    //{
    //    static void Main(string[] args)
    //    {
    //        #region 测试1

    //        DiscuzList<person> persons = new DiscuzList<person>();
    //        persons.Add(new person("daizhj", 31));
    //        persons.Add(new person("wohong",30));

    //        foreach (person p in persons)
    //        {
    //            Console.WriteLine(p.name+" "+p.age);
    //        }

    //        #endregion


    //        #region 测试2

    //        DiscuzList<student> studentsA = new DiscuzList<student>();
    //        studentsA.Add(new student("daizhj", 30,1,"bjpk"));
    //        studentsA.Add(new student("wohong", 31,2,"shfd"));

    //        DiscuzList<student> studentsB = new DiscuzList<student>();
    //        studentsB.Add(new student("daizhj", 32, 3, "hbhd"));
    //        studentsB.Add(new student("wohong", 33, 4, "FFBBV"));

    //        studentsA.AddRange(studentsB);

    //        Console.WriteLine("开始打印两部分学生集合");
    //        foreach (student s in studentsA)
    //        {
    //            Console.WriteLine(s.name + " " + s.age + " " + s.id + " " + s.schoolname);
    //        }

    //        #endregion


    //        Console.ReadLine();
    //    }
    //}

    //[Serializable]
    //class person
    //{
    //    public string name = "";
    //    public int age = 0;
    //    public person()
    //    {
    //    }

    //    public person(string Name, int Age)
    //    {
    //        name = Name;
    //        age = Age;
    //    }
    //}


    //[Serializable]
    //class student : person
    //{
    //    public int id = 0;
    //    public string schoolname = "";

    //    public student()
    //    {
    //    }

    //    public student(string Name, int Age, int ID, string SchoolName)
    //    {
    //        name = Name;
    //        age = Age;
    //        id = ID;
    //        schoolname = SchoolName;
    //    }
    //}
    #endregion
}
#endif