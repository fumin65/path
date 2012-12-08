//
//  ViewController.m
//  path
//
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController () {
    UITableView *tableView;
    UIImageView *imageView;
    UIView *scrollPanel;
    float defaultY;
    CGSize defaultSize;
    CGFloat defaultHeight;
    CGFloat prePointY;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    UIImage *image = [UIImage imageNamed:@"dora.jpeg"];
    
    UIGraphicsBeginImageContext(CGSizeMake(320, 480));
    [image drawInRect:CGRectMake(0, 0, 320, 480)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    imageView = [[UIImageView alloc] initWithImage:image];
    CGRect frame = imageView.frame;
    frame.origin.y -= 130;
    defaultY = frame.origin.y;
    imageView.frame = frame;
    
    tableView.backgroundColor = [UIColor clearColor];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 170)];
    header.backgroundColor = [UIColor clearColor];
    
    tableView.tableHeaderView = header;
    
    [self.view addSubview:imageView];    
    [self.view addSubview:tableView];

    defaultSize = CGSizeMake(50, 20);
    scrollPanel = [[UIView alloc] initWithFrame:CGRectMake(-defaultSize.width, 0, defaultSize.width, defaultSize.height)];
    scrollPanel.backgroundColor = [UIColor blackColor];
    scrollPanel.alpha = 0.45;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [self->tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    UIView *view = [cell viewWithTag:1];
    UITextView *textView = (UITextView *)[cell viewWithTag:2];
    
    if (!view) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
        view.tag = 1;
        [cell addSubview:view];
    }
    
    if (!textView) {
        textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        textView.tag = 2;
        [cell addSubview:textView];
    }
    
    textView.text = [NSString stringWithFormat:@"%d", indexPath.section];
    view.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 30;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    float offsetY = scrollView.contentOffset.y;
    
    CGRect frame = imageView.frame;
    
    if (offsetY < 0) {
        frame.origin.y = defaultY - offsetY * 0.7;
    } else {
        frame.origin.y = defaultY - offsetY;
    }
    imageView.frame = frame;
    
    UIView *scrollIndicator = scrollView.subviews.lastObject;
    
    if (scrollIndicator.frame.size.height < defaultHeight) {
        
        CGRect panelFrame = scrollPanel.frame;
        
        if (scrollIndicator.frame.origin.y > 0) {
            panelFrame.origin.y = prePointY - (defaultHeight - scrollIndicator.frame.size.height);
        } else {
            panelFrame.origin.y = prePointY;
        }
        
        scrollPanel.frame = panelFrame;
    } else {
        prePointY = scrollPanel.frame.origin.y;
    }
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (!scrollPanel.superview) {
        
        UIView *scrollIndicator = [scrollView.subviews lastObject];
        defaultHeight = scrollIndicator.frame.size.height;
        
        [scrollIndicator.layer addSublayer:scrollPanel.layer];
        
        CGRect panelFrame = scrollPanel.frame;
        panelFrame.size = defaultSize;
        panelFrame.origin.y = (scrollIndicator.frame.size.height - scrollPanel.frame.size.height) / 2.0;
        scrollPanel.frame = panelFrame;        
    }
}

- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [scrollView removeFromSuperview];
}

@end
