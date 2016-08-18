import {platformBrowser} from '@angular/platform-browser';
import {BasicModuleNgFactory} from './basic.ngfactory';
import {createPlatformFactory} from '@angular/core';


platformBrowser().bootstrapModuleFactory(BasicModuleNgFactory);