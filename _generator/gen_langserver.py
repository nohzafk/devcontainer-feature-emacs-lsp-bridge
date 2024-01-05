import requests
import tarfile
import os
import json

source_tar_gz_path = "/tmp/source.tar.gz"


def download_and_extract(url, extract_path="."):
    """
    Download a tar.gz file from a URL and extract it to a specified path.
    """
    response = requests.get(url, stream=True)
    if response.status_code == 200:
        with open(source_tar_gz_path, "wb") as f:
            f.write(response.raw.read())

        # Extract the tar.gz file
        with tarfile.open(source_tar_gz_path) as tar:
            tar.extractall(path=extract_path)
    else:
        raise Exception(f"Failed to download file: Status code {response.status_code}")


def main():
    repo = "manateelazycat/lsp-bridge"
    branch = "master"
    url = f"https://github.com/{repo}/archive/refs/heads/{branch}.tar.gz"
    extract_path = "/tmp/extracted"

    # Download and extract the tar.gz
    if not os.path.exists(source_tar_gz_path):
        download_and_extract(url, extract_path)

    process(
        os.path.join(extract_path, f"lsp-bridge-{branch}", "langserver"),
        process_langserver_json,
    )
    process(
        os.path.join(extract_path, f"lsp-bridge-{branch}", "multiserver"),
        process_multiserver_json,
    )
    print("gen_langserver.py done")


def process(server_path, handler):
    with open("langserver.json", "r") as f:
        langserver_list = json.load(f)

    langaserver_map = {item["langserver"]: item for item in langserver_list}

    # Iterate over JSON files in the 'langserver' directory
    for root, dirs, files in os.walk(server_path):
        for file in files:
            if file.endswith(".json"):
                json_file = os.path.join(root, file)
                try:
                    handler(langaserver_map, json_file)
                except Exception as e:
                    print(e)

    langserver_list = [
        langaserver_map[item] for item in sorted(list(langaserver_map.keys()))
    ]

    with open("langserver.json", "w") as f:
        json.dump(langserver_list, f, indent=4)

    print(f"processed {server_path} json files")


def process_langserver_json(langaserver_map, json_file):
    """
    Function to process a JSON file.
    """
    # Process the JSON data as needed
    with open(json_file, "r") as f:
        data = json.load(f)

    name = data["name"]
    # add if not exist to generate the file
    if name not in langaserver_map or not langaserver_map[name]["packages"]:
        langaserver_map[name] = {
            "langserver": name,
            "packages": "",
            "langserver_binary": data["command"][0],
        }
    elif langaserver_map[name]["langserver_binary"] != data["command"][0]:
        print(f"Upstream changed LSP server for {name}! Need manually update")
        print(
            "    "
            + langaserver_map[name]["langserver_binary"]
            + " -> "
            + data["command"][0]
        )


def process_multiserver_json(langaserver_map, json_file):
    langservers = set()

    with open(json_file, "r") as f:
        data = json.load(f)

    for item in list(data.values()):
        if isinstance(item, list):
            for i in item:
                langservers.add(i)
        elif isinstance(item, str):
            langservers.add(item)
        else:
            print(f"{json_file}: {item}")

    # all language servers in multserver has packages definiton
    if all(langaserver_map.get(item, {}).get("packages") for item in langservers):
        multiserver_name = os.path.basename(json_file)[: -len(".json")]
        multiserver_packages = ",".join(
            sorted([langaserver_map[item]["packages"] for item in langservers])
        )
        # add if not exist to generate the file
        if (
            multiserver_name not in langaserver_map
            or not langaserver_map[multiserver_name]["packages"]
        ):
            langaserver_map[multiserver_name] = {
                "langserver": multiserver_name,
                "packages": multiserver_packages,
                "langserver_binary": ",".join(
                    sorted(
                        [
                            langaserver_map[item]["langserver_binary"]
                            for item in langservers
                        ]
                    )
                ),
            }
        elif langaserver_map[multiserver_name]["packages"] != multiserver_packages:
            print(
                f"Upstream changed LSP server for {multiserver_name}! Need manually update"
            )
            print(
                "    "
                + langaserver_map[multiserver_name]["packages"]
                + " -> "
                + multiserver_packages
            )
    else:
        missing_items = [
            item
            for item in langservers
            if not langaserver_map.get(item, {}).get("packages")
        ]
        print(f"{json_file}, {missing_items} has no package definition")


if __name__ == "__main__":
    main()
