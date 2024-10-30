"""Python script defining the web app."""

import logging
import os
import pathlib

from climepi import climdata
from climepi.app import DASK_SCHEDULER_ADDRESS, get_app
from dask.distributed import Client

logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)

client = Client(DASK_SCHEDULER_ADDRESS)
logger.info(
    "Dask client connected to cluster at {%s} with {%s} workers",
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
