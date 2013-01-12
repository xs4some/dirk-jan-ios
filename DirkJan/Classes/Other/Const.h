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

#define kHttpUserAgentiPhone @"[DirkJan]:[iPhone]:[2.0]"
#define kHttpUserAgentiPad @"[DirkJan]:[iPad]:[2.0]"

#define kCartoonUrl @"http://marijnzwemmer.com/websites/dirkjan/getAllJSON.php"
#define kCartoonAlbumUrl @"https://graph.facebook.com/163562567032164/photos?fields=name,link,id&limit=%d"
#define kCartoonDetailsUrl @"https://graph.facebook.com/%@?fields=source,likes.limit(5000)"
#define kCartoonDateFormat @"yyyy-MM-dd"
#define kCartoonDisplayDateFormat @"d MMMM yyyy"
#define kRfc822DateFormat @"yyyy-MM-dd'T'HH:mm:ssZZZ"
#define kCartoonFetchLimit 50

// Defining the app to look a litle like Dirk Jan.
// e.g. the navigationController his head, the table view his shirt and the tabbar his jeans

#define kColourNavigationBar 0xFBF39E
#define kColourNavigationButtons 0x414141

#define kColourOddCells 0xFF802E
#define kColourEvenCells 0xEC3D19
#define kColourSeenCells 0xFBF39E
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
