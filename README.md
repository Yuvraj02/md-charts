# md-charts

Independent Helm charts for **Marketing Digest** backend services.

## Purpose

One chart per independently deployable service. Charts hold templates and
safe defaults only — not environment-specific values, secrets, Argo CD
config, or application source.

## Charts

| Chart | Service | Default port |
|---|---|---|
| `gateway/` | HTTP API gateway | 8080 |
| `blogs/` | Blog/article gRPC service | 50051 |
| `auth/` | Auth/user gRPC service | 50051 |

Frontend is not packaged here yet.

```text
md-charts
├── gateway/   → gateway Deployment + Service
├── blogs/     → blogs Deployment + Service
└── auth/      → auth Deployment + Service
```

Each chart is independently installable and upgradeable. There is no
umbrella chart and no chart dependencies between services.

## Environment values

Per-environment overrides live in:

https://github.com/Yuvraj02/md-helm-values.git

## Secrets

Secrets are **never** stored in this repository. Reference existing
Kubernetes Secrets via `env[].valueFrom.secretKeyRef` or
`envFrom[].secretRef` only.

## Related repositories

| Repository | Role |
|---|---|
| [md-infra](https://github.com/Yuvraj02/md-infra.git) | Argo CD ApplicationSets |
| [md-charts](https://github.com/Yuvraj02/md-charts.git) | Helm charts (this repo) |
| [md-helm-values](https://github.com/Yuvraj02/md-helm-values.git) | Environment values |

## Local validation

```bash
helm lint ./gateway ./blogs ./auth
helm template gateway ./gateway
helm template blogs ./blogs
helm template auth ./auth
```
