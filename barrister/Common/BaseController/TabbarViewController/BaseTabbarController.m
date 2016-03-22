//
//  BaseTabbarController.m
//  barrister
//
//  Created by 徐书传 on 16/3/21.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "BaseTabbarController.h"

//#import "SingletonState.h"
//#import "WTLoginViewController.h"

#define kCartNumBackgroundImageTag 1001
#define kCartNumTextLabelTag 1002

#define kItemCount 5

#define kDuration .2

@interface BaseTabbarController ()

@property (nonatomic, retain) NSMutableArray *buttons;

- (void)createCustomTabBar;
- (void)selectTab:(NSInteger)index;
@end

@implementation BaseTabbarController
@synthesize buttons = _buttons;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_buttons == nil)
    {
        [self createCustomTabBar];
    }
}


- (void)popToRootViewControllerWithIndex:(NSInteger)index
{
    NSInteger count = self.viewControllers.count;
    
    if (index < count)
    {
        UINavigationController *viewController = (UINavigationController *)[self.viewControllers objectAtIndex:index];
        if (viewController != nil && [self.delegate tabBarController:self shouldSelectViewController:viewController])
        {
            [viewController popToRootViewControllerAnimated:YES];
            [self.delegate tabBarController:self didSelectViewController:viewController];
        }
    }
}

- (void)selectButtonAtIndex:(NSUInteger)index
{
    
    UIViewController *viewController = nil;
    if (index < self.viewControllers.count)
    {
        viewController = [self.viewControllers objectAtIndex:index];
    }
    
    
    if (viewController != nil)
    {
        if (self.selectedIndex == index)
        {
            [self popToRootViewControllerWithIndex:index];
        }
        else
        {
            if ([self.delegate tabBarController:self shouldSelectViewController:viewController])
            {
                [self selectTab:index];
                
                [self setSelectedIndex:index];
                [self.delegate tabBarController:self didSelectViewController:viewController];
            }
        }
    }
}



- (void)loginSuccess:(int) tag{
    
    UIViewController *viewController = nil;
    if (tag < self.viewControllers.count)
    {
        viewController = [self.viewControllers objectAtIndex:tag];
    }
    
    if ([self.delegate tabBarController:self shouldSelectViewController:viewController])
    {
        [self selectTab:tag];
        [self.delegate tabBarController:self didSelectViewController:viewController];
    }
    [self hideTabBar:NO];
}

- (void)onTabItemDown:(id)sender
{
    
    UIButton *button = (UIButton *)sender;
    NSInteger index = button.tag - 10000;
    
//    SingletonState *dm = [SingletonState sharedInstance];
//    
//    if (!dm.userHasLogin  && index > 2  && MainScreenHeight > 485) {
//        [self showLoginView:index];
//        return;
//    }
    
    
    
    UIViewController *viewController = nil;
    if (index < self.viewControllers.count)
    {
        viewController = [self.viewControllers objectAtIndex:index];
    }
    
    
    if (viewController != nil)
    {
        if (self.selectedIndex == index)
        {
            [self popToRootViewControllerWithIndex:index];
        }
        else
        {
            if ([self.delegate tabBarController:self shouldSelectViewController:viewController])
            {
                [self selectTab:index];
                [self.delegate tabBarController:self didSelectViewController:viewController];
            }
        }
    }
}



- (void)onTabItemRepeat:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    NSInteger index = button.tag - 10000;
    
    [self popToRootViewControllerWithIndex:index];
}

- (void)createCustomTabBar
{
    
    UIView *tabBarBackGroundView = [self.tabBar viewWithTag:kMainTabbarBgViewTag];
    if (tabBarBackGroundView != nil)
    {
        [tabBarBackGroundView removeFromSuperview];
    }
    
    tabBarBackGroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, self.tabBar.frame.size.height)];
    
    //创建按钮,最多显示5个
    NSInteger viewCount = self.viewControllers.count > kItemCount ? kItemCount : self.viewControllers.count;
    self.buttons = [NSMutableArray arrayWithCapacity:viewCount];
    
    double itemWidth = SCREENWIDTH / viewCount;
    
    double itemHeight = self.tabBar.frame.size.height;
    for (int i = 0; i < viewCount; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * itemWidth, 0, itemWidth, itemHeight);
        
        [btn addTarget:self action:@selector(onTabItemDown:) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(onTabItemRepeat:) forControlEvents:UIControlEventTouchDownRepeat];
        btn.tag = 10000 + i;
        btn.contentMode = UIViewContentModeCenter;
        
        NSString *normalImgName = nil;
        
        switch (i)
        {
            case 0:
                normalImgName = @"Tab01Normal.png";
                break;
                
            case 1:
                normalImgName = @"Tab02Normal.png";
                break;
                
            case 2:
                normalImgName = @"Tab03Normal.png";
                break;
                
            case 3:
                normalImgName = @"Tab04Normal.png";
                break;
            case 4:
                normalImgName = @"Tab05Normal.png";
                
            default:
                break;
        }
        
        [btn setBackgroundImage:[UIImage imageNamed:normalImgName] forState:UIControlStateNormal];
        [btn setAdjustsImageWhenHighlighted:NO];
        [self.buttons addObject:btn];
        [tabBarBackGroundView addSubview:btn];
    }
    
    [self.tabBar addSubview:tabBarBackGroundView];
    //	[tabBarBackGroundView release];
    [self selectTab:0];
}

- (void)selectTab:(NSInteger)index
{
    if (index >= _buttons.count)
    {
        return;
    }
    
    NSString *normalImgName = nil;
    switch (self.selectedIndex)
    {
        case 0:
            normalImgName = @"Tab01Normal.png";
            break;
            
        case 1:
            normalImgName = @"Tab02Normal.png";
            break;
            
        case 2:
            normalImgName = @"Tab03Normal.png";
            break;
            
        case 3:
            normalImgName = @"Tab04Normal.png";
            break;
        case 4:
            normalImgName = @"Tab05Normal.png";
        default:
            break;
    }
    
    if (self.selectedIndex < _buttons.count)
    {
        UIButton *oldSelected = [_buttons objectAtIndex:self.selectedIndex];
        [oldSelected setBackgroundImage:[UIImage imageNamed:normalImgName] forState:UIControlStateNormal];
    }
    
    NSString *highlightedImgName = nil;
    switch (index)
    {
        case 0:
            highlightedImgName = @"Tab01Highlighted.png";
            break;
            
        case 1:
            highlightedImgName = @"Tab02Highlighted.png";
            break;
            
        case 2:
            highlightedImgName = @"Tab03Highlighted.png";
            break;
            
        case 3:
            highlightedImgName = @"Tab04Highlighted.png";
            break;
        case 4:
            highlightedImgName = @"Tab05Highlighted.png";
            break;
        default:
            break;
    }
    
    if (index < _buttons.count)
    {
        UIButton *newSelected = [_buttons objectAtIndex:index];
        UIImage * bg = [UIImage imageNamed:highlightedImgName];
        [newSelected setBackgroundImage:bg forState:UIControlStateNormal];
        self.selectedIndex = newSelected.tag - 10000;
    }
    
    if (self.selectedIndex < self.viewControllers.count)
    {
        UIViewController *viewController = [self.viewControllers objectAtIndex:self.selectedIndex];
        self.title = viewController.title;
    }
}

- (void)selectViewController:(UIViewController *)viewController
{
    if (viewController == nil)
    {
        return;
    }
    
    NSInteger controllerCount = self.viewControllers.count;
    for (NSInteger i = 0; i < controllerCount; i++)
    {
        if (viewController == [self.viewControllers objectAtIndex:i])
        {
            [self selectTab:i];
            break;
        }
    }
}


- (void)setPromptNum:(NSInteger)num onTabbarItem:(NSInteger)index
{
    NSInteger itemCount = _buttons.count;
    
    if (index < 0 || index >= itemCount)
    {
        return;
    }
    
    UIButton *itemBtn = [_buttons objectAtIndex:index];
    if (itemBtn != nil)
    {
        if (num > 0)
        {
            UIImageView *imageView = (UIImageView *)[itemBtn viewWithTag:kCartNumBackgroundImageTag];
            if (imageView == nil)
            {
                imageView = [[UIImageView alloc] initWithFrame:CGRectMake(45.0, 1.0, 19.0, 19.0)];
                imageView.tag = kCartNumBackgroundImageTag;
                imageView.image = [UIImage imageNamed:@"Prompt"];
                [itemBtn addSubview:imageView];
                //                [imageView release];
            }
            
            UILabel *label = (UILabel *)[itemBtn viewWithTag:kCartNumTextLabelTag];
            if (label == nil)
            {
                label = [[UILabel alloc] initWithFrame:CGRectMake(45.5, 1.0, 18.0, 19.0)];
                label.tag = kCartNumTextLabelTag;
                label.font = [UIFont systemFontOfSize:11.0];
                label.textColor = [UIColor whiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
                label.backgroundColor = [UIColor clearColor];
                [itemBtn addSubview:label];
                //                [label release];
            }
            
            if (num > 99)
            {
                label.text = @"...";
            }
            else
            {
                label.text = [NSString stringWithFormat:@"%ld", num];
            }
        }
        else
        {
            UIImageView *imageView = (UIImageView *)[itemBtn viewWithTag:kCartNumBackgroundImageTag];
            if (imageView != nil)
            {
                [imageView removeFromSuperview];
            }
            
            UILabel *label = (UILabel *)[itemBtn viewWithTag:kCartNumTextLabelTag];
            if (label != nil)
            {
                [label removeFromSuperview];
            }
        }
    }
}

CGFloat getDeviceHeight(){
    UIScreen *screen = [UIScreen mainScreen];
    return screen.bounds.size.height;
}

#pragma mark- HiddenTabBarMethods
BOOL isAnimating = NO;
- (void) hideTabBar:(BOOL) hidden
{
    if (hidden && !isAnimating) {
        isAnimating = YES;
        [UIView animateWithDuration:kDuration delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^(){
            
            CGRect frame = self.tabBar.frame;
            frame.origin.y = getDeviceHeight();
            self.tabBar.frame = frame;
            
        } completion:^(BOOL complete)
         {
             isAnimating = NO;
         }];
        
    }else if (!hidden && !isAnimating){
        isAnimating = YES;
        [UIView animateWithDuration:kDuration delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^(){
            
            CGRect frame = self.tabBar.frame;
            frame.origin.y = getDeviceHeight() - 49;
            self.tabBar.frame = frame;
            
        } completion:^(BOOL complete)
         {
             isAnimating = NO;
         }];
        
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 }
 */


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
