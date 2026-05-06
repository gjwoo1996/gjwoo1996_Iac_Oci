# Dev Container Setup Plan

## Purpose

This document describes only the Dev Container setup for this repository.

The repository will later use Pulumi with TypeScript to manage Oracle Cloud Infrastructure, but this document does not define the Pulumi project structure, stacks, OCI resources, or infrastructure code layout.

The goal of this stage is to prepare a reproducible development environment.

## Scope

Included in this document:

- Dev Container base image
- Tools to install inside the container
- OCI credential mounting strategy
- Pulumi CLI availability
- VS Code extension recommendations
- Security rules for local credentials
- Dev Container implementation checklist
- Verification commands

Not included in this document:

- `Pulumi.yaml`
- Pulumi stack files
- Pulumi backend design
- OCI resource architecture
- TypeScript source layout
- Environment-specific IaC structure

Those topics should be documented separately after the Dev Container baseline is complete.

## Target Development Environment

The Dev Container should support TypeScript-based Pulumi development for OCI.

Required runtime:

```text
Node.js LTS
```

Recommended base image:

```text
mcr.microsoft.com/devcontainers/typescript-node
```

Reason:

- It is maintained for Dev Container workflows.
- It already includes a Node.js and TypeScript-friendly environment.
- It works well as a base for installing Pulumi CLI and OCI CLI.

## Files to Create

The Dev Container setup should create the following files:

```text
.
└── .devcontainer/
    ├── devcontainer.json
    └── Dockerfile
```

No Pulumi project files should be created during this stage.

## Required Tools

The container should include:

- Node.js
- npm
- TypeScript support
- Pulumi CLI
- OCI CLI
- Git
- curl
- unzip
- jq
- ca-certificates

Optional convenience tools:

- bash-completion
- less
- vim or nano

## Dev Container Configuration

### `devcontainer.json`

The `devcontainer.json` file should define:

- Container name
- Dockerfile build path
- Workspace folder
- OCI config mount
- Recommended VS Code extensions
- Safe environment variables

Expected responsibilities:

- Build the image from `.devcontainer/Dockerfile`
- Mount the current repository as the workspace
- Mount host OCI credentials into the container
- Provide editor extensions useful for TypeScript, YAML, Docker, Pulumi, and OCI work

### `Dockerfile`

The `Dockerfile` should:

- Start from the TypeScript Node Dev Container image
- Install common OS packages
- Install Pulumi CLI
- Install OCI CLI
- Avoid copying repository source files into the image

The repository source should be mounted by the Dev Container runtime, not baked into the image.

## OCI Credential Mounting

OCI credentials should stay on the host machine.

Expected host location:

```text
~/.oci
```

Expected container location:

```text
/home/node/.oci
```

Recommended mount:

```text
source=${localEnv:HOME}/.oci,target=/home/node/.oci,type=bind
```

Read-only mounting may be used if the container only needs to read existing OCI config and key files.

Read-write mounting may be used if the container should also run OCI CLI setup commands that modify `~/.oci`.

## Pulumi Authentication

The Dev Container should install the Pulumi CLI, but it should not store Pulumi credentials in the repository.

Authentication should be performed manually inside the container when needed:

```bash
pulumi login
```

Alternatively, a local environment variable may be passed into the container:

```text
PULUMI_ACCESS_TOKEN
```

This document does not decide the Pulumi backend. That should be handled in a separate Pulumi project design document.

## Recommended VS Code Extensions

Recommended extension categories:

- Pulumi
- Docker
- YAML
- ESLint
- Prettier
- Oracle Cloud Infrastructure, if a stable extension is selected

The exact extension IDs should be verified while writing `devcontainer.json`.

## Security Rules

The Dev Container setup must not commit credentials or secrets.

The repository should ignore at least:

```text
.oci/
*.pem
*.key
.env
.env.*
.pulumi/
node_modules/
```

Even though this stage does not create Pulumi project files, `.pulumi/` and `node_modules/` can be ignored early to prevent accidental commits later.

## Implementation Checklist

1. Create `.devcontainer/devcontainer.json`.
2. Create `.devcontainer/Dockerfile`.
3. Add credential and local-development patterns to `.gitignore`.
4. Reopen the repository in the Dev Container.
5. Verify the required tools are installed.
6. Verify the OCI config directory is visible inside the container.
7. Verify Pulumi CLI is available.

## Verification Commands

Run these commands inside the Dev Container:

```bash
node --version
npm --version
pulumi version
oci --version
git --version
jq --version
```

Check OCI config visibility:

```bash
ls -la ~/.oci
```

Optional OCI CLI read-only check:

```bash
oci iam region list --profile DEFAULT
```

Optional Pulumi CLI check:

```bash
pulumi whoami
```

## Questions Before Implementation

The following decisions are needed before creating the actual Dev Container files:

1. Should `~/.oci` be mounted read-only or read-write?
2. Should the default OCI CLI profile be `DEFAULT`?
3. Should the container include only Pulumi and OCI CLI, or also extra security/dev tools such as Checkov, Trivy, or pre-commit?
4. Should npm remain the default Node.js package manager for the container environment?

## Recommended Defaults

If there are no strong preferences, use:

```text
Base image: mcr.microsoft.com/devcontainers/typescript-node
OCI config mount: ~/.oci -> /home/node/.oci
OCI mount mode: read-only
OCI profile: DEFAULT
Package manager: npm
Extra tools: none for the first setup
```
