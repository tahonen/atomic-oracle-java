# Simple Oracle Java binary builder image for Openshift

NOTE: Support only binary builds (--binary=true)

## Use this image with Openshift

You can add this builder image build config to openshift namespace if you have enough privileges. Otherwise you have to use this "local" in your namespace

```
oc new-project testing-image
oc new-build --name atomic-oracle-java https://github.com/tahonen/atomic-oracle-java.git
oc start-build atomic-oracle-java --follow
```

Now you have builder image ready for use. If it is in namespace openshift then all users and namespaces can consume it.

Deploy sample application using this new image. Since image support only binary builds, you have to use Jenkins pipeline or local env to create Java binary (jar)

```
# clone source
git clone https://github.com/tahonen/hello-springboot.git
# create binary
mvn package -DskipTests
```
Now you have binary, lets deploy it to Openshift

```
oc new-build --name=hello-fatjar --binary=true -i atomic-oracle-java -l app=hello-fatjar
oc start-build hello-fatjar --from-dir target -l app=hello-fatjar --follow
oc new-app hello-fatjar -l app=hello-fatjar
oc expose svc hello-fatjar -l app=hello-fatjar
```

Thats it!

If you like you can but app building to Jenkins pipeline and add trigger to build when builder images changes.

