//
//  GlobleHelp.swift
//  jadeApp2
//
//  Created by JD on 2017/1/13.
//  Copyright © 2017年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

import Foundation

/**
 获取指定类的属性和属性值  返回一个以属性名的为键 属性值为值的 字典
 */
func getClassAllPorp(aObject:AnyObject, filter:NSArray) -> NSDictionary {
    var count: UInt32 = 0
    //获取类的属性列表,返回属性列表的数组,可选项
    let list = class_copyPropertyList(aObject.classForCoder, &count)
    print("属性个数:\(count)")
    let propDic :NSMutableDictionary = NSMutableDictionary.init()
    for i in 0..<Int(count) {
        //根据下标获取属性
        let pty = list?[i]
        //获取属性的名称<C语言字符串>
        //转换过程:Int8 -> Byte -> Char -> C语言字符串
        let cName = property_getName(pty!)
        //转换成String的字符串
        let name = String(utf8String: cName!)
        var k : NSInteger = 0
        for str:String in filter as![String] {
            if str == name{
                k = k+1
            }
        }
        if k==0  {
            propDic.setValue(aObject.value(forKey: name!), forKey: name!)
            print(name!)
        }
    }
    free(list) //释放list
    return propDic
}
