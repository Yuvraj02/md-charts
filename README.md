# md-charts

Helm charts for **Marketing Digest** Kubernetes workloads.

## Purpose

`md-charts` owns reusable Helm chart definitions and Kubernetes templates.
It does **not** own environment-specific values, secrets, application source,
Argo CD config, or cloud infrastructure.

## Charts

Exactly two charts:

| Chart | Deploys |
|---|---|
| `services` | Backend services: **auth**, **blogs** (extensible map) |
| `gateway` | The **gateway** HTTP edge service |

The frontend is deployed separately and is not part of this repository.

```text
                    md-charts
                   /         \
            services/       gateway/
               |                |
        auth + blogs         gateway
        (Deployments +       (Deployment +
         Services)            Service)
```

## Why two charts

- **services** — multi-service chart for homogeneous backend processes (gRPC
  services today). Adding another backend is another key under `services:`.
- **gateway** — separate chart because the gateway is the HTTP edge process
  with a different role and lifecycle from the domain services.

## Environment-specific values

Chart `values.yaml` files contain **safe defaults only**.

Per-environment configuration (image tags, replicas, resources, domains,
non-secret env) lives in:

https://github.com/Yuvraj02/md-helm-values.git

## Secrets

Secrets are **never** stored in this repository.

Do not put passwords, tokens, `OWNER_STUDIO_SECRET`, or private keys in
`values.yaml` or templates. Charts may reference an **existing** Kubernetes
Secret via `env[].valueFrom.secretKeyRef` or `envFrom[].secretRef`. Secrets
themselves are created manually outside Git.

## Related repositories

| Repository | Role |
|---|---|
| [md-infra](https://github.com/Yuvraj02/md-infra.git) | Argo CD bootstrap, Applications, ApplicationSets |
| [md-charts](https://github.com/Yuvraj02/md-charts.git) | Helm charts (this repo) |
| [md-helm-values](https://github.com/Yuvraj02/md-helm-values.git) | Environment-specific Helm values |

## Consumption by Argo CD (future)

```text
md-infra
    |
    v
ApplicationSet
    |
    v
Argo CD Application
    |
    +---- md-charts/services  (or gateway)
    |
    +---- md-helm-values/<environment>/...
    |
    v
  Helm → Kubernetes → Marketing Digest
```

## Local validation

```bash
helm lint ./services
helm lint ./gateway
helm template services ./services
helm template gateway ./gateway
```
