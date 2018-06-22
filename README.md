Heron issue #2919
=================

Scripts and code to reproduce issue [#2919](https://github.com/apache/incubator-heron/issues/2919) of [Heron](https://github.com/apache/incubator-heron).

Requirements
------------

- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)
- [Helm client](https://docs.helm.sh/using_helm/#installing-helm) (the script
    install the server)

The script also downloads [Pants](https://www.pantsbuild.org).

Instructions
------------

Launch all:

```bash
git clone https://github.com/cristobalcl/heron-issue-2919.git
cd heron-issue-2919
./run.sh
```

Follow Heron server logs:

```bash
kubectl logs --namespace heron -f `kubectl get --namespace heron pods --context=minikube --selector=app=heron-tools --output=jsonpath='{.items..metadata.name}'` heron-apiserver
```

Try to submit the topology again (this is doing in the `run.sh` already):

```bash
cd word_count
./pants binary topologies:WordCountTopology
heron submit heron ./dist/WordCountTopology.pex  --deploy-deactivated --verbose \
    - word-count-topology
```

Get Kubernetes dashboard URL:

```bash
nikube dashboard --url
```

Get Heron dashboard URL:

```bash
minikube service -n heron --url heron-web
```

Comments
--------

If you open `word_count/topologies/BUILD` you will see a lot of not used
dependencies. Thore are used to build a big PEX... BUT a lot of times the issue
also occurs with small PEX, so you can comment all the dependencies except
`:word_count` and `3rdparty:heronpy` and try to submit again.
