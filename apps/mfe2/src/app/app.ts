import { Component, signal } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { UiBadgeComponent, SHARED_UI_VERSION } from 'shared-ui-v2';
import { GridModule, PageService, SortService, FilterService } from '@syncfusion/ej2-angular-grids';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, UiBadgeComponent, GridModule],
  providers: [PageService, SortService, FilterService],
  templateUrl: './app.html',
  styleUrl: './app.scss'
})
export class App {
  protected readonly title = signal('mfe2');
  protected readonly actualVersion = SHARED_UI_VERSION;
  protected readonly requestedVersion = '2.0.0';
  protected readonly isOverridden = (SHARED_UI_VERSION as string) !== this.requestedVersion;
  
  // Syncfusion Grid Data
  public gridData: Object[] = [
    { OrderID: 10248, CustomerName: 'Paul Henriot', OrderDate: new Date(8364186e5), Freight: 32.38, ShipCountry: 'France' },
    { OrderID: 10249, CustomerName: 'Karin Josephs', OrderDate: new Date(836505e6), Freight: 11.61, ShipCountry: 'Germany' },
    { OrderID: 10250, CustomerName: 'Mario Pontes', OrderDate: new Date(8367642e5), Freight: 65.83, ShipCountry: 'Brazil' },
    { OrderID: 10251, CustomerName: 'Mary Saveley', OrderDate: new Date(8368506e5), Freight: 41.34, ShipCountry: 'France' },
    { OrderID: 10252, CustomerName: 'Pascale Cartrain', OrderDate: new Date(8369370e5), Freight: 51.30, ShipCountry: 'Belgium' },
    { OrderID: 10253, CustomerName: 'Mario Pontes', OrderDate: new Date(8370234e5), Freight: 58.17, ShipCountry: 'Brazil' },
    { OrderID: 10254, CustomerName: 'Yang Wang', OrderDate: new Date(8371098e5), Freight: 22.98, ShipCountry: 'Switzerland' },
    { OrderID: 10255, CustomerName: 'Michael Holz', OrderDate: new Date(8371962e5), Freight: 148.33, ShipCountry: 'Switzerland' },
    { OrderID: 10256, CustomerName: 'Paula Parente', OrderDate: new Date(8372826e5), Freight: 13.97, ShipCountry: 'Brazil' },
    { OrderID: 10257, CustomerName: 'Carlos Hernández', OrderDate: new Date(8373690e5), Freight: 81.91, ShipCountry: 'Venezuela' },
    { OrderID: 10258, CustomerName: 'Roland Mendel', OrderDate: new Date(8374554e5), Freight: 140.51, ShipCountry: 'Austria' },
    { OrderID: 10259, CustomerName: 'Francisco Chang', OrderDate: new Date(8375418e5), Freight: 3.25, ShipCountry: 'Mexico' },
    { OrderID: 10260, CustomerName: 'Henriette Pfalzheim', OrderDate: new Date(8376282e5), Freight: 55.09, ShipCountry: 'Germany' },
    { OrderID: 10261, CustomerName: 'Bernardo Batista', OrderDate: new Date(8377146e5), Freight: 3.05, ShipCountry: 'Brazil' },
    { OrderID: 10262, CustomerName: 'Ann Devon', OrderDate: new Date(8378010e5), Freight: 48.29, ShipCountry: 'Germany' },
  ];
  
  public pageSettings: Object = { pageSize: 8 };
}
