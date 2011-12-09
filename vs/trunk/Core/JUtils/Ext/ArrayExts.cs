using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


namespace System
{
    /// <summary>
    /// 数组扩展方法
    /// </summary>
    public static class ArrayExts
    {
        public const float LoadConstant = 1.5f;
        
        /// <summary>
        /// 保证数组大小为size.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="arr"></param>
        /// <param name="size"></param>
        public static void EnsureSize<T>(ref T[] arr, int size)
        {
            if (arr.Length < size)
            {
                Array.Resize(ref arr, size);
            }
        }

        /// <summary>
        /// 返回指定索引处的对象,如果索引超出范围则返回null.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="arr"></param>
        /// <param name="index"></param>
        /// <returns></returns>
        public static T Get<T>(this T[] arr, uint index)
        {
            if (index >= arr.Length)
            {
                return default(T);
            }
            return arr[index];
        }

        /// <summary>
        /// 返回指定索引处的对象,如果索引超出范围则返回最后一个对象.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="arr"></param>
        /// <param name="index"></param>
        /// <returns></returns>
        public static T GetMax<T>(this T[] arr, uint index)
        {
            if (index >= arr.Length)
            {
                index = (uint)(arr.Length - 1);
            }
            return arr[index];
        }

        public static void Set<T>(ref T[] arr, uint index, T val)
        {
            if (index >= arr.Length)
            {
                EnsureSize(ref arr, (int)(index * LoadConstant) + 1);
            }
            arr[index] = val;
        }

        public static void Set<T>(ref T[] arr, uint index, T val, int maxSize)
        {
            if (index >= arr.Length)
            {
                EnsureSize(ref arr, maxSize);
            }
            arr[index] = val;
        }

        public static List<T> GetOrCreate<T>(ref List<T>[] arr, uint index)
        {
            if (index >= arr.Length)
            {
                EnsureSize(ref arr, (int)(index * LoadConstant) + 1);
            }

            var list = arr[index];
            if (list == null)
            {
                return arr[index] = new List<T>();
            }
            return list;
        }

        public static uint GetFreeIndex<T>(this T[] arr)
        {
            uint i = 0;
            for (; i < arr.Length; i++)
            {
                if (arr[i] == null || arr[i].Equals(default(T)))
                {
                    return i;
                }
            }
            return i;
        }

        /// <summary>
        /// 添加指定的值到数组中第一个未被占用的位置,超出范围时重新分配数组大小为原大小的1.5倍
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="arr"></param>
        /// <param name="val"></param>
        /// <returns></returns>
        public static uint Add<T>(ref T[] arr, T val)
        {
            var index = arr.GetFreeIndex();

            // no free space found: Make more space
            if (index >= arr.Length)
            {
                EnsureSize(ref arr, (int)(index * LoadConstant) + 1);
            }
            arr[index] = val;
            return index;
        }

        /// <summary>
        /// 添加指定的值到数组中第一个未被占用的位置,超出范围时重新分配数组大小为原大小+1
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="arr"></param>
        /// <param name="val"></param>
        /// <returns></returns>
        public static uint AddOnlyOne<T>(ref T[] arr, T val)
        {
            var index = arr.GetFreeIndex();

            // no free space found: Make more space
            if (index >= arr.Length)
            {
                EnsureSize(ref arr, (int)index + 1);
            }
            arr[index] = val;
            return index;
        }

        /// <summary>
        /// 添加指定的值到数组中第一个未被占用的位置,超出范围时将不进行添加
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="arr"></param>
        /// <param name="val"></param>
        /// <returns>添加位置的索引值</returns>
        public static int AddElement<T>(this T[] arr, T val)
        {
            var index = arr.GetFreeIndex();
            if (index < arr.Length)
            {
                arr[index] = val;
                return (int)index;
            }
            return -1;
        }

        /// <summary>
        /// 返回数组是否包含指定索引或指定索引处的值是否为null.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="arr"></param>
        /// <param name="index"></param>
        /// <returns></returns>
        public static bool ContainsIndex<T>(this T[] arr, uint index)
            where T : class
        {
            return index < arr.Length && arr[index] != null;
        }

        /// <summary>
        /// 返回数组中是否包含指定数组内的所有元素
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="arr"></param>
        /// <param name="arr2"></param>
        /// <returns></returns>
        public static bool EqualValues<T>(this T[] arr, T[] arr2)
            where T : struct
        {
            for (var i = 0; i < arr.Length; i++)
            {
                if (!arr[i].Equals(arr2[i]))
                {
                    return false;
                }
            }
            return true;
        }

        /// <summary>
        /// 返回数组中第一个与结构默认值相同的位置索引
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="arr"></param>
        /// <returns></returns>
        public static uint GetFreeValueIndex<T>(this T[] arr)
            where T : struct
        {
            uint i = 0;
            for (; i < arr.Length; i++)
            {
                if (arr[i].Equals(default(T)))
                {
                    return i;
                }
            }
            return i + 1;
        }

        /// <summary>
        /// 返回指定对象在数组中的索引位置
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="arr"></param>
        /// <param name="obj"></param>
        /// <returns></returns>
        public static int IndexOf<T>(this T[] arr, T obj)
            where T : class
        {
            for (int i = 0; i < arr.Length; i++)
            {
                if (arr[i].Equals(obj))
                {
                    return i;
                }
            }

            return -1;
        }

        /// <summary>
        /// 查找数组中由 predicate 方法返回值为true时的第一个对象,没有满足条件时则返回类型默认值.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="arr"></param>
        /// <param name="predicate"></param>
        /// <returns></returns>
        public static T GetWhere<T>(this T[] arr, Func<T, bool> predicate)
        {
            for (var i = 0; i < arr.Length; i++)
            {
                var item = arr[i];
                if (predicate(item))
                {
                    return item;
                }
            }
            return default(T);
        }
    }
}
