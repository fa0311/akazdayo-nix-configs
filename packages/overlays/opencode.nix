final: prev: {
  opencode = final.callPackage (builtins.fetchurl {
    url = "https://raw.githubusercontent.com/r-ryantm/nixpkgs/b29c72fedde8dc0795c0e2a9a720ef1dd7d68f0c/pkgs/by-name/op/opencode/package.nix";
    sha256 = "194x6s45kcyjdcmbyba2cymw85ag4nqp3f7kw1s64wj736d02cwy";
  }) { };
}
