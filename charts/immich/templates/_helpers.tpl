{{- define "valkey.password" -}}
{{- if .Values.valkey.auth.existingSecret -}}
{{- lookup "v1" "Secret" .Release.Namespace .Values.valkey.auth.existingSecret | get "data.REDIS_PASSWORD" | b64dec -}}
{{- else -}}
{{- $secretName := printf "%s-valkey-auth" .Release.Name -}}
{{- $secret := lookup "v1" "Secret" .Release.Namespace $secretName -}}
{{- if $secret -}}
{{- $secret.data.REDIS_PASSWORD | b64dec -}}
{{- else -}}
{{- randAlphaNum 40 -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "valkey.secretChecksum" -}}
{{- if .Values.valkey.auth.existingSecret -}}
{{- $secret := lookup "v1" "Secret" .Release.Namespace .Values.valkey.auth.existingSecret -}}
{{- if $secret -}}
{{- $secret.data | toJson | sha256sum -}}
{{- else -}}
{{- "" | quote -}}
{{- end -}}
{{- else -}}
{{- $password := include "valkey.password" . -}}
{{- $data := dict "REDIS_PASSWORD" ($password | b64enc) -}}
{{- $data | toJson | sha256sum -}}
{{- end -}}
{{- end -}}
