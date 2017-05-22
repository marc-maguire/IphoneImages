//
//  ViewController.m
//  Phone Images
//
//  Created by Marc Maguire on 2017-05-22.
//  Copyright © 2017 Marc Maguire. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic) NSString *downloadURLString;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.downloadURLString = @"http://imgur.com/bktnImE.png";
    [self networkCall];
    
   }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)randomize:(id)sender {
    int i = arc4random_uniform(5);
    
    switch (i) {
        case 0:
            self.downloadURLString = @"http://imgur.com/bktnImE.png";
            break;
        
        case 1:
            self.downloadURLString = @"http://imgur.com/zdwdenZ.png";
            break;
            
        case 2:
            self.downloadURLString = @"http://imgur.com/CoQ8aNl.png";
            break;
           
        case 3:
            self.downloadURLString = @"http://imgur.com/2vQtZBb.png";
            break;
            
        case 4:
            self.downloadURLString = @"http://imgur.com/y9MIaCS.png";
            break;
            
            
        default:
            break;
    }
    
    [self networkCall];
    
}

- (void)networkCall {
    
    //Create a new NSURL object from the iPhone image url string.
    NSURL *url = [NSURL URLWithString:self.downloadURLString]; //1
    //An NSURLSessionConfiguration object defines the behavior and policies to use when making a request with an NSURLSession object. We can set things like the caching policy on this object. The default system values are good for now, so we'll just grab the default configuration.
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration]; //2
    
    //Create an NSURLSession object using our session configuration. Any changes we want to make to our configuration object must be done before this.
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];//3
    
    //We create a task that will actually download the image from the server. The session creates and configures the task and the task makes the request. Download tasks retrieve data in the form of a file, and support background downloads and uploads while the app is not running. Check out the NSURLSession API Referece for more info on this. We could optionally use a delegate to get notified when the request has completed, but we're going to use a completion block instead. This block will get called when the network request is complete, weather it was successful or not.
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            //If there was an error, we want to handle it straight away so we can fix it. Here we're checking if there was an error, logging the description, then returning out of the block since there's no point in continuing.
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        
        NSData *data = [NSData dataWithContentsOfURL:location];
        UIImage *image = [UIImage imageWithData:data];
        //The download task downloads the file to the iPhone then lets us know the location of the download using a local URL. In order to access this as a UIImage object, we need to first convert the file's binary into an NSData object, then create a UIImage from that data.
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            self.image.image = image;
            //The only thing left to do is display the image on the screen. This is almost as simple as self.iPhoneImageView.image = image; however the networking happens on a background thread and the UI can only be updated on the main thread. This means that we need to make sure that this line of code runs on the main thread.
            
            
            
        }];
        
        
    }];//4
    
    [downloadTask resume]; //5
    

    
    
}


@end
