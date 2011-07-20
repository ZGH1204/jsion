using System;
using System.Collections.Generic;
using System.Text;

namespace SJSCAN.HandlersLib
{
    public static class eHandlerTypes
    {
        public const string INSTALLSYS = "InstallSys";

        public const string LOGIN = "Login";
        public const string LOGOUT = "Logout";
        public const string ADDUSER = "AddUser";
        public const string DELUSER = "DelUser";
        public const string ENABLEUSER = "EnableUser";
        public const string DISABLEUSER = "DisableUser";
        public const string GETUSERLIST = "GetUserList";

        public const string RETURNCASH = "ReturnCash";
        public const string DEDUCTION = "Deduction";

        public const string USERBALANCE = "UserBalance";
        public const string RESETPASSWD = "ResetPasswd";

        public const string SETADMIN = "SetAdmin";
        public const string SETNORMAL = "SetNormal";

        public const string GETBALANCELIST = "GetBalanceList";

        public const string ADDSHOP = "AddShop";
        public const string EDITSHOP = "EditShop";
        public const string DELSHOP = "DelShop";
        public const string GETSHOPLIST = "GetShopList";

        public const string ADDTRADE = "AddTrade";
        public const string EDITTRADE = "EditTrade";
        public const string DELTRADE = "DelTrade";
        public const string GETTRADELIST = "GetTradeList";

        public const string ADDBOOKING = "AddBooking";
        public const string DELBOOKING = "DelBooking";
        public const string FINISHBOOKING = "FinishBooking";
        public const string SETTLEBOOKING = "SettleBooking";
        public const string GETBOOKINGLIST = "GetBookingList";
        public const string GETBOOKINGLISTBYDATE = "GetBookingListByDate";
        public const string QUERYBOOKINGSHOPLISTBYDATE = "QueryBookingShopListByDate";
        public const string QUERYBOOKINGEDLIST = "QueryBookingedList";
        public const string GETBOOKINGSHOPLISTBYDATE = "GetBookingShopListByDate";
        public const string GETBOOKINGSHOPONLINELIST = "GetBookingshopOnlineList";

        public const string JOINBOOKING = "JoinBooking";

        public const string DELBOOKINGSHOP = "DelBookingShop";
        public const string GETBOOKINGSHOPLIST = "GetBookingShopList";


        public const string BOOKINGONLINE = "BookingOnline";
        public const string CANCELBOOKINGED = "CancelBookinged";
        public const string GETBOOKINGEDLIST = "GetBookingedList";
        public const string GETCURRENTBOOKINGEDLIST = "GetCurrentBookingedList";


        public const string GETUSERINFO = "GetUserInfo";

        public const string GETBOOKINGRECORDLIST = "GetBookingRecordList";
        public const string GETDEDUCTIONRECORDLIST = "GetDeductionRecordList";

        public const string EXPORTXLS = "ExportXLS";
    }
}
