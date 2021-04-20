//
//  HPInject.m
//  HPHook
//
//  Created by ZP on 2021/4/20.
//

#import "HPInject.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@implementation HPInject



//3.method_setImplementation 方式
+ (void)load {
    //拦截微信登录事件
    Class cls = objc_getClass("WCAccountMainLoginViewController");
    //获取method
    Method onNext = class_getInstanceMethod(cls,@selector(onNext));
    //get
    origin_onNext = method_getImplementation(onNext);
    //set
    method_setImplementation(onNext, new_onNext);
}

//原始imp
IMP (*origin_onNext)(id self, SEL _cmd);

//相当于imp
void new_onNext(id self, SEL _cmd) {
    //获取密码
    UITextField *textField = (UITextField *)[[self valueForKey:@"_textFieldUserPwdItem"] valueForKey:@"m_textField"];
    NSString *pwd = [textField text];
    NSLog(@"password: %@",pwd);
    origin_onNext(self,_cmd);
}


////2.class_replaceMethod 方式
//+ (void)load {
//    //拦截微信登录事件
//    Class cls = objc_getClass("WCAccountMainLoginViewController");
//    //替换
//    origin_onNext = class_replaceMethod(cls, @selector(onNext), new_onNext, "v@:");
//}
//
////原始imp
//IMP (*origin_onNext)(id self, SEL _cmd);
//
////相当于imp
//void new_onNext(id self, SEL _cmd) {
//    //获取密码
//    UITextField *textField = (UITextField *)[[self valueForKey:@"_textFieldUserPwdItem"] valueForKey:@"m_textField"];
//    NSString *pwd = [textField text];
//    NSLog(@"password: %@",pwd);
//    origin_onNext(self,_cmd);
//}


////1.class_addMethod 方式
//+ (void)load {
//    //拦截微信登录事件
//    Class cls = objc_getClass("WCAccountMainLoginViewController");
//    Method onNext = class_getInstanceMethod(cls, @selector(onNext));
//    //给WC添加新方法
//    class_addMethod(cls, @selector(new_onNext), new_onNext, "v@:");
//    //交换
//    method_exchangeImplementations(onNext, class_getInstanceMethod(cls, @selector(new_onNext)));
//}
//
////相当于imp
//void new_onNext(id self, SEL _cmd) {
//    //获取密码
//    UITextField *textField = (UITextField *)[[self valueForKey:@"_textFieldUserPwdItem"] valueForKey:@"m_textField"];
//    NSString *pwd = [textField text];
//    NSLog(@"password: %@",pwd);
//    [self performSelector:@selector(new_onNext)];
//}



// 方法交换，不能调用回原来的方法
//+ (void)load {
//    NSLog(@"HPInject Hook success");
//    //拦截微信登录事件
//    Method oldMethod = class_getInstanceMethod(objc_getClass("WCAccountMainLoginViewController"), @selector(onNext));
//    Method newMethod = class_getInstanceMethod(self, @selector(hook_onNext));
//    method_exchangeImplementations(oldMethod, newMethod);
//}
//
//- (void)hook_onNext {
//    NSLog(@"WeChat click login");
//    //获取密码
//    UITextField *textField = (UITextField *)[[self valueForKey:@"_textFieldUserPwdItem"] valueForKey:@"m_textField"];
//    NSString *pwd = [textField text];
//    NSLog(@"password: %@",pwd);
//    [self hook_onNext];
//}

//注册事件拦截
//+ (void)load {
//    NSLog(@"HPInject Hook success");
//    //拦截微信注册事件
//    Method oldMethod = class_getInstanceMethod(objc_getClass("WCAccountLoginControlLogic"), @selector(onFirstViewRegister));
//    Method newMethod = class_getInstanceMethod(self, @selector(hook_onFirstViewRegister));
//    method_exchangeImplementations(oldMethod, newMethod);
//}
//
//- (void)hook_onFirstViewRegister {
//    NSLog(@"WeChat click login");
//}

@end
