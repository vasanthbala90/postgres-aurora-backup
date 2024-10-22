{{/*
Expand the name of the chart.
*/}}
{{- define "postgres-aurora-backup.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "postgres-aurora-backup.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "postgres-aurora-backup.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "postgres-aurora-backup.labels" -}}
helm.sh/chart: {{ include "postgres-aurora-backup.chart" . }}
{{ include "postgres-aurora-backup.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "postgres-aurora-backup.selectorLabels" -}}
app.kubernetes.io/name: {{ include "postgres-aurora-backup.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "postgres-aurora-backup.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "postgres-aurora-backup.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the cron scheduler based on cluster name
*/}}
{{- define "postgresql-backup.cronScheduler" -}}
{{- if eq (split "-" .Values.clusterName)._2 "us" -}}
schedule: "{{ .Values.us }}"
{{- else if eq (split "-" .Values.clusterName)._2 "in" -}}
schedule: "{{ .Values.in }}"
{{- else if eq (split "-" .Values.clusterName)._2 "uk" -}}
schedule: "{{ .Values.uk }}"
{{- else if eq (split "-" .Values.clusterName)._2 "sg" -}}
schedule: "{{ .Values.sg }}"
{{- else if eq (split "-" .Values.clusterName)._2 "de" -}}
schedule: "{{ .Values.de }}"
{{- else if eq (split "-" .Values.clusterName)._2 "au" -}}
schedule: "{{ .Values.au }}"
{{- else if eq (split "-" .Values.clusterName)._2 "qatarcentral" -}}
schedule: "{{ .Values.qatar }}"
{{- else if eq (split "-" .Values.clusterName)._2 "me" -}}
schedule: "{{ .Values.me }}"
{{- else if eq (split "-" .Values.clusterName)._2 "ae" -}}
schedule: "{{ .Values.ae }}"
{{- else -}}
schedule: "{{ .Values.default }}"
{{- end -}}
{{- end -}}
