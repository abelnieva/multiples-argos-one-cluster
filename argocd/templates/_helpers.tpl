{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "argocd-project-name" -}}
{{-  printf "argocd-services-%s" .Values.namespace | trunc 63 | trimSuffix "-" }}
{{- end }}
