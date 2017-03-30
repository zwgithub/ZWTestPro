//
//  ZWFirstVC.m
//  ZWTestProject
//
//  Created by caozhenwei on 17/3/24.
//  Copyright © 2017年 czw. All rights reserved.
//

#import "ZWFirstVC.h"

@interface ZWFirstVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ZWFirstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"First";
    
    [self.view addSubview:self.tableView];
    
    _dataArray = @[
                    @{@"ZWAvPlayerVC":@"视频播放"},
                    @{@"ZWProgressViewController":@"progressView"}];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma UITableViewDataSource && UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:[[dic allKeys] objectAtIndex:0]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
    ZWBaseVC *clazz = [[NSClassFromString([[dic allKeys] objectAtIndex:0]) alloc] init];
    clazz.navTitleStr = [dic objectForKey:[[dic allKeys] objectAtIndex:0]];
    clazz.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:(UIViewController *)clazz animated:YES];
}

@end
