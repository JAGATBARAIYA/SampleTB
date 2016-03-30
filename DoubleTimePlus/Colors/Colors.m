//
//  Colors.m
//  DoubleTimePlus
//
//  Created by Manish on 14/11/14.
//  Copyright (c) 2014 Manish. All rights reserved.
//

#import "Colors.h"
#import "UIColor+BFPaperColors.h"

@implementation Colors

+ (id)sharedColors{
    static Colors *sharedColors = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedColors = [[self alloc] init];
    });
    return sharedColors;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _arrColors = [NSMutableArray arrayWithArray:[self populateColorsArray]];
    }
    return self;
}

- (NSArray *)populateColorsArray{
    NSMutableArray *shades = [NSMutableArray new];
    
    // Red:
    [shades addObject:[UIColor paperColorRed100]];
    [shades addObject:[UIColor paperColorRed200]];
    [shades addObject:[UIColor paperColorRed300]];
    [shades addObject:[UIColor paperColorRed400]];
    [shades addObject:[UIColor paperColorRed500]];
    [shades addObject:[UIColor paperColorRed600]];
    [shades addObject:[UIColor paperColorRed700]];
    [shades addObject:[UIColor paperColorRed800]];
    [shades addObject:[UIColor paperColorRed900]];
    [shades addObject:[UIColor paperColorRedA100]];
    [shades addObject:[UIColor paperColorRedA200]];
    [shades addObject:[UIColor paperColorRedA400]];
    [shades addObject:[UIColor paperColorRedA700]];
    
    // Pink:
    [shades addObject:[UIColor paperColorPink100]];
    [shades addObject:[UIColor paperColorPink200]];
    [shades addObject:[UIColor paperColorPink300]];
    [shades addObject:[UIColor paperColorPink400]];
    [shades addObject:[UIColor paperColorPink500]];
    [shades addObject:[UIColor paperColorPink600]];
    [shades addObject:[UIColor paperColorPink700]];
    [shades addObject:[UIColor paperColorPink800]];
    [shades addObject:[UIColor paperColorPink900]];
    [shades addObject:[UIColor paperColorPinkA100]];
    [shades addObject:[UIColor paperColorPinkA200]];
    [shades addObject:[UIColor paperColorPinkA400]];
    [shades addObject:[UIColor paperColorPinkA700]];
    
    // Purple:
    [shades addObject:[UIColor paperColorPurple100]];
    [shades addObject:[UIColor paperColorPurple200]];
    [shades addObject:[UIColor paperColorPurple300]];
    [shades addObject:[UIColor paperColorPurple400]];
    [shades addObject:[UIColor paperColorPurple500]];
    [shades addObject:[UIColor paperColorPurple600]];
    [shades addObject:[UIColor paperColorPurple700]];
    [shades addObject:[UIColor paperColorPurple800]];
    [shades addObject:[UIColor paperColorPurple900]];
    [shades addObject:[UIColor paperColorPurpleA100]];
    [shades addObject:[UIColor paperColorPurpleA200]];
    [shades addObject:[UIColor paperColorPurpleA400]];
    [shades addObject:[UIColor paperColorPurpleA700]];
    
    // Deep Purple:
    [shades addObject:[UIColor paperColorDeepPurple100]];
    [shades addObject:[UIColor paperColorDeepPurple200]];
    [shades addObject:[UIColor paperColorDeepPurple300]];
    [shades addObject:[UIColor paperColorDeepPurple400]];
    [shades addObject:[UIColor paperColorDeepPurple500]];
    [shades addObject:[UIColor paperColorDeepPurple600]];
    [shades addObject:[UIColor paperColorDeepPurple700]];
    [shades addObject:[UIColor paperColorDeepPurple800]];
    [shades addObject:[UIColor paperColorDeepPurple900]];
    [shades addObject:[UIColor paperColorDeepPurpleA100]];
    [shades addObject:[UIColor paperColorDeepPurpleA200]];
    [shades addObject:[UIColor paperColorDeepPurpleA400]];
    [shades addObject:[UIColor paperColorDeepPurpleA700]];
    
    // Indigo:
    [shades addObject:[UIColor paperColorIndigo100]];
    [shades addObject:[UIColor paperColorIndigo200]];
    [shades addObject:[UIColor paperColorIndigo300]];
    [shades addObject:[UIColor paperColorIndigo400]];
    [shades addObject:[UIColor paperColorIndigo500]];
    [shades addObject:[UIColor paperColorIndigo600]];
    [shades addObject:[UIColor paperColorIndigo700]];
    [shades addObject:[UIColor paperColorIndigo800]];
    [shades addObject:[UIColor paperColorIndigo900]];
    [shades addObject:[UIColor paperColorIndigoA100]];
    [shades addObject:[UIColor paperColorIndigoA200]];
    [shades addObject:[UIColor paperColorIndigoA400]];
    [shades addObject:[UIColor paperColorIndigoA700]];
    
    // Blue:
    [shades addObject:[UIColor paperColorBlue100]];
    [shades addObject:[UIColor paperColorBlue200]];
    [shades addObject:[UIColor paperColorBlue300]];
    [shades addObject:[UIColor paperColorBlue400]];
    [shades addObject:[UIColor paperColorBlue500]];
    [shades addObject:[UIColor paperColorBlue600]];
    [shades addObject:[UIColor paperColorBlue700]];
    [shades addObject:[UIColor paperColorBlue800]];
    [shades addObject:[UIColor paperColorBlue900]];
    [shades addObject:[UIColor paperColorBlueA100]];
    [shades addObject:[UIColor paperColorBlueA200]];
    [shades addObject:[UIColor paperColorBlueA400]];
    [shades addObject:[UIColor paperColorBlueA700]];
    
    // Light Blue:
    [shades addObject:[UIColor paperColorLightBlue100]];
    [shades addObject:[UIColor paperColorLightBlue200]];
    [shades addObject:[UIColor paperColorLightBlue300]];
    [shades addObject:[UIColor paperColorLightBlue400]];
    [shades addObject:[UIColor paperColorLightBlue500]];
    [shades addObject:[UIColor paperColorLightBlue600]];
    [shades addObject:[UIColor paperColorLightBlue700]];
    [shades addObject:[UIColor paperColorLightBlue800]];
    [shades addObject:[UIColor paperColorLightBlue900]];
    [shades addObject:[UIColor paperColorLightBlueA100]];
    [shades addObject:[UIColor paperColorLightBlueA200]];
    [shades addObject:[UIColor paperColorLightBlueA400]];
    [shades addObject:[UIColor paperColorLightBlueA700]];
    
    // Cyan:
    [shades addObject:[UIColor paperColorCyan100]];
    [shades addObject:[UIColor paperColorCyan200]];
    [shades addObject:[UIColor paperColorCyan300]];
    [shades addObject:[UIColor paperColorCyan400]];
    [shades addObject:[UIColor paperColorCyan500]];
    [shades addObject:[UIColor paperColorCyan600]];
    [shades addObject:[UIColor paperColorCyan700]];
    [shades addObject:[UIColor paperColorCyan800]];
    [shades addObject:[UIColor paperColorCyan900]];
    [shades addObject:[UIColor paperColorCyanA100]];
    [shades addObject:[UIColor paperColorCyanA200]];
    [shades addObject:[UIColor paperColorCyanA400]];
    [shades addObject:[UIColor paperColorCyanA700]];
    
    // Teal:
    [shades addObject:[UIColor paperColorTeal100]];
    [shades addObject:[UIColor paperColorTeal200]];
    [shades addObject:[UIColor paperColorTeal300]];
    [shades addObject:[UIColor paperColorTeal400]];
    [shades addObject:[UIColor paperColorTeal500]];
    [shades addObject:[UIColor paperColorTeal600]];
    [shades addObject:[UIColor paperColorTeal700]];
    [shades addObject:[UIColor paperColorTeal800]];
    [shades addObject:[UIColor paperColorTeal900]];
    [shades addObject:[UIColor paperColorTealA100]];
    [shades addObject:[UIColor paperColorTealA200]];
    [shades addObject:[UIColor paperColorTealA400]];
    [shades addObject:[UIColor paperColorTealA700]];
    
    // Green:
    [shades addObject:[UIColor paperColorGreen50]];
    [shades addObject:[UIColor paperColorGreen100]];
    [shades addObject:[UIColor paperColorGreen200]];
    [shades addObject:[UIColor paperColorGreen300]];
    [shades addObject:[UIColor paperColorGreen400]];
    [shades addObject:[UIColor paperColorGreen500]];
    [shades addObject:[UIColor paperColorGreen600]];
    [shades addObject:[UIColor paperColorGreen700]];
    [shades addObject:[UIColor paperColorGreen800]];
    [shades addObject:[UIColor paperColorGreen900]];
    [shades addObject:[UIColor paperColorGreenA100]];
    [shades addObject:[UIColor paperColorGreenA200]];
    [shades addObject:[UIColor paperColorGreenA400]];
    [shades addObject:[UIColor paperColorGreenA700]];
    
    // Light Green:
    [shades addObject:[UIColor paperColorLightGreen100]];
    [shades addObject:[UIColor paperColorLightGreen200]];
    [shades addObject:[UIColor paperColorLightGreen300]];
    [shades addObject:[UIColor paperColorLightGreen400]];
    [shades addObject:[UIColor paperColorLightGreen500]];
    [shades addObject:[UIColor paperColorLightGreen600]];
    [shades addObject:[UIColor paperColorLightGreen700]];
    [shades addObject:[UIColor paperColorLightGreen800]];
    [shades addObject:[UIColor paperColorLightGreen900]];
    [shades addObject:[UIColor paperColorLightGreenA100]];
    [shades addObject:[UIColor paperColorLightGreenA200]];
    [shades addObject:[UIColor paperColorLightGreenA400]];
    [shades addObject:[UIColor paperColorLightGreenA700]];
    
    // Lime:
    [shades addObject:[UIColor paperColorLime100]];
    [shades addObject:[UIColor paperColorLime200]];
    [shades addObject:[UIColor paperColorLime300]];
    [shades addObject:[UIColor paperColorLime400]];
    [shades addObject:[UIColor paperColorLime500]];
    [shades addObject:[UIColor paperColorLime600]];
    [shades addObject:[UIColor paperColorLime700]];
    [shades addObject:[UIColor paperColorLime800]];
    [shades addObject:[UIColor paperColorLime900]];
    [shades addObject:[UIColor paperColorLimeA100]];
    [shades addObject:[UIColor paperColorLimeA200]];
    [shades addObject:[UIColor paperColorLimeA400]];
    [shades addObject:[UIColor paperColorLimeA700]];
    
//    // Yellow:
//    [shades addObject:[UIColor paperColorYellow100]];
//    [shades addObject:[UIColor paperColorYellow200]];
//    [shades addObject:[UIColor paperColorYellow300]];
//    [shades addObject:[UIColor paperColorYellow400]];
//    [shades addObject:[UIColor paperColorYellow500]];
//    [shades addObject:[UIColor paperColorYellow600]];
//    [shades addObject:[UIColor paperColorYellow700]];
//    [shades addObject:[UIColor paperColorYellow800]];
//    [shades addObject:[UIColor paperColorYellow900]];
//    [shades addObject:[UIColor paperColorYellowA100]];
//    [shades addObject:[UIColor paperColorYellowA200]];
//    [shades addObject:[UIColor paperColorYellowA400]];
//    [shades addObject:[UIColor paperColorYellowA700]];
    
    // Amber:
    [shades addObject:[UIColor paperColorAmber100]];
    [shades addObject:[UIColor paperColorAmber200]];
    [shades addObject:[UIColor paperColorAmber300]];
    [shades addObject:[UIColor paperColorAmber400]];
    [shades addObject:[UIColor paperColorAmber500]];
    [shades addObject:[UIColor paperColorAmber600]];
    [shades addObject:[UIColor paperColorAmber700]];
    [shades addObject:[UIColor paperColorAmber800]];
    [shades addObject:[UIColor paperColorAmber900]];
    [shades addObject:[UIColor paperColorAmberA100]];
    [shades addObject:[UIColor paperColorAmberA200]];
    [shades addObject:[UIColor paperColorAmberA400]];
    [shades addObject:[UIColor paperColorAmberA700]];
    
    // Orange:
    [shades addObject:[UIColor paperColorOrange100]];
    [shades addObject:[UIColor paperColorOrange200]];
    [shades addObject:[UIColor paperColorOrange300]];
    [shades addObject:[UIColor paperColorOrange400]];
    [shades addObject:[UIColor paperColorOrange500]];
    [shades addObject:[UIColor paperColorOrange600]];
    [shades addObject:[UIColor paperColorOrange700]];
    [shades addObject:[UIColor paperColorOrange800]];
    [shades addObject:[UIColor paperColorOrange900]];
    [shades addObject:[UIColor paperColorOrangeA100]];
    [shades addObject:[UIColor paperColorOrangeA200]];
    [shades addObject:[UIColor paperColorOrangeA400]];
    [shades addObject:[UIColor paperColorOrangeA700]];
    
    // Deep Orange:
    [shades addObject:[UIColor paperColorDeepOrange100]];
    [shades addObject:[UIColor paperColorDeepOrange200]];
    [shades addObject:[UIColor paperColorDeepOrange300]];
    [shades addObject:[UIColor paperColorDeepOrange400]];
    [shades addObject:[UIColor paperColorDeepOrange500]];
    [shades addObject:[UIColor paperColorDeepOrange600]];
    [shades addObject:[UIColor paperColorDeepOrange700]];
    [shades addObject:[UIColor paperColorDeepOrange800]];
    [shades addObject:[UIColor paperColorDeepOrange900]];
    [shades addObject:[UIColor paperColorDeepOrangeA100]];
    [shades addObject:[UIColor paperColorDeepOrangeA200]];
    [shades addObject:[UIColor paperColorDeepOrangeA400]];
    [shades addObject:[UIColor paperColorDeepOrangeA700]];
    
    // Brown:
    [shades addObject:[UIColor paperColorBrown100]];
    [shades addObject:[UIColor paperColorBrown200]];
    [shades addObject:[UIColor paperColorBrown300]];
    [shades addObject:[UIColor paperColorBrown400]];
    [shades addObject:[UIColor paperColorBrown500]];
    [shades addObject:[UIColor paperColorBrown600]];
    [shades addObject:[UIColor paperColorBrown700]];
    [shades addObject:[UIColor paperColorBrown800]];
    [shades addObject:[UIColor paperColorBrown900]];
    
    // Blue Gray:
    [shades addObject:[UIColor paperColorBlueGray100]];
    [shades addObject:[UIColor paperColorBlueGray200]];
    [shades addObject:[UIColor paperColorBlueGray300]];
    [shades addObject:[UIColor paperColorBlueGray400]];
    [shades addObject:[UIColor paperColorBlueGray500]];
    [shades addObject:[UIColor paperColorBlueGray600]];
    [shades addObject:[UIColor paperColorBlueGray700]];
    [shades addObject:[UIColor paperColorBlueGray800]];
    [shades addObject:[UIColor paperColorBlueGray900]];
    
    return shades;
}

@end
