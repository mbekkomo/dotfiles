_: {
  language-server.nil = {
    config = {
      nil.formatting.command = [ "nixfmt" ];
    };
  };

  language-server.emmet-langserver = {
    command = "emmet-language-server";
    args = [ "--stdio" ];
  };

  language =
  let
    indent = { tab-width = 2; unit = " "; };
  in
  [
    {
      name = "html";
      roots = [ ".git" ];
      language-servers = [ "emmet-langserver" ];
    }
    {
      inherit indent;
      
      name = "civet";
      file-types = [ "civet" ];
      comment-tokens = "//";
      block-comment-tokens = [
        { start = "/*"; end = "*/"; }
        { start = "###\n"; end = "\n###"; }
      ];
    }
  ];
}
