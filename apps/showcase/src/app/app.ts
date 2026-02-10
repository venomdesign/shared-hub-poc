import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { CommonModule } from '@angular/common';
import { UiBadgeComponent } from 'shared-ui';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, CommonModule, UiBadgeComponent],
  templateUrl: './app.html',
  styleUrl: './app.scss'
})
export class App {
  title = 'Shared UI Showcase';
}
