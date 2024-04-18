# Aspire Dashboard for .NET - Packaged for Nix

## Overview

This project packages the Aspire Dashboard for .NET into a Nix package, making it easily deployable and manageable via Nix Flakes. The Aspire Dashboard is a visualization tool that integrates with any OpenTelemetry OTLP-emitting application to display telemetry data, leveraging OpenTelemetry for capturing and presenting traces, logs, and metrics.

### Flake Setup

The flake in this repo exposes the aspire-dashboard package, as well as a nixpkgs overlay that includes the Aspire Dashboard as a package.

For example, if you want to use the Aspire Dashboard in the development shell for another project that produces OpenTelemetry data, you project's flake would look something like this:

```nix
{
  description = "A devshell for development including Aspire Dashboard";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    aspire-dashboard.url = "github:starcraft66/nix-dotnet-aspire-dashboard";
  };

  outputs = { self, nixpkgs, flake-utils, aspire-dashboard, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        aspire-dashboard-package = aspire-dashboard.packages.${system}.default;
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [ aspire-dashboard-package ];
        };
      }
    );
}
```

You can then call `Aspire.Dashboard` from the command-line to run the dashboard.

#### Environment Variables:

- `DOTNET_DASHBOARD_UNSECURED_ALLOW_ANONYMOUS`: Allows unsecured and anonymous access, set to `false` if hosting this on a server. It is set by default because this dashboard is mostly intended to be run locally.

## Usage

To use the Aspire Dashboard, include it in your Nix configuration or directly invoke it as a flake application.

### Running the Dashboard

To run the Aspire Dashboard from anywhere:

```sh
nix run github:starcraft66/nix-dotnet-aspire-dashboard
```
# Integration with Applications

Ensure your applications are configured to emit OpenTelemetry data to the endpoint specified by the Aspire Dashboard's DOTNET_DASHBOARD_OTLP_ENDPOINT_URL (http://localhost:18889 by default).

To achieve this, set the `OTEL_EXPORTER_OTLP_ENDPOINT` to http://localhost:18889 in your application's environment variables. (`OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:18889`)