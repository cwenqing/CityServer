//
//  EditCardViewController.m
//  CityServer
//
//  Created by qing on 2018/2/28.
//  Copyright © 2018年 陈文清. All rights reserved.
//

#import "EditCardViewController.h"
#import "HXPhotoPicker.h"
#import "EditCardView.h"
#import "CardDetail.h"
#import "DynamicPicPath.h"

static const CGFloat kPhotoViewMargin = 20.0;
static const CGFloat kPhotoViewSectionMargin = 20.0;

@interface EditCardViewController ()<HXAlbumListViewControllerDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate,HXPhotoViewDelegate>
{
    CardDetail *cardDetail;
    NSMutableArray *picArray;
    NSArray *seletedFileArray;
}

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) EditCardView *editCardView;
@property (strong, nonatomic) HXPhotoView *onePhotoView;
@property (strong, nonatomic) HXPhotoManager *oneManager;
@end

@implementation EditCardViewController

- (HXPhotoManager *)oneManager {
    if (!_oneManager) {
        _oneManager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
    }
    return _oneManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    picArray = [NSMutableArray array];
    [self createUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIBarStyleBlackOpaque;
}

- (void)createUI{
    UIBarButtonItem *releaseButton = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(releaseCard)];
    [releaseButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = releaseButton;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:self.scrollView];
    
    _editCardView = [[[NSBundle mainBundle]loadNibNamed:@"EditCardView" owner:self options:nil]lastObject];
    _editCardView.frame = CGRectMake(0, 0, ScreenWidth, 540);
    [_scrollView addSubview:_editCardView];
    _editCardView.realNameTF.text = MEMBER.realName;
    
    if (_card) {
        self.title = @"编辑名片";
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeDeterminate;
        hud.label.text = @"正在加载...";
        NSDictionary*dic = @{
                             @"cardId":_card.cardId,
                             @"token":[MemberCofig shareInstance].token
                             };
        [CWNetWorkTool requestGetWithPath:CARDDETAIL_URL andParameters:dic andSuccess:^(id obj) {
            if ([obj[@"status"] intValue] == 200) {
                cardDetail = [[CardDetail alloc]initWithDictionary:obj[@"data"]];
                NSData *stringData = [cardDetail.picPath dataUsingEncoding:NSUTF8StringEncoding];
                NSArray *ary = [NSJSONSerialization JSONObjectWithData:stringData options:0 error:nil];
                for (NSDictionary *dic in ary) {
                    DynamicPicPath *filePath = [[DynamicPicPath alloc]initWithDictionary:dic];
                    [picArray addObject:filePath.filePath];
                }
                [self.oneManager addNetworkingImageToAlbum:picArray selected:YES];
                self.onePhotoView = [[HXPhotoView alloc] initWithFrame:CGRectMake(kPhotoViewMargin,540+ kPhotoViewMargin, self.view.frame.size.width - kPhotoViewMargin * 2, 0) WithManager:self.oneManager];
                self.onePhotoView.outerCamera = YES;
                self.onePhotoView.delegate = self;
                [self.scrollView addSubview:self.onePhotoView];
                
                [self.onePhotoView refreshView];
                self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(self.onePhotoView.frame) + kPhotoViewMargin);
                
                _editCardView.cardTitleTF.text = cardDetail.companyName;
                _editCardView.companyNameTF.text = cardDetail.companyName;
                _editCardView.userIndustryTF.text = cardDetail.userIndustry;
                _editCardView.userProfessionTF.text = cardDetail.userProfession;
                _editCardView.userQQTF.text = cardDetail.userQQ;
                _editCardView.userPhoneTF.text = cardDetail.userPhone;
                _editCardView.userAddressTF.text = cardDetail.userAddress;
                _editCardView.companyDescTF.text = cardDetail.companyDesc;
                [hud hideAnimated:YES afterDelay:1];
            }else{
                hud.label.text = obj[@"message"];
                [hud hideAnimated:YES afterDelay:1];
            }
            
        } Fail:^(id obj) {
            hud.label.text = @"网络错误";
            [hud hideAnimated:YES afterDelay:1];
        }];
    }else{
        self.title = @"添加名片";
        self.onePhotoView = [[HXPhotoView alloc] initWithFrame:CGRectMake(kPhotoViewMargin,540+ kPhotoViewMargin, self.view.frame.size.width - kPhotoViewMargin * 2, 0) WithManager:self.oneManager];
        self.onePhotoView.outerCamera = YES;
        self.onePhotoView.delegate = self;
        [self.scrollView addSubview:self.onePhotoView];
        
        [self.onePhotoView refreshView];
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(self.onePhotoView.frame) + kPhotoViewMargin);
    }

    
}

- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    if (self.onePhotoView == photoView) {
        NSSLog(@"onePhotoView - %@",allList);
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
}
- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(self.onePhotoView.frame) + kPhotoViewMargin);
}

- (void)releaseCard {
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
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeDeterminate;
    hud.label.text = @"正在提交";
    
    NSString *url;
    if (_card) {
        url = UPDATECARD_URL;
    }else{
        url = ADDCARD_URL;
    }
    
    if (seletedFileArray.count > 0) {
        [CWNetWorkTool upLoadImgPostWithPath:UPLOADCARD_URL andParameters:nil andFileArr:seletedFileArray andName:@"files" Progress:^(id obj) {
            NSProgress *pro = (NSProgress *)obj;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                hud.progress = pro.fractionCompleted;
                hud.label.text = @"正在上传图片...";
            });
        } Success:^(id obj) {
            if ([obj[@"status"] intValue] == 200) {
                
                NSDictionary*dic = @{
                                     @"picPath":obj[@"data"][@"fileUrl"],
                                     @"cardId":_card ? _card.cardId :@"",
                                     @"cardTitle":_editCardView.cardTitleTF.text,
                                     @"companyName":_editCardView.companyNameTF.text,
                                     @"userIndustry":_editCardView.userIndustryTF.text,
                                     @"userProfession":_editCardView.userProfessionTF.text,
                                     @"userQQ":_editCardView.userQQTF.text,
                                     @"userPhone":_editCardView.userPhoneTF.text,
                                     @"userAddress":_editCardView.userAddressTF.text,
                                     @"companyDesc":_editCardView.companyDescTF.text,
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
                }];
            }else
                [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:hud];
            [hud hideAnimated:YES afterDelay:1];
        } Fail:^(id obj) {
            hud.label.text = @"网络错误";
            [hud hideAnimated:YES afterDelay:1];
            
        }];
    }else{
        NSDictionary*dic = @{
                             @"cardId":_card ? _card.cardId :@"",
                             @"cardTitle":_editCardView.cardTitleTF.text,
                             @"companyName":_editCardView.companyNameTF.text,
                             @"userIndustry":_editCardView.userIndustryTF.text,
                             @"userProfession":_editCardView.userProfessionTF.text,
                             @"userQQ":_editCardView.userQQTF.text,
                             @"userPhone":_editCardView.userPhoneTF.text,
                             @"userAddress":_editCardView.userAddressTF.text,
                             @"companyDesc":_editCardView.companyDescTF.text,
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
