//
//  AlbumsView.m
//  Quting
//
//  Created by Johnil on 13-5-29.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import "AlbumsView.h"
#import <QuartzCore/QuartzCore.h>
#import "PlayViewController.h"
#import "MainViewController.h"
#import "ListViewController.h"
#import "UIImageView+AFNetworking.h"
#import "RequestHelper.h"
#import "PayView.h"
#import "UIView+Animation.h"
@implementation AlbumsView {
    UIImageView *cover;
    UIButton *control;
    NSDictionary *dict;
    NSMutableArray *listInfos;
    CircularProgressView *circularProgressView;
    BOOL isShop;
    UIImageView *fav;
}

@synthesize coverImage;

- (UIImage*)imageFromView:(UIView*)view{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, view.layer.contentsScale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (id)initWithFrame:(CGRect)frame andInfo:(NSDictionary *)info isShop:(BOOL)isShop_
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFav:) name:CHANGEFAV object:nil];
        isShop = isShop_;
        self.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1];
        self.clipsToBounds = NO;
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        bg.backgroundColor = [UIColor colorWithRed:229/255.0f green:229/255.0f blue:229/255.0f alpha:1];
        bg.layer.cornerRadius = frame.size.width/2;
        bg.clipsToBounds = YES;
        UIImage *temp = [self imageFromView:bg];
        [self addSubview:[[UIImageView alloc] initWithImage:temp]];
        dict = info;
        [self loadView];
    }
    return self;
}

- (void)loadView{
    //set backcolor & progresscolor
    UIColor *backColor = [UIColor whiteColor];
    UIColor *progressColor = [UIColor colorWithRed:238.0/255.0 green:55.0/255.0 blue:137.0/255.0 alpha:1.0];
    
    int width = self.frame.size.width-10;
    //alloc CircularProgressView instance
    circularProgressView = [[CircularProgressView alloc] initWithFrame:CGRectMake(5, 5, width, width)
                                                                  backColor:backColor
                                                              progressColor:progressColor
                                                                  lineWidth:5];
    //add CircularProgressView
    [self addSubview:circularProgressView];
    
    cover = [[UIImageView alloc] init];
    cover.image = [UIImage imageNamed:@"thumb"];
    
    __block AlbumsView *blocksafeSelf = self;
    __block UIImageView *blockCover = cover;
//    __block UIImage *blockCoverImage = coverImage;
    if (![@"" isEqualToString:[dict valueForKey:@"mtype"]]) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[dict valueForKey:@"mtype"]]];
        [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
        [cover setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//            blockCoverImage = [image copy];
            blocksafeSelf.coverImage = image;
            blockCover.image = image;
            [blocksafeSelf customCoverView];
        } failure:nil];
    } else {
        [self customCoverView];
    }
    
    control = [UIButton buttonWithType:UIButtonTypeCustom];
    [control setImage:imageNamed(@"playing.png") forState:UIControlStateNormal];
    [control setImage:imageNamed(@"btn_pause.png") forState:UIControlStateSelected];
    [control addTarget:self action:@selector(manageAudio) forControlEvents:UIControlEventTouchUpInside];
    control.frame = CGRectMake(self.frame.size.width-28, self.frame.size.height-28, 26, 26);
    [self addSubview:control];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height+5, self.frame.size.width, 15)];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont boldSystemFontOfSize:15];
    _label.text = [dict valueForKey:@"name"];
    _label.backgroundColor = [UIColor clearColor];
    _label.textColor = [UIColor colorWithRed:125/255.0 green:125/255.0 blue:125/255.0 alpha:1];
    [self addSubview:_label];
}

- (void)customCoverView{
    cover.frame = CGRectMake(10, 10, self.frame.size.width-20, self.frame.size.width-20);
    cover.contentMode = UIViewContentModeScaleAspectFill;
    cover.layer.cornerRadius = (self.frame.size.width-20)/2;
    cover.clipsToBounds = YES;

    UIView *blackCover;
    if (!isShop) {
        blackCover = [[UIView alloc] initWithFrame:CGRectMake(-10, self.frame.size.height-40, self.frame.size.width, self.frame.size.height)];
        blackCover.backgroundColor = [UIColor blackColor];
        blackCover.layer.cornerRadius = self.frame.size.width/2;
        blackCover.alpha = .5;
        [cover addSubview:blackCover];
    }
    
    UIImage *temp = [self imageFromView:cover];
    cover.image = temp;
    cover.layer.cornerRadius = 0;
    cover.alpha = .85;
    [self addSubview:cover];
    
    if (!isShop) {
        [blackCover removeFromSuperview];
        if ([[dict valueForKey:@"is_like"] intValue]==1) {
            fav = [[UIImageView alloc] initWithImage:imageNamed(@"fav.png")];
            fav.frame = CGRectMake(blackCover.center.x-7, self.frame.size.height-35, 14, 13);
            [cover addSubview:fav];
        } else {
            fav = [[UIImageView alloc] initWithImage:imageNamed(@"noFav.png")];
            fav.frame = CGRectMake(blackCover.center.x-7, self.frame.size.height-35, 14, 13);
            [cover addSubview:fav];
        }
    }
}

- (void)changeFav:(NSNotification *)notifi{
    if ([notifi.object intValue]!=self.tag) {
        return;
    }
    [dict setValue:[notifi.userInfo valueForKey:@"is_like"] forKey:@"is_like"];
    if ([[notifi.userInfo valueForKey:@"is_like"] intValue]==1) {
        [fav setImage:imageNamed(@"fav.png")];
    } else {
        [fav setImage:imageNamed(@"noFav.png")];
    }
}

- (void)stop{
    [[AudioManager defaultManager] clearAudioList];
    cover.alpha = .85;
    control.selected = NO;
    circularProgressView.progress = 0;
    [circularProgressView setNeedsDisplay];
}

- (void)manageAudio{
    [[AudioManager defaultManager] clearOtherAlbumsStat:self];
    if ([[AudioManager defaultManager] playing]) {
        [[AudioManager defaultManager] pause];
        [self audioPause];
    } else {
        if ([[AudioManager defaultManager] needURL]) {
            if (listInfos==nil) {
                [[RequestHelper defaultHelper] requestGETAPI:@"/api/mfiles" postData:@{@"medium_id": [NSString stringWithFormat:@"%d", self.tag]} success:^(id result) {
                    listInfos = [result valueForKey:@"mfiles"];
                    NSMutableArray *mp3files = [NSMutableArray array];
                    for (NSDictionary *temp in listInfos) {
                        [mp3files addObject:[NSString stringWithFormat:@"%@/%@", @"http://t.pamakids.com/", [[temp valueForKey:@"url"] stringByReplacingOccurrencesOfString:@"public" withString:@""]]];
                    }
                    [[AudioManager defaultManager] clearAudioList];
                    [[AudioManager defaultManager] addAudioListToList:mp3files];
                    [[AudioManager defaultManager] playListAtFirst];
                    [[AudioManager defaultManager] setCurrentAlbums:self];
                } failed:nil];
            } else {
                NSMutableArray *mp3files = [NSMutableArray array];
                for (NSDictionary *temp in listInfos) {
                    [mp3files addObject:[NSString stringWithFormat:@"%@/%@", @"http://t.pamakids.com/", [[temp valueForKey:@"url"] stringByReplacingOccurrencesOfString:@"public" withString:@""]]];
                }
                [[AudioManager defaultManager] clearAudioList];
                [[AudioManager defaultManager] addAudioListToList:mp3files];
                [[AudioManager defaultManager] playListAtFirst];
            }
        } else {
            [[AudioManager defaultManager] resume];
        }
        [self audioPlay];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    cover.alpha = .5;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.tag == -1) {
        [[AudioManager defaultManager] clearOtherAlbumsStat:nil];
        [[AudioManager defaultManager] setCurrentAlbums:nil];
    } else {
        [[AudioManager defaultManager] clearOtherAlbumsStat:self];
        [[AudioManager defaultManager] setCurrentAlbums:self];
    }
    cover.alpha = 1;
    if (isShop) {
        PayView *pay = [[PayView alloc] initWithImage:self.coverImage andInfo:dict];
        [self.window addSubview:pay];
        [pay fadeIn];
        return;
    }
    if (self.tag==-1) {
        [[RequestHelper defaultHelper] requestGETAPI:@"/api/likes" postData:@{@"guest_id": [[NSUserDefaults standardUserDefaults] valueForKey:@"guest"]} success:^(id result) {
//            if ([[result valueForKey:@"likes"] count]>0) {
                NSMutableArray *tempDatas = [NSMutableArray array];
                for (NSDictionary *temp in [result valueForKey:@"likes"]) {
                    [tempDatas addObject:temp];
                }
                ListViewController *list = [[ListViewController alloc] initWithModel:ListModel_fav];
                NSArray *temp = [[NSUserDefaults standardUserDefaults] valueForKey:@"historys"];
                if (temp == nil) {
                    temp = @[];
                }
                [list loadDatas:@[tempDatas, temp]];
                [((MainViewController *)self.superview.superview.nextResponder).navigationController pushViewController:list animated:YES];
//            }
        } failed:nil];

    } else {
        NSMutableArray *historys;
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"historys"]==nil) {
            historys = [NSMutableArray array];
        } else {
            historys = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"historys"]];
        }
        BOOL has = NO;
        for (NSDictionary *temp in historys) {
            if ([[temp valueForKey:@"id"] intValue] == [[dict valueForKey:@"id"] intValue]) {
                has = YES;
                break;
            }
        }
        if (!has) {
                [historys addObject:dict];
            [[NSUserDefaults standardUserDefaults] setValue:historys forKey:@"historys"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }

        if (listInfos==nil) {
            [[RequestHelper defaultHelper] requestGETAPI:@"/api/mfiles" postData:@{@"medium_id": [NSString stringWithFormat:@"%d", self.tag]} success:^(id result) {
                listInfos = [result valueForKey:@"mfiles"];
                PlayViewController *playViewController = [[PlayViewController alloc] initWithDatas:listInfos andParentData:dict andCover:self.coverImage];
                [((MainViewController *)self.superview.superview.nextResponder).navigationController pushViewController:playViewController animated:YES];
            } failed:nil];
        } else {
            PlayViewController *playViewController = [[PlayViewController alloc] initWithDatas:listInfos andParentData:dict andCover:self.coverImage];
            [((MainViewController *)self.superview.superview.nextResponder).navigationController pushViewController:playViewController animated:YES];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    cover.alpha = 1;
}

- (void)audioProgress:(float)temp{
    circularProgressView.progress = temp;
}

- (void)audioPlay{
    circularProgressView.progressColor =  [UIColor colorWithRed:238.0/255.0 green:55.0/255.0 blue:137.0/255.0 alpha:1.0];
    cover.alpha = 1;
    control.selected = YES;
}

- (void)audioPause{
    circularProgressView.progressColor = [UIColor grayColor];
    cover.alpha = .85;
    control.selected = NO;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
