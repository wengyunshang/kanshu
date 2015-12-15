#import <Foundation/Foundation.h>
#import "JMStaticContentTableViewBlocks.h"

@class JMStaticContentTableViewCell;

@interface JMStaticContentTableViewSection : NSObject

@property (nonatomic, assign) UITableView *tableView;
@property (nonatomic, strong) NSArray *staticContentCells;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger sectionum;

- (void) addCell:(JMStaticContentTableViewCellBlock)configurationBlock;

- (void) addCell:(JMStaticContentTableViewCellBlock)configurationBlock
	whenSelected:(JMStaticContentTableViewCellWhenSelectedBlock)whenSelectedBlock;

- (void) insertCell:(JMStaticContentTableViewCellBlock)configurationBlock
	   whenSelected:(JMStaticContentTableViewCellWhenSelectedBlock)whenSelectedBlock
		atIndexPath:(NSIndexPath *)indexPath
		   animated:(BOOL)animated;

- (void) removeAllCells;
- (void) removeCellAtIndex:(NSUInteger)rowIndex;
- (void) removeCellAtIndex:(NSUInteger)rowIndex animated:(BOOL)animated;

@end