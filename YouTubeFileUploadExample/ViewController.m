//
//  ViewController.m
//  YouTubeFileUploadExample
//
//  Created by Alok on 08/05/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import "ViewController.h"





#import "GDataServiceGoogleYouTube.h"
#import "GDataEntryPhotoAlbum.h"
#import "GDataEntryPhoto.h"
#import "GDataFeedPhoto.h"
#import "GDataEntryYouTubeUpload.h"
#import "GTMOAuth2Authentication.h"
#import "GTMOAuth2ViewControllerTouch.h"

///////////////////////////////////////////////////////////////////////////////////////////////
//constants related to youtube/////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
static NSString *const kKeychainItemName = @"YouTubeMobile: YouTube";
static NSString *const kMyClientID       = @"Put your client id here";
static NSString *const kMyClientSecret   = @"Put your client secret here";
static NSString *const kMyDeveloperKey   = @"Put your developer key here";
///////////////////////////////////////////////////////////////////////////////////////////////
//constants related to youtube/////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////



@interface ViewController ()

@end

@implementation ViewController

@synthesize mEntriesFeed,mEntriesFetchError,mEntryImageURLString,mEntriesFetchTicket;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self signInToYoutube];

}






















#pragma mark- Methods Related for UTube Video Uploading


//this method returns the static instance of GDataServiceGoogleYouTube object , which is the controller for utube related operations
- (GDataServiceGoogleYouTube *)youTubeService
{
    static GDataServiceGoogleYouTube* service = nil;
    if (!service)
    {
        service = [[GDataServiceGoogleYouTube alloc] init];
        [service setShouldCacheResponseData:YES];
        [service setServiceShouldFollowNextLinks:YES];
        [service setIsServiceRetryEnabled:YES];
    }
    
    NSString *devKey = @"AI39si6Q4H82CkOesBF8sy5f4cPbUoyPm8T0Bctkr15q4su2Wjo2u9T3g7eliQA2QlnWICIhC-huB5yLHRhVQL_RetaE_z1QFQ";
    [service setYouTubeDeveloperKey:devKey];
    return service;
}


-(void)uploadToYouTube
{        
    if ([[[self youTubeService] authorizer] canAuthorize])
    {
        [self viewController:nil finishedWithAuth:nil error:nil];
    }
    else
    {
        [self signInToYoutube];
    }
}


- (void)signInToYoutube
{
    GTMOAuth2ViewControllerTouch *viewController =
    [[GTMOAuth2ViewControllerTouch alloc] initWithScope:[GDataServiceGoogleYouTube authorizationScope]
                                                        clientID:kMyClientID
                                                        clientSecret:kMyClientSecret
                                                        keychainItemName:kKeychainItemName
                                                        delegate:self
                                                        finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    
	[self.navigationController pushViewController:viewController animated:NO];

}

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error
{
    // Callback from OAuth 2 sign-in
    if (error == nil)
	{
        if (auth!=nil)
            [[self youTubeService] setAuthorizer:auth];
        
        NSLog(@"success login");
		
        GDataServiceGoogleYouTube *service = [self youTubeService];
        NSURL *url = [GDataServiceGoogleYouTube youTubeUploadURLForUserID:kGDataServiceDefaultUser];
		
		GDataMediaTitle *title = [GDataMediaTitle textConstructWithString:@"SWAG"];
		
        GDataMediaCategory *category = [GDataMediaCategory mediaCategoryWithString:@"Comedy"];
        [category setScheme:kGDataSchemeYouTubeCategory];
		
        GDataMediaDescription *desc = [GDataMediaDescription textConstructWithString:@"I have uploaded a new video onto SWAG Enjoy watching"];
        
        GDataMediaKeywords *keywords = [GDataMediaKeywords keywordsWithString:@"Using SWAG"];
        
        
        GDataYouTubeMediaGroup *mediaGroup = [GDataYouTubeMediaGroup mediaGroup];
        [mediaGroup setMediaTitle:title];
        [mediaGroup setMediaDescription:desc];
        [mediaGroup addMediaCategory:category];
        [mediaGroup setMediaKeywords:keywords];
        [mediaGroup setIsPrivate:NO];
        
        NSString *mimeType = @"video/m4v";
        
		NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"YouTubeTest" ofType:@"m4v"]];
		        
        GDataEntryYouTubeUpload *entry = [GDataEntryYouTubeUpload uploadEntryWithMediaGroup:mediaGroup data:data MIMEType:mimeType slug:@"testing"];
		
        GDataServiceTicket *ticket;
        ticket = [service fetchEntryByInsertingEntry:entry forFeedURL:url delegate:self
								   didFinishSelector:@selector(uploadTicket:finishedWithEntry:error:)];
    }
    else
	{
        self.mEntriesFetchError = error;
        NSLog(@"fail login");
    }
}


// upload callback
- (void)uploadTicket:(GDataServiceTicket *)ticket finishedWithEntry:(GDataEntryYouTubeVideo *)videoEntry error:(NSError *)error
{
    if (error == nil)
	{
        NSLog(@"successfully uploaded");
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil message:@"Successfully uploaded on YouTube" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
		
    }
	else
	{
        UIAlertView *errAlert =[[UIAlertView alloc] initWithTitle:@"Upload failed" message:[error description]
                                                         delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [errAlert show];
        NSLog(@"Upload failed");
    }
}















@end
