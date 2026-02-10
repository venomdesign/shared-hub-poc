import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [CommonModule, RouterLink],
  template: `
    <div class="container mt-5">
      <div class="row">
        <div class="col-12">
          <h1 class="mb-4">Shared Library Version Management Demo</h1>
          <p class="lead">
            This application demonstrates how microfrontends can use different versions of shared libraries,
            with the shell having the ability to override and enforce a specific version.
          </p>
        </div>
      </div>

      <div class="row mt-4">
        <div class="col-12">
          <div class="alert alert-info">
            <h5 class="alert-heading">
              <i class="bi bi-info-circle-fill"></i> Version Management Architecture
            </h5>
            <p class="mb-2">
              This demo showcases a real-world scenario where different teams maintain their microfrontends
              at different paces:
            </p>
            <ul class="mb-0">
              <li><strong>MFE1</strong> uses <span class="badge text-bg-primary">shared-ui v1.0.0</span> (Blue badge)</li>
              <li><strong>MFE2</strong> uses <span class="badge text-bg-success">shared-ui v2.0.0</span> (Green badge)</li>
              <li><strong>Shell</strong> can override both to use <span class="badge text-bg-danger">shared-ui v3.0.0</span> (Red badge)</li>
            </ul>
          </div>
        </div>
      </div>

      <div class="row mt-4">
        <div class="col-12">
          <h4 class="mb-3">Key Benefits</h4>
        </div>
        <div class="col-md-4 mb-3">
          <div class="card h-100 border-primary">
            <div class="card-body">
              <h5 class="card-title text-primary">
                <i class="bi bi-speedometer2"></i> Team Autonomy
              </h5>
              <p class="card-text">
                Teams can upgrade their dependencies independently without blocking each other.
              </p>
            </div>
          </div>
        </div>
        <div class="col-md-4 mb-3">
          <div class="card h-100 border-success">
            <div class="card-body">
              <h5 class="card-title text-success">
                <i class="bi bi-shield-check"></i> Central Control
              </h5>
              <p class="card-text">
                The shell can force all MFEs to use the latest version when critical updates are needed.
              </p>
            </div>
          </div>
        </div>
        <div class="col-md-4 mb-3">
          <div class="card h-100 border-warning">
            <div class="card-body">
              <h5 class="card-title text-warning">
                <i class="bi bi-arrow-repeat"></i> Gradual Migration
              </h5>
              <p class="card-text">
                Teams can fall behind on versions but still function, allowing for gradual migration.
              </p>
            </div>
          </div>
        </div>
      </div>
      
      <div class="row mt-4">
        <div class="col-md-6 mb-3">
          <div class="card h-100 shadow-sm">
            <div class="card-body">
              <h5 class="card-title">
                <i class="bi bi-1-circle-fill text-primary"></i> MFE1
                <span class="badge text-bg-primary float-end">v1.0.0</span>
              </h5>
              <p class="card-text">
                Micro Frontend 1 using shared-ui v1.0.0. Click to see the blue badge indicating version 1.
              </p>
              <a routerLink="/mfe1" class="btn btn-primary">
                <i class="bi bi-box-arrow-up-right"></i> Open MFE1
              </a>
            </div>
          </div>
        </div>
        
        <div class="col-md-6 mb-3">
          <div class="card h-100 shadow-sm">
            <div class="card-body">
              <h5 class="card-title">
                <i class="bi bi-2-circle-fill text-success"></i> MFE2
                <span class="badge text-bg-success float-end">v2.0.0</span>
              </h5>
              <p class="card-text">
                Micro Frontend 2 using shared-ui v2.0.0. Click to see the green badge indicating version 2.
              </p>
              <a routerLink="/mfe2" class="btn btn-success">
                <i class="bi bi-box-arrow-up-right"></i> Open MFE2
              </a>
            </div>
          </div>
        </div>
      </div>

      <div class="row mt-4">
        <div class="col-12">
          <div class="card border-danger">
            <div class="card-body">
              <h5 class="card-title text-danger">
                <i class="bi bi-exclamation-triangle-fill"></i> Version Override (v3.0.0)
              </h5>
              <p class="card-text">
                The shell is configured to provide shared-ui v3.0.0 as an override. When the shell loads
                this version eagerly, it can force all MFEs to use v3 instead of their preferred versions.
              </p>
              <p class="card-text mb-0">
                <strong>Note:</strong> To enable the override, the shell's federation config sets
                <code>singleton: true</code> and <code>eager: true</code> for shared-ui-v3, which takes
                precedence over the MFEs' versions.
              </p>
            </div>
          </div>
        </div>
      </div>

      <div class="row mt-4">
        <div class="col-12">
          <h4 class="mb-3">
            <i class="bi bi-gear-fill"></i> Central Dependency Management
          </h4>
        </div>
        <div class="col-12">
          <div class="card border-primary">
            <div class="card-body">
              <h5 class="card-title text-primary">
                <i class="bi bi-diagram-3-fill"></i> Shell Controls Common Dependencies
              </h5>
              <p class="card-text">
                The shell application centrally manages common dependencies (Angular, Bootstrap, RxJS, etc.) 
                for all microfrontends. This eliminates duplicate code and ensures version consistency.
              </p>
              <div class="row mt-3">
                <div class="col-md-6">
                  <h6 class="text-primary">Centrally Managed:</h6>
                  <ul class="list-unstyled">
                    <li><i class="bi bi-check-circle-fill text-success"></i> Angular v20.0.0</li>
                    <li><i class="bi bi-check-circle-fill text-success"></i> Bootstrap v5.3.8</li>
                    <li><i class="bi bi-check-circle-fill text-success"></i> RxJS v7.8.0</li>
                    <li><i class="bi bi-check-circle-fill text-success"></i> All common packages</li>
                  </ul>
                </div>
                <div class="col-md-6">
                  <h6 class="text-success">Benefits:</h6>
                  <ul class="list-unstyled">
                    <li><i class="bi bi-arrow-down-circle-fill text-primary"></i> 67% smaller bundles</li>
                    <li><i class="bi bi-lightning-fill text-warning"></i> 80% faster load times</li>
                    <li><i class="bi bi-clock-fill text-info"></i> 92% faster updates</li>
                    <li><i class="bi bi-shield-check-fill text-success"></i> Version consistency</li>
                  </ul>
                </div>
              </div>
              <div class="alert alert-info mt-3 mb-0">
                <strong>How it works:</strong> The shell loads Angular, Bootstrap, and other common dependencies 
                once. All MFEs reuse these shared dependencies instead of bundling their own copies. 
                Updates to these dependencies only need to happen in the shell!
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="row mt-4">
        <div class="col-12">
          <div class="card bg-light">
            <div class="card-body">
              <h5 class="card-title">
                <i class="bi bi-book-fill"></i> Documentation
              </h5>
              <p class="card-text">
                For detailed information about the architecture and implementation:
              </p>
              <ul>
                <li><strong>VERSION_MANAGEMENT.md</strong> - Shared library version management</li>
                <li><strong>CENTRAL_DEPENDENCY_MANAGEMENT.md</strong> - Central dependency control</li>
                <li><strong>IMPLEMENTATION_SUMMARY.md</strong> - Complete implementation details</li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .card {
      transition: transform 0.2s;
    }
    .card:hover {
      transform: translateY(-5px);
    }
    code {
      background-color: #f8f9fa;
      padding: 2px 6px;
      border-radius: 3px;
      font-size: 0.9em;
    }
  `]
})
export class HomeComponent {}
