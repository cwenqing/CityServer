//
//  URLConfig.h
//  CityServer
//
//  Created by 陈文清 on 2017/12/18.
//  Copyright © 2017年 陈文清. All rights reserved.
//

#import <Foundation/Foundation.h>

//正式环境服务器地址
#define MAIN_PATH @"http://api.tchutong.com/customer"

//测试环境服务器地址
//#define MAIN_PATH @"http://47.92.131.197:81/customer"

#define IMAGE_PATH @""

//检查更新
#define CHECKUPDATE_URL @"/upgrade"

//上传动态文件
#define UPLOADFILE_URL @"/fileupload/upload/topic"

//上传名片文件
#define UPLOADCARD_URL @"/fileupload/upload/card"

//上传头像文件
#define UPLOADHEAD_URL @"/fileupload/upload/avatar"

//获取短信验证码
#define SMSSEND_URL @"/sms/smsSend"

//是否显示普通用户
#define MEMBERTYPE_RUL @"/config/memberType"

//登录
#define LOGIN_RUL @"/user/login"

//忘记密码
#define RECOVERYPASSWORD_URL @"/user/recoveryPassword"

//注册(支付版)
#define REGISTER_URL @"/user/register"

//注册(ios非支付版)
#define IOSREGISTER_URL @"/user/appRegister"

//支付宝会员办理
#define ALIMEMBERPAYORDER_URL @"/memberpay/aliMemberPayOrder"

//微信会员办理
#define WXMEMBERPAYORDER_URL @"/memberpay/wxPayOrderInfo"

//更新经纬度
#define UPDATESITR_URL @"/me/baseInfo/site"

//动态发帖
#define SUBMITTOPIC_URL @"/dynamic/submitTopic"

//搜索服务列表
#define SEARCHSERVERUSER_URL @"/search/searchServerUser"

//同城服务发帖
#define SUBMITSAMECITYSERVER_URL @"/dynamic/submitServerTopic"

//公益服务发帖
#define SUBMITWEALSERVER_URL @"/dynamic/submitCommonwealTopic"

//同城动态列表
#define CITYDYNAMIC_URL @"/dynamic/searchSameCityDynamic"

//好友动态列表
#define FRIENDDYNAMIC_URL @"/dynamic/searchFriendDynamic"

//动态点赞
#define DYNAMICSUPPORT @"/dynamic/dynamicSupport"

//动态取消点赞
#define DYNAMICUNSUPPORT @"/dynamic/dynamicUnsupport"

//同城服务列表
#define SAMESERVER_URL @"/dynamic/sameCityServer"

//公益服务列表
#define WEALSERVER_URL @"/dynamic/searchCommonweal"

//评论列表
#define COMMENTLIST_URL @"/comment/searchComment"

//评论
#define COMMENT_URL @"/comment/createComment"

//我的关注
#define FOLLOWS_UEL @"/attention/followers"

//我的粉丝
#define FANS_URL @"/attention/fans"

//推荐关注人
#define RECOMMENDERS_URL @"/attention/recommenders"

//添加关注
#define ADDATTENTION_URL @"/attention/add"

//取消关注
#define CANCELATTENTION_URL @"/attention/cancel"

//通讯录
#define CONTACTS_URL @"/contact/list"

//通讯录好友名片
#define CONTACTSCARD_URL @"/me/card/default"

//获取用户服务
#define USERDYNAMIC_URL @"/personDynamic/userDynamic"

//我的主页
#define MEMBERCENTER_URL @"/me/overview"

//修改资料
#define UPDATEINFO_URL @"/me/baseInfo/update"

//我的动态
#define MYDYNAMIC_URL @"/personDynamic/myDynamic"

//我的公益
#define MYCOMMONWEAL_URL @"/personDynamic/myCommonweal"

//删除动态
#define DELETEDYNAMIC_URL @"/dynamic/delDynamic"

//我的名片列表
#define MYCARDLIST_URL @"/me/card/list"

//名片详情
#define CARDDETAIL_URL @"/me/card/detail"

//新增名片
#define ADDCARD_URL @"/me/card/add"

//修改名片
#define UPDATECARD_URL @"/me/card/update"

//设置默认名片
#define MAINCARD_URL @"/me/card/main"

//删除名片
#define DELETECARD_URL @"/me/card/delete"

//我的服务
#define MYSERVER_URL @"/personDynamic/myServer"

//关闭服务
#define SERVERRESOLVE_URL @"/personDynamic/serverResolve"

//推荐码图片
#define QRCODE_URL @"/me/qrcode"

//修改密码
#define UPDATEPASSWORD_URL @"/user/updatePassword"
@interface URLConfig : NSObject


@end
