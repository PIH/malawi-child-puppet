cd %CD%
puppet apply --verbose --logdest=console --hiera_config=./hiera.yaml --modulepath=./modules manifests\site.pp