let
  jupyter = import (builtins.fetchTarball {
    url = "https://github.com/tweag/jupyterWith/archive/8e2294c27cad405a6c023b5da041877104fe463f.tar.gz";
    sha256 = "sha256:1kq4i4mnlkby8frri5jqphl2vivs852h1pa4ng591nrqzwqa87fg";
  }) {};
  iPython = jupyter.kernels.iPythonWith {
    name = "python";
    packages = p: with p; [ numpy pandas matplotlib ];
  };
  jupyterEnvironment =
    jupyter.jupyterlabWith {
      kernels = [ iPython ];
  };
in jupyterEnvironment.env
