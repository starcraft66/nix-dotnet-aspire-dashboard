{ fetchFromGitHub, buildDotnetModule, dotnet-sdk_8, dotnet-aspnetcore_8 }:

let
  version = "8.0.0-preview.5.24201.12";
in buildDotnetModule {
  pname = "Aspire.Dashboard";
  inherit version;

  src = fetchFromGitHub {
    owner = "dotnet";
    repo = "aspire";
    rev = "v${version}";
    hash = "sha256-D3zRmZbaT5ASYGtM2ziHqeSnYi5ykibYgqo96G4I1fI=";
  };

  projectFile = "src/Aspire.Dashboard/Aspire.Dashboard.csproj";
  # File generated with `nix build .#aspire-dashboard.passthru.fetch-deps deps.nix`.
  # To run fetch-deps when this file does not yet exist, set nugetDeps to null
  nugetDeps = ./deps.nix;

  dotnet-sdk = dotnet-sdk_8;
  dotnet-runtime = dotnet-aspnetcore_8;

  executables = [ "Aspire.Dashboard" ];

  preInstall = ''
    makeWrapperArgs+=(
      --set-default "ASPNETCORE_CONTENTROOT" "$out/lib/Aspire.Dashboard"
      --set-default "ASPNETCORE_HTTP_PORTS" ""
      --set-default "ASPNETCORE_URLS" "http://[::]:18888"
      --set-default "DOTNET_DASHBOARD_OTLP_ENDPOINT_URL" "http://[::]:18889"
      --set-default "DOTNET_DASHBOARD_UNSECURED_ALLOW_ANONYMOUS" "true"
    )
  '';
}
