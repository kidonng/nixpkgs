{ lib, buildPythonPackage, fetchPypi, libpulseaudio, glibc, substituteAll, stdenv, pulseaudio, python }:

buildPythonPackage rec {
  pname = "pulsectl";
  version = "22.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-8o/kuIHdLMFE0tlPg+xg2MWaUmQqCtNjXMTQ+EBvSFg=";
  };

  patches = [
    # substitute library paths for libpulse and librt
    (substituteAll {
      src = ./library-paths.patch;
      libpulse = "${libpulseaudio.out}/lib/libpulse${stdenv.hostPlatform.extensions.sharedLibrary}";
      librt = "${glibc.out}/lib/librt${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  pythonImportsCheck = [
    "pulsectl"
  ];

  checkInputs = [ pulseaudio ];

  checkPhase = ''
    export HOME=$TMPDIR
    ${python.interpreter} -m unittest discover
  '';

  meta = with lib; {
    description = "Python high-level interface and ctypes-based bindings for PulseAudio (libpulse)";
    homepage = "https://pypi.python.org/pypi/pulsectl/";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
