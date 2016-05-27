//
//  TitleModel.m
//  ScrollView
//
//  Created by vivo on 16/5/26.
//  Copyright © 2016年 vivo. All rights reserved.
//

#import "TitleModel.h"

@implementation TitleModel

-(void) setTitle:(NSString *)title{
    _title = title;
    _width = [self titleWidth];
}

-(CGFloat) titleWidth{
     return  [_title boundingRectWithSize:CGSizeMake(MAXFLOAT, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18]} context:nil].size.width+14.8;
}

@end
