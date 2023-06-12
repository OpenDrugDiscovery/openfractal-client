# openfractal-client

[![test](https://github.com/OpenDrugDiscovery/openfractal-client/actions/workflows/test.yml/badge.svg)](https://github.com/OpenDrugDiscovery/openfractal-client/actions/workflows/test.yml)
[![release](https://github.com/OpenDrugDiscovery/openfractal-client/actions/workflows/release.yml/badge.svg)](https://github.com/OpenDrugDiscovery/openfractal-client/actions/workflows/release.yml)
[![docker](https://github.com/OpenDrugDiscovery/openfractal-client/actions/workflows/docker.yml/badge.svg)](https://github.com/OpenDrugDiscovery/openfractal-client/actions/workflows/docker.yml)
[![code-check](https://github.com/OpenDrugDiscovery/openfractal-client/actions/workflows/code-check.yml/badge.svg)](https://github.com/OpenDrugDiscovery/openfractal-client/actions/workflows/code-check.yml)
[![doc](https://github.com/OpenDrugDiscovery/openfractal-client/actions/workflows/doc.yml/badge.svg)](https://github.com/OpenDrugDiscovery/openfractal-client/actions/workflows/doc.yml)

A Python client based on [QCPortal](https://github.com/MolSSI/QCFractal) for Open Drug Discovery (ODD) QM large scale data generation.

**Important: if you are planning to work with the Openfractal instances, it is highly recommended to read the upstream documentation at <https://molssi.github.io/QCFractal/overview/index.html>.**

## Available Openfractal instances

| Name               | Comment                                                                                                 | API URL                                            | Dashboard URL |
| ------------------ | ------------------------------------------------------------------------------------------------------- | -------------------------------------------------- | ------------- |
| `openfractal-test` | A test instance for learn how to use QCFractal. In case of reset, it will be communicated pro-actively. | <https://openfractal-test-pgzbs3yryq-uc.a.run.app> | _In progress_ |
| `openfractal-dev`  | Might be destroyed at any time.                                                                         | <https://openfractal-dev-pgzbs3yryq-uc.a.run.app>  | _In progress_ |

## Usage and installation

The two main libraries to interact with the Openfractal instances are:

- [`qcportal`](https://github.com/MolSSI/QCFractal/tree/next/qcportal): a Python client for Openfractal (QCFractal instance).
- [`qcfractalcompute`](https://github.com/MolSSI/QCFractal/tree/next/qcfractalcompute): a Python client for Openfractal (QCFractal instance) that can launch a worker (also called a manager).

For now the Python library of this repo `openfractal-client` does not contain any particular logic. The plan is to use it if we need custom logic related to openfractal moving forward.

### Docker

Public docker images are available at <https://github.com/OpenDrugDiscovery/openfractal-client/pkgs/container/openfractal-client>.

```bash
docker run --rm -ti ghcr.io/opendrugdiscovery/openfractal-client:main
```

### Using mamba

The QCFractal libraries ecosystem have not yet been released. It is actively being developed in the `next` branch at <https://github.com/MolSSI/QCFractal/tree/next>.

For now here is a minimal Conda `env.yml` file you can use to perform the installation (this will be simplified in the future):

```yaml
channels:
  - hadim/label/qcportal_next
  - conda-forge/label/libint_dev # for psi4
  - conda-forge

dependencies:
  - python >=3.9
  - pip

  # QCPortal deps
  - hadim/label/qcportal_next::qcportal
  - hadim/label/qcportal_next::qcfractalcompute

  # Compute managers
  - dask
  - dask-jobqueue
  - parsl
  - psi4 =1.8

  # Optional utilities
  - loguru
  - typer
  - python-dotenv
```

## Documentation

[Chech the notebooks](./docs/tutorials/).

## Development lifecycle

### Setup dev environment

```bash
micromamba create -n openfractal -f env.yml
micromamba activate openfractal

# Install openfractal-client lib
pip install -e .
```

### Tests

You can run tests locally with:

```bash
pytest
```

## Changelogs

See the latest changelogs at [CHANGELOGS.md](./CHANGELOGS.md).

## License

Under the Apache-2.0 license. See [LICENSE](LICENSE).
