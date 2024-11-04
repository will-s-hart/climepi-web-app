"""Python script defining the web app."""

import pathlib

from climepi import climdata
from climepi.app import run_app

if __name__ == "__main__":
    clim_dataset_example_base_dir = pathlib.Path(__file__).parents[1] / "data"
    clim_dataset_example_names = [
        name
        for name, details in climdata.EXAMPLES.items()
        if details.get("formatted_data_downloadable", False)
    ]
    run_app(
        clim_dataset_example_base_dir=clim_dataset_example_base_dir,
        clim_dataset_example_names=clim_dataset_example_names,
        dask_distributed=True,
        address="0.0.0.0",
        port=7860,
        allow_websocket_origin=["*"],
    )
