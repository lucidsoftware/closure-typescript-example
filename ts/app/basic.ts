import {BrowserModule} from '@angular/platform-browser';
import {ANALYZE_FOR_PRECOMPILE, ApplicationRef, AppModule, Component, ComponentFactoryResolver, Directive, Inject, Injectable, Input, OpaqueToken, Pipe} from '@angular/core';
import {Greeter} from './greeter';
import Statement from 'goog:Statement';

@Component({
  selector: 'basic',
  templateUrl: './basic.html',
})
@Injectable()
export class Basic {
  ctxProp: string;
  constructor() { this.ctxProp = new Greeter(new Statement('Hello from basic.ts')).greet();}
}

@AppModule({
  precompile: [Basic],
  modules: [BrowserModule]
})
export class BasicModule {
	constructor(appRef: ApplicationRef) {
	  var compRef =
	      appRef.bootstrap(Basic);
	}
}