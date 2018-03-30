//
//  MemberInfoViewController.m
//  CityServer
//
//  Created by 陈文清 on 2017/12/22.
//  Copyright © 2017年 陈文清. All rights reserved.
//

#import "MemberInfoViewController.h"
#import "ChangeInfoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "STPickerArea.h"
#import "DatePickerView.h"
@interface MemberInfoViewController ()<UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,STPickerAreaDelegate,DatePickerDelegate>
{
    NSData *seletedHeadImgData;
    UIImageView *headImg;
    UITextField *nickNameTF;
    UITextField *realNameTF;
    UILabel *genderLabel;
    UILabel *birthdayLabel;
    UITextField *signTF;
    UILabel *locationLabel;
    
    DatePickerView *datePickerView;
    
}
@property (nonatomic, strong) UITableView *memberInfoTableView;

@end

@implementation MemberInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人资料";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(updateInfo)];
    [saveButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = saveButton;
    [self createUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)createUI{
    _memberInfoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth) style:UITableViewStylePlain];
    _memberInfoTableView.backgroundColor = BACColor;
    _memberInfoTableView.delegate = self;
    _memberInfoTableView.dataSource = self;
    [self.view addSubview:_memberInfoTableView];
    [self setExtraCellLineHidden:_memberInfoTableView];
    
    datePickerView = [[[NSBundle mainBundle]loadNibNamed:@"DatePickerView" owner:self options:nil]lastObject];
    datePickerView.frame = CGRectMake(0, ScreenHeigth , ScreenWidth, 250);
    datePickerView.delegate = self;
    [self.view addSubview:datePickerView];
}

- (void)updateInfo{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeDeterminate;
    hud.label.text = @"正在提交";
    
    if (seletedHeadImgData) {
        [CWNetWorkTool upLoadImgPostWithPath:UPLOADHEAD_URL andParameters:nil andImageArr:@[seletedHeadImgData] andName:@"files" Progress:^(id obj) {
            NSProgress *pro = (NSProgress *)obj;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                hud.progress = pro.fractionCompleted;
                hud.label.text = @"正在上传图片...";
            });
        } Success:^(id obj) {
            if ([obj[@"status"] intValue] == 200) {
                
                
                NSDictionary*dic = @{
                                     @"avatarPath":obj[@"data"][@"fileUrl"],
                                     @"birthDate":birthdayLabel.text,
                                     @"province":[locationLabel.text componentsSeparatedByString:@" "].firstObject,
                                     @"city":[locationLabel.text componentsSeparatedByString:@" "][1],
                                     @"district":[locationLabel.text componentsSeparatedByString:@" "].lastObject,
                                     @"gender":[genderLabel.text isEqualToString:@"男"]? @(1) :@(2),
                                     @"userSignature":signTF.text,
                                     @"realName":realNameTF.text,
                                     @"userName":nickNameTF.text,
                                     @"token":[MemberCofig shareInstance].token
                                     };
                
                [CWNetWorkTool requestPostWithPath:UPDATEINFO_URL andParameters:dic andSuccess:^(id obj) {
                    if ([obj[@"status"] intValue] == 200) {
                        UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                        hud.customView = imageView;
                        hud.mode = MBProgressHUDModeCustomView;
                        hud.label.text = @"保存成功";
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
        NSDictionary*dic = @{
                             @"avatarPath":@"",
                             @"birthDate":birthdayLabel.text,
                             @"province":[locationLabel.text componentsSeparatedByString:@" "].firstObject,
                             @"city":[locationLabel.text componentsSeparatedByString:@" "][1],
                             @"district":[locationLabel.text componentsSeparatedByString:@" "].lastObject,
                             @"gender":[genderLabel.text isEqualToString:@"男"]? @(1) :@(2),
                             @"userSignature":signTF.text,
                             @"realName":realNameTF.text,
                             @"userName":nickNameTF.text,
                             @"token":[MemberCofig shareInstance].token
                             };
        
        [CWNetWorkTool requestPostWithPath:UPDATEINFO_URL andParameters:dic andSuccess:^(id obj) {
            if ([obj[@"status"] intValue] == 200) {
                UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                hud.customView = imageView;
                hud.mode = MBProgressHUDModeCustomView;
                hud.label.text = @"保存成功";
                [hud hideAnimated:YES afterDelay:1];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } Fail:^(id obj) {
            hud.label.text = @"网络错误";
            [hud hideAnimated:YES afterDelay:1];
        }];
    }
}

#pragma mark---隐藏多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 6;
            break;
        case 1:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 16;
            break;
        case 1:
            return 0;
            break;
        default:
            return 0;
            break;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 80;
    }else
        return 40;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = FONT(15);
    cell.detailTextLabel.font = FONT(15);
    cell.detailTextLabel.textColor = RGBA(125, 125, 125, 1);
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    headImg = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-100, 10, 60, 60)];
                    [headImg sd_setImageWithURL:IMAGE(_memberInfo.avatarPath) placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
                    [cell addSubview:headImg];
                    cell.textLabel.text = @"头像";
                }
                    break;
                case 1:
                {
                    cell.textLabel.text = @"昵称";
                    nickNameTF = [[UITextField alloc]initWithFrame:CGRectMake(0, 5, ScreenWidth-40, 30)];
                    nickNameTF.textColor = RGBA(125, 125, 125, 1);
                    nickNameTF.font = FONT(15);
                    nickNameTF.text = _memberInfo.userName;
                    nickNameTF.textAlignment = NSTextAlignmentRight;
                    [cell addSubview:nickNameTF];
                }
                    break;
                case 2:
                {
                    cell.textLabel.text = @"真实姓名";
                    realNameTF = [[UITextField alloc]initWithFrame:CGRectMake(0, 5, ScreenWidth-40, 30)];
                    realNameTF.textColor = RGBA(125, 125, 125, 1);
                    realNameTF.font = FONT(15);
                    realNameTF.text = _memberInfo.realName;
                    realNameTF.textAlignment = NSTextAlignmentRight;
                    [cell addSubview:realNameTF];
                }
                    break;
                case 3:
                {
                    cell.textLabel.text = @"性别";
                    genderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, ScreenWidth-40, 30)];
                    genderLabel.textColor = RGBA(125, 125, 125, 1);
                    genderLabel.font = FONT(15);
                    genderLabel.text = _memberInfo.gender==1 ? @"男":@"女";
                    genderLabel.textAlignment = NSTextAlignmentRight;
                    [cell addSubview:genderLabel];
                    
                }
                    break;
                case 4:
                {
                    cell.textLabel.text = @"出生日期";
                    birthdayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, ScreenWidth-40, 30)];
                    birthdayLabel.textColor = RGBA(125, 125, 125, 1);
                    birthdayLabel.font = FONT(15);
                    birthdayLabel.text = _memberInfo.birthDate;
                    birthdayLabel.textAlignment = NSTextAlignmentRight;
                    [cell addSubview:birthdayLabel];
                }
                    break;
                case 5:
                {
                    cell.textLabel.text = @"个性签名";
                    signTF = [[UITextField alloc]initWithFrame:CGRectMake(0, 5, ScreenWidth-40, 30)];
                    signTF.textColor = RGBA(125, 125, 125, 1);
                    signTF.font = FONT(15);
                    signTF.text = _memberInfo.userSignature;
                    signTF.textAlignment = NSTextAlignmentRight;
                    [cell addSubview:signTF];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:{
            cell.textLabel.text = @"地址";
            locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, ScreenWidth-40, 30)];
            locationLabel.textColor = RGBA(125, 125, 125, 1);
            locationLabel.font = FONT(15);
            locationLabel.text = [NSString stringWithFormat:@"%@ %@ %@",_memberInfo.province,_memberInfo.city,_memberInfo.district];
            locationLabel.textAlignment = NSTextAlignmentRight;
            [cell addSubview:locationLabel];
        }
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        __weak typeof(self) ws = self;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *otherButton1 = [UIAlertAction actionWithTitle:@"拍照"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 [ws openCamera];
                                                             }];
        UIAlertAction *otherButton2 = [UIAlertAction actionWithTitle:@"相册"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 [ws openPhotoLibrary];
                                                             }];
        
        [alertController addAction:cancelButton];
        [alertController addAction:otherButton1];
        [alertController addAction:otherButton2];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if (indexPath.section == 0 && indexPath.row == 3){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *otherButton1 = [UIAlertAction actionWithTitle:@"男"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 genderLabel.text = @"男";
                                                             }];
        UIAlertAction *otherButton2 = [UIAlertAction actionWithTitle:@"女"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 genderLabel.text = @"女";
                                                             }];
        
        [alertController addAction:cancelButton];
        [alertController addAction:otherButton1];
        [alertController addAction:otherButton2];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if (indexPath.section == 1 && indexPath.row == 0){
        [[[STPickerArea alloc]initWithDelegate:self] show];
        [UIView animateWithDuration:.3 animations:^{
            datePickerView.frame = CGRectMake(0, ScreenHeigth  , ScreenWidth, 250);
        }];
    }else if (indexPath.section == 0 && indexPath.row == 4){
        [self.view endEditing:YES];
        [UIView animateWithDuration:.3 animations:^{
            datePickerView.frame = CGRectMake(0, ScreenHeigth - 250 , ScreenWidth, 250);
        }];
    }
}

-(void)datePickerWithDate:(NSString *)date{
//    faultHappenTimeLabel.text = date;
    birthdayLabel.text = date;
    [UIView animateWithDuration:.3 animations:^{
        datePickerView.frame = CGRectMake(0, ScreenHeigth , ScreenWidth, 250);
    }];
    
    
}

-(void)datePickerCencel{
    [UIView animateWithDuration:.3 animations:^{
        datePickerView.frame = CGRectMake(0, ScreenHeigth  , ScreenWidth, 250);
    }];
}

#pragma mark - 头像选择
- (void)openCamera
{
    // 暂时弃用自定义相机
    // 打开系统相机拍照
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
    {
        UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:nil message:@"您没有相机使用权限,请到设置->隐私中开启权限" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            
        }];
        [alert show];
        return;
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *cameraIPC = [[UIImagePickerController alloc] init];
        cameraIPC.delegate = self;
        cameraIPC.allowsEditing = YES;
        cameraIPC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:cameraIPC animated:YES completion:nil];
        return;
    }
}


- (void)openPhotoLibrary
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
        return;
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    NSString *imageurl = [[info objectForKey:UIImagePickerControllerReferenceURL] description];
    
    if ([imageurl hasSuffix:@"JPG"]) {
        //把UIImage转成Data
        seletedHeadImgData =  UIImageJPEGRepresentation(image, 0.5);
    }else{//PNG
        seletedHeadImgData = UIImagePNGRepresentation(image);
        
    }
    headImg.image = image;
//    NSLog(@"%@",self.selectedCoverImage);
    [picker dismissViewControllerAnimated:YES completion:nil];
    
//    [self uploadImage];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)pickerArea:(STPickerArea *)pickerArea province:(NSString *)province city:(NSString *)city area:(NSString *)area
{
    NSString *text = [NSString stringWithFormat:@"%@ %@ %@", province, city, area];
    locationLabel.text = text;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ChangeInfo"]) {
        ChangeInfoViewController *vc = (ChangeInfoViewController *)[segue destinationViewController];
        vc.viewType = [sender intValue];
    }
    
}


@end
