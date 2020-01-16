

## Current

[] Test bazel by creating a pupet python project
[] Test build cluster (installed with helm)
[] Create a helm package with all necesary for build system
[] Build puppet project with build cluster
[] Add helm packaging in puppet project
[] Add bazel target for packaging 
....
Jenkins ... install with helm
....
Install spinnaker
Integrate 
 


## Install basic

```
sudo snap install helm3
```

```
helm3 search hub spinnaker
```

```
curl https://bazel.build/bazel-release.pub.gpg | sudo apt-key add -
echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
```

