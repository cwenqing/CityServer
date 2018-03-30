//
//  ReleaseViewController.m
//  CityServer
//
//  Created by jwdlh on 2017/12/22.
//  Copyright © 2017年 陈文清. All rights reserved.
//

#import "ReleaseViewController.h"
#import "HXPhotoPicker.h"
static const CGFloat kPhotoViewMargin = 12.0;
@interface ReleaseViewController ()<HXPhotoViewDelegate,UIImagePickerControllerDelegate,UITextViewDelegate>
{
    NSArray *seletedFileArray;
}
@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) HXPhotoView *photoView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;
@property (strong, nonatomic) UITextView *dynamicTV;

@end

@implementation ReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    switch (_viewType) {
        case 0:
            self.title = @"发布动态";
            break;
        case 1:
            self.title = @"发布同城";
            break;
        case 2:
            self.title = @"发布公益";
            break;
        default:
            break;
    }
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    self.scrollView.backgroundColor =[UIColor whiteColor];
    
    CGFloat width = scrollView.frame.size.width;
    
    _dynamicTV = [[UITextView alloc]initWithFrame:CGRectMake(kPhotoViewMargin, 0, width - kPhotoViewMargin * 2, 100)];
    _dynamicTV.font = FONT(14);
    _dynamicTV.text = @"此时此刻，想和大家分享什么";
    _dynamicTV.textColor = RGBA(167, 168, 177, 1);
    _dynamicTV.delegate = self;
    [scrollView addSubview:_dynamicTV];
    
    
    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
    photoView.frame = CGRectMake(kPhotoViewMargin, kPhotoViewMargin+100, width - kPhotoViewMargin * 2, 0);
    photoView.delegate = self;
    photoView.outerCamera = YES;
    photoView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:photoView];
    self.photoView = photoView;
    
    UIBarButtonItem *releaseButton = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(releaseDynamic)];
    [releaseButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = releaseButton;
}

-(void)viewWillAppear:(BOOL)animated{
  [UIApplication sharedApplication].statusBarStyle = UIBarStyleBlackOpaque;

    
}

-(void)releaseDynamic{
    [self.view endEditing:YES];
    float latitude;
    float longitude;
    
    if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        latitude = [MEMBER.latitude floatValue];
        longitude = [MEMBER.longitude floatValue];
    }else{
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        latitude = app.latitude;
        longitude = app.longitude;
    }
    
    if ([_dynamicTV.text isEqualToString:@"此时此刻，想和大家分享什么"] && seletedFileArray.count == 0) {
        [ProjectConfig mbRpogressHUDAlertWithText:@"不能同时为空" WithProgress:nil];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeDeterminate;
        hud.label.text = @"正在提交";
        
        NSString *dynamicStr;
        if ([_dynamicTV.text isEqualToString:@"此时此刻，想和大家分享什么"]) {
            dynamicStr = @"";
        }else{
            dynamicStr = _dynamicTV.text;
        }
        
        NSString *url;
        switch (_viewType) {
            case 0:
                url = SUBMITTOPIC_URL;
                break;
            case 1:
                url = SUBMITSAMECITYSERVER_URL;
                break;
            case 2:
                url = SUBMITWEALSERVER_URL;
                break;
            default:
                break;
        }
        
        if (seletedFileArray.count > 0) {
            [CWNetWorkTool upLoadImgPostWithPath:UPLOADFILE_URL andParameters:nil andFileArr:seletedFileArray andName:@"files" Progress:^(id obj) {
                NSProgress *pro = (NSProgress *)obj;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    hud.progress = pro.fractionCompleted;
                    hud.label.text = @"正在上传图片...";
                });
            } Success:^(id obj) {
                if ([obj[@"status"] intValue] == 200) {
                    
                    NSDictionary*dic;
                    if (_viewType == 0) {
                        dic = @{
                                @"files":obj[@"data"][@"fileUrl"],
                                @"content":dynamicStr,
                                @"dynamicStatus":[NSString stringWithFormat:@"%d",_seletedPageIndex+1],
                                @"latitude":[NSString stringWithFormat:@"%f",latitude],
                                @"longitude":[NSString stringWithFormat:@"%f",longitude],
                                @"token":[MemberCofig shareInstance].token
                                };
                    }else
                        dic = @{
                                @"files":obj[@"data"][@"fileUrl"],
                                @"content":dynamicStr,
                                @"latitude":[NSString stringWithFormat:@"%f",latitude],
                                @"longitude":[NSString stringWithFormat:@"%f",longitude],
                                @"token":[MemberCofig shareInstance].token
                                };
                    
                    [CWNetWorkTool requestPostWithPath:url andParameters:dic andSuccess:^(id obj) {
                        if ([obj[@"status"] intValue] == 200) {
                            UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                            hud.customView = imageView;
                            hud.mode = MBProgressHUDModeCustomView;
                            hud.label.text = @"提交成功";
                            [hud hideAnimated:YES afterDelay:1];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    } Fail:^(id obj) {
                        hud.label.text = @"网络错误";
                        [hud hideAnimated:YES afterDelay:1];
                    }];
                }else
                    [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:hud];
            } Fail:^(id obj) {
                hud.label.text = @"网络错误";
                [hud hideAnimated:YES afterDelay:1];
                
            }];
        }else{
            NSDictionary*dic;
            if (_viewType == 0) {
                dic = @{
                        @"content":dynamicStr,
                        @"dynamicStatus":[NSString stringWithFormat:@"%d",_seletedPageIndex+1],
                        @"latitude":[NSString stringWithFormat:@"%f",latitude],
                        @"longitude":[NSString stringWithFormat:@"%f",longitude],
                        @"token":[MemberCofig shareInstance].token
                        };
            }else
                dic = @{
                        @"content":dynamicStr,
                        @"latitude":[NSString stringWithFormat:@"%f",latitude],
                        @"longitude":[NSString stringWithFormat:@"%f",longitude],
                        @"token":[MemberCofig shareInstance].token
                        };
            
            [CWNetWorkTool requestPostWithPath:url andParameters:dic andSuccess:^(id obj) {
                if ([obj[@"status"] intValue] == 200) {
                    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                    hud.customView = imageView;
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.label.text = @"提交成功";
                    [hud hideAnimated:YES afterDelay:1];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } Fail:^(id obj) {
                hud.label.text = @"网络错误";
                [hud hideAnimated:YES afterDelay:1];
            }];
        }
        
        
    }

}


- (HXDatePhotoToolManager *)toolManager {
    if (!_toolManager) {
        _toolManager = [[HXDatePhotoToolManager alloc] init];
    }
    return _toolManager;
}

- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _manager.configuration.openCamera = NO;
        _manager.configuration.lookLivePhoto = YES;
        _manager.configuration.photoMaxNum = 9;
        _manager.configuration.videoMaxNum = 1;
        _manager.configuration.maxNum = 9;
        _manager.configuration.videoMaxDuration = 15;
        _manager.configuration.saveSystemAblum = NO;
        //        _manager.configuration.reverseDate = YES;
        _manager.configuration.showDateSectionHeader = NO;
        _manager.configuration.selectTogether = NO;
        //        _manager.configuration.rowCount = 3;
        _manager.configuration.themeColor = NavColor;
        //        _manager.configuration.navigationTitleSynchColor = YES;
        _manager.configuration.navigationBar = ^(UINavigationBar *navigationBar) {
            //            navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor orangeColor]};
        };
        
        //        _manager.configuration.movableCropBox = YES;
        //        _manager.configuration.movableCropBoxEditSize = YES;
        //        _manager.configuration.movableCropBoxCustomRatio = CGPointMake(1, 1);
        
    }
    return _manager;
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    HXPhotoModel *model;
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        model = [HXPhotoModel photoModelWithImage:image];
        if (self.manager.configuration.saveSystemAblum) {
            [HXPhotoTools savePhotoToCustomAlbumWithName:self.manager.configuration.customAlbumName photo:model.thumbPhoto];
        }
    }else  if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL *url = info[UIImagePickerControllerMediaURL];
        NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                         forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
        float second = 0;
        second = urlAsset.duration.value/urlAsset.duration.timescale;
        model = [HXPhotoModel photoModelWithVideoURL:url videoTime:second];
        if (self.manager.configuration.saveSystemAblum) {
            [HXPhotoTools saveVideoToCustomAlbumWithName:self.manager.configuration.customAlbumName videoURL:url];
        }
    }
    if (self.manager.configuration.useCameraComplete) {
        self.manager.configuration.useCameraComplete(model);
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    NSSLog(@"所有:%ld - 照片:%ld - 视频:%ld",allList.count,photos.count,videos.count);
    NSSLog(@"所有:%@ - 照片:%@ - 视频:%@",allList,photos,videos);
    
    [HXPhotoTools selectListWriteToTempPath:allList requestList:^(NSArray *imageRequestIds, NSArray *videoSessions) {
        NSSLog(@"requestIds - image : %@ \nsessions - video : %@",imageRequestIds,videoSessions);
    } completion:^(NSArray<NSURL *> *allUrl, NSArray<NSURL *> *imageUrls, NSArray<NSURL *> *videoUrls) {
        NSSLog(@"allUrl - %@\nimageUrls - %@\nvideoUrls - %@",allUrl,imageUrls,videoUrls);
        seletedFileArray = allUrl;
    } error:^{
        seletedFileArray = [NSMutableArray array];
        NSSLog(@"失败");
    }];
}
- (void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl {
    NSSLog(@"%@",networkPhotoUrl);
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    NSSLog(@"%@",NSStringFromCGRect(frame));
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(frame) + kPhotoViewMargin);
    
}

-(void)beginChoose{
    [self.dynamicTV resignFirstResponder];
}

#pragma mark - textViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"此时此刻，想和大家分享什么"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"此时此刻，想和大家分享什么";
        textView.textColor = RGBA(167, 168, 177, 1);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
