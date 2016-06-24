//
//  SecondViewController.m
//  MotionTrail
//
//  Created by chao on 16/4/5.
//  Copyright © 2016年 DoctorMundo. All rights reserved.
//

#import "SecondViewController.h"
#import "FmdbClass.h"
#import "LocationModel.h"
#import "DetailViewController.h"
#import <MJRefresh.h>

@interface SecondViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *array;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _array = [NSMutableArray array];
    _array = [FmdbClass selectAllData];

    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJrefresh)];
    
    
}
- (void)MJrefresh {
    _array = [FmdbClass selectAllData];
    [_tableView reloadData];
    [_tableView.mj_header endRefreshing];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.hidesBottomBarWhenPushed = NO;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    LocationModel * model = _array[indexPath.row];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.time;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationModel * model = _array[indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"detailid"];
    detailVC.titleName = model.name;
    [self.navigationController pushViewController:detailVC animated:YES];
    
    //[self presentViewController:detailVC animated:YES completion:nil];
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        LocationModel *model = [[LocationModel alloc] init];
        model = [_array objectAtIndex:indexPath.row];
        [_array removeObjectAtIndex:indexPath.row];
        [FmdbClass deleteData:model.name];
        
        
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
