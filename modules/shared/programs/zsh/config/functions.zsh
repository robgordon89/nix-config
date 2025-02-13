function gcloud-k8s-versions
{
    for project in $(gcloud projects list --format="value(projectId)") ; do \
        gcloud --verbosity=critical container clusters list --format="value[separator=' | '](name,currentMasterVersion,nodePools.version)" --project $project
    done;
}
