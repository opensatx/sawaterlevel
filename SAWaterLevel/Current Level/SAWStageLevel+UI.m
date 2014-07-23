/*
 *
 *  Copyright (c) 2014 Wayne Hartman
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy of
 *  this software and associated documentation files (the "Software"), to deal in the
 *  Software without restriction, including without limitation the rights to use,
 *  copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
 *  Software, and to permit persons to whom the Software is furnished to do so, subject
 *  to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in all copies
 *  or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 *  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 *  PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 *  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 *  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 *  THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 */

#import "SAWStageLevel+UI.h"

@implementation SAWStageLevel (UI)

- (UIColor *)backgroundColor {
    switch (self.level) {
        case SAWStageLevelNormal:   //  Light Blue
            return [UIColor colorWithRed:113.0f/255.0f
                                   green:174.0f/255.0f
                                    blue:212.0f/255.0f
                                   alpha:1.0f];
        case SAWStageLevel1:    //  Green
            return [UIColor colorWithRed:163.0f/255.0f
                                   green:212.0f/255.0f
                                    blue:113.0f/255.0f
                                   alpha:1.0f];
        case SAWStageLevel2:    //  Yellow
            return [UIColor colorWithRed:255.0f/255.0f
                                   green:212.0f/255.0f
                                    blue:99.0f/255.0f
                                   alpha:1.0f];
        case SAWStageLevel3:    //  Orange
            return [UIColor colorWithRed:255.0f/255.0f
                                   green:170.0f/255.0f
                                    blue:87.0f/255.0f
                                   alpha:1.0f];
        case SAWStageLevel4:    //  Red
            return [UIColor colorWithRed:255.0f/255.0f
                                   green:97.0f/255.0f
                                    blue:67.0f/255.0f
                                   alpha:1.0f];
        case SAWStageLevel5:    //  Purple
            return [UIColor colorWithRed:105.0f/255.0f
                                   green:68.0f/255.0f
                                    blue:108.0f/255.0f
                                   alpha:1.0f];
    }
    
    return nil;
}

- (UIColor *)foregroundColor {
    switch (self.level) {
        case SAWStageLevel5:
            return [UIColor whiteColor];
        default:
            return [UIColor blackColor];
    }
}

@end
