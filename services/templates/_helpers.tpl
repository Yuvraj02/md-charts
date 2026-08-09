{{/*
Expand the name of the chart.
*/}}
{{- define "services.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "services.fullname" -}}
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
{{- define "services.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels for all resources in this chart.
*/}}
{{- define "services.labels" -}}
helm.sh/chart: {{ include "services.chart" . }}
{{ include "services.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels shared across the chart release.
*/}}
{{- define "services.selectorLabels" -}}
app.kubernetes.io/name: {{ include "services.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Fully qualified name for a single backend service component.
Usage: {{ include "services.componentFullname" (dict "root" . "name" $name) }}
*/}}
{{- define "services.componentFullname" -}}
{{- printf "%s-%s" (include "services.fullname" .root) .name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Labels for a single backend service component.
Usage: {{ include "services.componentLabels" (dict "root" . "name" $name) }}
*/}}
{{- define "services.componentLabels" -}}
{{ include "services.labels" .root }}
app.kubernetes.io/component: {{ .name | quote }}
{{- end }}

{{/*
Selector labels for a single backend service component.
Usage: {{ include "services.componentSelectorLabels" (dict "root" . "name" $name) }}
*/}}
{{- define "services.componentSelectorLabels" -}}
{{ include "services.selectorLabels" .root }}
app.kubernetes.io/component: {{ .name | quote }}
{{- end }}

{{/*
Merge chart defaults with a per-service config map.
Usage: {{ $cfg := include "services.mergeConfig" (dict "defaults" .Values.defaults "service" $svc) | fromYaml }}
Uses fromYaml/toYaml to copy defaults so the loop does not mutate shared state.
*/}}
{{- define "services.mergeConfig" -}}
{{- $defaults := .defaults | default dict }}
{{- $service := .service | default dict }}
{{- $merged := mustMergeOverwrite (fromYaml (toYaml $defaults)) $service }}
{{- toYaml $merged }}
{{- end }}
