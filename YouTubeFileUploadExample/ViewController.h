//
//  ViewController.h
//  YouTubeFileUploadExample
//
//  Created by Alok on 08/05/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDataYouTube.h"

@interface ViewController : UIViewController
{
    GDataFeedYouTubeVideo *mEntriesFeed;
    GDataServiceTicket *mEntriesFetchTicket;
    NSError *mEntriesFetchError;
    NSString *mEntryImageURLString;
}

@property (nonatomic, retain) GDataFeedYouTubeVideo *mEntriesFeed;
@property (nonatomic, retain) GDataServiceTicket *mEntriesFetchTicket;
@property (nonatomic, retain) NSError *mEntriesFetchError;
@property (nonatomic, copy)   NSString *mEntryImageURLString;



-(GDataServiceGoogleYouTube *)youTubeService;

@end
