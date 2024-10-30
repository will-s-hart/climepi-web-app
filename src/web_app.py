"""Python script defining the web app."""

import logging
import pathlib
import sys

import panel as pn
from climepi import climdata
from climepi.app import DASK_SCHEDULER_ADDRESS, get_app
from dask.distributed import Client


@pn.cache()
def get_logger(name):
    """Set up logger (see https://panel.holoviz.org/how_to/logging/index.html)."""
    _logger = logging.getLogger(name)
    _logger.handlers.clear()
    handler = logging.StreamHandler()
    handler.setStream(sys.stdout)
    formatter = logging.Formatter(
        "%(asctime)s | %(levelname)s | %(name)s | %(message)s"
    )
    handler.setFormatter(formatter)
    _logger.addHandler(handler)
    _logger.propagate = False
    _logger.setLevel(logging.INFO)
    return _logger


logger = get_logger(name="app")

logger.info("Attempting to connect to Dask local cluster")
client = Client(DASK_SCHEDULER_ADDRESS)
logger.info(
    "Dask client connected to local cluster at %s with %s workers",
    DASK_SCHEDULER_ADDRESS,
    len(client.ncores()),
)

clim_dataset_example_base_dir = pathlib.Path(__file__).parents[1] / "data"
clim_dataset_example_names = [
    name
    for name, details in climdata.EXAMPLES.items()
    if details.get("formatted_data_downloadable", False)
]
get_app(
    clim_dataset_example_base_dir=clim_dataset_example_base_dir,
    clim_dataset_example_names=clim_dataset_example_names,
).servable()
