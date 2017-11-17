//
//  ViewController.m
//  MHImagePickerMaster
//
//  Created by 马浩 on 2017/11/17.
//  Copyright © 2017年 HuZhang. All rights reserved.
//

#import "ViewController.h"
#import "MHAssetPickerViewController.h"
#import "MHGetPermission.h"//这个是检测+获取权限的东西
@interface ViewController ()<UINavigationControllerDelegate,MHAssetPickerControllerDelegate>

@property(nonatomic,strong)NSMutableArray * imgsArr;//图片数组

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _imgsArr = [NSMutableArray arrayWithCapacity:0];
    
    UIButton * btn = [UIButton buttonWithType:0];
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(0, 0, 100, 100);
    btn.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.width/2);
    [btn addTarget:self action:@selector(kkkkkkkkk) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
-(void)kkkkkkkkk
{
    [MHGetPermission getPhotosPermission:^(BOOL has) {
        if (has) {
            [UIScrollView mh_scrollOpenAdjustment:YES];
            
            MHAssetPickerViewController *picker = [[MHAssetPickerViewController alloc] init];
            picker.assetPickType = MHAssetPickTypeImage;
            picker.delegate=self;
            picker.maxSelecteNum = 6;
            picker.curentSelectedNum = _imgsArr.count;
            //这里是对资源过滤的东西，如果选择视频的话，可以使用下边的方法，限制视频长度
//            picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
//                if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
//                    NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
//                    return duration >= 5;
//                } else {
//                    return YES;
//                }
//            }];
            picker.selectionFilter = nil;
            
            [self presentViewController:picker animated:YES completion:^{
            }];
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在iPhone的“设置-隐私”选项中，允许**访问您的相册" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }])];
            [alertController addAction:([UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //跳转到设置 该应用位置
                NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if([[UIApplication sharedApplication] canOpenURL:url]) {
                    NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:url];
                }
            }])];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}
#pragma mark - 代理方法
-(void)assetPickerController:(MHAssetPickerViewController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [_imgsArr removeAllObjects];
    
    for (int index = 0; index < assets.count; index ++) {
        ALAsset *asset=assets[index];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [_imgsArr addObject:tempImg];
    }
    NSLog(@"%@",_imgsArr);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
