//
//  NSBundle+Bundle.h
//  ConsentWidgetsTests
//
//  Created by Ravi Kiran HR on 04/12/17.
//  Copyright © 2016 /* Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (Bundle)

/**
 *  Method to load the Swizzler for mainBundle method, It is used for taking the resources from Test bundle whenever we call mainBundle in App Infra framework.
 *
 *  @return void
 */
+(void)loadSwizzler;

@end
