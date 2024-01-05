import json
import shutil
import os

from cookiecutter.main import cookiecutter

# Read the JSON file
with open("langserver.json", "r") as file:
    data = json.load(file)

template_src_dir = "src_template"
template_test_dir = "test_template"

for entry in data:
    if not entry["packages"]:
        continue

    langserver = entry["langserver"]
    target_src_dir = f"../src/{langserver}"
    target_test_dir = f"../test/{langserver}"

    if os.path.exists(target_src_dir):
        shutil.rmtree(target_src_dir)

    if os.path.exists(target_test_dir):
        shutil.rmtree(target_test_dir)

    cookiecutter(
        "src_template",
        no_input=True,
        output_dir=f"{target_src_dir}/../",
        extra_context=entry,
    )
    print(f"Generated {target_src_dir}")

    cookiecutter(
        "test_template",
        no_input=True,
        output_dir=f"{target_test_dir}/../",
        extra_context=entry,
    )
    print(f"Generated {target_test_dir}")
