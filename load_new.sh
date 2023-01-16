#!/bin/bash

cat <<'END_CAT'

Created path based policies /ci /cd /cloud /projects /web
so they could be well organised in specific folders

END_CAT
echo "[INFO] conjur policy update -b root -f root.yml"
conjur policy update -b root -f root.yml

cat <<'END_CAT'

Creating users , so they could assign roles,
in this phase users are not bound to any group

END_CAT
echo "[INFO] conjur policy update -b root -f users.yml"
conjur policy update -b root -f users.yml

cat <<'END_CAT'

Here we create two groups, conjur-admins, and conjur-auditors,
in this phase groups are not bounded to any of users
END_CAT
echo "[INFO] conjur policy update -b root -f groups.yml"
conjur policy update -b root -f groups.yml

cat <<'END_CAT'

In this  we add admin right to group conjur-admins ( FULL ACCESS )
and we promote joe,darren, and jed to conjur-admins
we add mark and james to conjur-auditors

END_CAT
echo "[INFO] conjur policy update -b root -f grants/grants_user.yml"
conjur policy update -b root -f grants/grants_user.yml


cat <<'END_CAT'

Here we create policy cd/kubernetes which holds variables db/host, db/username, db/password and db/name
full  path will be cd/kubernetes/db/host
also group cd/kubernetes/admins will be created, and conjur-admins global group will assume role of  cd/kubernetes/admins
cd/kubernetes/secrets-users group is created, and secret users have permission to read and execute variables
[ read, execute ] execute is right to see metadata of object
cd/kubernetes/authn-k8s/conjur-demo/consumers group is created

END_CAT
echo "[INFO] conjur policy update -b cd -f cd/kubernetes/kubernetes.yml"
conjur policy update -b cd -f cd/kubernetes/kubernetes.yml


cat <<'END_CAT'

This is END POINT definition owner is cd/kubernetes/admins,
host is defined by these params 
        authn-k8s/namespace: api-app
        authn-k8s/service-account: api-app-account
        authn-k8s/authentication-container-name: authenticator
        kubernetes: true
        TODO !!!!!!!!!!!  kubernetes: true should be openshift: true
		
END_CAT
echo "[INFO] conjur policy update -b cd -b cd/kubernetes -f cd/kubernetes/api-app.yml"
conjur policy update -b cd -b cd/kubernetes -f cd/kubernetes/api-app.yml

cat <<'END_CAT'

This is END POINT definition owner is cd/kubernetes/admins,
host is defined by these params 
        authn-k8s/namespace: k8s-secrets-app
        authn-k8s/service-account: k8ssecrets-account
        authn-k8s/authentication-container-name: cyberark-secrets-provider
        kubernetes: true
        TODO !!!!!!!!!!!  kubernetes: true should be openshift: true
		
END_CAT
echo "[INFO] conjur policy update -b cd -b cd/kubernetes -f cd/kubernetes/k8s-secrets-app.yml"
conjur policy update -b cd -b cd/kubernetes -f cd/kubernetes/k8s-secrets-app.yml

cat <<'END_CAT'

This is END POINT definition owner is cd/kubernetes/admins,
host is defined by these params 
        authn-k8s/namespace: k8s-secrets-app
        authn-k8s/service-account: k8ssecrets-account
        authn-k8s/authentication-container-name: cyberark-secrets-provider
        kubernetes: true
        TODO !!!!!!!!!!!  kubernetes: true should be openshift: true
		
END_CAT
echo "[INFO] conjur policy update -b cd -b cd/kubernetes -f cd/kubernetes/secretless-app.yml"
conjur policy update -b cd -b cd/kubernetes -f cd/kubernetes/secretless-app.yml

cat <<'END_CAT'

This is END POINT definition owner is cd/kubernetes/admins,
host is defined by these params 
        authn-k8s/namespace: summon-app
        authn-k8s/service-account: summon-app-account
        authn-k8s/authentication-container-name: authenticator
        kubernetes: true
        TODO !!!!!!!!!!!  kubernetes: true should be openshift: true
		
END_CAT
echo "[INFO] conjur policy update -b cd -b cd/kubernetes -f cd/kubernetes/summon-app.yml"
conjur policy update -b cd -b cd/kubernetes -f cd/kubernetes/summon-app.yml

cat <<'END_CAT'

Here we define that host define as END POINTs are granted as members of 
group cd/kubernetes/authn-k8s/conjur-demo/consumers and
group cd/kubernetes/secrets-users

END_CAT
echo "[INFO] conjur policy update -b root -f grants/grants_cd.yml"
conjur policy update -b root -f grants/grants_cd.yml


cat <<'END_CAT'

Here we define conjur/authn-k8s/conjur-demo, as cluster interface, 
it should be also DEFINED DIRECTLY when starting server, for every kubernetes/openshift cluster
there should be single policy file

conjur/authn-k8s/conjur-demo is created with policy, and certificates
webservice conjur/authn-k8s/conjur-demo           is created
group      conjur/authn-k8s/conjur-demo/consumers is created
conjur/authn-k8s/conjur-demo/consumers have : [ read, authenticate ] to conjur/authn-k8s/conjur-demo   

END_CAT
echo "[INFO] conjur policy update -b root -f authn/authn-k8s.yml"
conjur policy update -b root -f authn/authn-k8s.yml



cat <<'END_CAT'

# Grant the kubernetes authn-k8s/consumers group to use the 
                       authn-k8s/conjur-demo authenticator web service
- !grant
  role: !group conjur/authn-k8s/conjur-demo/consumers
  member: !group cd/kubernetes/authn-k8s/conjur-demo/consumers

END_CAT
echo "[INFO] conjur policy update -b root -f grants/grants_authn.yml"
conjur policy update -b root -f grants/grants_authn.yml

#echo "[INFO] conjur policy update -b root -f grants/grants_host.yml"
#conjur policy update -b root -f grants/grants_host.yml