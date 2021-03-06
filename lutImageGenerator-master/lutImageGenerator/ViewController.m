//
//  ViewController.m
//  lutImageGenerator
//
//  Created by 穆相臣 on 4/5/16.
//  Copyright © 2016 穆相臣. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSArray * dataArr;
}
@end

@implementation ViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
       
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // write your file name here.no extention
    
    dataArr = @[@"lj",@"lj",@"lj"];
    
    NSLog(@"%@",dataArr);
    
    for (NSString * file in dataArr)
    {
        [self turnFileToImage:file];
    }
    
    UIAlertView * aleart = [[UIAlertView alloc]initWithTitle:@"提示" message:@"处理完成" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [aleart show];
}

-(void)turnFileToImage:(NSString *)fileName
{
    NSString * file = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:fileName ofType:@"CUBE"] encoding:NSUTF8StringEncoding error:nil];
    
    NSArray * arr = [file componentsSeparatedByString:@"\n"];
    //    NSLog(@"%@",arr);
    
    
    CGRect rect = CGRectMake(0, 0, 512, 512);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (int by = 0; by < 8; by++) {
        for (int bx = 0; bx < 8; bx++) {
            for (int g = 0; g < 64; g++) {
                for (int r = 0; r < 64; r++) {
                    CGRect rect = CGRectMake(bx * 64 + g, by * 64 + r, 1, 1);
                    CGContextAddRect(context, rect);
                    NSString * color = [arr objectAtIndex:(by * 64 * 64 * 8 + bx * 64 * 64 + r * 64 + g)];
                    
                    NSString * red = [color substringWithRange:NSMakeRange(0, 8)];
                    NSString * green = [color substringWithRange:NSMakeRange(9, 8)];
                    NSString * blue = [color substringWithRange:NSMakeRange(18, 8)];
                    
                    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:red.floatValue green:green.floatValue blue:blue.floatValue alpha:1].CGColor);
                    CGContextFillRect(context, rect);
                    //                    image.setPixel(r + bx * 64, g + by * 64, qRgb((int)(r * 255.0 / 63.0 + 0.5),
                    //                                                                  (int)(g * 255.0 / 63.0 + 0.5),
                    //                                                                  (int)((bx + by * 8.0) * 255.0 / 63.0 + 0.5)));
                    
                }
            }
        }
    }
    
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    NSData * imageData = UIImagePNGRepresentation(img);
    
    NSString * targetFileName = [NSString stringWithFormat:@"%@.png",fileName];
    NSString * targetFilePath = [[NSHomeDirectory() stringByAppendingString:@"/Documents/"]stringByAppendingString:targetFileName];
    
    NSLog(@"%@",targetFilePath);
    [imageData writeToFile:targetFilePath atomically:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
