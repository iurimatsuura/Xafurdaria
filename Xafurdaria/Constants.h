//
//  Constants.h
//  Xafurdaria
//
//  Created by Iuri Matsuura on 18/08/14.
//  Copyright (c) 2014 Iuri Mac. All rights reserved.
//

#ifndef Xafurdaria_Constants_h
#define Xafurdaria_Constants_h

#define kNewVideoNotification @"kNewVideoNotification"

#define kAppDelegatePlaylistItemsUrl @"https://www.googleapis.com/youtube/v3/playlistItems?part=id,snippet,contentDetails&maxResults=1&playlistId=UU21wUP_bie85msUyT3eJnew&key=AIzaSyA7-TdCyHBVFoGvp2oixemxDX72a_C0Xcs"

#define kPlaylistItemsUrl @"https://www.googleapis.com/youtube/v3/playlistItems?part=id,snippet,contentDetails&maxResults=10&playlistId=UU21wUP_bie85msUyT3eJnew&key=AIzaSyA7-TdCyHBVFoGvp2oixemxDX72a_C0Xcs&pageToken=%@"

#define kVideoUrl @"https://www.googleapis.com/youtube/v3/videos?id=%@&part=snippet,contentDetails,statistics&fields=items&key=AIzaSyA7-TdCyHBVFoGvp2oixemxDX72a_C0Xcs"

#endif
