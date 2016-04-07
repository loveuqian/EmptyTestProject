//
//  TableViewController.m
//  EmptyTestProject
//
//  Created by WangShengFeng on 16/4/7.
//  Copyright © 2016年 loveuqian. All rights reserved.
//

#import "TableViewController.h"

#import <AFNetworking.h>
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>

@interface TableViewController ()

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation TableViewController

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.estimatedRowHeight = 100;
    
    self.tableView.mj_header =
    [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadData
{
    WeakSelf;
    
    self.dataArr = nil;
    
    [self.manager GET:@"https://www.v2ex.com/api/topics/hot.json"
           parameters:nil
             progress:nil
              success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
                  [weakSelf.dataArr addObjectsFromArray:responseObject];
                  [weakSelf.tableView reloadData];
                  [weakSelf.tableView.mj_header endRefreshing];
                  weakSelf.tableView.mj_footer =
                  [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
              }
              failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                  NSLog(@"%@", error);
              }];
}

- (void)loadMoreData
{
    WeakSelf;
    
    [self.manager GET:@"https://www.v2ex.com/api/topics/hot.json"
           parameters:nil
             progress:nil
              success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
                  [weakSelf.dataArr addObjectsFromArray:responseObject];
                  [weakSelf.tableView reloadData];
                  [weakSelf.tableView.mj_footer endRefreshing];
              }
              failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                  NSLog(@"%@", error);
              }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    NSDictionary *dataDict = self.dataArr[indexPath.row];
    cell.textLabel.text = dataDict[@"title"];
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.text = dataDict[@"member"][@"username"];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http:%@",
                                                             dataDict[@"member"][@"avatar_normal"]]]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 [cell layoutSubviews];
                             }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    NSDictionary *dataDict = self.dataArr[indexPath.row];
    textView.text = dataDict.description;
    
    UIViewController *detailVC = [[UIViewController alloc] init];
    detailVC.view.backgroundColor = [UIColor whiteColor];
    
    [detailVC.view addSubview:textView];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
