var ADMIN_AJAX_PATH = '/Ajax.aspx';
var ADMIN_LOGIN_PATH = '/Login.ashx';
var TIP_TITLE = '提示';
var COMPANY = 'XX有限公司';
var COMPANY_SHORTHAND = 'XX公司';
var LOGINWIN_TITLE = '点餐系统登录';
var COPYRIGHT = '<p style="text-align: center; font-size: 13px; padding-top: 20px;">版权信息&copy;2010</p>'+
                '<p style="text-align: center; font-size: 10px; padding-top: 3px;"><a href="javascript:void(0);">本系统下载</a></p>';
var COPYRIGHT_TITLE = '版权信息';
var CONTACT_US_TITLE = '联系我们';
var SUBMIT_TEXT = '提交';

var EAST_PROPERTY_SOURCE = {
//    "当前用户"      :       curRname,
//    "余额"          :       shengyu
//  "公司名称"      :       COMPANY,
//	'移交日期'		:		new Date(Date.parse('2010/08/20')),
//  '版本'          :       'V1.0.0'
//	'联系 Q Q'		:		'78102212',
//	'联 系 人'		:		'苏金水'
//	'体重'		:		130,
//	'生日'		:		new Date(Date.parse('1986/12/22')),
//	'婚否'	:		false,
//	'身高'		:		1.70
}; //右侧属性窗口的数据源
//if (curRname)
//    EAST_PROPERTY_SOURCE["当前用户"] = curRname;

var USERNAME_LABEL = '用 户 名';  //用户名输入框的标签
var USERNAME_EMPTY_TIP = '请输入用户名..'; //当用户名输入框为空时的提示信息
var USERNAME_BLANK_TEXT = '用户名不能为空!';//当验证用户名为空时的提示文字
var USERNAME_MAX_TEXT = '用户名允许的最大长度为:';//超过用户名允许长度时的提示信息
var USERNAME_MIN_TEXT = '用户名允许的最小长度为:';//小于用户名允许长度时的提示信息

var PASSWD_LABEL = '密　　码'; //密码输入框的标签
var RE_PASSWD_LABEL = '确认密码';
var PASSWD_BLANK_TEXT = '密码不能为空!';//当验证密码为空时的提示文字
var PASSWD_MAX_TEXT = '密码允许的最大长度为:';//超过密码允许长度时的提示信息
var PASSWD_MIN_TEXT = '密码允许的最小长度为:'; //小于密码允许长度时的提示信息

var RNAME_LABEL = '姓　　名';
var RNAME_BLANK_TEXT = '姓名不能为空..';
var RNAME_MAX_TEXT = '姓名允许的最大长度为:';
var RNAME_MIN_TEXT = '姓名允许的最小长度为:';

var REGISTER_TEXT = '提交';
var REGISTER_SUCCESS_TEXT = '注册成功,5秒后自动跳转!';
var REGISTER_ERROR_TEXT = '注册失败,原因:';

var LOGINBTN_TEXT = '登陆';//登陆按钮的文字
var LOGINBTN_WAIT_MSG = '正在提交数据...';//点击后提示文字的内容
var LOGINBTN_SUCCESS_TEXT = '登录成功,5秒后自动跳转!';//登陆成功后的提示信息
var LOGINBTN_ERROR_TEXT = '登陆失败,原因:';//登陆失败后的提示信息

var RELOGIN_LABEL = '重新登陆';//重新登陆按钮文本

var NAVIGATE_TITLE = '系统导航';//左侧导航菜单标题
var GLOBAL_SETTING_TITLE = '全局设置';//全局设置标题
var ADMIN_MANAGE_TITLE = '用户管理';//管理员管理标题
var INFO_MANAGE_TITLE = '信息管理';//信息、资讯管理标题
var PUBLISH_MANAGE_TITLE = '发布管理';//发布管理标题

var REALNAME_BLANK_TEXT = '姓名不能为空!';//当验证姓名为空时的提示文字
var REALCARD_BLANK_TEXT = '身份证不能为空!';//当验证身份证为空时的提示文字
var READCARD_MAX_TIP = '身份证允许的最大长度为:';//身份证最大长度验证提示
var READCARD_MIN_TIP = '身份证允许的最小长度为:';//身份证最小长度验证提示

var QUESTION_BLANK_TEXT = '提示问题不能为空!';//提示问题为空时的提示文字
var QUESTION_MAX_TIP = '提示问题最大长度为:';//提示问题超过最大长度时的提示文字
var QUESTION_MIN_TIP = '提示问题最小长度为:';//提示问题小于最小长度时的提示文字

var ANSWER_BLANK_TEXT = '问题答案不能为空!';//问题答案为空时的提示文字
var ANSWER_MAX_TIP = '问题答案最大长度为:';//问题答案超过最大长度时的提示文字
var ANSWER_MIN_TIP = '问题答案最小长度为:';//问题答案小于最小长度时的提示文字