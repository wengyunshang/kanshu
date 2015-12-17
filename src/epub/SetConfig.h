//
//  SetConfig.h
//  DontTry
//
//  Created by weng xiangxun on 13-1-15.
//  Copyright (c) 2013年 weng xiangxun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WxxConstants.h"
#import "SecurityUtil.h"
#define tabHeight 110
#define HEADRUL @"headurl"
#define yesDown @"1"
#define noDown @"0"
#define showAlert(atitle,amessage) UIAlertView *alert = [[UIAlertView alloc] initWithTitle:atitle message:amessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];[alert show];[alert release]
#define WXXHTTPUTIL [WxxHttpUtil sharedWxxHttpUtil] //网络http接口单例
#define WXXSTARDATA [WXXBASEINFOUTIL getStarData]
#define WXXNSLOG(str)  NSLog(str)
#define cellImage @"cellImgBack"
//*************baiduPush********************//
#define BAIDUUSERID @"us_baiduuserid"
#define BAIDUCHANNELID @"us_baiduchannelid"
//*************加密*******************
#import "SecurityUtil.h"
#define ENCODEBase64String(str) [SecurityUtil encodeBase64String:str]
#define DECODEBase64String(str) [SecurityUtil decodeBase64String:str]
//#define admobPageId @"" //插页
#define BACKCOLOR [UIColor whiteColor]//[UIColor colorWithRed:242/255.f green:241/255.f blue:227/255.f alpha:1]
//****************返回值判定**************************************//
#define ERROR @"error"
#define SUCCESS @"success"
#define WXXBACKSUCCESS(dic) [[dic objectForKey:@"back"] isEqualToString:SUCCESS] //返回值正确判断
#define WXXBACKERROR(dic) [[dic objectForKey:@"back"] isEqualToString:ERROR]  //返回值错误判断
//*****************YN ios7********************************//
#define YNIOS7() -(void)ynios7{if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){return YES;}else{return NO;}}
#define WXXCOLOR(r,g,b,alp) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alp]
#define fontTTFToSize(sizes) [UIFont fontWithName:@"STHeitiSC-Light" size:sizes]
#define fontTTFBOLDToSize(sizes) [UIFont fontWithName:@"STHeitiSC-Light" size:sizes]
#define fontToSize(sizes) [UIFont fontWithName:@"STHeitiSC-Light" size:sizes]
#define fontboldToSize(size) [UIFont fontWithName:@"STHeitiSC-Light" size:size]
//*************url***************************************//
//#define url @"http://wxxdriftbottle.duapp.com/"
//#define httpurl @"http://localhost/paperPlane/"

//#define httpurl @"http://localhost/ace/webroot/"   //穿越小说
#define httpurl @"http://huuua.com/epubWeb/"   //穿越小说

//分类logo现在替换到七牛服务器(以后的图片会逐渐使用七牛来存储)
//#define httpiconurl @"http://pkg.gao7gao8.com/epub/icon/"   //icon
#define httpiconurl @"http://7xo9hv.com1.z0.glb.clouddn.com/"   //icon


//#define httpurl @"http://englishepub.qiniudn.com/"   //英文书籍
#define wxxbaseURL [NSString stringWithFormat:@"%@%@",httpurl,@"index.php"]
#define wxxFileUrl(str) [NSString stringWithFormat:@"%@%@",httpurl,str]

#define ShowLocali(str) NSLocalizedString(str,nil) //国际化

#define enumToObj(enum) [NSNumber numberWithInt:enum] //枚举转num

#define UIBounds [[UIScreen mainScreen] bounds] //window外框大小

#define kWxxErrorDomain @"网络错误"

typedef enum{
    blBianji,//编辑
    blQuanxuan,//全选
    blQuxiao,//取消
    blShangchuan,//上传
    
}BooksListSelectType;

//**********应用名称, 用来区分不同应用加载不同资源和数据库生成数据**********//
typedef enum{
    BTbingyuhuozhige,//冰与火之歌
    BTshijing,       //诗经
    BTxiaoshuo,      //《小说》应用
    BTmonvtianjiao,  //魔女天骄美人痣
    BThanfeizi,      //韩非子
    BTchuanyue,      //穿越
    BTfojing,        //佛经
    BTguwen,         //古文
    BTjingdu,        //静读时光
    BTjinyong,       //金庸全集
    BTHanhan,        //韩寒的作品
    BTLiangyusheng,  //梁羽生全集
    BTmoyan,         //莫言精品全集
    BTzhangailin,    //张爱玲精品全集
    BTloucaining,    //楼采凝作品集
    BTqiongyao,      //琼瑶文学集
    BTGulong,        //古龙小说全集
    BTWolongsheng,   //卧龙生武侠小说
    BTHuangyi,       //黄易
    BTXiaoxiong,     //小熊看书
    BTStaticread,    //静读天下
    BTWaituomingzhu, //外国名著
    BTGuoguo,        //花千骨
    BTMingxiaoxi,    //明晓溪
    BTXijuan,        //席绢
}bookType;

//*******
typedef enum{
    setSelectNull,
    setSelectAddFont, //加大文字
    setSelectDelFont, //缩小文字
    setSelectLineOrg1,//板式1
    setSelectLineOrg2,//板式1
    setSelectLineOrg3,//板式1
    setSelectgrayWhite,//淡白
    setSelectWhite,//白
    setSelectOrage, //蓝色
    setSelectNight,//黑色
    setSelectVirescence,//淡绿色
    setSelectSepia,//     深褐色
    setToolFont,//工具栏字体
    setToolLight,//工具栏亮度
    setToolChapter,//工具栏目录
    setToolBack,//工具栏返回
}setSelectType;  //读书界面设置选中的内容
//***********app分类， 当前app的  更多好书 是获取那个分类的书籍
#define bookXiaoshuo @"3" // 小说
#define bookAppstore @"5" // appstore
#define bookFojing   @"7" // 佛经
#define bookGudianwenxue    @"6" // 古典文学
#define bookGuwen    @"13" // 古文
#define bookChuanyue    @"11" // 穿越
#define bookEnglishBook @"12" //英文
#define bookJingdu @"15" //
#define bookJinYong @"16" //金庸全集
#define bookHanHan @"17" //韩寒的作品
#define bookLiangyusheng @"18" //梁羽生全集
#define bookMoyan @"19" //莫言精品全集
#define bookZhangailin @"20" //张爱玲精品全集
#define bookQiongyao @"21" //琼瑶文学集
#define bookGulong @"22" //古龙
#define bookLoucaining @"23"//楼采凝
#define bookWolongsheng @"24"//卧龙生
#define bookHuangyi @"25"
#define bookXiaoxiong @"44"
#define bookStaticread @"46" //静读天下
#define bookWaiguomingzhu @"50" //外国名著
#define bookMingxiaoxi @"51" //明晓溪
#define bookGuoguo @"52" //花千骨
#define bookXijuan @"53" //席绢
////判断是否为iPhone
#define IS_IPHONE ([[UIDevice currentDevice] userInterfaceIdiom] ==  UIUserInterfaceIdiomPhone)
//判断是否为iPad
#define IS_IPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//判断是否为ipod
#define IS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])
//判断是否为iPhone5
#define IS_IPHONE_5_SCREEN [[UIScreen mainScreen] bounds].size.height >= 568.0f && [[UIScreen mainScreen] bounds].size.height < 1024.0f

#define statuStarBarWidth (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 1024: 320

#define bodyFont @"bodyFont"
#define bodyColor @"bodyColor"
#define bodyFontOrg @"bodyFontOrg"
#define selectTypeKey @"selectType"
#define bookWidth 80
#define bookHeight bookWidth*8/6
#define bookOgrx (UIBounds.size.width-bookWidth*3)/4
