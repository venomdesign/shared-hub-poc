import { Component, signal } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { UiBadgeComponent } from 'shared-ui-v1';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, UiBadgeComponent],
  templateUrl: './app.html',
  styleUrl: './app.scss'
})
export class App {
  protected readonly title = signal('mfe1');
}
