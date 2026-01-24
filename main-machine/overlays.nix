[
    (final: prev: {
      gh = prev.gh.overrideAttrs (old: {
        version = "2.82.0";
        src = prev.fetchFromGitHub {
          owner = "cli";
          repo = "cli";
          rev = "v2.28.0";
          sha256 = "11a5zmn27778haz52cwwd42dip9drwd8diymzrifr5a0sfamxy6h";
        };
        vendorHash = "sha256-rVNKTr3b4zShPfkiEBx7LqVQY2eMrXo/s8iC5tyQZNo=";
      });
    })
    (final: prev: {
      git-town = prev.git-town.overrideAttrs (old: {
        version = "22.1.0";
        src = prev.fetchFromGitHub {
          owner = "git-town";
          repo = "git-town";
          rev = "v22.1.0";
          sha256 = "1dd5i5d3p547l9c526wzvg0nyij1a2pqsczjb88wi21igq89mkl4";
        };
      });
    })
  ]