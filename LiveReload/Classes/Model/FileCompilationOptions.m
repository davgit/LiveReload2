
#import "FileCompilationOptions.h"


@implementation FileCompilationOptions

@synthesize sourcePath=_sourcePath;
@synthesize destinationDirectory=_destinationDirectory;
@synthesize additionalOptions=_additionalOptions;


#pragma mark - init/dealloc

- (id)initWithFile:(NSString *)sourcePath memento:(NSDictionary *)memento {
    self = [super init];
    if (self) {
        _sourcePath = [sourcePath copy];
        _destinationDirectory = [memento objectForKey:@"output_dir"];
        if ([_destinationDirectory length] == 0) {
            _destinationDirectory = nil;
        } else if ([_destinationDirectory isEqualToString:@"."]) {
            _destinationDirectory = @"";
        }
        _additionalOptions = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc {
    [_sourcePath release], _sourcePath = nil;
    [_destinationDirectory release], _destinationDirectory = nil;
    [_additionalOptions release], _additionalOptions = nil;
    [super dealloc];
}


#pragma mark -

- (NSDictionary *)memento {
    return [NSDictionary dictionaryWithObjectsAndKeys:(_destinationDirectory ? ([_destinationDirectory length] == 0 ? @"." : _destinationDirectory) : @""), @"output_dir", nil];
}


#pragma mark -

- (void)setDestinationDirectory:(NSString *)destinationDirectory {
    if (_destinationDirectory != destinationDirectory) {
        [_destinationDirectory release];
        _destinationDirectory = [destinationDirectory retain];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged" object:self];
    }
}


#pragma mark -

+ (NSString *)commonOutputDirectoryFor:(NSArray *)fileOptions {
    NSString *commonOutputDirectory = nil;
    for (FileCompilationOptions *options in fileOptions) {
        if (options.destinationDirectory == nil)
            continue;
        if (commonOutputDirectory == nil) {
            commonOutputDirectory = options.destinationDirectory;
        } else if (![commonOutputDirectory isEqualToString:options.destinationDirectory]) {
            return nil;
        }
    }
    return (commonOutputDirectory ? commonOutputDirectory : @"__NONE_SET__");
}

@end
