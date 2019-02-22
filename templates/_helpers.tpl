{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "health.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "health.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a full DB host name.
If databaseOverride is set, the name is not trimmed because
it's the name of an external service and it's not used to setup
a database service / container.
*/}}
{{- define "health.dbname" -}}
{{- if .Values.databaseOverride -}}
{{- .Values.databaseOverride.host -}}
{{- else -}}
{{- printf "%s-postgres" (include "health.fullname" . ) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create a full DB secrets name.
If databaseOverride is set, the name is not trimmed because
it's the name of an external service and it's not used to setup
a database service / container.
*/}}
{{- define "health.dbsecrets" -}}
{{- if .Values.databaseOverride -}}
{{- .Values.databaseOverride.secret -}}
{{- else -}}
{{- printf "%s-dbsecrets" (include "health.fullname" . ) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "health.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Image name that support for the single value format as well as the hash.
*/}}
{{- define "health.database.image" -}}
{{- if .Values.overrideDatabaseImage -}}
{{- .Values.overrideDatabaseImage -}}
{{- else -}}
{{- printf "%s/%s:%s" .Values.image.repository .Values.database.image.name .Values.database.image.version -}}
{{- end -}}
{{- end -}}

{{- define "health.api.image" -}}
{{- if .Values.overrideApiImage -}}
{{- .Values.overrideApiImage -}}
{{- else -}}
{{- printf "%s/%s:%s" .Values.image.repository .Values.api.image.name .Values.api.image.version -}}
{{- end -}}
{{- end -}}

{{- define "health.frontend.image" -}}
{{- if .Values.overrideFrontendImage -}}
{{- .Values.overrideFrontendImage -}}
{{- else -}}
{{- printf "%s/%s:%s" .Values.image.repository .Values.frontend.image.name .Values.frontend.image.version -}}
{{- end -}}
{{- end -}}

{{/*
API full URL for client access. We don't really handle the no-ingress case.
*/}}
{{- define "health.api.fullurl" -}}
{{- if .Values.ingress.enabled -}}
{{- if .Values.knative.enabled -}}
{{- printf "http://%s-api.%s.%s/" (include "health.name" .) .Release.Namespace .Values.ingress.host -}}
{{- else -}}
{{- printf "http://%s/%s-api" .Values.ingress.host .Release.Name -}}
{{- end -}}
{{- end -}}
{{- end -}}
