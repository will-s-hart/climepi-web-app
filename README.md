---
title: Climepi App
emoji: 📈
colorFrom: gray
colorTo: green
sdk: docker
pinned: false
license: gpl-3.0
---

Code for web version (hosted on Hugging Face) of the front-end application provided by
the `climepi` python package (https://github.com/idm-oxford/climate-epidemics). The app
is available at https://idm-oxford.github.io/climate-epidemics/.

## Updating climepi

`climepi` is pinned to an exact version in `pyproject.toml`. On the 2nd of each month, the
`Update climepi` workflow checks conda-forge for a newer release. If there is one, the
workflow bumps the pin, refreshes `pixi.lock`, builds and smoke-tests the Docker image, and
opens a PR (with the smoke-test result in its description). Merging the PR deploys to the Space. The workflow can also be run manually from
the Actions tab after a climepi release.

To run the smoke test locally (requires pixi and Docker): `pixi run smoke-test`.

Check out the configuration reference at https://huggingface.co/docs/hub/spaces-config-reference

