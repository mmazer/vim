command! -nargs=* Gce :Shell gcloud compute <args>
command! -nargs=* GceInstances :Shell gcloud compute instances list <args>
command! -nargs=* Gke :Shell gcloud container <args>
command! -nargs=* GkeClusters :Shell gcloud container clusters list <args>
command! -nargs=1 GcrImages :Shell gcloud container images list --repository gcr.io/<args>
command! -nargs=1 GcrTags :Shell gcloud container images list-tags gcr.io/<args>
