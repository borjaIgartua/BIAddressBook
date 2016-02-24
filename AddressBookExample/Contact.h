//
//  Contact.h
//  AddressBookExample
//
//  Created by Borja on 20/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject

- (instancetype)initWithName:(NSString *)name
                   lastname:(NSString *)lasname
                  imageData:(NSData *)imageData
                   recordID:(NSInteger)recordID
                 telephones:(NSArray *)telephones;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *lastname;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, assign) NSInteger recordID;

@property (nonatomic, strong) NSArray *telephones;

@end
