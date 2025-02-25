#!/usr/bin/python3
"""Module to retrieve a recursive list of titles from a given subreddit."""

from requests import get


def recurse(subreddit, hot_list=[], after="", count=0):
    """
    Recursively retrieve a list of titles from a given subreddit.

    Args:
        subreddit (str): The name of the subreddit.
        hot_list (list, optional): List to store titles of posts.
        after (str, optional): Parameter to paginate through posts.
        count (int, optional): Total number of posts processed.

    Returns:
        list: A list of titles of posts from the subreddit.
    """
    url = "https://www.reddit.com/r/{}/hot/.json".format(subreddit)
    header = {"user-agent": "alx:0x16.api.advanced:v1.0.0"}
    param = {"limit": 100, "after": after, "count": count}
    response = get(url, headers=header, params=param, allow_redirects=False)
    if response.status_code != 200:
        return None
    posts = response.json().get("data")
    after = posts.get("after")
    count += posts.get("dist")
    for post in posts.get("children"):
        hot_list.append(post.get("data").get("title"))
    if after is not None:
        return recurse(subreddit, hot_list, after, count)
    return hot_list
