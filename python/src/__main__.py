import requests

def main():
    url = "https://coconala.com/"
    user_agent = "SampleScraping/0.1.0"
    headers = {
        "User-Agent": user_agent
    }
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        with open("coconala-scraping.txt", "w") as f:
            textRes = response.text
            f.write(textRes)
    else:
        print(f"Failed to fetch data. Status code: {response.status_code}")


if __name__ == "__main__":
    main()