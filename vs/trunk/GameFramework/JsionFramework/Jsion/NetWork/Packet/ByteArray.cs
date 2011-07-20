using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Jsion.Interfaces;
using Jsion.Contants;
using JsionFramework.Jsion.Interfaces;

namespace Jsion.NetWork.Packet
{
    public class ByteArray : IDataInput, IDataOutput
    {
        protected byte[] m_buffer;

        public byte[] Buffer
        {
            get { return m_buffer; }
            set { m_buffer = value; }
        }

        /// <summary>
        /// 构造函数，缓冲区默认最小长度为：1024，默认字节码顺序为：EndianEnum.BIG_ENDIAN。
        /// </summary>
        public ByteArray()
        {
            endian = EndianEnum.BIG_ENDIAN;
            postion = 0;
            size = 2048;
            m_buffer = new byte[size];
        }
        /// <summary>
        /// 构造函数
        /// </summary>
        /// <param name="minSize">缓冲区最小长度</param>
        /// <param name="endianEnum">字节码顺序</param>
        public ByteArray(int minSize, EndianEnum endianEnum)
        {
            endian = endianEnum;
            postion = 0;
            dataLength = 0;
            size = minSize;
            m_buffer = new byte[size];
        }

        public EndianEnum endian { get; set; }

        public int postion { get; set; }

        public int size { get; set; }

        public int dataLength { get; set; }

        public bool readBoolean()
        {
            return m_buffer[postion++] != 0;
        }

        public sbyte readByte()
        {
            return (sbyte)m_buffer[postion++];
        }

        public byte[] readBytes(int length = 0)
        {
            length = (length == 0 ? length - postion : length);
            byte[] bytes = new byte[length];
            Array.Copy(m_buffer, postion, bytes, 0, length);
            postion += length;
            return bytes;
        }

        public double readDouble()
        {
            byte[] bytes = readBytes(8);
            refreshBytesByEndian(bytes);
            return BitConverter.ToDouble(bytes, 0);
        }

        public float readFloat()
        {
            byte[] bytes = readBytes(4);
            refreshBytesByEndian(bytes);
            return BitConverter.ToSingle(bytes, 0);
        }

        public int readInt()
        {
            byte[] bytes = readBytes(4);
            refreshBytesByEndian(bytes);
            return BitConverter.ToInt32(bytes, 0);
        }

        public short readShort()
        {
            byte[] bytes = readBytes(2);
            refreshBytesByEndian(bytes);
            return BitConverter.ToInt16(bytes, 0);
        }

        public byte readUnsignedByte()
        {
            return (byte)readByte();
        }

        public uint readUnsignedInt()
        {
            byte[] bytes = readBytes(4);
            refreshBytesByEndian(bytes);
            return BitConverter.ToUInt32(bytes, 0);
        }

        public ushort readUnsignedShort()
        {
            byte[] bytes = readBytes(2);
            refreshBytesByEndian(bytes);
            return BitConverter.ToUInt16(bytes, 0);
        }

        public string readUTF()
        {
            ushort len = readUnsignedShort();
            string temp = Encoding.UTF8.GetString(m_buffer, postion, len);
            postion += len;
            return temp.Replace("\0", "");
        }

        public DateTime readDate()
        {
            return new DateTime(readShort(), readByte(), readByte(), readByte(), readByte(), readByte());
        }








        private void refreshDataLength(int pos)
        {
            dataLength = (pos > dataLength ? pos : dataLength);
        }

        public void writeBoolean(bool value)
        {
            checkSize(postion);
            m_buffer[postion++] = (value ? (byte)1 : (byte)0);
            refreshDataLength(postion);
            //refreshLength();
        }

        public void writeByte(sbyte value)
        {
            writeUnsignedByte((byte)value);
        }

        public void writeUnsignedByte(byte value)
        {
            checkSize(postion);
            m_buffer[postion++] = value;
            refreshDataLength(postion);
            //refreshLength();
        }

        public void writeBytes(byte[] value, int offset = 0, int length = 0)
        {
            if (length == 0) length = value.Length - offset;
            if (checkSize(postion + length))
            {
                writeBytes(value, offset, length);
            }
            else
            {
                if (length == 0 || length > (value.Length - offset))
                    length = value.Length - offset;
                Array.Copy(value, offset, m_buffer, postion, length);
                postion += length;
                refreshDataLength(postion);
                //refreshLength();
            }
        }

        public void writeByteArray(ByteArray bytes, int offset = 0, int length = 0)
        {
            if (length <= 0) length = bytes.dataLength;
            writeBytes(bytes.Buffer, offset, length);
        }

        public void writeDouble(double value)
        {
            byte[] bytes = BitConverter.GetBytes(value);
            refreshBytesByEndian(bytes);
            writeBytes(bytes);
        }

        public void writeFloat(float value)
        {
            byte[] bytes = BitConverter.GetBytes(value);
            refreshBytesByEndian(bytes);
            writeBytes(bytes);
        }

        public void writeInt(int value)
        {
            byte[] bytes = BitConverter.GetBytes(value);
            refreshBytesByEndian(bytes);
            writeBytes(bytes);
        }

        public void writeUnsignedInt(uint value)
        {
            writeInt((int)value);
            //byte[] bytes = BitConverter.GetBytes(value);
            //refreshBytesByEndian(bytes);
            //writeBytes(bytes);
        }

        public void writeShort(short value)
        {
            byte[] bytes = BitConverter.GetBytes(value);
            refreshBytesByEndian(bytes);
            writeBytes(bytes);
        }

        public void writeUnsignedShort(ushort value)
        {
            writeShort((short)value);
        }

        public void writeUTF(string value)
        {
            if (String.IsNullOrEmpty(value) == false)
            {
                byte[] bytes = Encoding.UTF8.GetBytes(value);
                writeShort((short)(bytes.Length + 1));
                writeBytes(bytes);
                writeUnsignedByte(0x0);
            }
            else
            {
                writeShort((short)1);
                writeUnsignedByte(0x0);
            }
        }

        public void writeDate(DateTime date)
        {
            writeShort((short)date.Year);
            writeUnsignedByte((byte)date.Month);
            writeUnsignedByte((byte)date.Day);
            writeUnsignedByte((byte)date.Hour);
            writeUnsignedByte((byte)date.Minute);
            writeUnsignedByte((byte)date.Second);
        }
        /// <summary>
        /// 检查是否超出缓冲区大小，true为超出。
        /// </summary>
        /// <param name="pos"></param>
        /// <returns></returns>
        private bool checkSize(int pos)
        {
            if (pos >= m_buffer.Length)
            {
                byte[] temp = m_buffer;
                m_buffer = new byte[m_buffer.Length * 2];
                Array.Copy(temp, m_buffer, temp.Length);
                size = m_buffer.Length;
                return true;
            }
            return false;
        }

        //private void refreshLength()
        //{
        //    size = (postion > size ? postion : size);
        //}

        private void refreshBytesByEndian(byte[] bytes)
        {
            if (endian == EndianEnum.BIG_ENDIAN)
            {
                if (BitConverter.IsLittleEndian)
                    Array.Reverse(bytes);
            }
            else if (endian == EndianEnum.LITTLE_ENDIAN)
            {
                if (BitConverter.IsLittleEndian == false)
                    Array.Reverse(bytes);
            }
        }





        //////////////////////////////          缓冲区操作          //////////////////////////////

        /// <summary>
        /// 将 ByteArray 对象的缓冲区中 offset 参数指定位置开始的缓冲区数据复制到
        /// 起始于 dstOffset 参数指定位置的 dst 参数指定的缓冲区中
        /// </summary>
        /// <param name="dst">要复制到的目标缓冲区</param>
        /// <param name="dstOffset"> dst 中从零开始的字节偏移量</param>
        /// <param name="offset">当前ByteArray对象缓冲区从零开始的字节偏移量</param>
        /// <returns></returns>
        public virtual int CopyTo(byte[] dst, int dstOffset, int offset)
        {
            int len = Math.Min(dst.Length - dstOffset, dataLength - offset);

            if (len > 0)
                System.Buffer.BlockCopy(m_buffer, offset, dst, dstOffset, len);
            else
                len = 0;

            refreshDataLength(offset + len);

            return len;
        }
        /// <summary>
        /// 将 ByteArray 对象的缓冲区中 offset 参数指定位置开始的缓冲区数据复制到
        /// 起始于 dstOffset 参数指定位置的 dst 参数指定的缓冲区中（加密复制）
        /// </summary>
        /// <param name="dst">要复制到的目标缓冲区</param>
        /// <param name="dstOffset"> dst 中从零开始的字节偏移量</param>
        /// <param name="offset">当前ByteArray对象缓冲区从零开始的字节偏移量</param>
        /// <param name="crytor">加/解密器对象</param>
        /// <returns></returns>
        public virtual int CopyToEncryt(byte[] dst, int dstOffset, int offset, ICrytPackage crytor)
        {
            int len = Math.Min(dst.Length - dstOffset, dataLength - offset);

            if (len > 0)
            {
                for (int i = 0; i < len; i++)
                {
                    dst[dstOffset + i] = crytor.Encryt(m_buffer[offset + i]);
                }
            }
            else
            {
                len = 0;
            }

            refreshDataLength(offset + len);

            return len;
        }
        /// <summary>
        /// 将 ByteArray 对象的缓冲区中 offset 参数指定位置开始的缓冲区数据复制到
        /// 起始于 dstOffset 参数指定位置的 dst 参数指定的缓冲区中（解密复制）
        /// </summary>
        /// <param name="dst">要复制到的目标缓冲区</param>
        /// <param name="dstOffset"> dst 中从零开始的字节偏移量</param>
        /// <param name="offset">当前ByteArray对象缓冲区从零开始的字节偏移量</param>
        /// <param name="crytor">加/解密器对象</param>
        /// <returns></returns>
        public virtual int CopyToDecryt(byte[] dst, int dstOffset, int offset, ICrytPackage crytor)
        {
            int len = Math.Min(dst.Length - dstOffset, dataLength - offset);

            if (len > 0)
            {
                for (int i = 0; i < len; i++)
                {
                    dst[dstOffset + i] = crytor.Decryt(m_buffer[offset + i]);
                }
            }
            else
            {
                len = 0;
            }

            refreshDataLength(offset + len);

            return len;
        }

        /// <summary>
        /// 在 src 参数指定的缓冲区中，从 srcOffset 参数指定的位置开始将 count 参数指定的长度
        /// 复制到起始于 offset 参数指定位置的当前 ByteArray 对象缓冲区
        /// </summary>
        /// <param name="src">源缓冲区</param>
        /// <param name="srcOffset"> src 中从零开始的字节偏移量</param>
        /// <param name="offset">当前ByteArray对象缓冲区从零开始的字节偏移量</param>
        /// <param name="count">要复制的字节数，如果超出缓冲区则仅复制有效缓冲区数据</param>
        /// <returns>复制的字节数</returns>
        public virtual int CopyFrom(byte[] src, int srcOffset, int offset, int count)
        {
            var canCopyLen = Math.Min(src.Length - srcOffset, size - offset);
            count = Math.Min(count, canCopyLen);
            refreshDataLength(offset + count);
            if (count > 0)
            {
                System.Buffer.BlockCopy(src, srcOffset, m_buffer, offset, count);
                return count;
            }

            return 0;
        }
        /// <summary>
        /// 在 src 参数指定的缓冲区中，从 srcOffset 参数指定的位置开始将 count 参数指定的长度
        /// 复制到起始于 offset 参数指定位置的当前 ByteArray 对象缓冲区（解密复制）
        /// </summary>
        /// <param name="src">源缓冲区</param>
        /// <param name="srcOffset"> src 中从零开始的字节偏移量</param>
        /// <param name="offset">当前ByteArray对象缓冲区从零开始的字节偏移量</param>
        /// <param name="count">要复制的字节数，如果超出缓冲区则仅复制有效缓冲区数据</param>
        /// <param name="crytor">加/解密器对象</param>
        /// <returns>复制的字节数</returns>
        public virtual int CopyFromDecryt(byte[] src, int srcOffset, int offset, int count, ICrytPackage crytor)
        {
            var canCopyLen = Math.Min(src.Length - srcOffset, size - offset);
            count = Math.Min(count, canCopyLen);
            refreshDataLength(offset + count);
            if (count > 0)
            {
                for (int i = 0; i < count; i++)
                {
                    m_buffer[offset + i] = crytor.Decryt(src[srcOffset + i]);
                }
                return count;
            }

            return 0;
        }
        /// <summary>
        /// 在 src 参数指定的缓冲区中，从 srcOffset 参数指定的位置开始将 count 参数指定的长度
        /// 复制到起始于 offset 参数指定位置的当前 ByteArray 对象缓冲区（加密复制）
        /// </summary>
        /// <param name="src">源缓冲区</param>
        /// <param name="srcOffset"> src 中从零开始的字节偏移量</param>
        /// <param name="offset">当前ByteArray对象缓冲区从零开始的字节偏移量</param>
        /// <param name="count">要复制的字节数，如果超出缓冲区则仅复制有效缓冲区数据</param>
        /// <param name="crytor">加/解密器对象</param>
        /// <returns>复制的字节数</returns>
        public virtual int CopyFromEncryt(byte[] src, int srcOffset, int offset, int count, ICrytPackage crytor)
        {
            var canCopyLen = Math.Min(src.Length - srcOffset, size - offset);
            count = Math.Min(count, canCopyLen);
            refreshDataLength(offset + count);
            if (count > 0)
            {
                for (int i = 0; i < count; i++)
                {
                    m_buffer[offset + i] = crytor.Encryt(src[srcOffset + i]);
                }
                return count;
            }

            return 0;
        }


        //////////////////////////////          缓冲区操作          //////////////////////////////
    }
}
