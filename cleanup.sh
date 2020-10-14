#!/bin/bash
multipass delete master5 worker51 worker52
multipass purge
rm kubeconfig.yaml
#
