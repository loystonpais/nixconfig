final: prev: {
  lunar = {
    writeKioServiceMenu = name: text:
      prev.writeTextFile {
        name = "kio-servicemenu-${name}";
        inherit text;
        destination = "/share/kio/servicemenus/${name}.desktop";
        executable = true;
      };
  };
}
