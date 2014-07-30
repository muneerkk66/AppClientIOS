

#import "MNMPullToRefreshManager.h"
#import "MNMPullToRefreshView.h"

static CGFloat const kAnimationDuration = 0.2f;

@interface MNMPullToRefreshManager()

/*
 * The pull-to-refresh view to add to the top of the table.
 */
@property (nonatomic, readwrite, strong) MNMPullToRefreshView *pullToRefreshView;

/*
 * Table view in which pull to refresh view will be added.
 */
@property (nonatomic, readwrite, weak) UITableView *table;

/*
 * Client object that observes changes in the pull-to-refresh.
 */
@property (nonatomic, readwrite, weak) id<MNMPullToRefreshManagerClient> client;

@end

@implementation MNMPullToRefreshManager

@synthesize pullToRefreshView = pullToRefreshView_;
@synthesize table = table_;
@synthesize client = client_;

#pragma mark -
#pragma mark Instance initialization

/*
 * Initializes the manager object with the information to link view and table
 */
- (id)initWithPullToRefreshViewHeight:(CGFloat)height tableView:(UITableView *)table withClient:(id<MNMPullToRefreshManagerClient>)client {

    if (self = [super init]) {
        
        client_ = client;
        table_ = table;        
        pullToRefreshView_ = [[MNMPullToRefreshView alloc] initWithFrame:CGRectMake(0.0f, -height, CGRectGetWidth([table_ frame]), height)];
        
        [table_ addSubview:pullToRefreshView_];
    }
    
    return self;
}

#pragma mark -
#pragma mark Table view scroll management

/*
 * Checks state of control depending on tableView scroll offset
 */
- (void)tableViewScrolled {
    
    if (![pullToRefreshView_ isHidden] && ![pullToRefreshView_ isLoading]) {
        
        CGFloat offset = [table_ contentOffset].y;

        if (offset >= 0.0f) {
        
            [pullToRefreshView_ changeStateOfControl:MNMPullToRefreshViewStateIdle withOffset:offset];
            
        } else if (offset <= 0.0f && offset >= -[pullToRefreshView_ fixedHeight]) {
                
            [pullToRefreshView_ changeStateOfControl:MNMPullToRefreshViewStatePull withOffset:offset];
            
        } else {
            
            [pullToRefreshView_ changeStateOfControl:MNMPullToRefreshViewStateRelease withOffset:offset];
        }
    }
}

/*
 * Checks releasing of the tableView
 */
- (void)tableViewReleased {
    
    if (![pullToRefreshView_ isHidden] && ![pullToRefreshView_ isLoading]) {
        
        CGFloat offset = [table_ contentOffset].y;
        
        if (offset <= 0.0f && offset < -[pullToRefreshView_ fixedHeight]) {
            
            [pullToRefreshView_ changeStateOfControl:MNMPullToRefreshViewStateLoading withOffset:offset];
            
            UIEdgeInsets insets = UIEdgeInsetsMake([pullToRefreshView_ fixedHeight], 0.0f, 0.0f, 0.0f);
            
            [UIView animateWithDuration:kAnimationDuration animations:^{

                [table_ setContentInset:insets];
            }];
            
            [client_ pullToRefreshTriggered:self];
        }
    }
}

/*
 * The reload of the table is completed
 */
- (void)tableViewReloadFinishedAnimated:(BOOL)animated {
    
    [UIView animateWithDuration:(animated ? kAnimationDuration : 0.0f) animations:^{
        
        [table_ setContentInset:UIEdgeInsetsZero];
    
    } completion:^(BOOL finished) {
        
        [pullToRefreshView_ setLastUpdateDate:[NSDate date]];
        [pullToRefreshView_ changeStateOfControl:MNMPullToRefreshViewStateIdle withOffset:CGFLOAT_MAX];
    }];    
}

#pragma mark -
#pragma mark Properties

/*
 * Sets the pull-to-refresh view visible or not. Visible by default
 */
- (void)setPullToRefreshViewVisible:(BOOL)visible {
    
    [pullToRefreshView_ setHidden:!visible];
}

@end