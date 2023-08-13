# Continuous Integration

Minimal Github Actions docker image.

```yaml
jobs:
  ci:
    runs-on: self-hosted
    container:
      image: docker.io/jeremyje/ci-core:canary
    permissions:
      packages: write
      contents: "write"
      id-token: "write"
    timeout-minutes: 45
    steps:
      - name: Checkout Code
        uses: actions/checkout@v3

      - name: Container Fix
        run: git config --system --add safe.directory /__w/
```
