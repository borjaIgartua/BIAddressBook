//
//  ViewController.m
//  AddressBookExample
//
//  Created by Borja on 20/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

#import "ViewController.h"
#import "BIAddressBook.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BIAddressBook *addressBook = [[BIAddressBook alloc] init];
    
    NSLog(@"Starting reading contacts");
    [addressBook readAllContactsCompletion:^(NSArray *contacts, BOOL permissionsGranted) {
        
        if (permissionsGranted) {
            NSLog(@"Contacts retrieved: %ld", (long)contacts.count);
        }
        
    }];
    
    NSLog(@"Task while reading");
}


@end
