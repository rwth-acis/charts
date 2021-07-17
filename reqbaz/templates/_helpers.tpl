{{/*
Expand the name of the chart.
*/}}
{{- define "reqbaz.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "reqbaz.fullname" -}}
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
{{- define "reqbaz.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "reqbaz.labels" -}}
helm.sh/chart: {{ include "reqbaz.chart" . }}
{{ include "reqbaz.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "reqbaz.selectorLabels" -}}
app.kubernetes.io/name: {{ include "reqbaz.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "reqbaz.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "reqbaz.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}



{/*
Return the proper backend image name
*/}}
{{- define "reqbaz.backend.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.reqbaz.image "global" .Values.global) }}
{{- end -}}

{/*
Return the proper backend init image name
*/}}
{{- define "reqbaz.backend.initImage" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.reqbaz.initImage "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper frontend image name
*/}}
{{- define "reqbaz.frontend.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.frontend.image "global" .Values.global) }}
{{- end -}}

{{/* vim: set filetype=mustache: */}}
{{/*
Renders a value that contains template.
Usage:
{{ include "common.tplvalues.render" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "reqbaz.tplvalues.render.json" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toPrettyJson) .context }}
    {{- end }}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "reqbaz.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "reqbaz.validateValues.foo" .) -}}
{{- $messages := append $messages (include "reqbaz.validateValues.bar" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}
