from climepi import climdata
from climepi.app import get_app

clim_dataset_example_names = [
    name
    for name, details in climdata.EXAMPLES.items()
    if details.get("formatted_data_downloadable", False)
]
get_app(clim_dataset_example_names=clim_dataset_example_names).servable()
