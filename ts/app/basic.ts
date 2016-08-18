import {BrowserModule} from '@angular/platform-browser';
import {ApplicationRef, NgModule, Component, Injectable} from '@angular/core';
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

@NgModule({
  declarations: [Basic],
  entryComponents: [Basic],
  imports: [BrowserModule],
})
export class BasicModule {
	ngDoBootstrap(appRef: ApplicationRef) {
	  var compRef =
	      appRef.bootstrap(Basic);
	}
}