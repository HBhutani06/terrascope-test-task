{{- define "chart.name" -}}
{{ .Values.global.appName | default "image-api" }}
{{- end }}

{{- define "chart.labels" -}}
app.kubernetes.io/name: {{ include "chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

