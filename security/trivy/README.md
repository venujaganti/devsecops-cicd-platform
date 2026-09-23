# Trivy Security Scanner

Trivy is used in this project for security scanning.

## Scans

The project uses Trivy for:

- Filesystem vulnerability scanning
- Secret scanning
- Container image scanning
- Kubernetes configuration scanning
- Infrastructure-as-Code scanning

## Configuration

Main configuration:

```text
security/trivy/trivy.yaml
```

The main project scripts use Podman for image builds and Trivy for security scanning.
