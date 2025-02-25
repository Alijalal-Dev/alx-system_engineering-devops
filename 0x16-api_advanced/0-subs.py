#!/usr/bin/python3
"""Module to retrieve the number of subscribers for a given subreddit."""

import requests


def number_of_subscribers(subreddit):
    """
    Return the number of subscribers for a given subreddit.

    Args:
        subreddit (str): The name of the subreddit.

    Return:
        int: The number of subscribers of the subreddit.
    """
    url = "https://www.reddit.com/r/{}/about/.json".format(subreddit)
    headers = {"User-agent": "Mozilla/5.0 Gecko/20100101 Firefox/50.0"}
    try:
        response = requests.get(url, headers=headers, allow_redirects=False)
        response.raise_for_status()
        data = response.json()
        if "data" in data and "subscribers" in data["data"]:
            return data["data"]["subscribers"]
        else:
            return 0
    except Exception:
        return 0
