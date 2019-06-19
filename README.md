# SO1
It's overview of my solution for task 3.
Declaimer: regarding timelimitation i have used most simple steps (no helmet deployments and etc).
I am ready to provide additional information if needed.
I have used minikube (local installation) because time limitation.
It's no docker registry available, so I have used workaround eval $(minikube docker-env).

App - users-mysql.jar. I build app with maven (mvn clean install) from source repo.
It's some temporary problem with JDBC driver (sometimes app crached, sometimes not)
- I didn't spend time for troubleshooting that.
Test app requests access to db by default, so I created deployment of Db and then deployment of app.

Mysql deployment - single instance. I have used information from k8s
[site](https://kubernetes.io/docs/tasks/run-application/run-single-instance-stateful-application/).

App deployment - 2 pods with NodePort.

Answers to questions:

**Question 5 - Can you do a HA of a database? Any way to keep the data persistent when pods are
recreated?**

Answer:
We can do HA of db. It's huge discussion in DevOps community about DBs in k8s, but in general - DBs are
just one of stateful-solutions. Here is old example
[pets vs cattle](https://www.theregister.co.uk/2013/03/18/servers_pets_or_cattle_cern/) where k8s is from cattle,
DBs are from pets. HA in k8s fro DBS - Deployments and StatefulSet. I never deployed MySQl to k8s before, but PostreSQl
has [Stolon](https://github.com/sorintlab/stolon) for that.

Also to keep data - persistent volumes (as I used for MySql deployment). One of most popular solutions -
[portworx](https://portworx.com/run-ha-mysql-google-kubernetes-engine/).

**Question 6 - Add CI to the deployment process**

Answer:
I would like to recommend next CI deployment process:
- developer commits code to git repo
- CI server: build new docker image
- CI server: run unittests, integrations tests, service tests, UI tests, perfomance tests
- CI server: push new Docker image to docker repository
After that it's process of deployment, here I would like to use stage env and id everythink is ok - prod.
Process of deployment:
- create new pod
- check pod health
- check external results (how app works) using historical data (for example)
- if ok - delete old pods

**Question 7 - Split your deployment into prd/qa/dev environment**

Answer:
It's must be dev/stage/prod environment. Also prod should be isolated from dev/stage envs.
So, CI/CD process in dev/stage/prod envs:
I prefer to have multiple k8s clusters for dev/stage/prod. It's point of
[discussion](http://vadimeisenberg.blogspot.com/2019/03/multicluster-pros-and-cons.html), but I am adept of 3 enviroments.

So, high-level overview:
- when code was pushed to git repo, create docker image and deploy in test k8s cluster. Run test in automatically mode (as unit-test).
If everythink ok - copy image to stage k8s cluster, tested again with business data.
After that deploy to prod with minimum prod traffic to new pods via loadbalancer, if everythink is ok - delete limitations.

**Question8 - Please suggest a monitoring solution for your system. How would you notify an admin
that the resources are scarce?**

Answer:
Prometheus. I really like to work with prometheus, because this solution was created for microservices architecture.
To reduce number of exporters I am using [netdata](https://my-netdata.io/) as a source for prometheus.
Also we need to use prometheus alertmanager with rules, which can send notification to different channels as Slack,
VictorOps, emails, sms.




