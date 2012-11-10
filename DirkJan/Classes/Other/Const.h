//
//  Const.h
//  DirkJan
//
//  Created by Hendrik Bruinsma on 08-09-12.
//  Copyright (c) 2012 Hendrik Bruinsma. All rights reserved.
//

#ifndef DirkJan_Const_h
#define DirkJan_Const_h

#define kEnableEmail YES
#define kEnableTwitter YES
#define kEnableFaceBook NO

#define kHttpUserAgentiPhone @"[DirkJan]:[iPhone]:[1.0]"
#define kHttpUserAgentiPad @"[DirkJan]:[iPad]:[1.0]"

#define kCartoonUrl @"http://marijnzwemmer.com/websites/dirkjan/getAllJSON.php"
#define kCartoonDateFormat @"yyyy-MM-dd"
#define kCartoonFetchLimit 50

// Defining the app to look a litle like Dirk Jan.
// e.g. the navigationController his head, the table view his shirt and the tabbar his jeans

#define kColourNavigationBar 0xFBF39E
#define kColourNavigationButtons 0x414141

#define kColourOddCells 0xFF802E
#define kColourEvenCells 0xEC3D19
#define kColourCellSeperator 0x000000
#define kColourCellsInaRow 3

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define Retina ([UIScreen mainScreen].scale == 2.0f)
#define iPhone5 ([[UIScreen mainScreen] bounds].size.height == 568.0)

#endif
