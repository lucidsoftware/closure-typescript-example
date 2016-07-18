import {bootstrapModuleFactory} from '@angular/core';
import {browserPlatform} from '@angular/platform-browser';
import {BasicModuleNgFactory} from './basic.ngfactory';

bootstrapModuleFactory(BasicModuleNgFactory, browserPlatform());