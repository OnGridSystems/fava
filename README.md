# Fava Service for Google Cloud Run

* Runs Fava as Cloud Run service from Artifact Registry
* Beancount data files are served from Storage Bucket mounted using Fuse

## Howto

- [ ] [Create a Google Cloud Project](https://cloud.google.com/resource-manager/docs/creating-managing-projects), [check if billing is enabled on it](https://cloud.google.com/billing/docs/how-to/verify-billing-enabled)
- [ ] [Install](https://cloud.google.com/sdk/docs/install) and [initialize](https://cloud.google.com/sdk/docs/initializing) the Google Cloud CLI, set the default project for your Cloud Run service

```sh
gcloud config set project PROJECT_ID
```

- [ ] Enable Artifact Registry and [create repository](https://cloud.google.com/artifact-registry/docs/repositories/create-repos) in it
- [ ] Configure Docker to use the Google Cloud CLI to authenticate image pushed to the Artifact Registry

```sh
gcloud auth configure-docker
```

- [ ] Build Docker image locally, tag it with repo address and push to the Artifact Registry

```sh
export DOCKER_IMAGE_URI=$REGION.pkg.dev/$PROJECT/$REPOSITORY/$IMAGE
docker build -f ./contrib/docker/Dockerfile --tag $DOCKER_IMAGE_URI .
docker push $DOCKER_IMAGE_URI
```

- [ ] Create service account for read-only or read-write operations on the bucket

CLI equivalent:

```sh
gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME
```

- [ ] Create Storage Bucket for keeping beancount files

- [ ] Assign Role for Service account on bucket

```sh
export SERVICE_ACCOUNT_FULL_NAME=serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT.iam.gserviceaccount.com
export ROLE="roles/storage.objectAdmin"
gcloud projects add-iam-policy-binding $PROJECT \
     --member $SERVICE_ACCOUNT_FULL_NAME \
     --role $ROLE
```

7. [Deploy Cloud Run service](https://cloud.google.com/run/docs/deploying) from the submitted image.

pass the link to the bucket in `BUCKET` variable
pass beancount filenames through container argiments like `/mnt/gcs/$FILENAME`
set service account to `$SERVICE_ACCOUNT_NAME`

gcloud equivalent:

```sh
export CLOUDRUN_SERVICE_NAME=cr-fava
gcloud run deploy $CLOUDRUN_SERVICE_NAME \
--image=$DOCKER_IMAGE_URI:latest \
--execution-environment=gen2 \
--region=europe-west1 \
--project=$PROJECT \
 && gcloud run services update-traffic $CLOUDRUN_SERVICE_NAME --to-latest
```

## Optional: Protect Fava using Identity-Aware Proxy

Set up IAP proxy to authenticate users https://dev.to/ku6ryo/how-to-limit-access-to-your-internal-users-with-cloud-run-4lcg 
